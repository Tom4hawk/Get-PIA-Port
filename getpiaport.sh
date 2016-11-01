#!/bin/sh
#
# Enable port forwarding for Private Internet Access (https://www.privateinternetaccess.com/)
#
# Script is based on:
#	https://www.privateinternetaccess.com/installer/port_forward.sh
#	https://www.privateinternetaccess.com/forum/discussion/3359/port-forwarding-without-application-pia-script-advanced-users
#
# Site: https://github.com/Tom4hawk/Get-PIA-Port
#
# Requirements:
#   Your Private Internet Access user and password
#
# Usage:
#  ./getpiaport.sh [OPTIONS]
#
# Arguments:
#	--user, -p (pia-username)
#		user for your PIA account	
#	--pass, -u (pia-password)
#		password for your PIA account
#	--login-file, -f (path-to-file)
#		you can get login information for your PIA account from text file,
#		format for this file is the same as for credentials file for openvpn -
#		login in first line, password in second (last)
#	--version, -v
#		output version information and exit
#	--usage, --help, -h
#		displays information about how to use this script (yep, you are reading that right now)
#	--silent, -s
#		suppresses unnecessary information from displaying, useful for scripts
#		does not suppress error and help messages

EXITCODE=0
PROGRAM=`basename $0`
VERSION=1.1
USER=""
PASS=""
SILENT=1

error(){
	echo "$@" 1>&2
	exit 1
}

error_and_usage(){
	echo "$@" 1>&2
	usage_and_exit 1
}

usage(){
	sed -n '3,28p' < $PROGRAM
}

usage_and_exit(){
	usage
	exit $1
}

version(){
	echo "$PROGRAM version $VERSION"
}


port_forward_assignment(){
	if [ "$SILENT" -eq 1 ]; then
		echo 'Loading port forward assignment information..'
	fi

	if [ "$(uname)" = "Linux" ] && ( command -v ip >/dev/null 2>&1 ); then
		local_ip=`ip addr show tun0|grep -oE "inet *10\.[0-9]+\.[0-9]+\.[0-9]+"|tr -d "a-z "`
		client_id=`head -n 100 /dev/urandom | md5sum | tr -d " -"`
	elif [ "$(uname)" = "Linux" ] && ( command -v ifconfig >/dev/null 2>&1 ); then
		local_ip=`ifconfig tun0|grep -oE "inet addr: *10\.[0-9]+\.[0-9]+\.[0-9]+"|tr -d "a-z :"`
		client_id=`head -n 100 /dev/urandom | md5sum | tr -d " -"`
	elif [ "$(uname)" = "Darwin" ]; then
		local_ip=`ifconfig tun0 | grep "inet " | cut -d\  -f2|tee /tmp/vpn_ip`
		client_id=`head -n 100 /dev/urandom | md5 -r | tr -d " -"`
	fi
	
	json=`curl --silent --data "user=$1&pass=$2&client_id=$client_id&local_ip=$local_ip" -o - 'https://www.privateinternetaccess.com/vpninfo/port_forward_assignment' | head -1 | grep -o '[0-9]*'`
	echo $json
}

read_credentials_from_file(){
	if [ -z "$1" ]; then
		echo "No argument supplied"
	elif [ -s $1 ] && [ -r $1 ]; then
		USER=$(head -1 $1)
		PASS=$(tail -1 $1)
	else
		echo "Cannot read $1. Check whether file exists and you've got permission to read it."
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
		--login-file | -f )
			read_credentials_from_file $2
			shift
			;;
		--pass | -p )
			PASS=$2
			shift
			;;
		--user | -u )
			USER=$2
			shift
			;;
		--silent | -s )
			SILENT=0
			;;
		*)
			error_and_usage "Unrecognized option: $1"
			;;
	esac
	shift
done


if [ -z "$USER" ] || [ -z "$PASS" ]; then
	echo "Provide PIA user and password"
	error_and_usage
fi

if [ "$SILENT" -eq 1 ]; then
	echo "VPN user: $USER"
	echo "VPN password: $PASS"
fi


		
port_forward_assignment $USER $PASS

exit 0
