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

##### 29.05.2018 - JG
Removed EngineID note from readme
##### 17.05.2018 - JG
Added basic tutorial on setting up trap receiver
##### 25.04.2018 - RT:
Initial creation

## How to configure simple trap receiver for testing
You can run it either directly on RSU or on any linux machine (install a snmp package).
Create snmptrapd.conf (for example in /tmp/ in case of running it on RSU) with this content:
```
createUser rsuRwUser SHA "password" AES "password"
authUser log,execute,net rsuRwUser
```
Now, you can start trap receiver by running:
```
sudo snmptrapd -f -Lo udp6:[::]:162 -c /tmp/snmptrapd.conf
```
Verify that the trap receiver is working correctly by running:
```
snmptrap -Ci -v 3 -a SHA -A "password" -x AES -X "password" -l authPriv -u rsuRwUser udp6:[::]:162 0 linkUp.0
```
Set IPv6 address of the machine with the trap receiver to RSU via snmpset call with OID rsuNotifyIpAddress and rsuNotifyPort.
## How to configure simple UDP receiver for NMEA GPGGA messages
Start UDP server by running:
```
sudo nc -6 -l -u -p 8888 -vvv
```
Set IPv6 address of the machine with the UDP server to RSU via snmpset call with OID rsuGpsOutputPort and rsuGpsOutputAddress.
