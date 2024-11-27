#!/bin/sh


# git tag --sort=creatordata;
tags=(
 v0.1.0
v0.2.0
v0.3.0
)
REMOTE_NAME="g1"

for tag in "${tags[@]}"; do
  echo "tag: ${tag}"
  git push $REMOTE_NAME --delete "$tag" || echo "Failed to delete $tag"

  # Recreate and push the tag
  git push $REMOTE_NAME "$tag"     # Push the tag to the remote

  echo "Sleep 10s"
  sleep 10
done
