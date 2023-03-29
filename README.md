#dig_grepper.sh
This script is a Bash script designed to perform DNS queries using the dig command and retrieve information about IP addresses and websites.

## How to use
The script can be executed by running ./dig_grepper.sh followed by one or more arguments. The arguments can be either IP addresses or website URLs.

If no arguments are provided, an error message will be displayed with instructions on how to use the script.

If a website URL is provided, the script will perform a DNS query using the dig command and retrieve information about the website. If an IP address is provided, the script will perform a reverse DNS query and retrieve information about the IP address.

The script can also take an optional DNS server as its first argument. If a DNS server is provided, the script will use that server instead of the default system DNS server.

Examples:
`./dig_grepper google.es`
`./dig_grepper @8.8.8.8 google.es`
`./dig_grepper @8.8.8.8 54.54.54.54`
`./dig_grepper 54.54.54.54`
`./dig_grepper @8.8.8.8 google.es 54.54.54.54`
`./dig_grepper google.es 54.54.54.54 @8.8.8.8 192.168.16.16`
`./dig_grepper @8.8.8.8 google.es @12.12.12.12 54.54.54.54`

## Functions
The script has three functions:

### error_message
Displays an error message with the provided text.

### check_message
Displays a success message with the provided text.

### info_message
Displays an information message with the provided text.

## License
This script is licensed under the MIT License. Please see the LICENSE file for more information.
