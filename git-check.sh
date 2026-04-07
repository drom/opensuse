#!/bin/bash

# Define colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
BOLD='\033[1m'

echo -e "${BOLD}Scanning for uncommitted changes...${NC}\n"

# Find all directories containing a .git folder
# -type d: search for directories
# -name ".git": look for the git metadata folder
# -prune: don't descend into the .git folder itself
find . -name ".git" -type d -prune | while read -r gitdir; do
    # Get the parent directory of the .git folder
    repo_dir=$(dirname "$gitdir")

    # Move into the repo and check status
    # Use --porcelain to get a stable, easy-to-parse output
    status=$(git -C "$repo_dir" status --porcelain 2>/dev/null)

    if [[ -n "$status" ]]; then
        echo -e "${RED}[!] Uncommitted changes:${NC} $repo_dir"
        # Optional: Print a summary of changes
        # echo "$status" | sed 's/^/    /'
    else
        # Optional: Uncomment the line below if you want to see clean repos too
        # echo -e "${GREEN}[✓] Clean:${NC} $repo_dir"
        true
    fi
done

echo -e "\n${BOLD}Scan complete.${NC}"
