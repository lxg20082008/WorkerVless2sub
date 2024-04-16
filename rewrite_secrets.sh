#!/bin/bash

# Create a temporary TOML file
temp_toml_file=$(mktemp -t wrangler-temp.XXXXXX.toml)
echo "Temporary file created successfully: $temp_toml_file"

# Copy the original wrangler.toml content to a temporary file
cp wrangler.toml "$temp_toml_file"

# 添加'[vars]'块的新值
echo "UUID = \"$SECRET_UUID\"" >> "$temp_toml_file"
echo "PATH = \"$SECRET_PATH\"" >> "$temp_toml_file"
echo "HOST = \"$SECRET_HOST\"" >> "$temp_toml_file"
echo "TOKEN = \"$SECRET_TOKEN\"" >> "$temp_toml_file"
# 添加多行字符串的值，不添加额外的双引号和空行
echo "ADDAPI = \"\"\"" >> "$temp_toml_file"
echo "$SECRET_ADDAPI" >> "$temp_toml_file"
echo "\"\"\"" >> "$temp_toml_file"

echo "ADDCSV = \"\"\"" >> "$temp_toml_file"
echo "$SECRET_ADDCSV" >> "$temp_toml_file"
echo "\"\"\"" >> "$temp_toml_file"

echo "ADD = \"\"\"" >> "$temp_toml_file"
echo "$SECRET_ADD" >> "$temp_toml_file"
echo "\"\"\"" >> "$temp_toml_file"

# Print out the contents of the modified TOML file for verification
cat "$temp_toml_file"

# Expose the path of the temporary file as an environment variable for other steps to consume
echo "temp_toml_file=$temp_toml_file" >> $GITHUB_ENV
echo "temp_toml_file environment variable is created:" 'env.temp_toml_file'

# (Optional: Exit with a specific code if needed)
# exit 0
