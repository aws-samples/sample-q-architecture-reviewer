# ArchiQ - Amazon Q-powered Architecture Reviewer

A simplified AWS architecture analysis tool with two main analysis paths and language support.

## 🚀 Quick Start

```bash
# AWS resource-based analysis (no external files needed)
./run_aws_analysis.sh

# Service Screener analysis (requires Service Screener output files)
./run_service_screener_analysis.sh
```

## 📁 Project Structure

```
sample-q-architecture-reviewer/
├── run_aws_analysis.sh               # AWS resource-based analysis
├── run_service_screener_analysis.sh  # Service Screener output analysis
├── prompts/                          # Analysis prompts
│   ├── en/                          # English prompts
│   │   ├── aws_security.md
│   │   ├── aws_well-architected.md
│   │   ├── aws_architecture.md
│   │   ├── aws_modernization.md
│   │   ├── service_screener_review.md
│   │   └── service_screener_ship.md
│   └── kr/                          # Korean prompts
│       ├── aws_security.md
│       ├── aws_well-architected.md
│       ├── aws_architecture.md
│       ├── aws_modernization.md
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

### AWS Resource Analysis

Analyzes your current AWS resources using AWS credentials:

```bash
# Interactive menu
./run_aws_analysis.sh

# Direct analysis
./run_aws_analysis.sh security -r us-east-1 -l kr
./run_aws_analysis.sh well-architected -l en
./run_aws_analysis.sh architecture -r eu-west-1
./run_aws_analysis.sh modernization -l kr
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
./run_service_screener_analysis.sh modern -d /path/to/results -l en
```

**Analysis Types:**
- `review` - Service Screener Well-Architected review
- `ship` - SHIP (Security Health Improvement Program) review
- `modern` - AI powered Architecture Modernization review

## 🌐 Language Support

- **English**: `-l en` (default)
- **Korean**: `-l kr`

## 📊 Output

### Sample SHIP Report(KR version)

![SHIP Report Sample](https://private-user-images.githubusercontent.com/12553776/505091066-7715d31c-478f-4379-8f49-42bab700f0ae.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NjIxODc3NjksIm5iZiI6MTc2MjE4NzQ2OSwicGF0aCI6Ii8xMjU1Mzc3Ni81MDUwOTEwNjYtNzcxNWQzMWMtNDc4Zi00Mzc5LThmNDktNDJiYWI3MDBmMGFlLnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTExMDMlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUxMTAzVDE2MzEwOVomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTBjZmNlYTA0NmI4YTZjZmJlNWZmYzk1MzJmMzA5MDY5MTM4MWYwMWMyMTM2N2I4ZGRjZGRjZThkMGYzMGVjMGMmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.MNq8qVhaoobfT2Ag_cwnM6ZgkIBsB0Gm4ovuFa2QKWw)

![SHIP Report Diagram](https://private-user-images.githubusercontent.com/12553776/505091065-e426224d-62d7-43b4-8aad-4160900324f5.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NjIxODc3NjksIm5iZiI6MTc2MjE4NzQ2OSwicGF0aCI6Ii8xMjU1Mzc3Ni81MDUwOTEwNjUtZTQyNjIyNGQtNjJkNy00M2I0LThhYWQtNDE2MDkwMDMyNGY1LnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTExMDMlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUxMTAzVDE2MzEwOVomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTYzZjZlMDE2NGRjODJiNDEyYTZiYmFkZjhjYzlhMzI1OWMxN2M2MDAxYzczM2I3ZGUxNmFjOWIzOWE4ZmM3MjAmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.1lCxVNe8DIRD3BEUH96ntTRQfipPOQo8DA-duQ5Rmh4)

[Samples Report HTML](https://github.com/aws-samples/sample-q-architecture-reviewer/blob/main/samples/service_screener_ship_sample.html)

All reports are generated as HTML files in the `output/` directory with timestamps:
- `aws_security_assessment_us-east-1_20241021_220223.html`
- `aws_well_architected_us-east-1_20241021_220223.html`
- `aws_architecture_diagram_us-east-1_20241021_220223.html`
- `aws_modernization_path_us-east-1_20241021_220223.html`
- `service_screener_review_20241021_220223.html`
- `service_screener_ship_20241021_220223.html`

## ⚙️ Prerequisites

- AWS CLI configured with appropriate credentials
- Amazon Q CLI installed
- Bash shell environment

## 🔧 Options

### AWS Analysis Options
- `-r, --region REGION` - AWS region (default: ap-northeast-2)
- `-l, --lang LANG` - Language: en/kr (default: en)
- `-h, --help` - Show help

### Service Screener Analysis Options
- `-d, --dir PATH` - Service Screener results directory (required)
- `-l, --lang LANG` - Language: en/kr (default: en)
- `-h, --help` - Show help
