#!/bin/bash
echo "PHP $2 Compatiblity checking..."

CURRENT_VERSION=`composer show $1 | grep 'versions' | grep -o -E '\*\ .+' | cut -d' ' -f2 | cut -d',' -f1`
echo "Current version of package: $CURRENT_VERSION"

echo -ne '#####                     (33%)\r'

BASEDIR=$(PWD)

URL=`composer show $1 | grep 'source' | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*.git"`

echo "Git url: $URL"

# Remove temp directory if exist
rm -rf temp

# Clone project in temp directory
git clone $URL temp &> /dev/null

echo -ne '#############             (66%)\r'

# Go to temp directory
cd temp

# Fetch all tags
git fetch --all --tags &> /dev/null

OUTPUT=''
COMPATIBLE='NO'

for crt_tag in $(git tag)
do
   git checkout $crt_tag &> /dev/null

   cd .github/workflows &> /dev/null

   for FILE in *;
   do
      if [[ -f $FILE ]]
      then
        OUTPUT=`cat $FILE | grep $2`

        if [[ $OUTPUT == *"$2"* ]]; then
          COMPATIBLE='YES'
          echo "Minimum compatible package version: $crt_tag, Compatible: Yes"
          break
        else
          echo "Package version: $crt_tag, Compatible: No"
        fi
      fi
   done

   if [[ $COMPATIBLE == "YES" ]]; then
     break
   fi
done

echo -ne '#######################   (100%)\r'
echo -ne '\n'

# Remove temp directory
rm -rf $BASEDIR/temp
