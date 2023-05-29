#!/bin/bash

# Function to perform Wikipedia search
wikipedia_search() {
    local query="$1"
    local api_endpoint="https://api.duckduckgo.com/"

    # Make the API request and retrieve the abstract result
    local response=$(curl -s "${api_endpoint}?q=${query}&format=json&kp=-1&skip_disambig=1&no_html=1")

    # Extract the abstract result from the response
    local abstract_result=$(echo "$response" | grep -oE '"Abstract":"[^"]+"' | cut -d':' -f2 | tr -d '"')

    # If no abstract is available, try retrieving a related topic
    if [[ -z "$abstract_result" ]]; then
        abstract_result=$(echo "$response" | grep -oE '"RelatedTopics":\[\{"Text":"[^"]+"' | cut -d':' -f3- | tr -d '"')
    fi

    # If still no result, try retrieving a disambiguation message
    if [[ -z "$abstract_result" ]]; then
        abstract_result=$(echo "$response" | grep -oE '"Disambiguation":"[^"]+"' | cut -d':' -f2 | tr -d '"')
    fi

    # If still no result, display a message indicating no information found
    if [[ -z "$abstract_result" ]]; then
        echo "No information found for '$query'."
    else
        # Print the abstract, related topic, or disambiguation message
        echo "$abstract_result"
    fi
}

# Check if an argument is provided
if [[ -z "$1" ]]; then
    echo "Please provide a search query as an argument."
    exit 1
fi

# Perform the Wikipedia search with the provided argument
search_query="$1"
wikipedia_search "$search_query"
