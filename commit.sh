#!/bin/bash
set -eux

######################
# Build and commit
######################

cd `dirname $0`

rm -rf pages
git clone https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/kijimad/roam pages

cd pages

docker build --target build -t roam-build .
docker run --detach --name roam-build-container roam-build
docker cp roam-build-container:/roam/org-roam.db .
sudo chown -R $USER:$USER ./org-roam.db
rm -rf .git
ls -al

cd ../

git status   # check
git add -N . # 新規ファイルを含める
if ! git diff --exit-code --quiet
then
    git config user.name  "github-actions[bot]"
    git config user.email "github-actions[bot]@users.noreply.github.com"
    git add .
    git commit -m ":robot: auto commit"
    git push
fi
