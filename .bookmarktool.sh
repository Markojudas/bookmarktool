#!/bin/bash

BOOKMARKS_FILE=".bookmark.list"

# Checking if the file where all the bookmark entries exists
# If it doesn't, it will create such file under the /tmp/ directory

if [ ! -w ${BOOKMARKS_FILE} ]; then
	echo "bookmark list created"
	touch $BOOKMARKS_FILE
fi

# Checking if .bashrc file already contains the script for automatical use upon
# a new shell. If it doesn't then it appends the file to start the script.

grep -q ".bookmarktool.sh" ~/.bashrc

if [ $? -ne 0 ]; then
	echo "if [ -f ~/.bookmarktool.sh ]; then 
		. ~/.bookmarktool.sh 
	fi" >> ~/.bashrc
fi

# Main function

function bm(){
	CREATE="-c"
	SHOW="-s"
	LIST="-l"
	REMOVE="-r"
	VISIT="-v"
	BOOKMARK_NAME=$2
	BOOKMARK_PATH=$3
	VISIT_COUNT=0
	
	# Aux function to check if a bookmark entry already exists

	function isFound(){
		grep -q "${BOOKMARK_NAME}:" ${BOOKMARKS_FILE}
		
		if [ $? -eq 0 ]; then
			return 0
		else
			return 1
		fi
	}

	# Creates a new bookmark entry if it doesn't exits by appending bookmark.list
	# Usuage: bookmark create <name> <full path>

	if [[ $1 = $CREATE && $# -eq 3 ]]; then

		isFound

		if [ $? -ne 0 ]; then
			echo "Creating Entry for the bookmark $BOOKMARK_NAME"
			echo "${BOOKMARK_NAME}:${BOOKMARK_PATH}:${VISIT_COUNT}" >> ${BOOKMARKS_FILE}
			return 0
		else
			echo "Entry Already Exists"
			return 1
		fi
	# Removes existing bookmark entry.
	# Usage: bookmark remove <name>

	elif [[ $1 = $REMOVE && $# -eq 2 ]]; then

		isFound

		if [ $? -ne 0 ]; then
			echo "Entry not found"
			return 1
		else
			echo "Removing the ${BOOKMARK_NAME} entry"
			sed -i /${BOOKMARK_NAME}:/d ${BOOKMARKS_FILE}
			return 0
		fi
	# Lists in a formatted form the containts of bookmark.list
	# Usage: bookmark list

	elif [[ $1 = $LIST && $# -eq 1 ]]; then

		if [ ! -s $BOOKMARKS_FILE ]; then
			echo "File is empty"
			return 1
		else
			while read line;
			do
				IFS=":"

				read -ra ARR <<< "${line}"

				NAME=${ARR[0]}
				BMARK_PATH=${ARR[1]}
				VISITS=${ARR[2]}

				echo "Name:${NAME} -----> Path:${BMARK_PATH} -----> Visits:${VISITS}"
			done < ${BOOKMARKS_FILE}
			return 0
		fi
	# Shows a specific bookmark entry, if it exists
	# Usage: bookmark show <name>

	elif [[ $1 = $SHOW && $# -eq 2 ]]; then
		
		isFound

		if [ $? -ne 0 ]; then
			echo "Entry not Found"
			return 1
		else
			sed -n -e /${BOOKMARK_NAME}:/p ${BOOKMARKS_FILE}
			return 0
		fi
	# Appends the specific bookmark entry by incrementing the number of visits by 1
	# It changes directory to the one associated with the bookmark
	#Usage: bookmark visit <name>

	elif [[ $1 = $VISIT && $# -eq 2 ]]; then

		isFound

		if [ $? -ne 0 ]; then
			echo "Entry not Found"
			return 1
		else
			LINE=$(sed -n -e /${BOOKMARK_NAME}:/p ${BOOKMARKS_FILE})

			IFS=":"

			read -ra ARR1 <<< "$LINE"

			BM_NAME=${ARR1[0]}
			BM_PATH=${ARR1[1]}
			BM_VISIT=${ARR1[2]}

			if [ -d ${BM_PATH} ]; then
				let BM_VISIT++

				N_LINE="${BM_NAME}:${BM_PATH}:${BM_VISIT}"
				#echo "$LINE"
				#echo "$N_LINE"

				sed -i "s|${LINE}|${N_LINE}|g" $BOOKMARKS_FILE	
				cd "$BM_PATH"
				return 0
			else
				echo "PATH: ${BM_PATH}: no such directory exists"
				return 1
			fi
		fi
	else
		echo "******************************"
		echo "MARKOJUDAS' BOOKMARK TOOL"
		echo "******************************"
		echo ""
		echo "Please make sure the script is stored in the user's home directory. /home/<user>"
		echo ""
		echo "Usage:"
		echo "bookmark [OPTION] [name-of-bookmark] [path-to-directory]"
		echo ""
		echo "OPTIONS"
		echo "-c [create]			[name-of-bookmark] [path-to-directory]"
		echo "-r [remove]			[name-of-bookmark]"
		echo "-l [list]"
		echo "-s [show]			[name-of-bookmark]"
		echo "-v [visti]			[name-of-bookmark]"
				
		return 1


	fi
}
