#!/bin/sh
echo "PHP $1 Compatiblity checking..."

PACKAGES=`composer show --self | grep -o '^[a-z/a-z-]*'`

echo -ne '######    (1%)\r'

for package in $PACKAGES
do
   CURRENT_VERSION=`composer show $package | grep 'versions' | grep -o -E '\*\ .+' | cut -d' ' -f2 | cut -d',' -f1`
   
   echo "Current version of package: $package - $CURRENT_VERSION"

   BASEDIR=$(PWD)

   URL=`composer show $package | grep 'source' | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*.git"`

   echo "Git url: $URL"

   # Remove temp directory if exist
   rm -rf temp

   echo -ne '########    (5%)\r'

   # Clone project into temp directory
   git clone $URL temp &> /dev/null

   wait

   echo -ne '#############    (10%)\r'

   # Go to temp directory
   cd temp

   # Fetch all tags
   git fetch --all --tags &> /dev/null
   TAG_SUPPORT='No' 

   echo -ne '###################    (12%)\r'

   COMPLETION=12

   for crt_tag in $(git tag)
   do
      git checkout $crt_tag &> /dev/null
      wait
      OUTPUT=''

      if [ $COMPLETION -le 98 ]
      then 
         COMPLETION=$((COMPLETION+1))
      fi

      echo -ne "#########################    (${COMPLETION}%)\r"

      for FILE in .github/workflows/*;
      do
         if [[ -f $FILE ]]
         then
           OUTPUT=`cat $FILE | grep $1`

            if [[ $OUTPUT != '' ]]
            then
               break
            fi
         fi
      done

      if [[ $OUTPUT == *"$1"* ]];
      then
         echo "Minimum compatible package version: $crt_tag, Compatible: Yes"
         TAG_SUPPORT='Yes'
         rm -rf $BASEDIR/temp
         cd $BASEDIR
         break
      fi
   done

   if [ $TAG_SUPPORT == 'No' ]
   then 
      echo 'Package have not explicitly updated their support'
      rm -rf $BASEDIR/temp
      cd $BASEDIR
   fi
done
