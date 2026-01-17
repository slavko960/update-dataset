local Pls = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Plr = Pls.LocalPlayer
local UIsafe = gethui() or game:GetService("CoreGui") --or Plr:WaitForChild("PlayerGui") -- only for tests in roblox studio
local PG = UIsafe

local T = {
	Bg = Color3.fromRGB(15, 15, 15),
	BgA = Color3.fromRGB(25, 25, 25),
	Hdr = Color3.fromRGB(20, 20, 20),
	Bdr = Color3.fromRGB(50, 50, 50),
	Sec = Color3.fromRGB(22, 22, 22),
	Acc = Color3.fromRGB(90, 90, 90),
	AccR = Color3.fromRGB(255, 255, 255),
	AccG = Color3.fromRGB(211, 211, 211),
	Txt = Color3.fromRGB(255, 255, 255),
	TxD = Color3.fromRGB(200, 200, 200),
	Btn = Color3.fromRGB(35, 35, 35),
	BtH = Color3.fromRGB(45, 45, 45),
	BtA = Color3.fromRGB(55, 55, 55),
	Tgl = Color3.fromRGB(40, 40, 40),
	TgE = Color3.fromRGB(180, 60, 60), 
	TgD = Color3.fromRGB(50, 50, 50), 
	Sld = Color3.fromRGB(30, 30, 30),
	SlF = Color3.fromRGB(180, 60, 60),
}

-- Ensure required folders exist
local function ensureThemeFolders()
	if makefolder then
		pcall(makefolder, "looksink")
		pcall(makefolder, "looksink/configs")
		pcall(makefolder, "looksink/themes")
	end
end

-- Theme management
local Theme = {}
Theme.__index = Theme

local themeUpdateCallbacks = {}

function Theme:Get()
	return T
end

function Theme:Set(newTheme)
	for key, value in pairs(newTheme) do
		if T[key] and typeof(value) == typeof(T[key]) then
			T[key] = value
		end
	end
	Theme:NotifyUpdate()
	return T
end

function Theme:UpdateColor(colorName, colorValue)
	if T[colorName] and typeof(colorValue) == typeof(T[colorName]) then
		T[colorName] = colorValue
		Theme:NotifyUpdate()
		return true
	end
	return false
end

function Theme:Reset()
	T = {
		Bg = Color3.fromRGB(15, 15, 15),
		BgA = Color3.fromRGB(25, 25, 25),
		Hdr = Color3.fromRGB(20, 20, 20),
		Bdr = Color3.fromRGB(50, 50, 50),
		Sec = Color3.fromRGB(22, 22, 22),
		Acc = Color3.fromRGB(90, 90, 90),
		AccR = Color3.fromRGB(255, 255, 255),
		AccG = Color3.fromRGB(211, 211, 211),
		Txt = Color3.fromRGB(255, 255, 255),
		TxD = Color3.fromRGB(200, 200, 200),
		Btn = Color3.fromRGB(35, 35, 35),
		BtH = Color3.fromRGB(45, 45, 45),
		BtA = Color3.fromRGB(55, 55, 55),
		Tgl = Color3.fromRGB(40, 40, 40),
		TgE = Color3.fromRGB(180, 60, 60), 
		TgD = Color3.fromRGB(50, 50, 50), 
		Sld = Color3.fromRGB(30, 30, 30),
		SlF = Color3.fromRGB(180, 60, 60),
	}
	Theme:NotifyUpdate()
	return T
end

function Theme:RegisterUpdateCallback(callback)
	table.insert(themeUpdateCallbacks, callback)
end

function Theme:NotifyUpdate()
	for _, callback in ipairs(themeUpdateCallbacks) do
		pcall(callback, T)
	end
end

local DEFAULT_THEME = {
	Bg = Color3.fromRGB(15, 15, 15),
	BgA = Color3.fromRGB(25, 25, 25),
	Hdr = Color3.fromRGB(20, 20, 20),
	Bdr = Color3.fromRGB(50, 50, 50),
	Sec = Color3.fromRGB(22, 22, 22),
	Acc = Color3.fromRGB(90, 90, 90),
	AccR = Color3.fromRGB(255, 255, 255),
	AccG = Color3.fromRGB(211, 211, 211),
	Txt = Color3.fromRGB(255, 255, 255),
	TxD = Color3.fromRGB(200, 200, 200),
	Btn = Color3.fromRGB(35, 35, 35),
	BtH = Color3.fromRGB(45, 45, 45),
	BtA = Color3.fromRGB(55, 55, 55),
	Tgl = Color3.fromRGB(40, 40, 40),
	TgE = Color3.fromRGB(180, 60, 60),
	TgD = Color3.fromRGB(50, 50, 50),
	Sld = Color3.fromRGB(30, 30, 30),
	SlF = Color3.fromRGB(180, 60, 60),
}

local function ensureThemeFolders()
	if makefolder then
		pcall(makefolder, "looksink")
		pcall(makefolder, "looksink/configs")
		pcall(makefolder, "looksink/themes")
	end
end

local function ensureDefaultTheme()
	if not writefile or not readfile then return end
	
	ensureThemeFolders()
	
	local defaultPath = "looksink/themes/default.json"
	local exists = pcall(readfile, defaultPath)
	
	if not exists then
		local themeData = {}
		for key, value in pairs(DEFAULT_THEME) do
			if typeof(value) == "Color3" then
				themeData[key] = {
					r = math.floor(value.R * 255),
					g = math.floor(value.G * 255),
					b = math.floor(value.B * 255)
				}
			end
		end
		local jsonData = game:GetService("HttpService"):JSONEncode(themeData)
		pcall(writefile, defaultPath, jsonData)
	end
end

local function getStartupTheme()
	if not readfile then return nil end
	local success, name = pcall(readfile, "looksink/themes/_startup.txt")
	if success and name and name ~= "" then
		return name
	end
	return nil
end

local function setStartupTheme(name)
	if not writefile then return false end
	ensureThemeFolders()
	local success = pcall(writefile, "looksink/themes/_startup.txt", name)
	return success
end

local function clearStartupTheme()
	if not delfile then return false end
	local success = pcall(delfile, "looksink/themes/_startup.txt")
	return success
end

function Theme:SetDefault(name)
	return setStartupTheme(name)
end

function Theme:GetDefault()
	return getStartupTheme()
end

function Theme:ClearDefault()
	return clearStartupTheme()
end

function Theme:LoadStartup()
	ensureDefaultTheme()
	local startupTheme = getStartupTheme()
	if startupTheme then
		return self:LoadTheme(startupTheme)
	end
	return false
end

function Theme:SaveTheme(name)
	if not writefile then
		warn("writefile not available")
		return false
	end
	
	ensureThemeFolders()
	
	local themeData = {}
	for key, value in pairs(T) do
		if typeof(value) == "Color3" then
			themeData[key] = {
				r = math.floor(value.R * 255),
				g = math.floor(value.G * 255),
				b = math.floor(value.B * 255)
			}
		end
	end
	
	local fileName = "looksink/themes/" .. name .. ".json"
	local jsonData = game:GetService("HttpService"):JSONEncode(themeData)
	
	local success = pcall(writefile, fileName, jsonData)
	return success
end

function Theme:LoadTheme(name)
	if not readfile then
		warn("readfile not available")
		return false
	end
	
	ensureThemeFolders()
	local fileName = "looksink/themes/" .. name .. ".json"
	
	local success, data = pcall(readfile, fileName)
	if not success then 
		return false 
	end
	
	local success2, themeData = pcall(game:GetService("HttpService").JSONDecode, game:GetService("HttpService"), data)
	if not success2 then 
		return false 
	end
	
	local loadedTheme = {}
	for key, value in pairs(themeData) do
		if typeof(value) == "table" and value.r and value.g and value.b then
			loadedTheme[key] = Color3.fromRGB(value.r, value.g, value.b)
		end
	end
	
	return self:Set(loadedTheme)
end

