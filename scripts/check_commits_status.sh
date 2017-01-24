#!/bin/bash

usage() {
	echo "Usage: $0 [OPTIONS] [CONFIG [...]]"
	echo "  -h    display this help text"
	echo "  -f    file contains all commits to check"
	echo "  -b    target branch to check"
	echo "  -o    dir to put generated output files."
}


if [ "$#" -lt 4 ] ; then
	usage
	exit
fi

while true; do
	case $1 in
	"-f")
		ALLCOMMITS=$2
		shift 2
		continue
		;;
	"-b")
		TARGET_BRANCH=$2
		shift 2
		continue
		;;
	"-h")
		usage
		exit
		;;
	"-o")
		OUT_DIR=$(echo $2 | sed 's/\/*$//')
		if [ ! -d $2 ];then
			mkdir $OUT_DIR
		fi
		shift 2
		continue
		;;
	*)
		break
		;;
	esac
done

MRGD_FILE=$OUT_DIR/mrgd.txt
UMRGD_FILE=$OUT_DIR/umrgd.txt
UMRGD_CID=$OUT_DIR/umrgd_cid.txt
CHRY_PICKS=$OUT_DIR/chry-pick.sh
CHK_PATCHS=$OUT_DIR/chk-patches.sh
TARGET_LOG=$OUT_DIR/target.log
index=0
rm $MRGD_FILE 2> /dev/null
rm $UMRGD_FILE 2> /dev/null
git log $TARGET_BRANCH --oneline > $TARGET_LOG
while read line
do
	#echo "$line"
	#echo "--------"
	title=$(echo $line | awk -F '}' '{print $NF}')
	cid=$(echo $line | awk '{print $1}')
	tgt=$(grep  "$title" $TARGET_LOG)
	if [ $? -eq 0 ]
	then
		#echo found $tgt
		tgt_cid=$(echo $tgt | awk '{print $1}')
		echo "===================$line =================" >>$MRGD_FILE
		echo "diff $cid $tgt_cid" >> $MRGD_FILE
		git show -U0 $cid > $OUT_DIR/patch
		git show -U0 $tgt_cid > $OUT_DIR/tgt_patch
        diff -u0 $OUT_DIR/patch $OUT_DIR/tgt_patch >> $MRGD_FILE
		echo >>$MRGD_FILE
		echo >>$MRGD_FILE
	else
		index=$(($index+1));
 		#echo "estuary don't have $line" 
		echo $line>>$UMRGD_FILE
		echo "$index $cid" >> $UMRGD_CID
	fi
	#echo 
	#echo 
done < $ALLCOMMITS
cat $UMRGD_CID | sort -n -r | awk -F ' ' '{print "git cherry-pick " $NF}' > $CHRY_PICKS

echo "All merged commits:   $MRGD_FILE"
echo "All unmerged commits: $UMRGD_FILE"
echo "cherry-pick all unmerged commits can use $CHRY_PICKS"
