--[[
Modified by Andy Reischle

Based on 
XChip's NodeMCU IDE
]]--

srv=net.createServer(net.TCP) 
srv:listen(80,function(conn) 

   local rnrn=0
   local Status = 0
   local DataToGet = 0
   local method=""
   local url=""
   local vars=""

  conn:on("receive",function(conn,payload)
  
    if Status==0 then
        _, _, method, url, vars = string.find(payload, "([A-Z]+) /([^?]*)%??(.*) HTTP")
        -- print(method, url, vars)                          
    end

	-- some ugly magic for Apple IOS Devices
	if string.find(url, "/") ~= nil then
	 --print ("Slash found")
	 local invurl=string.reverse(url)
	 local a,b=string.find(invurl, "/", 1)
	 url=string.sub(url, string.len(url)-(a-2))
	 --print ("Neue URL= " .. url)
	end
		
	if string.len(url)>= 25 then
		url = string.sub (url,1,25)
	--	print ("cut down URL")
	end
	
   
    DataToGet = -1

    if url == "favicon.ico" then
        conn:send("HTTP/1.1 404 file not found")
        return
    end    

	
    conn:send("HTTP/1.1 200 OK\r\n\r\n")

	if url=="status.htm" then
	file.open("counter.txt", "r")
    local cnt=(file.read('\r'))
    file.close()
	conn:send("<html><body><h1>System status</h1>")
	conn:send("<p>Die Spiele wurden " .. cnt .. " mal aufgerufen.</p>")
	conn:send("<p>Freier Arbeitsspeicher: " .. node.heap() .. " Bytes</p>")
	conn:send("<p>System Laufzeit: " .. tmr.now()/1000000 .. " seconds</p>")
    conn:send("</body></html>")
	conn:close()
	-- print ("<p>games have been viewed " .. cnt .. " times.</p>")
	return
    end
	
	if url==nil then
		url="index.htm"
	end
	
	if url=="" then
		url="index.htm"
	end
	
	local foundmatch = 0
	local a = {'wumpus.htm','index.htm','about.htm','ttt.htm','instruct.htm','status.htm'}
	for _,v in pairs(a) do
		if v == url then
			foundmatch=1
			-- print ("Found " .. v)
			break
		end
	end

if foundmatch == 0 then
	-- print ("Found no match, setting index")
    url="index.htm"
end

	
	if url == "wumpus.htm" or url == "ttt.htm" then
	  --increment the counter file
	  --print ("game called!")
	  counter()
	end
		
    -- it wants a file in particular
    if url~="" then
        DataToGet = 0
        return
    end    

   -- conn:send("<html><body><h1>NodeMCU IDE</h1>")
  
    
   -- conn:send("</body></html>")

  end)
  
  conn:on("sent",function(conn) 
    if DataToGet>=0 and method=="GET" then
        if file.open(url, "r") then            
            file.seek("set", DataToGet)
            local line=file.read(512)
            file.close()
            if line then
                conn:send(line)
                DataToGet = DataToGet + 512    

                if (string.len(line)==512) then
                    return
                end
            end
        end        
    end

    conn:close() 
  end)
end)

function counter()
file.open("counter.txt", "r")
    local cnt=(file.read('\r'))
    file.close()
cnt=cnt+1
    file.open("counter.txt", "w+")
    file.write(cnt)
    file.flush()
    file.close()
end

	
print("listening, free:", node.heap())

