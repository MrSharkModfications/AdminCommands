
RegisterCommand("kick", function(source, args)
    local playerId = tonumber(args[1])
    local reason = table.concat(args, " ", 2)

    if playerId then
        local playerName = GetPlayerName(playerId)
        if playerName then
            if IsPlayerAceAllowed(source, "kick.allow") then
                DropPlayer(playerId, reason)
                print("Player with ID " .. playerId .. " has been kicked for: " .. reason)
            else
                print("You don't have permission to use this command.")
            end
        else
            print("Player with ID " .. playerId .. " not found.")
        end
    else
        print("Invalid player ID.")
    end
end, false)


RegisterCommand("ban", function(source, args)
    local playerId = tonumber(args[1])
    local reason = table.concat(args, " ", 2)
    local playerPed = GetPlayerPed(source)

    if playerId then
        local playerName = GetPlayerName(playerId)
        if playerName then
            if IsPlayerAceAllowed(source, "ban.allow") then
                TriggerServerEvent("ban:banPlayer", playerId, reason)
                print("Ban request for player with ID " .. playerId .. " has been sent to the server.")
            else
                print("You don't have permission to use this command.")
            end
        else
            print("Player with ID " .. playerId .. " not found.")
        end
    else
        print("Invalid player ID.")
    end
end, false)

RegisterCommand("tp", function(source, args)
    local playerId = tonumber(args[1])
    local targetId = tonumber(args[2])

    if playerId and targetId then
        local playerPed = GetPlayerPed(playerId)
        local targetPed = GetPlayerPed(targetId)

        if playerPed and targetPed then
            local playerCoords = GetEntityCoords(targetPed)
            SetEntityCoords(playerPed, playerCoords.x, playerCoords.y, playerCoords.z, false, false, false, false)
            print("Teleported player with ID " .. playerId .. " to player with ID " .. targetId)
        else
            print("Invalid player ID.")
        end
    else
        print("Invalid usage. Please use /tp [player_id] [target_player_id]")
    end
end, true) 

RegisterCommand("Permban", function(source, args)
    local playerId = tonumber(args[1])
    local reason = table.concat(args, " ", 2)
    local playerPed = GetPlayerPed(source)

    if playerId then
        local playerName = GetPlayerName(playerId)
        if playerName then
            if IsPlayerAceAllowed(source, "ban.allow") then
                TriggerServerEvent("Permban:banPlayer", playerId, reason)
                print("Ban request for player with ID " .. playerId .. " has been sent to the server.")
            else
                print("You don't have permission to use this command.")
            end
        else
            print("Player with ID " .. playerId .. " not found.")
        end
    else
        print("Invalid player ID.")
    end
end, false)

-- Replace 'WEBHOOK_URL' with your actual Discord webhook URL
local WEBHOOK_URL = "YOUR_DISCORD_WEBHOOK_URL_HERE"

RegisterCommand("callstaff", function(source, args)
    local playerName = GetPlayerName(source)
    local message = table.concat(args, " ")

    if message ~= "" then
        -- Notify server staff about the call for assistance
        TriggerClientEvent("staff:receiveCall", -1, playerName, message)
        print("Call for staff assistance from " .. playerName .. ": " .. message)
        
        -- Send a Discord webhook notification
        SendDiscordWebhook("Staff Assistance Request", "**Player:** " .. playerName .. "\n**Message:** " .. message)
    else
        print("Usage: /callstaff [message]")
    end
end, false)

function SendDiscordWebhook(title, message)
    local jsonData = json.encode({["content"] = message, ["username"] = title})

    PerformHttpRequest(WEBHOOK_URL, function(statusCode, response, headers)
        if statusCode ~= 204 and statusCode ~= 200 then
            print("Failed to send Discord webhook (Status Code: " .. tostring(statusCode) .. ")")
            print("Response: " .. tostring(response))
        else
            print("Discord webhook sent successfully!")
        end
    end, "POST", jsonData, {["Content-Type"] = "application/json"})
end



