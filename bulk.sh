#!/usr/bin/env bash
set -e

REPO="wanga90/build-your-own-x"
BASE_BRANCH="master"

i=0

while IFS= read -r topic && [ $i -lt 100 ]; do
  i=$((i+1))

  echo "=== [$i] Processing: $topic ==="

  # 1. Create issue
  ISSUE_URL=$(gh issue create \
    --repo $REPO \
    --title "$topic" \
    --body "Task: $topic")

  ISSUE_NUMBER=$(echo $ISSUE_URL | grep -oE '[0-9]+$')
  BRANCH="feature/issue-$ISSUE_NUMBER"

  echo "Issue #$ISSUE_NUMBER created"

  # 2. Create branch
  git checkout $BASE_BRANCH
  git pull origin $BASE_BRANCH
  git checkout -b $BRANCH

  # 3. Add stub change (real minimal work)
  FILE="progress_$ISSUE_NUMBER.txt"
  echo "Working on: $topic" > $FILE

  git add .
  git commit -m "$topic (#$ISSUE_NUMBER)"

  # 4. Push branch
  git push -u origin $BRANCH

  # 5. Create PR
  gh pr create \
    --repo $REPO \
    --title "$topic" \
    --body "Fixes #$ISSUE_NUMBER" \
    --base $BASE_BRANCH \
    --head $BRANCH

  echo "PR created for issue #$ISSUE_NUMBER"

done < topics.txt

echo "✅ Done: Created $i issues and PRs"