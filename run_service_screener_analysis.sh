#!/bin/bash

# Service Screener Output-based Analysis Tool
# Usage: ./run_service_screener_analysis.sh [analysis_type] -d [directory] [options]

set -e

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Default settings
DEFAULT_LANG="en"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


show_help() {
    echo -e "${BLUE}Service Screener Output-based Analysis Tool${NC}"
    echo ""
    echo "Usage: $0 [analysis_type] -d [directory] [options]"
    echo ""
    echo "Analysis Types:"
    echo "  review          Service Screener Well-Architected review"
    echo "  ship            SHIP (Security Health Improvement Program) review"
    echo ""
    echo "Options:"
    echo "  -d, --dir PATH        Service Screener results directory (required)"
    echo "  -l, --lang LANG       Language: en/kr (default: en)"
    echo "  -h, --help           Show help"
    echo ""
    echo "Examples:"
    echo "  $0 review -d /path/to/service-screener-results -l kr"
    echo "  $0 ship -d /path/to/results"
}

execute_analysis() {
    local analysis_type="$1"
    local screener_dir="$2"
    local lang="$3"

    local system_prompt="**Important** 1/Only analyze the files in the given directory(${screener_dir})** 2/In the report, timestamp must be same with filename and report content 3/ do not manipulate number of findings and resource_id"
    local prompt_file="${SCRIPT_DIR}/prompts/${lang}/service_screener_${analysis_type}.md"
    local output_dir="${SCRIPT_DIR}/output/service-screener"
    
    mkdir -p "$output_dir"
    
    if [[ ! -f "$prompt_file" ]]; then
        echo -e "${RED}❌ Prompt file not found: $prompt_file${NC}"
        exit 1
    fi
    
    if [[ ! -d "$screener_dir" ]]; then
        echo -e "${RED}❌ Service Screener directory not found: $screener_dir${NC}"
        exit 1
    fi
    
    # Check Amazon Q CLI installation
    if ! command -v q &> /dev/null; then
        echo -e "${RED}❌ Amazon Q CLI is not installed.${NC}"
        echo "Please install Amazon Q CLI."
        exit 1
    fi
    
    echo -e "${GREEN}📁 Directory: $screener_dir${NC}"
    echo -e "${GREEN}🌐 Language: $lang${NC}"
    echo -e "${YELLOW}🔍 Service Screener ${analysis_type} analysis running...${NC}"
    
    local screener_files=$(find "$screener_dir" -name "*.json" -o -name "*.txt" -o -name "*.csv" | head -10)
    
    if [[ -z "$screener_files" ]]; then
        echo -e "${RED}❌ No Service Screener files found in $screener_dir${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}📄 Found Service Screener files:${NC}"
    echo "$screener_files"
    echo ""
    
    local prompt_content=$(cat "$prompt_file" | tr '\n' ' ')
    prompt_content+=${system_prompt}
    # Send prompt to Amazon Q CLI (single line)
    echo "Prompt: $prompt_content"
    printf "%s" "$prompt_content" | q chat --trust-all-tools
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✅ Service Screener ${analysis_type} analysis completed!${NC}"
        echo -e "${BLUE}📁 Check results in $output_dir directory.${NC}"
    else
        echo -e "${RED}❌ Analysis failed.${NC}"
        exit 1
    fi
}

# Parse arguments
ANALYSIS_TYPE=""
SCREENER_DIR=""
LANG="$DEFAULT_LANG"

while [[ $# -gt 0 ]]; do
    case $1 in
        review|ship)
            ANALYSIS_TYPE="$1"
            shift
            ;;
        -d|--dir)
            SCREENER_DIR="$2"
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
    echo -e "${BLUE}Service Screener Analysis Tool${NC}"
    echo ""
    echo "Select analysis type:"
    echo "1. Service Screener Well-Architected Review"
    echo "2. SHIP (Security Health Improvement Program) Review"
    echo "3. Exit"
    echo ""
    read -p "Enter choice (1-3): " choice
    
    case $choice in
        1) ANALYSIS_TYPE="review" ;;
        2) ANALYSIS_TYPE="ship" ;;
        3) exit 0 ;;
        *) echo -e "${RED}Invalid choice${NC}"; exit 1 ;;
    esac
fi

# Validate required directory parameter
if [[ -z "$SCREENER_DIR" ]]; then
    read -p "Enter Service Screener results directory path: " SCREENER_DIR
fi

execute_analysis "$ANALYSIS_TYPE" "$SCREENER_DIR" "$LANG"