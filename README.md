# Get-PIA-Port
Enable port forwarding for [Private Internet Access](https://www.privateinternetaccess.com/)
##Script is based on
[Script](https://www.privateinternetaccess.com/installer/port_forward.sh)  
[PIA forum post](https://www.privateinternetaccess.com/forum/discussion/3359/port-forwarding-without-application-pia-script-advanced-users)
##Changes from original script
- Script detects whether your system has _ifconfig_ or _iproute2_
- now it's posix shell(sh) script (original script is in bash)
- uses curl instead of wget (it's more likely that you have _curl_ than _wget_)
- there is `--silent` option which makes it much more suitable for using with other scripts (output contains only port number)
- better error handling
- script can read PIA credentials from text file, same format can be used in OpenVPN which makes it very convenient
- FreeBSD support

##Requirements
Your Private Internet Access user and password
##Usage
1. Download Get-PIA-Port
2. `chmod +x getpiaport.sh`
3. Make sure you are connected in one of the gateways that supports port forwarding
4. `./getpiaport.sh [OPTIONS]`

##Arguments
```
--user, -p (pia-username)
    user for your PIA account
--pass, -u (pia-password)
    password for your PIA account
--login-file, -f (path-to-file)
    you can get login information for your PIA account from text file,
    format for this file is the same as for credentials file for openvpn -
    login in first line, password in second (last)
--version, -v
    output version information and exit
--usage, --help, -h
    displays information about how to use this script (yep, you are reading that right now)
--silent, -s
    suppresses unnecessary information from displaying, useful for scripts
    does not suppress error and help messages
```
##Examples
###Credentials passed as arguments
```
./getpiascript.sh --user x3523666 --pass x784235
```
###Credentials read from file
Credentials file:
```
  /etc/openvpn/login.conf
x3523666
x784235
```
Run:
```
./getpiascript.sh --login-file /etc/openvpn/login.conf
```
###Gateways that supports port forwarding
```
CA Toronto
Ca Montreal
Netherlands
Sweden
Switzerland
France
Germany
Romania
Israel
```
Up to date list: [PIA Client Support Area](https://www.privateinternetaccess.com/pages/client-support/#sixth)
