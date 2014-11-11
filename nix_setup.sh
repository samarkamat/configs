#!/bin/bash

delete_common_section ()
{
    file=$1
    header="$2"
    footer="$3"

	# find header and footer markers in target. if found clear delete the marker and any code below
	start_line=`grep -n "$header" $file | cut -f1 -d:`
	end_line=`grep -n "$footer" $file | cut -f1 -d:`
	if [[ $start_line && $end_line ]]
	then
		sed "$start_line,$end_line{/.*/d}" $file > tmpfile && mv tmpfile $file
	fi
}

install_config ()
{
    target="$1"
    config="$2"
    header="$3"
    footer="$4"

    cp "$target" "$target"_bk_setup

    delete_common_section $target "$header" "$footer"

	echo "$header" >> $target
	cat  $config   >> $target
	echo "$footer" >> $target
}

## MAIN

if [ $# -gt 0 ] && [ $1 = "help" ]
then
	echo "USAGE: $0 [help | bash | vim]"
	exit 1
fi

if [ $# -eq 0 ] || [ $1 = "bash" ]
then 
	echo "installing .bashrc"
    install_config ~/.bashrc bashrc_common \
        '####### STARTING COMMON #######' \
        '####### ENDING COMMON #######'
fi


if [ $# -eq 0 ] || [ $1 = "vim" ]
then 
	echo "installing .vimrc"
    install_config ~/.vimrc vimrc_common \
        '""""""" STARTING COMMON """""""' \
        '""""""" ENDING COMMON """""""'
fi

