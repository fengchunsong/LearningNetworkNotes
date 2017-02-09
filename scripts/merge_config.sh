#!/bin/sh
#  merge_config.sh - Takes a list of config fragment values, and merges
#  them one by one. Provides warnings on overridden values, and specified
#  values that did not make it to the resulting .config file (due to missed
#  dependencies or config symbol removal).
#
#  Portions reused from kconf_check and generate_cfg:
#  http://git.yoctoproject.org/cgit/cgit.cgi/yocto-kernel-tools/tree/tools/kconf_check
#  http://git.yoctoproject.org/cgit/cgit.cgi/yocto-kernel-tools/tree/tools/generate_cfg
#
#  Copyright (c) 2009-2010 Wind River Systems, Inc.
#  Copyright 2011 Linaro
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License version 2 as
#  published by the Free Software Foundation.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#  See the GNU General Public License for more details.


usage() {
	echo "Usage: $0 [OPTIONS] [CONFIG [...]]"
	echo "  -h    display this help text"
	echo "  -b    base config to compare with"
	echo "  -c    config to be compared,and will be splited to common and private files"
	echo "  -o    dir to put generated output files."
}

if [ "$#" -lt 6 ] ; then
	usage
	exit
fi

while true; do
	case $1 in
	"-h")
		usage
		exit
		;;
	"-b")
		if [ -f $2 ];then
			BASE_CONFIG=$2
		else
			echo "config $2 does not exist" 1>&2
			exit 1
		fi
		shift 2
		continue
		;;
	"-c")
		if [ -f $2 ];then
			TGT_CONFIG=$2
		else
			echo "config $2 does not exist" 1>&2
			exit 1
		fi
		shift 2
		continue
		;;
	"-o")
		OUT_DIR=$(echo $2 | sed 's/\/*$//')
		if [ ! -d $OUT_DIR ]; then
			mkdir -p $OUT_DIR
		fi
		shift 2
		continue
		;;
	*)
		break
		;;
	esac
done

SED_CONFIG_EXP="s/^\(# \)\{0,1\}\(CONFIG_[a-zA-Z0-9_]*\)[= ].*/\2/p"

COMMON_CONFIG=$OUT_DIR/common_config
PRIVATE_CONFIG=$OUT_DIR/private_config
rm $COMMON_CONFIG 2> /dev/null
rm $PRIVATE_CONFIG 2> /dev/null

CFG_LIST=$(sed -n "$SED_CONFIG_EXP" $TGT_CONFIG)
cp $TGT_CONFIG $PRIVATE_CONFIG
for cfg in $CFG_LIST
do
	base_cfg=$(grep -w "$cfg" $BASE_CONFIG)
	tgt_cfg=$(grep -w "$cfg" $TGT_CONFIG)
	if [ "x$base_cfg" = "x$tgt_cfg" ] ; then
		echo $base_cfg >> $COMMON_CONFIG
		sed -i "/$cfg[ =]/d" $PRIVATE_CONFIG
	fi
done 

echo
echo "common  config is in $COMMON_CONFIG"
echo "private config is in $PRIVATE_CONFIG"
echo

