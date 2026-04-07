#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'
BOLD='\033[1m'

echo -e "${BOLD}Scanning Git repositories...${NC}\n"

find . -name ".git" -type d -prune | while read -r gitdir; do
    repo_dir=$(dirname "$gitdir")

    # 1. Check for Uncommitted Changes (Local files)
    uncommitted=$(git -C "$repo_dir" status --porcelain 2>/dev/null)

    # 2. Check for Unpushed Commits (Local commits vs Remote)
    # We check if the current branch has an upstream to compare against
    unpushed=""
    if git -C "$repo_dir" rev-parse --abbrev-ref @{u} >/dev/null 2>&1; then
        # Count commits that are in HEAD but not in the upstream branch
        unpushed_count=$(git -C "$repo_dir" rev-list @{u}..HEAD | wc -l | xargs)
        if [ "$unpushed_count" -gt 0 ]; then
            unpushed="Yes ($unpushed_count ahead)"
        fi
    fi

    # Output results
    if [[ -n "$uncommitted" || -n "$unpushed" ]]; then
        echo -e "${BOLD}Repo:${NC} $repo_dir展"

        if [[ -n "$uncommitted" ]]; then
            echo -e "  ${RED}[!] Uncommitted changes found${NC}"
        fi

        if [[ -n "$unpushed" ]]; then
            echo -e "  ${YELLOW}[↑] Unpushed commits: $unpushed${NC}"
        fi
        echo ""
    fi
done

echo -e "${BOLD}Scan complete.${NC}"