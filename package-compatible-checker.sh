#!/bin/sh
echo "PHP $2 Compatiblity checking..."

CURRENT_VERSION=`composer show $1 | grep 'versions' | grep -o -E '\*\ .+' | cut -d' ' -f2 | cut -d',' -f1`
echo "Current version of package: $CURRENT_VERSION"

echo -ne '#####                     (33%)\r'

BASEDIR=$(PWD)

URL=`composer show $1 | grep 'source' | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*.git"`

echo "Git url: $URL"

# Remove temp directory if exist
rm -rf temp

# Clone project into temp directory
git clone $URL temp &> /dev/null

echo -ne '#############             (66%)\r'

# Go to temp directory
cd temp

# Fetch all tags
git fetch --all --tags &> /dev/null

# Get latest tag name
latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
git checkout $latestTag &> /dev/null

# Go to workflows
cd .github/workflows

OUTPUT=''

for FILE in *;
   do OUTPUT=`cat $FILE | grep $2;`
done

if [[ $OUTPUT == *"$2"* ]];
then
   echo "Compatible: Yes, Package version: $latestTag"
else
   echo "Compatible: No"
fi

echo -ne '#######################   (100%)\r'
echo -ne '\n'

# Remove temp directory
rm -rf $BASEDIR/temp
