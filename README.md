# CaptiveIntraweb
A very simple, esp8266 based standalone captive-portal-like, access point serving local files only.
This turns an ESP-01 module into an autonomous WiFi throwie. 

<b>As the project seems to run stable enough to pass as a 1.0 version. So have a try and let me know how it went for you.</b>

Description:
This project (apart from the code here) only requires an ESP-01 module, slightly modified NodeMCU firmware and a (rechargeable?) battery.
Once running, the ESP-01 acts as an access-point, offering unencrypted access.
I have added the firmware to the release packages, as the dev-environment now should all be open source / MIT licensed.

All DNS-requests are answered with the module's IP (192.168.4.1)
The HTTP-request is parsed and one of the locally stored html pages is sent to the client.
