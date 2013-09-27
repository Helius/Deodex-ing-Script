#!/bin/bash

smalibaksmali_dir=/home/samoylov/.bin
classpath=":com.android.location.provider.jar:javax.obex.jar:core.jar:apache-xml.jar:bouncycastle.jar"

clear; for x in `find -iname "*.odex"|sort`; do
odexFile=${x/\.\//}
     [ -e ${x/odex/jar} ] && Jarfile=${odexFile/odex/jar} || Jarfile=${odexFile/odex/apk}

    echo "Uncompiling $odexFile for $Jarfile"
			java -Xmx512m -jar $smalibaksmali_dir/baksmali.jar -x $odexFile -o $odexFile.out -c $classpath -d framework

    if [ -e $odexFile.out ]; then
			java -Xmx512m -jar $smalibaksmali_dir/smali.jar $odexFile.out -o $odexFile-classes.dex
        ERROR=1
    fi

		if [ -e $odexFile-classes.dex ]; then
			echo "Adding classes.dex to $Jarfile"
      mv $odexFile-classes.dex classes.dex
      zip -q $Jarfile classes.dex
      rm -rf $odexFile.out $odexFile-classes.dex classes.dex $odexFile
    else
			rm -rf $odexFile.out $odexFile-classes.dex classes.dex
      echo "Error: $odexFile-classes.dex not found"
    fi

echo
done