function Theme:GetSavedThemes()
	if not readfile then return {"default"} end
	
	ensureDefaultTheme()
	
	local themes = {}
	local success = pcall(function()
		if listfiles then
			ensureThemeFolders()
			local files = listfiles("looksink/themes")
			for _, file in ipairs(files) do
				local name = file:match("([^/\\]+)%.json$")
				if name and name ~= "_startup" then
					table.insert(themes, name)
				end
			end
		end
	end)
	
	if #themes == 0 then
		table.insert(themes, "default")
	end
	
	return themes
end

function Theme:TestFiles()
	print("=== Testing file access ===")
	print("makefolder:", makefolder ~= nil)
	print("writefile:", writefile ~= nil)
	print("readfile:", readfile ~= nil)
	print("listfiles:", listfiles ~= nil)
	print("delfiles:", delfiles ~= nil)
	
	ensureThemeFolders()
	
	if writefile then
		local testSuccess = pcall(writefile, "looksink/themes/test.json", '{"test": true}')
		print("Test write success:", testSuccess)
	end
	
	if readfile then
		local testSuccess, testData = pcall(readfile, "looksink/themes/test.json")
		print("Test read success:", testSuccess, testData)
	end
	
	if listfiles then
		local testSuccess, testFiles = pcall(listfiles, "looksink/themes")
		print("Test listfiles success:", testSuccess, testFiles)
	end
	
	print("=== End test ===")
end

_G.LooksinkTheme = Theme

local function ensureThemeFolders()
	if makefolder then
		pcall(makefolder, "looksink")
		pcall(makefolder, "looksink/configs")
		pcall(makefolder, "looksink/themes")
	end
end

local function CI(c, p)
	local i = Instance.new(c)
	for k, v in pairs(p) do i[k] = v end
	return i
end

local Lib = {}
Lib.__index = Lib

local KBL = {}

function Lib.new(o)
	local s = setmetatable({}, Lib)
	o = o or {}

	s.Tbs = {}
	s.CTb = nil
	s.Vis = true
	s.Sz = o.Size or UDim2.new(0, 700, 0, 550)
	s.Ttl = o.Title or ""

	s.SG = CI("ScreenGui", {
		Name = "CG",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = PG
	})

	s.MF = CI("Frame", { 
		Name = "MF",
		Size = s.Sz,
		Position = UDim2.new(0.5, -s.Sz.X.Offset/2, 0.5, -s.Sz.Y.Offset/2),
		BackgroundColor3 = T.Bg,
		BorderSizePixel = 1,
		BorderColor3 = T.Bdr,
		Parent = s.SG
	})

	CI("ImageLabel", {
		Name = "Shadow",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, 60, 1, 60),
		BackgroundTransparency = 1,
		Image = "rbxassetid://6015897843",
		ImageColor3 = Color3.new(0, 0, 0),
		ImageTransparency = 0.3,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(49, 49, 450, 450),
		ZIndex = 0, 
		Parent = s.MF
	})

	s.Hdr = CI("Frame", {
		Name = "Hdr",
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundColor3 = T.Hdr,
		BorderSizePixel = 0,
		Parent = s.MF
	})

	CI("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 1, -1),
		BackgroundColor3 = T.Bdr,
		BorderSizePixel = 0,
		Parent = s.Hdr
	})

	CI("TextLabel", {
		Size = UDim2.new(1, -10, 1, 0),
		Position = UDim2.new(0, 8, 0, 0),
		BackgroundTransparency = 1,
		Text = s.Ttl,
		TextColor3 = T.AccR,
		TextSize = 12,
		Font = Enum.Font.Code,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = s.Hdr
	})

	s.TC = CI("Frame", {
		Name = "TC",
		Size = UDim2.new(0, 140, 1, -34),
		Position = UDim2.new(0, 5, 0, 29),
		BackgroundColor3 = T.BgA,
		BorderSizePixel = 1,
		BorderColor3 = T.Bdr,
		Parent = s.MF
	})

	CI("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 2),
		Parent = s.TC
	})

	CI("UIPadding", {
		PaddingTop = UDim.new(0, 4),
		PaddingLeft = UDim.new(0, 4),
		PaddingRight = UDim.new(0, 4),
		Parent = s.TC
	})

	s.CC = CI("Frame", {
		Name = "CC",
		Size = UDim2.new(1, -160, 1, -34),
		Position = UDim2.new(0, 150, 0, 29),
		BackgroundColor3 = T.BgA,
		BackgroundTransparency = 0.5,
		BorderSizePixel = 1,
		BorderColor3 = T.Bdr,
		Parent = s.MF
	})

	s:MD()

	Theme:RegisterUpdateCallback(function(theme)
		if s.MF then
			s.MF.BackgroundColor3 = theme.Bg
			s.MF.BorderColor3 = theme.Bdr
		end
		if s.Hdr then
			s.Hdr.BackgroundColor3 = theme.Hdr
		end
		if s.TC then
			s.TC.BackgroundColor3 = theme.BgA
			s.TC.BorderColor3 = theme.Bdr
		end
		if s.CC then
			s.CC.BackgroundColor3 = theme.BgA
			s.CC.BorderColor3 = theme.Bdr
		end
		if s.WM then
			s.WM.BackgroundColor3 = theme.Bg
			s.WM.BorderColor3 = theme.Bdr
		end
		if s.WMT then
			s.WMT.TextColor3 = theme.AccR
		end
		
		for _, tb in pairs(s.Tbs) do
			if tb.Btn then
				tb.Btn.BackgroundColor3 = tb == s.CTb and theme.BgA or theme.Bg
				local tbL = tb.Btn:FindFirstChild("TbL")
				if tbL then
					tbL.TextColor3 = tb == s.CTb and theme.AccR or theme.TxD
				end
			end
		end
		
		for _, tb in pairs(s.Tbs) do
			if tb.LC and tb.RC then
				for _, container in pairs({tb.LC, tb.RC}) do
					for _, child in pairs(container:GetChildren()) do
						if child:IsA("Frame") and child.Name ~= "TC" then
							child.BackgroundColor3 = theme.Sec
							child.BorderColor3 = theme.Bdr
							
							for _, element in pairs(child:GetChildren()) do
								if element:IsA("TextLabel") then
									element.TextColor3 = theme.AccR
								elseif element:IsA("TextButton") then
									if element.Name:find("Slider") or element.Name:find("Toggle") then
										element.BackgroundColor3 = theme.Tgl
										element.BorderColor3 = theme.Bdr
									else
										element.BackgroundColor3 = theme.Btn
										element.BorderColor3 = theme.Bdr
									end
									element.TextColor3 = theme.AccR
								elseif element:IsA("Frame") and (element.Name:find("Slider") or element.Name:find("Toggle")) then
									element.BackgroundColor3 = theme.Sld
									element.BorderColor3 = theme.Bdr
								end
							end
						end
					end
				end
			end
		end
		
		if s.KLF then
			s.KLF.BackgroundColor3 = theme.Bg
			s.KLF.BorderColor3 = theme.Bdr
			local klfHeader = s.KLF:FindFirstChildWhichIsA("TextLabel")
			if klfHeader then
				klfHeader.BackgroundColor3 = theme.Hdr
				klfHeader.TextColor3 = theme.AccR
			end
		end
	end)

	s.LastMouseBehavior = UIS.MouseBehavior

	s.ToggleBind = Enum.KeyCode.RightShift

	local function matchesToggle(input)
		if not s.ToggleBind then return false end
		if typeof(s.ToggleBind) ~= "EnumItem" then return false end
		if s.ToggleBind.EnumType == Enum.KeyCode and input.KeyCode == s.ToggleBind then
			return true
		elseif s.ToggleBind.EnumType == Enum.UserInputType and input.UserInputType == s.ToggleBind then
			return true
		end
		return false
	end

	local function applyCursorState(showing)
		if showing then
			s.LastMouseBehavior = UIS.MouseBehavior
			UIS.MouseIconEnabled = true
			UIS.MouseBehavior = Enum.MouseBehavior.Default
		else
			UIS.MouseBehavior = s.LastMouseBehavior or Enum.MouseBehavior.Default
		end
	end

	local toggleConn = nil
	local function enableToggle()
		if toggleConn then toggleConn:Disconnect() end
		toggleConn = UIS.InputBegan:Connect(function(i, p)
			if not p and matchesToggle(i) then
				s.Vis = not s.Vis
				s.MF.Visible = s.Vis
				applyCursorState(s.Vis)
			end
		end)
	end
	
	enableToggle()
	
	return s
