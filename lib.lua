local OS, OSAddon = ...
OnslaughtAce = LibStub("AceAddon-3.0"):NewAddon("OnslaughtAce", "AceConsole-3.0")
AceGUI = LibStub("AceGUI-3.0")

OSAddon.lib = {}

OSAddon.lib.ADDON_MSG_PREFIX = "ONSAddonMessage"
OSAddon.lib.separator = "|"
OSAddon.lib.sendAddonMessage = function(prefix, ...)
    local msg = prefix
    local argz = {...}
    for i = 1, #argz do
        msg = msg .. OSAddon.lib.separator .. argz[i]
    end
    C_ChatInfo.SendAddonMessage(OSAddon.lib.ADDON_MSG_PREFIX, msg, "RAID")
end
OSAddon.lib.separate = function(text, count)
    return strsplit(OSAddon.lib.separator, text, count)
end

-- DUMP TABLE
OSAddon.lib.dump = function(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. OSAddon.lib.dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

 -- SPLIT STRING
OSAddon.lib.split = function(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

 -- PARSE LOOT TSV
 OSAddon.lib.parseLootTSV = function(lootString)
    local items = {}
    local split = OSAddon.lib.split
    local lines = split(lootString, "\n")
    for i = 1, #lines do
        local str = lines[i]
        str = string.gsub(str, "^%s+", "")
        if string.match(str, "^(.*(%a+): (%d+).*)") then
            local data = split(str.."  ", "%s%s+")
            local item = data[1]
            items[item] = {}
            for l = 1, #data do
                local details = data[l]
                if string.match(details, "^(%a+): (%d+)") then
                    local nameScore = split(details, ": ")
                    table.insert(items[item], { name = nameScore[1], score = nameScore[2] })
                end
            end
        end
    end
    return items
end

-- AM I MASTER LOOTER?
OSAddon.lib.getRosterInfo = function()
    local roster = {}
    for i = 1, 40 do
        local name, _, _, _, playerClass, _, _, _, _, _, isML, _ = GetRaidRosterInfo(i)
           -- name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole
        if name then
            roster[name] = { class = playerClass, isMasterLooter = isML, name = name }
        end
    end
    return roster
end
