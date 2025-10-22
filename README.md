# ArchiQ - Amazon Q-powered Architecture Reviewer

A simplified AWS architecture analysis tool with two main analysis paths and language support.

## 🚀 Quick Start

```bash
# Resource-based analysis (no external files needed)
./run_resource_analysis.sh

# Service Screener analysis (requires Service Screener output files)
./run_service_screener_analysis.sh
```

## 📁 Project Structure

```
sample-q-architecture-reviewer/
├── run_resource_analysis.sh          # AWS resource-based analysis
├── run_service_screener_analysis.sh  # Service Screener output analysis
├── prompts/                          # Analysis prompts
│   ├── en/                          # English prompts
│   │   ├── security.md
│   │   ├── well-architected.md
│   │   ├── architecture.md
│   │   ├── modernization.md
│   │   ├── service_screener_review.md
│   │   └── service_screener_ship.md
│   └── kr/                          # Korean prompts
│       ├── security.md
│       ├── well-architected.md
│       ├── architecture.md
│       ├── modernization.md
│       ├── service_screener_review.md
│       └── service_screener_ship.md
└── output/                          # Generated reports
    ├── security/
    ├── well-architected/
    ├── architecture/
    ├── modernization/
    └── service-screener/
```

## 🛠️ Usage

### Resource-based Analysis

Analyzes your current AWS resources using AWS credentials:

```bash
# Interactive menu
./run_resource_analysis.sh

# Direct analysis
./run_resource_analysis.sh security -r us-east-1 -l kr
./run_resource_analysis.sh well-architected -l en
./run_resource_analysis.sh architecture -r eu-west-1
./run_resource_analysis.sh modernization -l kr
```

**Analysis Types:**
- `security` - Security assessment
- `well-architected` - Well-Architected Framework review
- `architecture` - Architecture diagram generation
- `modernization` - Modernization path analysis

### Service Screener Analysis

Analyzes Service Screener output files:

```bash
# Interactive menu
./run_service_screener_analysis.sh

# Direct analysis
./run_service_screener_analysis.sh review -d /path/to/screener-results -l en
./run_service_screener_analysis.sh ship -d /path/to/results -l kr
```

**Analysis Types:**
- `review` - General Well-Architected review
- `ship` - SHIP (Security Health Improvement Program) review

## 🌐 Language Support

- **English**: `-l en` (default)
- **Korean**: `-l kr`

## 📊 Output

All reports are generated as HTML files in the `output/` directory with timestamps:
- `aws_security_us-east-1_20241021_220223.html`
- `service_screener_review_20241021_220223.html`

## ⚙️ Prerequisites

- AWS CLI configured with appropriate credentials
- Amazon Q CLI installed
- Bash shell environment

## 🔧 Options

### Resource Analysis Options
- `-r, --region REGION` - AWS region (default: ap-northeast-2)
- `-l, --lang LANG` - Language: en/kr (default: en)
- `-h, --help` - Show help

### Service Screener Analysis Options
- `-d, --dir PATH` - Service Screener results directory (required)
- `-l, --lang LANG` - Language: en/kr (default: en)
- `-h, --help` - Show help
