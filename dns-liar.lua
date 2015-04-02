svr=net.createServer(net.UDP) 
svr:on("receive",function(svr,pl)
decodedns(pl)
encodedns (query, transaction_id)
svr:send(response)
end)
svr:listen(53)

function decodedns(pl)
a=string.len(pl)
transaction_id  = string.sub(pl, 1, 2)
bte=""
query=""
i=13
bte2=""
while bte2 ~= "0" do
bte = string.byte(pl,i)
bte2 = string.format("%x", bte )
query = query .. string.char(bte)
i=i+1
end
end

function encodedns(query, transaction_id)
local tmpresponse=transaction_id
tmpresponse=tmpresponse .. unhex "81 80"
tmpresponse=tmpresponse .. unhex "00 01"
tmpresponse=tmpresponse .. unhex "00 01"
tmpresponse=tmpresponse .. unhex "00 00"
tmpresponse=tmpresponse .. unhex "00 00"
tmpresponse=tmpresponse .. query
tmpresponse=tmpresponse .. unhex "00 01"
tmpresponse=tmpresponse .. unhex "00 01"
tmpresponse=tmpresponse .. unhex "c0 0c"
tmpresponse=tmpresponse .. unhex "00 01"
tmpresponse=tmpresponse .. unhex "00 01"
tmpresponse=tmpresponse .. unhex "00 00"
tmpresponse=tmpresponse .. unhex "03 09"
tmpresponse=tmpresponse .. unhex "00 04"
--IP Address goes here
tmpresponse=tmpresponse .. unhex "c0 a8" 
response=tmpresponse .. unhex "04 01" 
collectgarbage("collect")
end

function unhex(str)
    str = string.gsub (str, "(%x%x) ?",
        function(h) return string.char(tonumber(h,16)) end)
	    return str
end