#!/usr/bin/env bash
set -e

BACKLOG_DIR="./backlog"
ISSUES_DIR="$BACKLOG_DIR/issues"
PRS_DIR="$BACKLOG_DIR/prs"

mkdir -p "$ISSUES_DIR" "$PRS_DIR"

count=0

while IFS= read -r topic; do
  count=$((count + 1))

  issue_file=$(printf "%s/%03d.md" "$ISSUES_DIR" "$count")
  pr_file=$(printf "%s/%03d.md" "$PRS_DIR" "$count")

  slug=$(echo "$topic" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g; s/-\+/-/g')

  cat > "$issue_file" <<EOF
# Issue $count: $topic

## Summary
$topic

## Acceptance Criteria
- [ ] Implement feature
- [ ] Add tests
- [ ] Update docs

## Branch
feature/$slug
EOF

  cat > "$pr_file" <<EOF
# PR $count: $topic

## Description
Implements: $topic

## Related Issue
Closes #$count

## Checklist
- [ ] Code added
- [ ] Tests pass
- [ ] Ready to merge
EOF

done < topics.txt

echo "✅ Generated $count issues + PR drafts"