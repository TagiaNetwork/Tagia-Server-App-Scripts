--[[
  Title: Weapon Weight
  Version: 1.0
  Description: Add "weight" to each weapon to slow or speed up a player's movement.
  Credits: aLTis (https://opencarnage.net/index.php?/profile/1639-altis/), Kavawuvi (https://opencarnage.net/index.php?/profile/1240-kavawuvi/), and Chalwk (https://opencarnage.net/index.php?/profile/1539-chalwk/)
  Really special thanks to Chawlk, his script organizational structure helped me clean things up a lot. Check out his GitHub if you want more great scrips (https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS)!
]]--

api_version = "1.12.0.0"


local WeaponWeight = {
  version = 1.0,

  enabled = true,

  -- Avaliable Modes:
  -- 0 = Weight is calculated based on the total weight of weapons in the player's inventory.
  -- 1 = Weight is calculated based on the currently held weapon.
  mode = 0,

  -- Default weight of the player.
  default_weight = 1,

  weapons = {
    ["weapons\\assault rifle\\assault rifle"] = 0,
    ["weapons\\shotgun\\shotgun"] = 0,
    ["weapons\\sniper rifle\\sniper rifle"] = 0,
    ["weapons\\pistol\\pistol"] = 0,
    ["weapons\\plasma pistol\\plasma pistol"] = 0,
    ["weapons\\needler\\mp_needler"] = 0,
    ["weapons\\plasma rifle\\plasma rifle"] = 0,
    ["weapons\\rocket launcher\\rocket launcher"] = 0,
    ["weapons\\flamethrower\\flamethrower"] = -0.3,
    ["weapons\\plasma_cannon\\plasma_cannon"] = 0,
    ["weapons\\gravity rifle\\gravity rifle"] = -2,
  }
}


function OnScriptLoad()
  WeaponWeight:Load()
end
function OnScriptUnload() end


function WeaponWeight:Load()
  self.players = {  }

  if (self.enabled) then
    register_callback(cb["EVENT_JOIN"],"OnPlayerConnect")
    register_callback(cb["EVENT_LEAVE"],"OnPlayerDisconnect")

    register_callback(cb["EVENT_TICK"],"OnTick")

    -- Please use Halo: Custom Edition, it's better.
    if (halo_type == "PC") then
      execute_command("quit")
    end
  end
end


function WeaponWeight:InitPlayer(PlayerIndex, Reset)
  if (not Reset) then
    self.players[PlayerIndex] = {
      weight = self.default_weight,
      inventory = {
        ["slot1"] = "None",
        ["slot2"] = "None",
        ["slot3"] = "None"
      },
      vehicle = false
    }
  else
    self.players[PlayerIndex] = nil
  end
end


function OnPlayerConnect(PlayerIndex)
  WeaponWeight:InitPlayer(PlayerIndex, false)
end


function OnPlayerDisconnect(PlayerIndex)
  WeaponWeight:InitPlayer(PlayerIndex, true)
end




function OnTick()
  for PlayerIndex = 1, 16 do
    if (player_present(PlayerIndex) and player_alive(PlayerIndex)) then
      local player = get_dynamic_player(PlayerIndex)
      local player_weight = WeaponWeight.players[PlayerIndex]["weight"]

      local weapons = WeaponWeight.weapons
      local inventory = WeaponWeight.players[PlayerIndex]["inventory"]

      for i = 1, 4 do
        inventory["slot" .. i] = get_object_memory(read_dword(player + 0x2F8 + 4*(i-1)))
        GetSlot(PlayerIndex, "slot" .. i, GetName(inventory["slot" .. i]))
        if (inventory["slot" .. i] ~= nil and weapons[GetName(inventory["slot" .. i])] ~= nil) then
          player_weight = player_weight - weapons[GetName(inventory["slot" .. i])]
        end
      end

      SetSpeedOfPlayer(PlayerIndex, player_weight)
    end
  end
end


function GetSlot(PlayerIndex, Slot, Item)
  WeaponWeight.players[PlayerIndex][Slot] = Item
end



function SetSpeedOfPlayer(PlayerIndex, Speed)
    Speed = math.floor(Speed * 40 + 0.5) / 40
    local player = get_player(PlayerIndex)
    local player_speed = (read_float(get_player(PlayerIndex)) * 40 + 0.5) / 40
    if(player_speed ~= Speed) then
        write_float(get_player(PlayerIndex) + 0x6C, Speed)
    end
end


function GetName(object)
  if (object ~= 0 and object ~= nil ) then
        return read_string(read_dword(read_short(object) * 32 + 0x40440038))
    end
end
