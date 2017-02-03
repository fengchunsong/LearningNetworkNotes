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

MRGD_FILE=$OUT_DIR/mrgd-subject.txt
UMRGD_FILE=$OUT_DIR/umrgd.txt
CHRY_PICKS=$OUT_DIR/umrgd-cherry-pick.sh
CONFLICT_CMTS=$OUT_DIR/umrgd-conflict.txt
TARGET_LOG=$OUT_DIR/.target.log
UMRGD_CIDS=$OUT_DIR/.umrgd-cid.txt
SORT_UMRGD_CIDS=$OUT_DIR/.umrgd-scid.txt
MRGD_PATCH_FILE=$OUT_DIR/mrgd-patch.txt
CMT_PATCH=$OUT_DIR/.patch
TGT_PATCH=$OUT_DIR/.tgt_patch
index=0
rm $MRGD_FILE 2> /dev/null
rm $UMRGD_FILE 2> /dev/null
rm $UMRGD_CIDS 2> /dev/null
rm $CHRY_PICKS 2> /dev/null
rm $CONFLICT_CMTS 2> /dev/null
rm $MRGD_PATCH_FILE 2> /dev/null
TARGET_HEAD=$(git log $TARGET_BRANCH --format=%h -1)
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
		git show -U0 $cid > $CMT_PATCH
		git show -U0 $tgt_cid > $TGT_PATCH
		diff -u0 $CMT_PATCH $TGT_PATCH >> $MRGD_FILE
		echo >>$MRGD_FILE
		echo >>$MRGD_FILE
	else
		index=$(($index+1));
 		#echo "estuary don't have $line" 
		echo "$index $cid" >> $UMRGD_CIDS
	fi
	#echo 
	#echo 
done < $ALLCOMMITS

git checkout $TARGET_BRANCH > /dev/null 2>&1

cat $UMRGD_CIDS | sort -n -r | awk -F ' ' '{print $NF}' > $SORT_UMRGD_CIDS
while read line
do
	#echo "$line"
	#echo "--------"
	git cherry-pick $line > /dev/null 2>&1
	if [ $? -eq 0 ]
	then
		#echo 
		#echo "$line merge in success."
		echo $line >> $UMRGD_FILE
		echo "git cherry-pick $line" >> $CHRY_PICKS
	else
		subject=$(git log $line  --format=%s -1)
		git commit --allow-empty -m "$subject" > /dev/null 2>&1
		if [ $? -eq 0 ]
		then
			echo $line >> $MRGD_PATCH_FILE
		else
			git cherry-pick --abort > /dev/null 2>&1
			echo $line >> $UMRGD_FILE
			echo $line >> $CONFLICT_CMTS
		fi
	fi
	#echo 
	#echo 
done < $SORT_UMRGD_CIDS
git reset --hard $TARGET_HEAD > /dev/null 2>&1
echo
echo "======================merged=========================="
echo "same subject:   $MRGD_FILE"
echo "different subject:   $MRGD_PATCH_FILE"
echo
echo "======================unmerged========================"
echo "all unmerged commits in $UMRGD_FILE"
echo "cherry-pick by $CHRY_PICKS"
echo "conflict: $CHRY_PICKS"
echo

rm $CMT_PATCH
rm $TGT_PATCH
