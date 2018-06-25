# v2i-cert
V2I Certification scripts

Assume to run by bash !
Edit sut.txt to match your SUT setup

Has to contain the following values a list of lines:
- IP address
- Username
- the authentication pass phrase
- the privacy pass phrase
- network interface connected to SUT

##### 25.06.2018 - JG
Added EngineID note to readme again
##### 29.05.2018 - JG
Removed EngineID note from readme
##### 17.05.2018 - JG
Added basic tutorial on setting up trap receiver
##### 25.04.2018 - RT:
Initial creation

## How to configure simple trap receiver for testing
You can run it either directly on RSU or on any linux machine (install a snmp package).
You have to get EngineID from SUT by running snmpget call with OID SNMP-FRAMEWORK-MIB::snmpEngineID.0
With this EngineID, create snmptrapd.conf (for example in /tmp/ in case of running it on RSU) with this content:
```bash
createUser -e 0x80001F8880BCE1231CCF14FC5A rsuRwUser SHA 'password' AES 'password' # EngineID obtained from testing RSU, SNMP username and passwords
authUser log,execute,net rsuRwUser
```
Now, you can start trap receiver by running:
```bash
sudo snmptrapd -f -Lo udp6:[::]:162 -c /tmp/snmptrapd.conf
```
Verify that the trap receiver is working correctly by running:
```bash
snmptrap -v 3 -a SHA -A 'password' -x AES -X 'password' -l authPriv -u rsuRwUser -e 0x80001F8880BCE1231CCF14FC5A udp6:[::]:162 0 linkUp.0
```
Set IPv6 address of the machine with the trap receiver to RSU via snmpset call with OID rsuNotifyIpAddress and rsuNotifyPort.
## How to configure simple UDP receiver for NMEA GPGGA messages
Start UDP server by running:
```bash
sudo nc -6 -l -u -p 8888 -vvv
```
Set IPv6 address of the machine with the UDP server to RSU via snmpset call with OID rsuGpsOutputPort and rsuGpsOutputAddress.
