-- create your exemple. chat gpt user..
local ImGui = loadstring(game:HttpGet("https://raw.githubusercontent.com/slavko960/update-dataset/refs/heads/main/looksink/looksink%20lib.lua"))()

_G.LooksinkTheme:LoadStartup()

local Window = ImGui.new({
	Title = "Looksink UI Demo",
	Size = UDim2.new(0, 800, 0, 510)
})

Window:CreateWatermark({
	Text = "Demo | Shift to toggle",
	Size = UDim2.new(0, 260, 0, 22),
	Position = UDim2.new(0, 10, 0, 10)
})
Window:CreateKeybindList()

local UITab = Window:AddTab("UI")
local VisualsTab = Window:AddTab("Visuals")
local MiscTab = Window:AddTab("Misc")

local uiSec = UITab:AddSection("Window", "left")

local toggleKeybind = uiSec:AddKeybind("Toggle Menu", Enum.KeyCode.RightShift, function(k)
	Window:SetToggleKey(k)
end)

toggleKeybind.SetMode("toggle")

local visSecL = VisualsTab:AddSection("Toggles & Slider", "left")
local visSecR = VisualsTab:AddSection("Dropdowns & Colors", "right")

visSecL:AddToggle("ESP Enabled", true, function(v) end)
visSecL:AddToggle("Chams", false, function(v) end)
visSecL:AddSlider("FOV", 30, 150, 90, function(v) end)

visSecR:AddDropdown("Scheme", {"Dark", "Gray", "Light"}, "Dark", function(v) end)
visSecR:AddColorPicker("Accent", Color3.fromRGB(255, 80, 80), function(c) end)

local miscSec = MiscTab:AddSection("Actions", "left")

local panicKeybind = miscSec:AddKeybind("Panic key", Enum.KeyCode.P, function(active)
	if active then
		print("Panic activated!")
	else
		print("Panic deactivated!")
	end
end)

panicKeybind.SetMode("toggle")

local sprintKeybind = miscSec:AddKeybind("Sprint", Enum.KeyCode.LeftShift, function(active)
	if active then
		print("Sprint activated!")
	else
		print("Sprint deactivated!")
	end
end)

sprintKeybind.SetMode("hold")

local flyKeybind = miscSec:AddKeybind("Fly", Enum.KeyCode.F, function(active)
	if active then
		print("Fly enabled!")
	else
		print("Fly disabled!")
	end
end)

miscSec:AddToggle("Show debug info", false, function(v) end)

local themeSec = MiscTab:AddSection("Theme", "right")

themeSec:AddColorPicker("Main Background", _G.LooksinkTheme:Get().Bg, function(c)
	_G.LooksinkTheme:UpdateColor("Bg", c)
end)

themeSec:AddColorPicker("Alt Background", _G.LooksinkTheme:Get().BgA, function(c)
	_G.LooksinkTheme:UpdateColor("BgA", c)
end)

themeSec:AddColorPicker("Header", _G.LooksinkTheme:Get().Hdr, function(c)
	_G.LooksinkTheme:UpdateColor("Hdr", c)
end)

themeSec:AddColorPicker("Section", _G.LooksinkTheme:Get().Sec, function(c)
	_G.LooksinkTheme:UpdateColor("Sec", c)
end)

themeSec:AddColorPicker("Border", _G.LooksinkTheme:Get().Bdr, function(c)
	_G.LooksinkTheme:UpdateColor("Bdr", c)
end)

themeSec:AddColorPicker("Accent", _G.LooksinkTheme:Get().Acc, function(c)
	_G.LooksinkTheme:UpdateColor("Acc", c)
	_G.LooksinkTheme:UpdateColor("AccG", c)
	_G.LooksinkTheme:UpdateColor("SlF", c)
end)

themeSec:AddColorPicker("Main Text", _G.LooksinkTheme:Get().AccR, function(c)
	_G.LooksinkTheme:UpdateColor("AccR", c)
	_G.LooksinkTheme:UpdateColor("Txt", c)
end)

themeSec:AddColorPicker("Secondary Text", _G.LooksinkTheme:Get().TxD, function(c)
	_G.LooksinkTheme:UpdateColor("TxD", c)
end)

themeSec:AddColorPicker("Button", _G.LooksinkTheme:Get().Btn, function(c)
	_G.LooksinkTheme:UpdateColor("Btn", c)
end)

themeSec:AddColorPicker("Button Hover", _G.LooksinkTheme:Get().BtH, function(c)
	_G.LooksinkTheme:UpdateColor("BtH", c)
end)

themeSec:AddColorPicker("Button Active", _G.LooksinkTheme:Get().BtA, function(c)
	_G.LooksinkTheme:UpdateColor("BtA", c)
end)

themeSec:AddColorPicker("Toggle", _G.LooksinkTheme:Get().Tgl, function(c)
	_G.LooksinkTheme:UpdateColor("Tgl", c)
end)

themeSec:AddColorPicker("Toggle Enabled", _G.LooksinkTheme:Get().TgE, function(c)
	_G.LooksinkTheme:UpdateColor("TgE", c)
end)

themeSec:AddColorPicker("Toggle Disabled", _G.LooksinkTheme:Get().TgD, function(c)
	_G.LooksinkTheme:UpdateColor("TgD", c)
end)

themeSec:AddColorPicker("Slider", _G.LooksinkTheme:Get().Sld, function(c)
	_G.LooksinkTheme:UpdateColor("Sld", c)
end)

local themeNameBox = themeSec:AddTextBox("Theme Name", "", function(name) end)

local savedThemesDropdown = themeSec:AddDropdown("Saved Themes", _G.LooksinkTheme:GetSavedThemes(), _G.LooksinkTheme:GetDefault(), function(themeName) end)

themeSec:AddButton("Load Theme", function()
	local themeName = savedThemesDropdown.Get()
	if themeName and themeName ~= "" then
		_G.LooksinkTheme:LoadTheme(themeName)
	end
end)

themeSec:AddButton("Save Theme", function()
	local themeName = themeNameBox.Get()
	if themeName and themeName ~= "" then
		_G.LooksinkTheme:SaveTheme(themeName)
		savedThemesDropdown.Refresh(_G.LooksinkTheme:GetSavedThemes())
	end
end)

themeSec:AddButton("Set as Default", function()
	local themeName = savedThemesDropdown.Get()
	if themeName and themeName ~= "" then
		_G.LooksinkTheme:SetDefault(themeName)
	end
end)

themeSec:AddButton("Clear Default", function()
	_G.LooksinkTheme:ClearDefault()
end)

themeSec:AddButton("Delete Theme", function()
	local themeName = savedThemesDropdown.Get()
	if themeName and themeName ~= "" and themeName ~= "default" and delfile then
		pcall(delfile, "looksink/themes/" .. themeName .. ".json")
		savedThemesDropdown.Refresh(_G.LooksinkTheme:GetSavedThemes())
	end
end)

themeSec:AddButton("Refresh List", function()
	savedThemesDropdown.Refresh(_G.LooksinkTheme:GetSavedThemes())
end)

themeSec:AddButton("Reset Theme", function()
	_G.LooksinkTheme:Reset()

end)

