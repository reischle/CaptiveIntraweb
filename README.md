# CaptiveIntraweb
A very simple, esp8266 based standalone captive-portal-like, access point serving local files only

This project (apart from the code here) only requires an ESP-01 module and a (rechargeable?) battery.

Once running, the ESP-01 acts as an access-point, offering unenctypted access.
The ESP-01 needs to be flashed with slightly modified firmware (DHCP sets DNS server)
All DNS-requests are answered with the module's IP (192.168.4.1)
The HTTP-request is parsed and one of the locally stored html pages is sent to the client.