end

function Lib:SetToggleKey(k)
	if typeof(k) == "EnumItem" and (k.EnumType == Enum.KeyCode or k.EnumType == Enum.UserInputType) then
		self.ToggleBind = k
		self:_enableToggle()
		return true
	end
	return false
end

function Lib:_enableToggle()
	if self.ToggleBind then
		local UIS = game:GetService("UserInputService")
		local matchesToggle = function(input)
			if typeof(self.ToggleBind) ~= "EnumItem" then return false end
			if self.ToggleBind.EnumType == Enum.KeyCode and input.KeyCode == self.ToggleBind then
				return true
			elseif self.ToggleBind.EnumType == Enum.UserInputType and input.UserInputType == self.ToggleBind then
				return true
			end
			return false
		end
		if self._toggleConn then self._toggleConn:Disconnect() end
		self._toggleConn = UIS.InputBegan:Connect(function(i, p)
			if not p and matchesToggle(i) then
				self.Vis = not self.Vis
				self.MF.Visible = self.Vis
				local applyCursorState = function(showing)
					if showing then
						self.LastMouseBehavior = UIS.MouseBehavior
						UIS.MouseIconEnabled = true
						UIS.MouseBehavior = Enum.MouseBehavior.Default
					else
						UIS.MouseBehavior = self.LastMouseBehavior or Enum.MouseBehavior.Default
					end
				end
				applyCursorState(self.Vis)
			end
		end)
	end
end

function Lib:CreateWatermark(o)
	o = o or {}
	local txt = o.Text or "WATERMARK"
	local sz = o.Size or UDim2.new(0, 220, 0, 26)
	local pos = o.Position or UDim2.new(0, 10, 0, 10)

	self.WM = CI("Frame", {
		Name = "WM",
		Size = sz,
		Position = pos,
		BackgroundColor3 = T.Bg,
		BorderSizePixel = 1,
		BorderColor3 = T.Bdr,
		Parent = self.SG
	})

	self.WMT = CI("TextLabel", {
		Size = UDim2.new(1, -10, 1, 0),
		Position = UDim2.new(0, 5, 0, 0),
		BackgroundTransparency = 1,
		Text = txt .. " | FPS: 60",
		TextColor3 = T.AccR,
		TextSize = 11,
		Font = Enum.Font.Code,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = self.WM
	})

	self:MWD()

	local bt = txt
	spawn(function()
		while wait(0.5) do
			if self.WMT and self.WMT.Parent then
				local fps = math.floor(1 / RS.RenderStepped:Wait())
				local png = math.floor(Plr:GetNetworkPing() * 1000)
				self.WMT.Text = bt .. " | FPS: " .. fps .. " | " .. png .. "ms"
			end
		end
	end)

	return self.WM
end

function Lib:MWD()
	if not self.WM then return end
	local dg, ds, sp = false, nil, nil

	self.WM.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dg = true
			ds = i.Position
			sp = self.WM.Position
		end
	end)

	self.WM.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then dg = false end
	end)

	UIS.InputChanged:Connect(function(i)
		if dg and i.UserInputType == Enum.UserInputType.MouseMovement then
			local d = i.Position - ds
			self.WM.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
		end
	end)
end

function Lib:CreateKeybindList(o)
	o = o or {}
	local sz = o.Size or UDim2.new(0, 160, 0, 140)
	local pos = o.Position or UDim2.new(1, -170, 0, 10)
	local vis = o.Visible ~= false

	self.KLF = CI("Frame", {
		Name = "KL",
		Size = sz,
		Position = pos,
		BackgroundColor3 = T.Bg,
		BorderSizePixel = 1,
		BorderColor3 = T.Bdr,
		Visible = vis,
		Parent = self.SG
	})

	CI("TextLabel", {
		Size = UDim2.new(1, 0, 0, 22),
		BackgroundColor3 = T.Hdr,
		BorderSizePixel = 0,
		Text = "[ KEYBINDS ]",
		TextColor3 = T.AccR,
		TextSize = 11,
		Font = Enum.Font.Code,
		Parent = self.KLF
	})

	CI("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 0, 22),
		BackgroundColor3 = T.Bdr,
		BorderSizePixel = 0,
		Parent = self.KLF
	})

	self.KLC = CI("Frame", {
		Size = UDim2.new(1, -8, 1, -30),
		Position = UDim2.new(0, 4, 0, 26),
		BackgroundTransparency = 1,
		Parent = self.KLF
	})

	CI("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 2),
		Parent = self.KLC
	})

	self:MKLD()

	return self.KLF
end

function Lib:MKLD()
	if not self.KLF then return end
	local dg, ds, sp = false, nil, nil

	self.KLF.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dg = true
			ds = i.Position
			sp = self.KLF.Position
		end
	end)

	self.KLF.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then dg = false end
	end)

	UIS.InputChanged:Connect(function(i)
		if dg and i.UserInputType == Enum.UserInputType.MouseMovement then
			local d = i.Position - ds
			self.KLF.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
		end
	end)
end

function Lib:SKL(v)
	if self.KLF then self.KLF.Visible = v end
end

function Lib:UKL()
	if not self.KLC then return end
	for _, c in pairs(self.KLC:GetChildren()) do
		if c:IsA("TextLabel") then c:Destroy() end
	end

	for n, k in pairs(KBL) do
		CI("TextLabel", {
			Size = UDim2.new(1, 0, 0, 16),
			BackgroundTransparency = 1,
			Text = "[" .. k .. "] " .. n,
			TextColor3 = T.TxD,
			TextSize = 9,
			Font = Enum.Font.Code,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = self.KLC
		})
	end
end

function Lib:MD()
	local dg, ds, sp = false, nil, nil

	self.Hdr.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dg = true
			ds = i.Position
			sp = self.MF.Position
		end
	end)

	self.Hdr.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then dg = false end
	end)

	UIS.InputChanged:Connect(function(i)
		if dg and i.UserInputType == Enum.UserInputType.MouseMovement then
			local d = i.Position - ds
			self.MF.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
		end
	end)
end

