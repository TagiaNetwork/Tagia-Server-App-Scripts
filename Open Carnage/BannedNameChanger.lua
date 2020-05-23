-- Banned Name Changer by Enclusion (https://opencarnage.net/index.php?/profile/2156-enclusion/)
-- Version: 1.2
-- Uploaded: OpenCarnage.net
-- Credits:
	-- OnNameRequest by Devieth (https://opencarnage.net/index.php?/profile/1597-devieth/)

-- CONFIG START

local banned = {'ebon4', 'gamerword', 'nword', 'fword'}
local replaceWith = "Blocked" -- 

-- CONFIG END

local count = 0
local newReplace = replaceWith .. count

api_version = "1.12.0.0"
ce, client_info_size = 0x40, 0xEC

function OnScriptLoad()
	register_callback(cb['EVENT_PREJOIN'], "OnPlayerPrejoin")
	if halo_type == "PC" then execute_command("quit")end --btfo halo pc, play halo custom edition or else
end
function OnScriptUnload() end

function OnPlayerPrejoin(PlayerIndex)
    local network_struct = read_dword(sig_scan("F3ABA1????????BA????????C740??????????E8????????668B0D") + 3)
    local client_network_struct = network_struct + 0x1AA + ce + to_real_index(PlayerIndex) * 0x20
    local name = read_widestring(client_network_struct, 12)
    local new_name = OnNameRequest(PlayerIndex, name)
    if has_value(banned, name)then -- Check if the new name is different from the players orignal name.
		cprint("[BannedName] User '" .. name .. "' violated banned name list. Changed to '" .. newReplace .. "'.")
        write_widestring(client_network_struct, string.sub(new_name,1,11), 12) -- Set the new name if its different from the orignal.
    end
end

function OnNameRequest(PlayerIndex, Name)
	if count == 0 then
		count = count + 1
		return replaceWith -- Send back the decidred name.
	end
	if count ~= 0 then
		if count ==  99 then
			count = 0
		end
		count = count + 1
		newReplace = replaceWith .. count
		return newReplace
	end
end

-- Don't touch these...
function write_widestring(address, str, len)
    local Count = 0
    for i = 1,len do -- Nuls out the old sting.
        write_byte(address + Count, 0)
        Count = Count + 2
    end
    local length = string.len(str)
    local count = 0
    for i = 1,length do -- Sets the new string.
        local newbyte = string.byte(string.sub(str,i,i))
        write_byte(address + count, newbyte)
        count = count + 2
    end
end

function read_widestring(Address, Size)
    local str = ""
    for i=0,Size-1 do
        if read_byte(Address + i*2) ~= 00 then
            str = str .. string.char(read_byte(Address + i*2))
        end
    end
    if str ~= "" then return str end
    return nil
end
function has_value (tab, val)
    for index, value in ipairs(tab) do
		if string.find(val, value) ~= nil then
			return true
		end
    end

    return false
end
