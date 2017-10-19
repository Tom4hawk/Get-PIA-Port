# Get-PIA-Port
Enable port forwarding for [Private Internet Access](https://www.privateinternetaccess.com/)
This script works with new API introduced in 2017 - now there is no need to provide your cridentials into script, all you need is working OpenVPN connection with PIA.
## Script is based on
[Script](https://privateinternetaccess.com/installer/port_forwarding.sh)  
[PIA forum post](https://www.privateinternetaccess.com/forum/discussion/23431/new-pia-port-forwarding-api)
## Changes from original script
- Script detects whether your system has _curl_ or _wget_
- now it's posix shell(sh) script (original script is in bash)
- there is `--silent` option which makes it much more suitable for using with other scripts (output contains only port number)
- there is `--output-file` option which makes it easy to save current port into file
- better error handling
- FreeBSD support on the way!

## Requirements
Working OpenVPN connection with PIA.  
After connecting you have only two minutes to request port forwarding, after that time you have to reconnect and try again.
## Usage
1. Download Get-PIA-Port
2. `chmod +x getpiaport.sh`
3. Make sure you are connected into one of the gateways that supports port forwarding
4. `./getpiaport.sh [OPTIONS]`

## Arguments
```
    --version, -v
    output version information and exit
    --usage, --help, -h
    displays information about how to use this script (yep, you are reading that right now)
    --silent, -s
    suppresses unnecessary information from displaying, useful for scripts
    does not suppress error and help messages
    --output-file, -o
        saves result to file (only if if getting forwarded port succeeds)
```
## Gateways that supports port forwarding (as of 2017-09-07)
```
CA Toronto
CA Montreal
Netherlands
Sweden
Switzerland
France
Germany
Romania
Israel
```
Up to date list: [PIA Client Support Area](https://www.privateinternetaccess.com/pages/client-support/#sixth)