function Lib:AddTab(n)
	local Tb = {}
	local sr = self

	Tb.Btn = CI("TextButton", {
		Name = n,
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundTransparency = 1,
		Text = "",
		BorderSizePixel = 0,
		Parent = self.TC
	})

	local Ind = CI("Frame", {
		Size = UDim2.new(0, 3, 1, -6),
		Position = UDim2.new(0, 0, 0, 3),
		BackgroundColor3 = T.AccR,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = Tb.Btn
	})

	local TbL = CI("TextLabel", {
		Size = UDim2.new(1, -10, 1, 0),
		Position = UDim2.new(0, 8, 0, 0),
		BackgroundTransparency = 1,
		Text = n:upper(),
		TextColor3 = T.TxD,
		TextSize = 12,
		Font = Enum.Font.Code,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Tb.Btn
	})

	Tb.Cnt = CI("Frame", {
		Name = n .. "C",
		Size = UDim2.new(1, -8, 1, -8),
		Position = UDim2.new(0, 4, 0, 4),
		BackgroundTransparency = 1,
		Visible = false,
		Parent = self.CC
	})

	Tb.LC = CI("ScrollingFrame", {
		Size = UDim2.new(0.5, -4, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 1,
		ScrollBarImageColor3 = T.Acc,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = Tb.Cnt
	})

	CI("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = Tb.LC })
	CI("UIPadding", { PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 2), Parent = Tb.LC })

	Tb.RC = CI("ScrollingFrame", {
		Size = UDim2.new(0.5, -4, 1, 0),
		Position = UDim2.new(0.5, 4, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 1,
		ScrollBarImageColor3 = T.Acc,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = Tb.Cnt
	})

	CI("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = Tb.RC })
	CI("UIPadding", { PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 2), Parent = Tb.RC })

	local function Act()
		for _, tb in pairs(self.Tbs) do
			tb.Cnt.Visible = false
			for _, c in pairs(tb.Btn:GetChildren()) do
				if c:IsA("TextLabel") then c.TextColor3 = T.TxD end
				if c:IsA("Frame") then c.BackgroundTransparency = 1 end
			end
		end
		Tb.Cnt.Visible = true
		TbL.TextColor3 = T.AccR
		Ind.BackgroundTransparency = 0
		self.CTb = Tb
	end

	Tb.Btn.MouseButton1Click:Connect(Act)
	Tb.Btn.MouseEnter:Connect(function() if self.CTb ~= Tb then TbL.TextColor3 = T.AccR end end)
	Tb.Btn.MouseLeave:Connect(function() if self.CTb ~= Tb then TbL.TextColor3 = T.TxD end end)

	self.Tbs[n] = Tb
	if not self.CTb then Act() end

	function Tb:AddSection(t, c)
		local pr = c == "right" and self.RC or self.LC

		local SF = CI("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundColor3 = T.Sec,
			BorderSizePixel = 1,
			BorderColor3 = T.Bdr,
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = pr
		})

		CI("TextLabel", {
			Size = UDim2.new(1, 0, 0, 22),
			BackgroundColor3 = T.Hdr,
			BorderSizePixel = 0,
			Text = "  " .. t:upper(),
			TextColor3 = T.AccR,
			TextSize = 11,
			Font = Enum.Font.Code,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = SF
		})

		CI("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0, 22),
			BackgroundColor3 = T.Bdr,
			BorderSizePixel = 0,
			Parent = SF
		})

		local SC = CI("Frame", {
			Size = UDim2.new(1, -6, 0, 0),
			Position = UDim2.new(0, 3, 0, 25),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = SF
		})

		CI("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = SC })
		CI("UIPadding", { PaddingBottom = UDim.new(0, 4), Parent = SC })

		local Sec = {}

		function Sec:AddToggle(n, d, cb)
			local en = d or false

			local TF = CI("Frame", {
				Size = UDim2.new(1, 0, 0, 22),
				BackgroundTransparency = 1,
				Parent = SC
			})

			CI("TextLabel", {
				Size = UDim2.new(1, -30, 1, 0),
				Position = UDim2.new(0, 4, 0, 0),
				BackgroundTransparency = 1,
				Text = n,
				TextColor3 = T.AccR,
				TextSize = 10,
				Font = Enum.Font.Code,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = TF
			})

			local TB = CI("Frame", {
				Size = UDim2.new(0, 16, 0, 16),
				Position = UDim2.new(1, -20, 0.5, -8),
				BackgroundColor3 = en and T.TgE or T.TgD,
				BorderSizePixel = 1,
				BorderColor3 = T.Bdr,
				Parent = TF
			})

			local TBtn = CI("TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = "",
				Parent = TB
			})

			local function Upd()
				en = not en
				TB.BackgroundColor3 = en and T.TgE or T.TgD
				if cb then cb(en) end
			end

			TBtn.MouseButton1Click:Connect(Upd)

			Theme:RegisterUpdateCallback(function(theme)
				if TF and TF.Parent then
					local label = TF:FindFirstChildWhichIsA("TextLabel")
					if label then
						label.TextColor3 = theme.AccR
					end
					if TB then
						TB.BackgroundColor3 = en and theme.TgE or theme.TgD
						TB.BorderColor3 = theme.Bdr
					end
				end
			end)

			return { Set = function(v) if en ~= v then Upd() end end, Get = function() return en end }
		end

		function Sec:AddSlider(n, mn, mx, d, cb)
			local v = d or mn

			local SlF = CI("Frame", {
				Size = UDim2.new(1, 0, 0, 36),
				BackgroundTransparency = 1,
				Parent = SC
			})

			CI("TextLabel", {
				Size = UDim2.new(0.65, 0, 0, 14),
				Position = UDim2.new(0, 4, 0, 0),
				BackgroundTransparency = 1,
				Text = n,
				TextColor3 = T.AccR,
				TextSize = 10,
				Font = Enum.Font.Code,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = SlF
			})

			local VL = CI("TextLabel", {
				Size = UDim2.new(0.35, -4, 0, 14),
				Position = UDim2.new(0.65, 0, 0, 0),
				BackgroundTransparency = 1,
				Text = tostring(v),
				TextColor3 = T.AccG,
				TextSize = 10,
				Font = Enum.Font.Code,
				TextXAlignment = Enum.TextXAlignment.Right,
				Parent = SlF
			})

			local SB = CI("Frame", {
				Size = UDim2.new(1, -8, 0, 12),
				Position = UDim2.new(0, 4, 0, 18),
				BackgroundColor3 = T.Sld,
				BorderSizePixel = 1,
				BorderColor3 = T.Bdr,
				Parent = SlF
			})

			local SFl = CI("Frame", {
				Size = UDim2.new((v - mn) / (mx - mn), 0, 1, 0),
				BackgroundColor3 = T.SlF,
				BorderSizePixel = 0,
				Parent = SB
			})

			local SBtn = CI("TextButton", {
				Size = UDim2.new(1, 0, 1, 10),
				Position = UDim2.new(0, 0, 0, -5),
				BackgroundTransparency = 1,
				Text = "",
				Parent = SB
			})

			local dg = false

			local function US(i)
				local p = math.clamp((i.Position.X - SB.AbsolutePosition.X) / SB.AbsoluteSize.X, 0, 1)
				v = math.floor(mn + (mx - mn) * p)
				VL.Text = tostring(v)
				SFl.Size = UDim2.new(p, 0, 1, 0)
				if cb then cb(v) end
			end

			SBtn.MouseButton1Down:Connect(function() dg = true end)
			UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dg = false end end)
			UIS.InputChanged:Connect(function(i) if dg and i.UserInputType == Enum.UserInputType.MouseMovement then US(i) end end)
			SBtn.MouseButton1Click:Connect(function() US({Position = Vector3.new(Plr:GetMouse().X, 0, 0)}) end)


			Theme:RegisterUpdateCallback(function(theme)
				if SlF and SlF.Parent then
					local label = SlF:FindFirstChildWhichIsA("TextLabel")
					if label then
						label.TextColor3 = theme.AccR
					end
					if VL then
						VL.TextColor3 = theme.AccG
					end
					if SB then
						SB.BackgroundColor3 = theme.Sld
						SB.BorderColor3 = theme.Bdr
					end
					if SFl then
						SFl.BackgroundColor3 = theme.SlF
					end
				end
			end)

			return { Set = function(nv) v = math.clamp(nv, mn, mx) VL.Text = tostring(v) SFl.Size = UDim2.new((v - mn) / (mx - mn), 0, 1, 0) end, Get = function() return v end }
		end

		function Sec:AddButton(n, cb)
			local BF = CI("TextButton", {
				Size = UDim2.new(1, 0, 0, 22),
				BackgroundColor3 = T.Btn,
				BorderSizePixel = 1,
				BorderColor3 = T.Bdr,
				Text = n,
				TextColor3 = T.AccR,
				TextSize = 10,
				Font = Enum.Font.Code,
				Parent = SC
			})

			BF.MouseButton1Click:Connect(function()
				BF.BackgroundColor3 = T.BtA
				wait(0.1)
				BF.BackgroundColor3 = T.Btn
				if cb then cb() end
			end)
			BF.MouseEnter:Connect(function() BF.BackgroundColor3 = T.BtH end)
			BF.MouseLeave:Connect(function() BF.BackgroundColor3 = T.Btn end)

			Theme:RegisterUpdateCallback(function(theme)
				if BF and BF.Parent then
					BF.BackgroundColor3 = theme.Btn
					BF.BorderColor3 = theme.Bdr
					BF.TextColor3 = theme.AccR
				end
			end)

			return BF
		end

		function Sec:AddLabel(txt)
			local L = CI("TextLabel", {
				Size = UDim2.new(1, 0, 0, 16),
				BackgroundTransparency = 1,
				Text = txt,
				TextColor3 = T.TxD,
				TextSize = 9,
				Font = Enum.Font.Code,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = SC
			})
			
			Theme:RegisterUpdateCallback(function(theme)
				if L and L.Parent then
					L.TextColor3 = theme.TxD
				end
			end)
			
			return { Set = function(t) L.Text = t end }
		end

		function Sec:AddTextBox(n, d, cb, maxLength)
			maxLength = maxLength or 200
			local text = d or ""
			
			local TF = CI("Frame", {
				Size = UDim2.new(1, 0, 0, 22),
				BackgroundTransparency = 1,
				Parent = SC
			})

			CI("TextLabel", {
				Size = UDim2.new(1, -30, 1, 0),
				Position = UDim2.new(0, 4, 0, 0),
				BackgroundTransparency = 1,
				Text = n,
				TextColor3 = T.AccR,
				TextSize = 10,
				Font = Enum.Font.Code,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = TF
			})

			local TB = CI("TextBox", {
				Size = UDim2.new(0, 120, 0, 16),
				Position = UDim2.new(1, -124, 0.5, -8),
				BackgroundColor3 = T.BgA,
				BorderSizePixel = 1,
				BorderColor3 = T.Bdr,
				Text = text,
				TextColor3 = T.TxD,
				TextSize = 9,
				Font = Enum.Font.Code,
				TextXAlignment = Enum.TextXAlignment.Left,
				PlaceholderText = "Enter text...",
				PlaceholderColor3 = T.AccG,
				Parent = TF
			})

			TB.Changed:Connect(function()
				if #TB.Text > maxLength then
					TB.Text = string.sub(TB.Text, 1, maxLength)
				end
			end)

			TB.FocusLost:Connect(function()
				if TB.Text ~= text then
					text = TB.Text
					if cb then cb(text) end
				end
			end)

			Theme:RegisterUpdateCallback(function(theme)
				if TF and TF.Parent then
					local label = TF:FindFirstChildWhichIsA("TextLabel")
					if label then
						label.TextColor3 = theme.AccR
					end
					if TB then
						TB.BackgroundColor3 = theme.BgA
						TB.BorderColor3 = theme.Bdr
						TB.TextColor3 = theme.TxD
						TB.PlaceholderColor3 = theme.AccG
					end
				end
			end)

			return { 
				Set = function(t) 
					text = t
					TB.Text = t 
				end, 
				Get = function() return text end 
			}
		end

		function Sec:AddDropdown(n, o, d, cb, mode)
            mode = mode or "single"
            
            local sel = nil
            local opn = false
            local connection = nil
            local scrollConnection = nil
            local optionButtons = {}
            local currentOptions = type(o) == "table" and table.clone(o) or {}

            if mode == "multi" then
                if type(d) == "table" then
                    sel = {}
                    for _, v in ipairs(d) do
                        if table.find(currentOptions, v) then
                            sel[v] = true
                        end
                    end
                else
                    sel = {}
                end
            else
                sel = d or currentOptions[1]
            end

            local function getDisplayText()
                if mode == "multi" then
                    local selected = {}
                    for _, op in ipairs(currentOptions) do
                        if sel[op] then
                            table.insert(selected, op)
                        end
                    end
                    if #selected == 0 then
                        return "None"
                    elseif #selected == 1 then
                        return selected[1]
                    elseif #selected == #currentOptions then
                        return "All (" .. #selected .. ")"
                    else
                        return #selected .. " selected"
                    end
                else
                    return tostring(sel or "")
                end
            end

            local function getCallbackValue()
                if mode == "multi" then
                    local result = {}
                    for _, op in ipairs(currentOptions) do
                        if sel[op] then
                            table.insert(result, op)
                        end
                    end
                    return result
                else
                    return sel
                end
            end

            local function isSelected(op)
                if mode == "multi" then
                    return sel[op] == true
                else
                    return sel == op
                end
            end

            local DF = CI("Frame", {
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Parent = SC
            })

            CI("TextLabel", {
                Size = UDim2.new(0.4, 0, 1, 0),
                Position = UDim2.new(0, 4, 0, 0),
                BackgroundTransparency = 1,
                Text = n,
                TextColor3 = T.AccR,
                TextSize = 10,
                Font = Enum.Font.Code,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DF
            })

            local SB = CI("TextButton", {
                Size = UDim2.new(0.6, -8, 0, 16),
                Position = UDim2.new(0.4, 0, 0.5, -8),
                BackgroundColor3 = T.BgA,
                BorderSizePixel = 1,
                BorderColor3 = T.Bdr,
                Text = getDisplayText() .. " v",
                TextColor3 = T.AccR,
                TextSize = 9,
                Font = Enum.Font.Code,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = DF
            })

            CI("UIPadding", {
                PaddingRight = UDim.new(0, 6),
                Parent = SB
            })

            local DP = CI("Frame", {
                Size = UDim2.new(0, 200, 0, #currentOptions * 18 + 4),
                BackgroundColor3 = T.Bg,
                BorderSizePixel = 1,
                BorderColor3 = T.Bdr,
                Visible = false,
                ZIndex = 9999,
                Active = true,
                ClipsDescendants = false,
                Parent = sr.SG
            })

            sr.SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

            local DPLayout = CI("UIListLayout", { 
                SortOrder = Enum.SortOrder.LayoutOrder, 
                Padding = UDim.new(0, 1), 
                Parent = DP 
            })
            
            CI("UIPadding", { 
                PaddingTop = UDim.new(0, 2), 
                PaddingLeft = UDim.new(0, 2), 
                PaddingRight = UDim.new(0, 2), 
                Parent = DP 
            })

            local function updateButtonVisual(btn, op)
                local selected = isSelected(op)
                btn.BackgroundColor3 = selected and T.BtA or T.Btn
                btn.Text = op
                btn.TextXAlignment = Enum.TextXAlignment.Right

                if selected then
                    local existingIcon = btn:FindFirstChild("SelectedIcon")
                    if not existingIcon then
                        CI("ImageLabel", {
                            Name = "SelectedIcon",
                            Size = UDim2.new(0, 14, 0, 14),
                            Position = UDim2.new(1, -165, 0.5, -7),
                            Image = "" --"rbxassetid://10709797382",
                            --BackgroundTransparency = 0,
                            ZIndex = 10001,
                            Parent = btn
                        })
                    end
                else
                    local existingIcon = btn:FindFirstChild("SelectedIcon")
                    if existingIcon then
                        existingIcon:Destroy()
                    end
                end
                
                btn.TextColor3 = selected and T.AccR or T.TxD
            end

            local function updateAllButtons()
                for op, btn in pairs(optionButtons) do
                    if btn and btn.Parent then
                        updateButtonVisual(btn, op)
                    end
                end
                SB.Text = getDisplayText() .. (opn and " ^" or " v")
            end

            local function updateDropdownPosition()
                if not opn then return end
                local ps = SB.AbsolutePosition
                local sz = SB.AbsoluteSize
                local screenHeight = sr.SG.AbsoluteSize.Y
                local dropdownHeight = #currentOptions * 18 + 4
                
                local yPos = ps.Y + sz.Y + 2
                if yPos + dropdownHeight > screenHeight then
                    yPos = ps.Y - dropdownHeight - 2
                end
                
                DP.Position = UDim2.new(0, ps.X, 0, yPos)
                DP.Size = UDim2.new(0, sz.X, 0, dropdownHeight)
            end

            local function closeDropdown()
                opn = false
                DP.Visible = false
                SB.Text = getDisplayText() .. " v"
                if connection then
                    connection:Disconnect()
                    connection = nil
                end
                if scrollConnection then
                    scrollConnection:Disconnect()
                    scrollConnection = nil
                end
            end

            local function openDropdown()
                opn = true
                updateDropdownPosition()
                DP.Visible = true
                SB.Text = getDisplayText() .. " ^"

                if connection then connection:Disconnect() end
                connection = UIS.InputBegan:Connect(function(i, gameProcessed)
                    if gameProcessed then return end
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        task.defer(function()
                            if not opn then return end
                            
                            local mousePos = UIS:GetMouseLocation()
                            local inset = game:GetService("GuiService"):GetGuiInset()
                            local mx, my = mousePos.X, mousePos.Y - inset.Y

                            local pP, pS = DP.AbsolutePosition, DP.AbsoluteSize
                            local bP, bS = SB.AbsolutePosition, SB.AbsoluteSize

                            local insideDP = (mx >= pP.X and mx <= pP.X + pS.X and my >= pP.Y and my <= pP.Y + pS.Y)
                            local insideSB = (mx >= bP.X and mx <= bP.X + bS.X and my >= bP.Y and my <= bP.Y + bS.Y)

                            if not insideDP and not insideSB then
                                closeDropdown()
                            end
                        end)
                    end
                end)
                
                if scrollConnection then scrollConnection:Disconnect() end
                scrollConnection = RS.RenderStepped:Connect(function()
                    if opn then
                        updateDropdownPosition()
                    end
                end)
            end

            local function createOptionButton(op)
                local OB = CI("TextButton", {
                    Size = UDim2.new(1, 0, 0, 16),
                    BackgroundColor3 = isSelected(op) and T.BtA or T.Btn,
                    BorderSizePixel = 0,
                    Text = op,
                    TextColor3 = isSelected(op) and T.AccR or T.TxD,
                    TextSize = 9,
                    Font = Enum.Font.Code,
                    ZIndex = 10000,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = DP
                })

                CI("UIPadding", {
                    PaddingRight = UDim.new(0, 6),
                    PaddingLeft = UDim.new(0, 4),
                    Parent = OB
                })

                optionButtons[op] = OB
                updateButtonVisual(OB, op)

                OB.MouseButton1Click:Connect(function()
                    if mode == "multi" then
                        sel[op] = not sel[op]
                        updateAllButtons()
                        if cb then cb(getCallbackValue()) end
                    else
                        sel = op
                        updateAllButtons()
                        closeDropdown()
                        if cb then cb(getCallbackValue()) end
                    end
                end)

                OB.MouseEnter:Connect(function()
                    if not isSelected(op) then
                        OB.BackgroundColor3 = T.BtH
                        OB.TextColor3 = T.Txt
                    end
                end)

                OB.MouseLeave:Connect(function()
                    if not isSelected(op) then
                        OB.BackgroundColor3 = T.Btn
                        OB.TextColor3 = T.TxD
                    end
                end)

                return OB
            end

            for _, op in ipairs(currentOptions) do
                createOptionButton(op)
            end

            SB.MouseButton1Click:Connect(function()
                if opn then
                    closeDropdown()
                else
                    openDropdown()
                end
            end)

            Theme:RegisterUpdateCallback(function(theme)
                if DF and DF.Parent then
                    local label = DF:FindFirstChildWhichIsA("TextLabel")
                    if label then
                        label.TextColor3 = theme.AccR
                    end
                    if SB then
                        SB.BackgroundColor3 = theme.BgA
                        SB.BorderColor3 = theme.Bdr
                        SB.TextColor3 = theme.AccR
                    end
                    if DP then
                        DP.BackgroundColor3 = theme.Bg
                        DP.BorderColor3 = theme.Bdr
                    end
                    for op, btn in pairs(optionButtons) do
                        if btn and btn.Parent then
                            btn.BackgroundColor3 = isSelected(op) and theme.BtA or theme.Btn
                            btn.TextColor3 = isSelected(op) and theme.AccR or theme.TxD
                        end
                    end
                end
            end)

            return {
                Set = function(v)
                    if mode == "multi" then
                        if type(v) == "table" then
                            sel = {}
                            for _, item in ipairs(v) do
                                if table.find(currentOptions, item) then
                                    sel[item] = true
                                end
                            end
                        elseif type(v) == "string" and table.find(currentOptions, v) then
                            sel[v] = true
                        end
                    else
                        if table.find(currentOptions, v) then
                            sel = v
                        end
                    end
                    updateAllButtons()
                end,
                
                Get = function()
                    return getCallbackValue()
                end,
                
                Clear = function()
                    if mode == "multi" then
                        sel = {}
                        updateAllButtons()
                    end
                end,
                
                SelectAll = function()
                    if mode == "multi" then
                        for _, op in ipairs(currentOptions) do
                            sel[op] = true
                        end
                        updateAllButtons()
                    end
                end,
                
                Toggle = function(v)
                    if mode == "multi" and table.find(currentOptions, v) then
                        sel[v] = not sel[v]
                        updateAllButtons()
                    end
                end,
                
                Refresh = function(newOptions)
                    if opn then
                        closeDropdown()
                    end
                    
                    for op, btn in pairs(optionButtons) do
                        if btn and btn.Parent then
                            btn:Destroy()
                        end
                    end
                    optionButtons = {}
                    
                    currentOptions = type(newOptions) == "table" and newOptions or {}
                    
                    if mode == "multi" then
                        local newSel = {}
                        for op, v in pairs(sel) do
                            if table.find(currentOptions, op) then
                                newSel[op] = v
                            end
                        end
                        sel = newSel
                    else
                        if sel and not table.find(currentOptions, sel) then
                            sel = currentOptions[1] or nil
                        end
                    end
                    
                    for _, op in ipairs(currentOptions) do
                        createOptionButton(op)
                    end
                    
                    updateAllButtons()
                end,
                
                AddOption = function(option)
                    if not table.find(currentOptions, option) then
                        table.insert(currentOptions, option)
                        createOptionButton(option)
                        updateAllButtons()
                    end
                end,
                
                RemoveOption = function(option)
                    local index = table.find(currentOptions, option)
                    if index then
                        table.remove(currentOptions, index)
                        if optionButtons[option] then
                            optionButtons[option]:Destroy()
                            optionButtons[option] = nil
                        end
                        if mode == "multi" then
                            sel[option] = nil
                        elseif sel == option then
                            sel = currentOptions[1] or nil
                        end
                        updateAllButtons()
                    end
                end,
                
                GetOptions = function()
                    return currentOptions
                end
            }
        end

		function Sec:AddColorPicker(n, d, cb)
            local cc = d or Color3.fromRGB(255, 0, 0)
            local opn = false
            local h, st, vl = Color3.toHSV(cc)
            local scrollConnection = nil
            local clickConnection = nil

            local CF = CI("Frame", {
                Size = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
                Parent = SC
            })

            CI("TextLabel", {
                Size = UDim2.new(1, -35, 1, 0),
                Position = UDim2.new(0, 4, 0, 0),
                BackgroundTransparency = 1,
                Text = n,
                TextColor3 = T.AccR,
                TextSize = 10,
                Font = Enum.Font.Code,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = CF
            })

            local CP = CI("TextButton", {
                Size = UDim2.new(0, 18, 0, 12),
                Position = UDim2.new(1, -22, 0.5, -6),
                BackgroundColor3 = cc,
                BorderSizePixel = 1,
                BorderColor3 = T.Bdr,
                Text = "",
                Parent = CF
            })

            CI("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = CP
            })

            local CPP = CI("Frame", {
                Size = UDim2.new(0, 180, 0, 150),
                BackgroundColor3 = T.Bg,
                BorderSizePixel = 1,
                BorderColor3 = T.Bdr,
                Visible = false,
                ZIndex = 9999,
                Parent = sr.SG
            })

            local SVP = CI("Frame", {
                Size = UDim2.new(0, 130, 0, 100),
                Position = UDim2.new(0, 5, 0, 5),
                BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                BorderSizePixel = 1,
                BorderColor3 = T.Bdr,
                ZIndex = 10000,
                ClipsDescendants = true,
                Parent = CPP
            })

            local WhiteGradient = CI("Frame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                ZIndex = 10001,
                Parent = SVP
            })

            CI("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                    ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
                }),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1)
                }),
                Rotation = 0,
                Parent = WhiteGradient
            })

            local BlackGradient = CI("Frame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                ZIndex = 10002,
                Parent = SVP
            })

            CI("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
                    ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
                }),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }),
                Rotation = 90,
                Parent = BlackGradient
            })

            local SVC = CI("Frame", {
                Size = UDim2.new(0, 8, 0, 8),
                Position = UDim2.new(st, -4, 1 - vl, -4),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 2,
                BorderColor3 = Color3.new(0, 0, 0),
                ZIndex = 10004,
                Parent = SVP
            })

            CI("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SVC
            })

            local HS = CI("Frame", {
                Size = UDim2.new(0, 18, 0, 100),
                Position = UDim2.new(0, 145, 0, 5),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 1,
                BorderColor3 = T.Bdr,
                ZIndex = 10000,
                Parent = CPP
            })

            CI("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                }),
                Rotation = 90,
                Parent = HS
            })

            local HC = CI("Frame", {
                Size = UDim2.new(1, 4, 0, 4),
                Position = UDim2.new(0, -2, h, -2),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 1,
                BorderColor3 = Color3.new(0, 0, 0),
                ZIndex = 10001,
                Parent = HS
            })

            local RD = CI("TextLabel", {
                Size = UDim2.new(0, 100, 0, 18),
                Position = UDim2.new(0, 5, 1, -23),
                BackgroundColor3 = T.BgA,
                BorderSizePixel = 1,
                BorderColor3 = T.Bdr,
                Text = string.format("R:%d G:%d B:%d", math.floor(cc.R * 255), math.floor(cc.G * 255), math.floor(cc.B * 255)),
                TextColor3 = T.Txt,
                TextSize = 9,
                Font = Enum.Font.Code,
                ZIndex = 10000,
                Parent = CPP
            })

            local PP = CI("Frame", {
                Size = UDim2.new(0, 50, 0, 18),
                Position = UDim2.new(0, 115, 1, -23),
                BackgroundColor3 = cc,
                BorderSizePixel = 1,
                BorderColor3 = T.Bdr,
                ZIndex = 10000,
                Parent = CPP
            })

            local function UC()
                cc = Color3.fromHSV(h, st, vl)
                CP.BackgroundColor3 = cc
                PP.BackgroundColor3 = cc
                SVP.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                SVC.Position = UDim2.new(st, -4, 1 - vl, -4)
                HC.Position = UDim2.new(0, -2, h, -2)
                RD.Text = string.format("R:%d G:%d B:%d", math.floor(cc.R * 255), math.floor(cc.G * 255), math.floor(cc.B * 255))
                if cb then cb(cc) end
            end

            local function updatePickerPosition()
                if not opn then return end
                local ps = CP.AbsolutePosition
                local sz = CP.AbsoluteSize
                local screenHeight = sr.SG.AbsoluteSize.Y
                local screenWidth = sr.SG.AbsoluteSize.X
                local pickerHeight = 150
                local pickerWidth = 180
                
                local xPos = ps.X - pickerWidth + sz.X
                local yPos = ps.Y + sz.Y + 5
                
                if xPos < 0 then
                    xPos = ps.X
                end
                if xPos + pickerWidth > screenWidth then
                    xPos = screenWidth - pickerWidth - 5
                end
                
                if yPos + pickerHeight > screenHeight then
                    yPos = ps.Y - pickerHeight - 5
                end
                
                CPP.Position = UDim2.new(0, xPos, 0, yPos)
            end

            local function closePicker()
                opn = false
                CPP.Visible = false
                if scrollConnection then
                    scrollConnection:Disconnect()
                    scrollConnection = nil
                end
                if clickConnection then
                    clickConnection:Disconnect()
                    clickConnection = nil
                end
            end

            local function openPicker()
                opn = true
                updatePickerPosition()
                CPP.Visible = true
                
                if scrollConnection then scrollConnection:Disconnect() end
                scrollConnection = RS.RenderStepped:Connect(function()
                    if opn then
                        updatePickerPosition()
                    end
                end)
                
                if clickConnection then clickConnection:Disconnect() end
                clickConnection = UIS.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 and opn then
                        task.defer(function()
                            if not opn then return end
                            
                            local m = UIS:GetMouseLocation()
                            local inset = game:GetService("GuiService"):GetGuiInset()
                            local mx, my = m.X, m.Y - inset.Y
                            
                            local pP, pS = CPP.AbsolutePosition, CPP.AbsoluteSize
                            local bP, bS = CP.AbsolutePosition, CP.AbsoluteSize
                            
                            local insidePicker = (mx >= pP.X and mx <= pP.X + pS.X and my >= pP.Y and my <= pP.Y + pS.Y)
                            local insideButton = (mx >= bP.X and mx <= bP.X + bS.X and my >= bP.Y and my <= bP.Y + bS.Y)
                            
                            if not insidePicker and not insideButton then
                                closePicker()
                            end
                        end)
                    end
                end)
            end

            local dSV, dH = false, false

            local SVB = CI("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 10003,
                Parent = SVP
            })
            
            local HB = CI("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 10002,
                Parent = HS
            })

            SVB.MouseButton1Down:Connect(function()
                dSV = true
                local m = Plr:GetMouse()
                st = math.clamp((m.X - SVP.AbsolutePosition.X) / SVP.AbsoluteSize.X, 0, 1)
                vl = 1 - math.clamp((m.Y - SVP.AbsolutePosition.Y) / SVP.AbsoluteSize.Y, 0, 1)
                UC()
            end)
            
            HB.MouseButton1Down:Connect(function()
                dH = true
                local m = Plr:GetMouse()
                h = math.clamp((m.Y - HS.AbsolutePosition.Y) / HS.AbsoluteSize.Y, 0, 1)
                UC()
            end)

            UIS.InputChanged:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseMovement then
                    if dSV then
                        st = math.clamp((i.Position.X - SVP.AbsolutePosition.X) / SVP.AbsoluteSize.X, 0, 1)
                        vl = 1 - math.clamp((i.Position.Y - SVP.AbsolutePosition.Y) / SVP.AbsoluteSize.Y, 0, 1)
                        UC()
                    elseif dH then
                        h = math.clamp((i.Position.Y - HS.AbsolutePosition.Y) / HS.AbsoluteSize.Y, 0, 1)
                        UC()
                    end
                end
            end)

            UIS.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    dSV = false
                    dH = false
                end
            end)

            CP.MouseButton1Click:Connect(function()
                if opn then
                    closePicker()
                else
                    openPicker()
                end
            end)

            Theme:RegisterUpdateCallback(function(theme)
                if CF and CF.Parent then
                    local label = CF:FindFirstChildWhichIsA("TextLabel")
                    if label then
                        label.TextColor3 = theme.AccR
                    end
                    if CP then
                        CP.BorderColor3 = theme.Bdr
                    end
                    if CPP then
                        CPP.BackgroundColor3 = theme.Bg
                        CPP.BorderColor3 = theme.Bdr
                    end
                    if SVP then
                        SVP.BorderColor3 = theme.Bdr
                    end
                    if HS then
                        HS.BorderColor3 = theme.Bdr
                    end
                    if RD then
                        RD.BackgroundColor3 = theme.BgA
                        RD.BorderColor3 = theme.Bdr
                        RD.TextColor3 = theme.Txt
                    end
                    if PP then
                        PP.BorderColor3 = theme.Bdr
                    end
                end
            end)

            return {
                Set = function(c)
                    cc = c
                    h, st, vl = Color3.toHSV(c)
                    UC()
                end,
                Get = function()
                    return cc
                end
            }
        end

		function Sec:AddKeybind(n, d, cb)
            local k = d or Enum.KeyCode.Unknown
            local ls = false
            local mode = "toggle"
            local isHolding = false
            local isActive = false
            local modeMenuOpen = false
            local modeConnection = nil
            local scrollConnection = nil
            local holdConnections = {}

            local KF = CI("Frame", {
                Size = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
                Parent = SC
            })

            CI("TextLabel", {
                Size = UDim2.new(1, -55, 1, 0),
                Position = UDim2.new(0, 4, 0, 0),
                BackgroundTransparency = 1,
                Text = n,
                TextColor3 = T.AccR,
                TextSize = 10,
                Font = Enum.Font.Code,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = KF
            })

            local function keyName(v)
                if typeof(v) == "EnumItem" then
                    if v.EnumType == Enum.KeyCode then
                        return v.Name
                    elseif v.EnumType == Enum.UserInputType then
                        return v.Name
                    end
                end
                return tostring(v)
            end

            local KB = CI("TextButton", {
                Size = UDim2.new(0, 45, 0, 16),
                Position = UDim2.new(1, -49, 0.5, -8),
                BackgroundColor3 = T.BgA,
                BorderSizePixel = 1,
                BorderColor3 = T.Bdr,
                Text = k ~= Enum.KeyCode.Unknown and keyName(k) or "NONE",
                TextColor3 = T.AccR,
                TextSize = 8,
                Font = Enum.Font.Code,
                Parent = KF
            })

            local ModeMenu = CI("Frame", {
                Size = UDim2.new(0, 60, 0, 38),
                BackgroundColor3 = T.Bg,
                BorderSizePixel = 1,
                BorderColor3 = T.Bdr,
                Visible = false,
                ZIndex = 9999,
                Parent = sr.SG
            })

            CI("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 1),
                Parent = ModeMenu
            })

            CI("UIPadding", {
                PaddingTop = UDim.new(0, 2),
                PaddingLeft = UDim.new(0, 2),
                PaddingRight = UDim.new(0, 2),
                Parent = ModeMenu
            })

            local function closeModeMenu()
                modeMenuOpen = false
                ModeMenu.Visible = false
                if modeConnection then
                    modeConnection:Disconnect()
                    modeConnection = nil
                end
                if scrollConnection then
                    scrollConnection:Disconnect()
                    scrollConnection = nil
                end
            end

            local function updateModeButtons()
                for _, child in pairs(ModeMenu:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end

                local ToggleBtn = CI("TextButton", {
                    Size = UDim2.new(1, 0, 0, 16),
                    BackgroundColor3 = mode == "toggle" and T.BtA or T.Btn,
                    BorderSizePixel = 0,
                    Text = "Toggle",
                    TextColor3 = mode == "toggle" and T.AccR or T.TxD,
                    TextSize = 9,
                    Font = Enum.Font.Code,
                    ZIndex = 10000,
                    Parent = ModeMenu
                })

                local HoldBtn = CI("TextButton", {
                    Size = UDim2.new(1, 0, 0, 16),
                    BackgroundColor3 = mode == "hold" and T.BtA or T.Btn,
                    BorderSizePixel = 0,
                    Text = "Hold",
                    TextColor3 = mode == "hold" and T.AccR or T.TxD,
                    TextSize = 9,
                    Font = Enum.Font.Code,
                    ZIndex = 10000,
                    Parent = ModeMenu
                })

                ToggleBtn.MouseButton1Click:Connect(function()
                    mode = "toggle"
                    isActive = false
                    updateModeButtons()
                    closeModeMenu()
                end)

                HoldBtn.MouseButton1Click:Connect(function()
                    mode = "hold"
                    isActive = false
                    updateModeButtons()
                    closeModeMenu()
                end)

                ToggleBtn.MouseEnter:Connect(function()
                    if mode ~= "toggle" then
                        ToggleBtn.BackgroundColor3 = T.BtH
                    end
                end)

                ToggleBtn.MouseLeave:Connect(function()
                    if mode ~= "toggle" then
                        ToggleBtn.BackgroundColor3 = T.Btn
                    end
                end)

                HoldBtn.MouseEnter:Connect(function()
                    if mode ~= "hold" then
                        HoldBtn.BackgroundColor3 = T.BtH
                    end
                end)

                HoldBtn.MouseLeave:Connect(function()
                    if mode ~= "hold" then
                        HoldBtn.BackgroundColor3 = T.Btn
                    end
                end)
            end

            updateModeButtons()

            local function updateMenuPosition()
                if not modeMenuOpen then return end
                local ps = KB.AbsolutePosition
                local sz = KB.AbsoluteSize
                local screenWidth = sr.SG.AbsoluteSize.X
                local menuWidth = 60

                local xPos = ps.X + sz.X + 5
                if xPos + menuWidth > screenWidth then
                    xPos = ps.X - menuWidth - 5
                end

                ModeMenu.Position = UDim2.new(0, xPos, 0, ps.Y)
            end

            local function openModeMenu()
                modeMenuOpen = true
                updateMenuPosition()
                ModeMenu.Visible = true

                if scrollConnection then scrollConnection:Disconnect() end
                scrollConnection = RS.RenderStepped:Connect(function()
                    if modeMenuOpen then
                        updateMenuPosition()
                    end
                end)

                if modeConnection then modeConnection:Disconnect() end
                modeConnection = UIS.InputBegan:Connect(function(i, gp)
                    if gp then return end
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.MouseButton2 then
                        task.defer(function()
                            if not modeMenuOpen then return end

                            local m = UIS:GetMouseLocation()
                            local inset = game:GetService("GuiService"):GetGuiInset()
                            local mx, my = m.X, m.Y - inset.Y

                            local mP, mS = ModeMenu.AbsolutePosition, ModeMenu.AbsoluteSize
                            local bP, bS = KB.AbsolutePosition, KB.AbsoluteSize

                            local insideMenu = (mx >= mP.X and mx <= mP.X + mS.X and my >= mP.Y and my <= mP.Y + mS.Y)
                            local insideButton = (mx >= bP.X and mx <= bP.X + bS.X and my >= bP.Y and my <= bP.Y + bS.Y)

                            if not insideMenu and not insideButton then
                                closeModeMenu()
                            end
                        end)
                    end
                end)
            end

            if k ~= Enum.KeyCode.Unknown then
                KBL[n] = keyName(k)
                sr:UKL()
            end

            KB.MouseButton1Click:Connect(function()
                if modeMenuOpen then
                    closeModeMenu()
                end
                ls = true
                KB.Text = "..."
                KB.TextColor3 = T.Txt
            end)

            KB.MouseButton2Click:Connect(function()
                if ls then return end
                if modeMenuOpen then
                    closeModeMenu()
                else
                    openModeMenu()
                end
            end)

            local function matchesKey(input)
                if typeof(k) ~= "EnumItem" then return false end
                if k == Enum.KeyCode.Unknown then return false end
                if k.EnumType == Enum.KeyCode and input.KeyCode == k then
                    return true
                elseif k.EnumType == Enum.UserInputType and input.UserInputType == k then
                    return true
                end
                return false
            end

            UIS.InputBegan:Connect(function(i, p)
                if ls then
                    if i.KeyCode == Enum.KeyCode.Escape then
                        k = Enum.KeyCode.Unknown
                        KB.Text = "NONE"
                        KBL[n] = nil
                    elseif i.UserInputType == Enum.UserInputType.Keyboard then
                        k = i.KeyCode
                        KB.Text = keyName(k)
                        KBL[n] = keyName(k)
                    elseif i.UserInputType == Enum.UserInputType.MouseButton1 or 
                        i.UserInputType == Enum.UserInputType.MouseButton2 or 
                        i.UserInputType == Enum.UserInputType.MouseButton3 then
                        k = i.UserInputType
                        KB.Text = keyName(k)
                        KBL[n] = keyName(k)
                    end
                    KB.TextColor3 = T.AccR
                    ls = false
                    sr:UKL()
                    return
                end

                if not p and matchesKey(i) then
                    if mode == "toggle" then
                        isActive = not isActive
                        if cb then cb(isActive) end
                    elseif mode == "hold" then
                        isActive = true
                        if cb then cb(true) end
                    end
                end
            end)

            UIS.InputEnded:Connect(function(i, p)
                if mode == "hold" and matchesKey(i) then
                    isActive = false
                    if cb then cb(false) end
                end
            end)

            Theme:RegisterUpdateCallback(function(theme)
                if KF and KF.Parent then
                    local label = KF:FindFirstChildWhichIsA("TextLabel")
                    if label then
                        label.TextColor3 = theme.AccR
                    end
                    if KB then
                        KB.BackgroundColor3 = theme.BgA
                        KB.BorderColor3 = theme.Bdr
                        KB.TextColor3 = theme.AccR
                    end
                    if ModeMenu then
                        ModeMenu.BackgroundColor3 = theme.Bg
                        ModeMenu.BorderColor3 = theme.Bdr
                    end
                end
            end)

            return {
                Set = function(nk)
                    k = nk
                    KB.Text = k ~= Enum.KeyCode.Unknown and keyName(k) or "NONE"
                    if k ~= Enum.KeyCode.Unknown then
                        KBL[n] = keyName(k)
                    else
                        KBL[n] = nil
                    end
                    sr:UKL()
                end,
                Get = function()
                    return k
                end,
                GetMode = function()
                    return mode
                end,
                SetMode = function(newMode)
                    if newMode == "toggle" or newMode == "hold" then
                        mode = newMode
                        isActive = false
                        updateModeButtons()
                    end
                end,
                IsActive = function()
                    return isActive
                end
            }
        end

		return Sec
	end

	return Tb
end


return Lib

