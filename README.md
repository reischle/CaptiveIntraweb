# CaptiveIntraweb
A very simple, esp8266 based standalone captive-portal-like, access point serving local files only.
This turns an ESP-01 module into an autonomous WiFi throwie. 

<b>As the project is nearing its first release, we have working code and html files in the dev-tree. The German branch will be somewhat ahead of the dev tree, but both are currently working well enough to try.</b>

Description:
This project (apart from the code here) only requires an ESP-01 module, slightly modified NodeMCU firmware and a (rechargeable?) battery.
Once running, the ESP-01 acts as an access-point, offering unencrypted access.
I will not redestribute the NodeMCU firmware because of potential rights issues. (Binary blobs in SDK) The relevant change ist to activate the DNS feature in the DHCP settings, so the client uses the module as DNS server.

All DNS-requests are answered with the module's IP (192.168.4.1)
The HTTP-request is parsed and one of the locally stored html pages is sent to the client.
