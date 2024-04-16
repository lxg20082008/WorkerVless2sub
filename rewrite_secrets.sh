#!/bin/bash

# Create a temporary TOML file
temp_toml_file=$(mktemp -t wrangler-temp.XXXXXX.toml)
echo "Temporary file created successfully: $temp_toml_file"

# Copy the original wrangler.toml content to a temporary file
cp wrangler.toml "$temp_toml_file"

# Replace placeholder with actual secret value in the temporary file
# Here we're using the actual environment variable name instead of the secret placeholder
sed -i "s|\\${{secrets.UUID}}|${SECRET_UUID}|g" "$temp_toml_file"
sed -i "s|\\${{secrets.PATH}}|${SECRET_PATH}|g" "$temp_toml_file"
sed -i "s|\\${{secrets.HOST}}|${SECRET_HOST}|g" "$temp_toml_file"
sed -i "s|\\${{secrets.TOKEN}}|${SECRET_TOKEN}|g" "$temp_toml_file"
sed -i "s|\\${{secrets.ADDAPI}}|${SECRET_ADDAPI}|g" "$temp_toml_file"
sed -i "s|\\${{secrets.ADDCSV}}|${SECRET_ADDCSV}|g" "$temp_toml_file"
sed -i "s|\\${{secrets.ADD}}|${SECRET_ADD}|g" "$temp_toml_file"

# Print out the contents of the modified TOML file for verification
cat "$temp_toml_file"

# Expose the path of the temporary file as an environment variable for other steps to consume
echo "temp_toml_file=$temp_toml_file" >> $GITHUB_ENV
echo "temp_toml_file environment variable is created:" 'env.temp_toml_file'

# (Optional: Exit with a specific code if needed)
# exit 0
