#!/bin/bash

# Create a temporary TOML file
temp_toml_file=$(mktemp --template="wrangler-temp-XXXXXX.toml")

# Read the original wrangler.toml file
original_toml_content=$(cat wrangler.toml)

# Process each environment variable in the [vars] section
while IFS= read -r -d '' line; do
  # Extract the variable name and placeholder
  var_name=${line%%=*}
  placeholder="${!var_name}"

  # Replace the placeholder with the actual secret value
  secret_value=$(echo "${!var_name}" | sed 's/^{{ secrets.//; s/ }}//g')
  original_toml_content="${original_toml_content/$placeholder/$secret_value}"
done < <(sed '/^\[vars\]/,/^[^\[]*$/p' wrangler.toml)

# Write the modified TOML content to the temporary file
echo "$original_toml_content" > "$temp_toml_file"

# Deploy using the temporary TOML file
wrangler deploy _worker.js --compatibility-date 2024-04-13 --name ${{ secrets.SCRIPT_NAME }} --config "$temp_toml_file"

# Remove the temporary TOML file
rm "$temp_toml_file"
