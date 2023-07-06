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

for crt_tag in $(git tag)
do
   git checkout $crt_tag &> /dev/null

   cd .github/workflows &> /dev/null

   OUTPUT=''

   for FILE in *;
   do
      if [[ -f $FILE ]]
      then
        OUTPUT=`cat $FILE | grep $2`
      fi
   done

   if [[ $OUTPUT =~ $2 ]];
   then
     echo "Minimum compatible package version: $crt_tag, Compatible: Yes"
     break
   else
     echo "Package version: $crt_tag, Compatible: No"
   fi

done
