#!/bin/bash

# Usage: ./deploy_report.sh -i <report_file> -o <s3_path> -d <days> [-r <region>]
# Example: ./deploy_report.sh -i output/security/report.html -o s3://my-bucket/reports/ -d 7 -r us-east-1

REGION="ap-northeast-2"

while getopts "i:o:d:r:h" opt; do
    case $opt in
        i) REPORT_FILE="$OPTARG" ;;
        o) S3_PATH="$OPTARG" ;;
        d) DAYS="$OPTARG" ;;
        r) REGION="$OPTARG" ;;
        h) echo "Usage: $0 -i <report_file> -o <s3_path> -d <days> [-r <region>]"; exit 0 ;;
        *) echo "Usage: $0 -i <report_file> -o <s3_path> -d <days> [-r <region>]"; exit 1 ;;
    esac
done

if [ -z "$REPORT_FILE" ] || [ -z "$S3_PATH" ] || [ -z "$DAYS" ]; then
    echo "Usage: $0 -i <report_file> -o <s3_path> -d <days> [-r <region>]"
    exit 1
fi

if [ ! -f "$REPORT_FILE" ]; then
    echo "Error: Report file '$REPORT_FILE' not found"
    exit 1
fi

# Upload to S3
echo "Uploading $REPORT_FILE to $S3_PATH..."
aws s3 cp "$REPORT_FILE" "$S3_PATH" || exit 1

# Extract filename and generate presigned URL
FILENAME=$(basename "$REPORT_FILE")
S3_FULL_PATH="${S3_PATH%/}/$FILENAME"

echo "Generating presigned URL for $DAYS days..."
if ! aws s3 presign "$S3_FULL_PATH" --expires-in $((DAYS * 86400)) --region "$REGION"; then
    echo "Error: Failed to generate presigned URL"
    exit 1
fi