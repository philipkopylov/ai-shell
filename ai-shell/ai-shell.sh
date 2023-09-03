#!/bin/bash

ai () {

  # Function to check if a command is available
  command_exists() {
    command -v "$1" >/dev/null 2>&1
  }

  # Check if curl and jq are installed
  if ! command_exists curl || ! command_exists jq; then
    echo "Dependencies (curl and/or jq) are missing. Installing..."
    chmod +x install_dependencies.sh
    ./install_dependencies.sh
  fi


  # Check if OPENAI_API_KEY is empty
  if [ -z "$OPENAI_API_KEY" ]; then
    read -p "Please enter your OpenAI API key: " user_token
    export OPENAI_API_KEY="$user_token"
  fi

  # Put your key here or export to env
  user_token="$OPENAI_API_KEY"

  # Check if user input is not empty
  if [ $# -eq 0 ]; then
    echo "Usage: ai-shell <want you want to do>"
    return 1
  fi

  # Grab user input
  user_message="$*"

  # Check if user_message is empty or contains only whitespace
  if [ -z "$user_message" ]; then
    echo "Error: Input message is empty."
    return 1
  fi
  
  # Example: Remove potentially harmful characters using sed
  user_message=$(echo "$user_message" | sed 's/[^a-zA-Z0-9\s]//g')


  # Form a request 
  request=$(curl --silent https://api.openai.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $user_token" \
    -d '{
   "model": "gpt-3.5-turbo",
   "messages": [{"role": "user", "content": "You are an expert at using shell commands. Only provide a single executable line of shell code as output. Never output any text before or after the shell code, as the output will be directly executed in a shell. You are allowed to chain commands like ls \"|\" grep .txt. Create a command for: '"${user_message}"'"}],
   "temperature": 0.7
    }')

  # Send a request
  response=$request

  # Check if the response contains an "error" field
  if echo "$response" | jq -e 'has("error")' > /dev/null; then
    # Extract the "error.message" value
    error=$(echo "$response" | jq -r '.error.message')
    echo "Error: $error"
  else
    # Use jq to extract the content
    content=$(echo "$response" | jq -r '.choices[0].message.content')
    
    # Allow the user to modify the generated shell command
    echo "Generated Shell Command: $content"
    read -p "Modify the command (press Enter to keep as is): " modified_content

    # Use the modified command or the original if no modifications made
    if [ -n "$modified_content" ]; then
      content="$modified_content"
    fi

    # Execute the generated shell command
    echo "Executing: $content"
    eval "$content"




  fi

}

ai "$@"
