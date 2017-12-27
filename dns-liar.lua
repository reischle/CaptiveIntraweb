--Very simple DNS server that only ever serves the IP of this node.

--Thanks to Thomas Shaddack for optimizations - 20150707 ARe

--Get the IP of this node and get its octets so we can insert it into the
--DNS response.
dns_ip=wifi.ap.getip()
local i1,i2,i3,i4=dns_ip:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")

--Convenience vars to hold 0x00 and 0x01, since we'll be using them a bunch
x00=string.char(0)
x01=string.char(1)

--The DNS packet we send is in basically five parts:
--  1. The 2-byte request ID we got from the client
--  2. The _str1 part of the header, which generates the QR-to-ARCOUNT fields
--     of the RFC1035 header.
--  3. The name that was requested by the client (parroted back)
--  4. A blob with the predefined Question/Response type/class/ttl/length and
--     finally
--  5. The IP of this node.
-- The blobs are further broken out below.

-- The first blob.  This is the first several fields of the response:
--  Byte 1:
--    Bit 1 (QR) - set on to indicate this is a response
--    Bits 2-5 (OPCODE) - set to zero (a standard query)
--    Bit 6 (AA) - set to zero (non-authoritative)
--    Bit 7 (TC) - set to zero (not truncated)
--    Bit 8 (RD) - set to zero (no need to recurse)
--  Byte 2:
--    Bit 1 (RA) - set to zero (no recursion available)
--    Bits 2-4 (Z) - set to zero (reserved)
--    Bits 5-8 (RCODE) - set to zero (no errors)
--  Bytes 3-4 (QDCOUNT): set to one entry (big endian) in the question section
--  Bytes 5-6 (ANCOUNT): set to one entry (big endian) in the answer section
--  Bytes 7-8 (NSCOUNT): set to zero entries in the authority records section
--  Bytes 9-10 (ARCOUNT): set to zero entries in the additional records section
dns_str1=string.char(128)..x00..x00..x01..x00..x01..x00..x00..x00..x00

-- The second blob covering the question type/class and the response
-- type/class/ttl/length
--  Question:
--    Bytes 1-2 (TYPE): Specifies resource type 0x1 big-endian (an A record)
--    Bytes 3-4 (CLASS): Specifies class type 0x1 big-endian (Internet class)
--  Response:
--    Bytes 5-6 (NAME): Uses the RFC1035 "compression" scheme as:
--      Bits 1-2: Set to one per the spec
--      Bits 3-16 (OFFSET): Set to decimal 12 big-endian, which is where
--                          (relative to the beginning of the ID field) the
--                          original question domain is.  This is a cheap way
--                          of repeating the original question as a pointer
--                          rather than spitting the whole thing out again.
--    Bytes 7-8 (TYPE): Specifies 0x1 big-endian (A record)
--    Bytes 9-10 (CLASS): Internet class 0x1 BE
--    Bytes 11-16 (TTL): How long to keep this record cached in big-endian
--                       seconds (0x30 = 768 secs).
--    Bytes 17-18 (RDLENGTH) How long the RDATA field is in big-endian (4)
dns_str2=x00..x01..x00..x01..string.char(192)..string.char(12)..x00..x01..x00..x01..x00..x00..string.char(3)..x00..x00..string.char(4)

--The IP of this node expressed as a big-endian bytestring
dns_strIP=string.char(i1)..string.char(i2)..string.char(i3)..string.char(i4)

--Now that we've defined all the stuff we'll stick in the response (other than
--the bits we get from the question), create the server:

--Set up the simple server, add a callback to decode the question part of the
--packet.
svr=net.createServer(net.UDP)
svr:on("receive",function(svr,dns_pl)
  decodedns(dns_pl)
  svr:send(dns_tr..dns_str1..dns_q..dns_str2..dns_strIP)
  collectgarbage("collect")
end)
svr:listen(53)

--Decode the incoming question.  We fairly blindly make several assumptions
--about the question--this will break horribly if those assumptions aren't
--correct.
--
--Input: The DNS packet from the client
--Output: None
--Side Effects: dns_tr is set to the ID we got from the client, dns_q is set
--              to the NAME field from the client request.
function decodedns(dns_pl)
  local a=string.len(dns_pl)
  dns_tr = string.sub(dns_pl, 1, 2)
  local bte=""
  dns_q=""
  -- We make a fairly blind assumption that the DNS requested NAME is at offset
  -- 13 (as it will be in our response).  This will work pretty much all the
  -- time, but isn't guaranteed per spec.
  local i=13
  local bte2=""
  -- The RFC says any name will have a zero as the final length, which behaves
  -- de facto like an ASCIIZ string (though, strictly-speaking, it isn't).
  -- So basically we reimplement strcpy(3) kinda.
  while bte2 ~= "0" do
    bte = string.byte(dns_pl,i)
    bte2 = string.format("%x", bte )
    dns_q = dns_q .. string.char(bte)
    i=i+1
  end
end

print("DNS Server is now listening. Free Heap:", node.heap())
