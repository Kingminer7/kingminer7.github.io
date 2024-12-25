-- loadstring(game:HttpGet("https://km7dev.tech/km7menu.luau"))

--[[
       _             ______  _            
      | |           |____  || |           
      | | ___ __ ___    / /_| | _____   __
      | |/ / '_ ` _ \  / / _` |/ _ \ \ / /
      |   <| | | | | |/ / (_| |  __/\ V / 
      |_|\_\_| |_| |_/_/ \__,_|\___| \_/  
       _ __ ___   ___ _ __  _   _         
      | '_ ` _ \ / _ \ '_ \| | | |        
      | | | | | |  __/ | | | |_| |        
      |_| |_| |_|\___|_| |_|\__,_|        
                    | |                   
       ___ _   _ ___| |_ ___ _ __ ___     
      / __| | | / __| __/ _ \ '_ ` _ \    
      \__ \ |_| \__ \ ||  __/ | | | | |   
      |___/\__, |___/\__\___|_| |_| |_|   
            __/ |                         
           |___/
           
	system for creating mod menus
]]	

-- config

local hackName = "km7hack"

-- internal stuff

local services = {
	http = game:GetService("HttpService"),
	run = game:GetService("RunService"),
	repStor = game:GetService("ReplicatedStorage"),
	plrs = game:GetService("Players"),
}

local plr = services.plrs.LocalPlayer
local m = plr:GetMouse()

local globalInstance = _G["GLOBAL_" ..hackName]
if globalInstance then pcall(function() globalInstance.Destroy() end) end

globalInstance = {
	Connections = {},
	Instances = {}
}
globalInstance.Destroy = function() 
	for id, connection in pairs(globalInstance.Connections) do
		pcall(function()
			connection:Disconnect()
		end)
	end
end

globalInstance.Destroy()

local Console = {
	log = function(...)
		print(hackName .. " " .. ...)
	end,
	warn = function(...)
		warn(hackName .. " " .. ...)
	end,
	err = function(...)
		error(hackName .. " " .. ...)
	end,
}

local CEnum = {
	EnvironmentType = {
		Unknown = { Name = "Unknown", Value = 0 },
		Studio = { Name = "Studio", Value = 1 },
		Exploit = { Name = "Exploit", Value = 2 }
	}
}

local envType = CEnum.EnvironmentType.Unknown

if services.run:IsStudio() then
	envType = CEnum.EnvironmentType.Studio
else
	local success, _ = pcall(function()
		identifyexecutor()
	end)

	if success then
		envType = CEnum.EnvironmentType.Exploit
	end
end

Console.log("Running in a(n) " .. envType.Name .. " environment.")

_G["GLOBAL_" ..hackName] = globalInstance

-- UI

local sg = Instance.new("ScreenGui")
sg.Name = services.http:GenerateGUID(false)
sg.Parent = if envType == CEnum.EnvironmentType.Exploit then game.CoreGui else plr:WaitForChild("PlayerGui")

local ratio = sg.AbsoluteSize.X / 1920

local winOffset = Vector2.new(30 * ratio, 30 * ratio)

local dragging = nil

local function createWindow(name: string)
	if sg:FindFirstChild("Window_"..name) then return false end
	local win = Instance.new("Frame")
	win.Position = UDim2.fromOffset(winOffset.X, winOffset.Y)
	win.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
	win.BackgroundTransparency = 0.25
	win.Size = UDim2.new(0, 250 * ratio, 0, 350 * ratio)
	win.BorderSizePixel = 0
	win.Name = "Window_"..name
	win.Parent = sg
	local tb = Instance.new("TextLabel", win)
	tb.BackgroundColor3 = Color3.fromRGB(15, 82, 186)
	tb.BackgroundTransparency = .3
	tb.Size = UDim2.new(0, 250 * ratio, 0, 30 * ratio)
	tb.BorderSizePixel = 0
	tb.Text = name
	tb.TextSize = 16 * ratio
	tb.TextColor3 = Color3.fromRGB(255,255,255)
	
	winOffset += Vector2.new(win.AbsoluteSize.X + 8 * ratio)
	if winOffset.X + 250 * ratio > sg.AbsoluteSize.X then
		winOffset = Vector2.new(30 * ratio, winOffset.Y + win.AbsoluteSize.Y + 8 * ratio)
	end 
	
	spawn(function()
		local inBounds = false
		local offset
		local con = m.Button1Down:Connect(function()
			if inBounds and dragging == nil then
				offset = Vector2.new(win.AbsolutePosition.X - m.X, win.AbsolutePosition.Y - m.Y)
				dragging = name
			end
		end)
		local con2 = services.run.RenderStepped:Connect(function(dt)
			if dragging == name then
				win.Position = UDim2.new(0, m.X + offset.X, 0, m.Y + offset.Y)
			end
		end)
		local con3 = m.Button1Up:Connect(function()
			dragging = nil
		end)
		local con4 = tb.MouseEnter:Connect(function()
			inBounds = true
		end)
		local con5 = tb.MouseLeave:Connect(function()
			inBounds = false
		end)
		globalInstance.Connections["DragWin.Down_"..name] = con
		globalInstance.Connections["DragWin.RS_"..name] = con2
		globalInstance.Connections["DragWin.Up_"..name] = con3
	end)
	return win
end
createWindow("Main Window")
createWindow("Hey look")
createWindow("Its megahack")
createWindow("In roblox")
createWindow("Definitely")
createWindow(":D")
createWindow("hello chat")
createWindow("whatup")
