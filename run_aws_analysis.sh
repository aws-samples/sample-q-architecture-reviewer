#!/bin/bash

# AWS Analysis Tool
# Usage: ./run_aws_analysis.sh [analysis_type] [options]

set -e

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Default settings
DEFAULT_REGION="ap-northeast-2"
DEFAULT_LANG="en"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_help() {
    echo -e "${BLUE}AWS Analysis Tool${NC}"
    echo ""
    echo "Usage: $0 [analysis_type] [options]"
    echo ""
    echo "Analysis Types:"
    echo "  security        Security assessment"
    echo "  well-architected Well-Architected review"
    echo "  architecture    Architecture diagram generation"
    echo "  modernization   Modernization path analysis"
    echo ""
    echo "Options:"
    echo "  -r, --region REGION    AWS region (default: ap-northeast-2)"
    echo "  -l, --lang LANG        Language: en/kr (default: en)"
    echo "  -h, --help            Show help"
    echo ""
    echo "Examples:"
    echo "  $0 security -r us-east-1 -l kr"
    echo "  $0 well-architected"
    echo "  $0 architecture -l en"
}

execute_analysis() {
    local analysis_type="$1"
    local region="$2"
    local lang="$3"
    
    local prompt_file="${SCRIPT_DIR}/prompts/${lang}/aws_${analysis_type}.md"
    local output_dir="${SCRIPT_DIR}/output/${analysis_type}"
    local timestamp=$(date "+%F %T %Z(%z)")
    local system_prompt="Use current timestamp:${timestamp} **Critical Guidelines** 1/Use ONLY the use_aws tool to query and analyze actual AWS resources in ${region} region 2/DO NOT execute or generate any shell scripts, bash commands, or external tools 3/Ensure report consistency: content, resources, findings must match exactly with actual AWS environment queried via use_aws tool 4/NEVER use placeholder or example data - use real resource IDs, configurations, and settings obtained from use_aws tool 5/Validate report accuracy post-completion especially file timestamp(year and datetime) must reflect report creation year and datetime 6/Save the file with this format in the ${output_dir}/aws_${analysis_type}_${region}_{YYYYMMDD_HHMMSS}.html. The timezone must follow current system timezone."
    
    mkdir -p "$output_dir"
    
    if [[ ! -f "$prompt_file" ]]; then
        echo -e "${RED}❌ Prompt file not found: $prompt_file${NC}"
        exit 1
    fi
    
    # Check AWS CLI installation
    if ! command -v aws &> /dev/null; then
        echo -e "${RED}❌ AWS CLI is not installed.${NC}"
        echo "Please install AWS CLI and configure credentials."
        exit 1
    fi
    
    # Check Amazon Q CLI installation
    if ! command -v q &> /dev/null; then
        echo -e "${RED}❌ Amazon Q CLI is not installed.${NC}"
        echo "Please install Amazon Q CLI."
        exit 1
    fi
    
    # Check AWS credentials
    if ! aws sts get-caller-identity &> /dev/null; then
        echo -e "${RED}❌ AWS credentials are not configured.${NC}"
        echo "Please configure credentials using 'aws configure' command."
        exit 1
    fi
    
    echo -e "${GREEN}🌏 AWS Region: $region${NC}"
    echo -e "${GREEN}🌐 Language: $lang${NC}"
    echo -e "${YELLOW}🔍 ${analysis_type} analysis running...${NC}"
    echo ""
    
    # Generate prompt content with region substitution
    local prompt_content
    prompt_content=$(cat "$prompt_file" | tr '\n' ' ')
    prompt_content=$(sed "s/{REGION}/$region/g" <<< "$prompt_content")
    prompt_content+=" ${system_prompt}"
    
    # Send prompt to Amazon Q CLI
    echo "Prompt: $prompt_content"
    printf "%s" "$prompt_content" | q chat --trust-all-tools
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✅ ${analysis_type} analysis completed!${NC}"
        echo -e "${BLUE}📁 Check results in $output_dir directory.${NC}"
    else
        echo -e "${RED}❌ Analysis failed.${NC}"
        exit 1
    fi
}

# Parse arguments
ANALYSIS_TYPE=""
REGION="$DEFAULT_REGION"
LANG="$DEFAULT_LANG"

while [[ $# -gt 0 ]]; do
    case $1 in
        security|well-architected|architecture|modernization)
            ANALYSIS_TYPE="$1"
            shift
            ;;
        -r|--region)
            REGION="$2"
            shift 2
            ;;
        -l|--lang)
            LANG="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# Interactive menu if no analysis type specified
if [[ -z "$ANALYSIS_TYPE" ]]; then
    echo -e "${BLUE}AWS Analysis Tool${NC}"
    echo ""
    echo "Select analysis type:"
    echo "1. Security Assessment"
    echo "2. Well-Architected Review"
    echo "3. Architecture Diagram"
    echo "4. Modernization Path"
    echo "5. Exit"
    echo ""
    read -p "Enter choice (1-5): " choice
    
    case $choice in
        1) ANALYSIS_TYPE="security" ;;
        2) ANALYSIS_TYPE="well-architected" ;;
        3) ANALYSIS_TYPE="architecture" ;;
        4) ANALYSIS_TYPE="modernization" ;;
        5) exit 0 ;;
        *) echo -e "${RED}Invalid choice${NC}"; exit 1 ;;
    esac
fi

execute_analysis "$ANALYSIS_TYPE" "$REGION" "$LANG"
