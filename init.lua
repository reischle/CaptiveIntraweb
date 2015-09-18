print ("---------------------")
print("Setting up WiFi AP...")

 wifi.setmode(wifi.SOFTAP)
 cfg={}
     cfg.ssid="PlayWithMe"
     wifi.ap.config(cfg)

print("Done.")
print ("---------------------")

majorVer, minorVer, devVer, chipid, flashid, flashsize, flashmode, flashspeed = node.info();
print("Flash size is "..flashsize.." kBytes.")

remaining, used, total=file.fsinfo()
    print("File system:\n Total : "..(total/1024).." kBytes\n Used  : "..(used/1024).." kBytes\n Remain: "..(remaining/1024).." kBytes")

local compileAndRemoveIfNeeded = function(f)
   if file.open(f) then
      file.close()
      print('Compiling:', f)
      node.compile(f)
      file.remove(f)
      collectgarbage()
    else
    print("No need to compile ", f )
    end
end
print ("---------------------")
print("Compiling LUA files...")

local serverFiles = {'dns-liar.lua', 'server.lua'}
for i, f in ipairs(serverFiles) do compileAndRemoveIfNeeded(f) end

compileAndRemoveIfNeeded = nil
serverFiles = nil
collectgarbage()

print("Compiling done.")
print ("---------------------")

function startup()
    uart.on("data")
    if abort == true then
        print('startup aborted')
        return
        end
	print ("---------------------")
    print('Starting HTTP Server')
    dofile('server.lc')
    print ('Starting DNS Server')
    dofile('dns-liar.lc')
	print ("---------------------")
    end

 -- prepare abort procedure
    abort = false
    print('Send some xxxx Keystrokes now to abort startup.')
    -- if <CR> is pressed, abort
      uart.on("data", "x", 
      function(data)
        print("receive from uart:", data)
        if data=="x" then
          abort = true 
          uart.on("data") 
        end        
    end, 0)


print ('Will launch servers in 5 seconds...')
tmr.alarm(0,5000,0,startup)