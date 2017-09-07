#!/bin/sh
#
# Enable port forwarding for Private Internet Access (https://www.privateinternetaccess.com/)
#
# Script is based on:
#	https://privateinternetaccess.com/installer/port_forwarding.sh (version 2.1)
#	https://www.privateinternetaccess.com/forum/discussion/23431/new-pia-port-forwarding-api?new=1
#
# Site: https://github.com/Tom4hawk/Get-PIA-Port
#
# Requirements:
#	Your Private Internet Access OpenVPN connection
#
# Usage:
#	./getpiaport.sh [OPTIONS]
#
# Arguments:
#	--version, -v
#		output version information and exit
#	--usage, --help, -h
#		displays information about how to use this script (yep, you are reading that right now)
#	--silent, -s
#		suppresses unnecessary information from displaying, useful for scripts
#		does not suppress error and help messages
#	--output-file, -o
#		saves result to file (only if if getting forwarded port succeeds)

EXITCODE=0
PROGRAM=`basename $0`
VERSION=2.0
SILENT=0
OUTPUTFILE=0

error(){
	echo "$@" 1>&2
	exit 1
}

error_and_usage(){
	echo "$@" 1>&2
	usage_and_exit 1
}

usage(){
	sed -n '3,26p' < $PROGRAM
}

usage_and_exit(){
	usage
	exit $1
}

version(){
	echo "$PROGRAM version $VERSION"
}


port_forward_assignment(){
	if [ "$SILENT" -eq 0 ]; then
		echo 'Loading port forward assignment information..'
	fi

	if [ "$(uname)" == "Linux" ]; then
		client_id=`head -n 100 /dev/urandom | sha256sum | tr -d " -"`
	fi
	if [ "$(uname)" == "Darwin" ]; then
		client_id=`head -n 100 /dev/urandom | shasum -a 256 | tr -d " -"`
	fi

	if ( command -v curl >/dev/null 2>&1 ); then
		result=`curl --silent --data "http://209.222.18.222:2000/?client_id=$client_id" 2>/dev/null`
	elif ( command -v wget >/dev/null 2>&1 ); then
		result=`wget -qO- "http://209.222.18.222:2000/?client_id=$client_id" 2>/dev/null`
	fi

	if [ "$result" == "" ]; then
		result='Port forwarding is already activated on this connection, has expired, or you are not connected to a PIA region that supports port forwarding'
		error($result)
	else
		result=`echo $result | head -1 | grep -o '[0-9]*'`
		if [ "$OUTPUTFILE" -ne 0 ]; then
			echo $result > $OUTPUTFILE
		fi
		if [ "$SILENT" -eq 0 ]; then
			echo $result
		fi
	fi
}

while [ $# -gt 0 ]
do
	key="$1"

	case $key in
		--usage | --help | -h )
			usage_and_exit 0
			;;
		--version | -v )
			version
			exit 0
			;;
		--output-file | -o )
			OUTPUTFILE=$2
			shift
			;;
		--silent | -s )
			SILENT=1
			;;
		*)
			error_and_usage "Unrecognized option: $1"
			;;
	esac
	shift
done


port_forward_assignment

exit 0
