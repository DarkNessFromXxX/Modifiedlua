loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"))() 
wait(25)
local Http = game:GetService("HttpService")
local TPS = game:GetService("TeleportService")
local Api = "https://games.roblox.com/v1/games/"

local _place = game.PlaceId
local desiredOrder = "Asc" -- Choose "Asc" for ascending or "Desc" for descending order

local function ListServers(cursor)
  local url = Api .. _place .. "/servers/Public?sortOrder=" .. desiredOrder .. "&limit=100" .. ((cursor and "&cursor=" .. cursor) or "")
  local Raw = game:HttpGet(url)
  return Http:JSONDecode(Raw)
end

local function JoinAvailableServer()
  repeat
    local Servers = ListServers(Next)
    for i, v in next, Servers.data do
      if v.playing < v.maxPlayers then
        local success, result = pcall(TPS.TeleportToPlaceInstance, TPS, _place, v.id, game.Players.LocalPlayer)
        if success then
          return -- Teleport successful, exit loop
        end
      end
    end
    Next = Servers.nextPageCursor
  until not Next
  
  -- No available servers found
  print("No available servers found. Please try again later.")
end

JoinAvailableServer() -- Call the function to start searching
