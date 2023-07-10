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

wait

echo -ne '#############             (66%)\r'

# Go to temp directory
cd temp

# Fetch all tags
git fetch --all --tags &> /dev/null
TAG_SUPPORT='No' 
for crt_tag in $(git tag)
do
   git checkout $crt_tag &> /dev/null
   wait
   OUTPUT=''

   for FILE in .github/workflows/*;
   do
      if [[ -f $FILE ]]
      then
        OUTPUT=`cat $FILE | grep $2`

         if [[ $OUTPUT != '' ]]
         then
            break
         fi
      fi
   done

   if [[ $OUTPUT == *"$2"* ]];
   then
     echo "Minimum compatible package version: $crt_tag, Compatible: Yes"
     TAG_SUPPORT='Yes'
     break
    fi
done

if [ $TAG_SUPPORT == 'No' ]
then 
  echo 'Package have not explicitly updated their support'
fi
