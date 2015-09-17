# CaptiveIntraweb
A very simple, esp8266 based standalone captive-portal-like, access point serving local files only.
This turns an ESP-01 module into an autonomous WiFi throwie. 

<b>Although the English release is currently ahead of the German version, you can use the html files of the German verion in the new English release.</b>

Description:
This project (apart from the code here) only requires an ESP-01 module, slightly modified NodeMCU firmware and a (rechargeable?) battery.
Once running, the ESP-01 acts as an access-point, offering unencrypted access.
I have added the firmware to the release packages, as the dev-environment now should all be open source / MIT licensed.

All DNS-requests are answered with the module's IP (192.168.4.1)
The HTTP-request is parsed and one of the locally stored html pages is sent to the client.

Rel03 comes with a vastly improved startup procedure (init.lua).
Not all files may fit on your module, especially if flash size is only 512kByte. Leave out the PDF and MP3 files to resolve that.
