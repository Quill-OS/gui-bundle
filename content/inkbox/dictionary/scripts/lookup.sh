#!/bin/sh -ex

export WORD=`cat /inkbox/dictionary/word`
export LINE_MATCH=`cat index | grep -nw "$WORD" | cut -d: -f 1 | sed -n ""$1"p"`
if [ LINE_MATCH = "" ]; then
	exit 1
else
	export REGEX_DEF="`sed ""$LINE_MATCH"q;d" definitions`"
	export PREVENT="`sed "1q;d" definitions`"
	if [ "$REGEX_DEF" = "$PREVENT" ]; then
		if [ "$LINE_MATCH" = "1" ]; then
			echo $REGEX_DEF > /inkbox/dictionary/definition
		else
			echo "No definition found." > /inkbox/dictionary/definition
		fi
	else
		echo $REGEX_DEF > /inkbox/dictionary/definition
		echo normal
	fi
fi
