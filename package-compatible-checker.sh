#!/bin/sh
echo "Package compatible checker"

echo "Current version of package" 
composer show $1 | grep 'versions' | grep -o -E '\*\ .+' | cut -d' ' -f2 | cut -d',' -f1


echo "Git url"
URL=`composer show $1 | grep 'source' | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*.git"`

echo $URL

git clone $URL temp

cd temp

git fetch --all --tags

# Get latest tag name
latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
git checkout latestTag

#git checkout tags/3.6.4

cat .github/workflows/static-analysis.yml | grep '8.2'
cat .github/workflows/ci.yml | grep '8.2'

rm -rf ../temp
