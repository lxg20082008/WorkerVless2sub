#!/bin/bash

# Create a temporary TOML file
temp_toml_file=$(mktemp -t wrangler-temp.XXXXXX.toml)
echo "Temporary file created successfully: $temp_toml_file"

# Copy the contents of the original wrangler.toml file to the temporary file
cp wrangler.toml "$temp_toml_file"

# Replace placeholders with actual secret values in the temporary file
while IFS= read -r line; do
  var_name=$(echo $line | sed -n 's/.*${{ secrets.\(.*\) }}.*/\1/p')
  if [ -n "$var_name" ]; then
    secret_value=$(jq -r .env.$var_name <<< "$GITHUB_ENV")
    sed -i "s|\${{ secrets.$var_name }}|$secret_value|g" "$temp_toml_file"
  fi
done < <(grep -o '\${{ secrets.[^ ]* }}' wrangler.toml)

cat $temp_toml_file

# Set the temp_toml_file environment variable
echo "temp_toml_file=$temp_toml_file" >> $GITHUB_ENV
echo "temp_toml_file environment variable is created:" 'env.temp_toml_file'

# (Optional: Exit with a specific code if needed)
# exit 0
