#!/bin/bash

# Create a temporary TOML file
temp_toml_file=$(mktemp -t wrangler-temp.XXXXXX.toml)

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

# Set the temp_toml_file environment variable
echo "env.temp_toml_file=$temp_toml_file" >> $GITHUB_ENV

# (Optional: Exit with a specific code if needed)
# exit 0
