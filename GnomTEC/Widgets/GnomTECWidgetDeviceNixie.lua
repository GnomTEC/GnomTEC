-- **********************************************************************
-- GnomTECWidgetDeviceNixie
-- Version: 7.1.5.8
-- Author: Peter Jack
-- URL: http://www.gnomtec.de/
-- **********************************************************************
-- Copyright © 2014-2017 by Peter Jack
--
-- Licensed under the EUPL, Version 1.1 only (the "Licence");
-- You may not use this work except in compliance with the Licence.
-- You may obtain a copy of the Licence at:
--
-- http://ec.europa.eu/idabc/eupl5
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the Licence is distributed on an "AS IS" basis,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the Licence for the specific language governing permissions and
-- limitations under the Licence.
-- **********************************************************************
local MAJOR, MINOR = "GnomTECWidgetDeviceNixie-1.0", 8
local _widget, _oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not _widget then return end -- No Upgrade needed.

-- ----------------------------------------------------------------------
-- Widget Global Constants (local)
-- ----------------------------------------------------------------------
-- localization 
local L = LibStub("AceLocale-3.0"):GetLocale("GnomTEC")

-- texure path
local T = [[Interface\Addons\]].. ... ..[[\GnomTEC\Textures\]]

-- Class levels
local CLASS_BASE		= 0
local CLASS_CLASS		= 1
local CLASS_WIDGET		= 2
local CLASS_ADDON		= 3

-- Log levels
local LOG_FATAL 	= 0
local LOG_ERROR		= 1
local LOG_WARN		= 2
local LOG_INFO 		= 3
local LOG_DEBUG 	= 4

-- offset for alphanumerics in nixie texture

local NIXIE_OFFSET = {
	['A'] = { 0 * 23/1024, 0 * 39/128},
	['B'] = { 1 * 23/1024, 0 * 39/128},
	['C'] = { 2 * 23/1024, 0 * 39/128},
	['D'] = { 3 * 23/1024, 0 * 39/128},
	['E'] = { 4 * 23/1024, 0 * 39/128},
	['F'] = { 5 * 23/1024, 0 * 39/128},
	['G'] = { 6 * 23/1024, 0 * 39/128},
	['H'] = { 7 * 23/1024, 0 * 39/128},
	['I'] = { 8 * 23/1024, 0 * 39/128},
	['J'] = { 9 * 23/1024, 0 * 39/128},
	['K'] = {10 * 23/1024, 0 * 39/128},
	['L'] = {11 * 23/1024, 0 * 39/128},
	['M'] = {12 * 23/1024, 0 * 39/128},
	['N'] = {13 * 23/1024, 0 * 39/128},
	['O'] = {14 * 23/1024, 0 * 39/128},
	['P'] = {15 * 23/1024, 0 * 39/128},
	['Q'] = {16 * 23/1024, 0 * 39/128},
	['R'] = {17 * 23/1024, 0 * 39/128},
	['S'] = {18 * 23/1024, 0 * 39/128},
	['T'] = {19 * 23/1024, 0 * 39/128},
	['U'] = {20 * 23/1024, 0 * 39/128},
	['V'] = {21 * 23/1024, 0 * 39/128},
	['W'] = {22 * 23/1024, 0 * 39/128},
	['X'] = {23 * 23/1024, 0 * 39/128},
	['Y'] = {24 * 23/1024, 0 * 39/128},
	['Z'] = {25 * 23/1024, 0 * 39/128},
	
	['&'] = {26 * 23/1024, 0 * 39/128},
	['~'] = {27 * 23/1024, 0 * 39/128},
	['@'] = {28 * 23/1024, 0 * 39/128},
	[''] = {29 * 23/1024, 0 * 39/128},
	['\\'] = {30 * 23/1024, 0 * 39/128},
	['^'] = {31 * 23/1024, 0 * 39/128},
	[':'] = {32 * 23/1024, 0 * 39/128},
	[','] = {33 * 23/1024, 0 * 39/128},
	

	['0'] = {34 * 23/1024, 0 * 39/128},
	['1'] = {35 * 23/1024, 0 * 39/128},
	['2'] = {36 * 23/1024, 0 * 39/128},
	['3'] = {37 * 23/1024, 0 * 39/128},
	['4'] = {38 * 23/1024, 0 * 39/128},
	['5'] = {39 * 23/1024, 0 * 39/128},
	['6'] = {40 * 23/1024, 0 * 39/128},
	['7'] = {41 * 23/1024, 0 * 39/128},
	['8'] = {42 * 23/1024, 0 * 39/128},
	['9'] = {43 * 23/1024, 0 * 39/128},

	['-'] = { 0 * 23/1024, 1 * 39/128},
	['$'] = { 1 * 23/1024, 1 * 39/128},
	['\"'] = { 2 * 23/1024, 1 * 39/128},
	['='] = { 3 * 23/1024, 1 * 39/128},
	['!'] = { 4 * 23/1024, 1 * 39/128},
	['>'] = { 5 * 23/1024, 1 * 39/128},
	['#'] = { 6 * 23/1024, 1 * 39/128},
	['§'] = { 7 * 23/1024, 1 * 39/128},
	['{'] = { 8 * 23/1024, 1 * 39/128},
	['<'] = { 9 * 23/1024, 1 * 39/128},

	['a'] = {10 * 23/1024, 1 * 39/128},
	['b'] = {11 * 23/1024, 1 * 39/128},
	['c'] = {12 * 23/1024, 1 * 39/128},
	['d'] = {13 * 23/1024, 1 * 39/128},
	['e'] = {14 * 23/1024, 1 * 39/128},
	['f'] = {15 * 23/1024, 1 * 39/128},
	['g'] = {16 * 23/1024, 1 * 39/128},
	['h'] = {17 * 23/1024, 1 * 39/128},
	['i'] = {18 * 23/1024, 1 * 39/128},
	['j'] = {19 * 23/1024, 1 * 39/128},
	['k'] = {20 * 23/1024, 1 * 39/128},
	['l'] = {21 * 23/1024, 1 * 39/128},
	['m'] = {22 * 23/1024, 1 * 39/128},
	['n'] = {23 * 23/1024, 1 * 39/128},
	['o'] = {24 * 23/1024, 1 * 39/128},
	['p'] = {25 * 23/1024, 1 * 39/128},
	['q'] = {26 * 23/1024, 1 * 39/128},
	['r'] = {27 * 23/1024, 1 * 39/128},
	['s'] = {28 * 23/1024, 1 * 39/128},
	['t'] = {29 * 23/1024, 1 * 39/128},
	['u'] = {30 * 23/1024, 1 * 39/128},
	['v'] = {31 * 23/1024, 1 * 39/128},
	['w'] = {32 * 23/1024, 1 * 39/128},
	['x'] = {33 * 23/1024, 1 * 39/128},
	['y'] = {34 * 23/1024, 1 * 39/128},
	['z'] = {35 * 23/1024, 1 * 39/128},

	['('] = {36 * 23/1024, 1 * 39/128},
	['['] = {37 * 23/1024, 1 * 39/128},
	['%'] = {38 * 23/1024, 1 * 39/128},
	['.'] = {39 * 23/1024, 1 * 39/128},
	['|'] = {40 * 23/1024, 1 * 39/128},
	['+'] = {41 * 23/1024, 1 * 39/128},
	['?'] = {42 * 23/1024, 1 * 39/128},
	['}'] = {43 * 23/1024, 1 * 39/128},

	[')'] = { 0 * 23/1024, 2 * 39/128},
	[']'] = { 1 * 23/1024, 2 * 39/128},
	[';'] = { 2 * 23/1024, 2 * 39/128},
	['´'] = { 3 * 23/1024, 2 * 39/128},
	['/'] = { 4 * 23/1024, 2 * 39/128},
	[' '] = { 5 * 23/1024, 2 * 39/128},
	['*'] = { 6 * 23/1024, 2 * 39/128},
	['_'] = { 7 * 23/1024, 2 * 39/128},
	
	['\''] = {29 * 23/1024, 0 * 39/128},
}
	
local NIXIE_OFFSET_UNKNOWN = { 7 * 23/1024, 1 * 39/128}

	

-- ----------------------------------------------------------------------
-- Widget Static Variables (local)
-- ----------------------------------------------------------------------


-- ----------------------------------------------------------------------
-- Widget Startup Initialization
-- ----------------------------------------------------------------------


-- ----------------------------------------------------------------------
-- Helper Functions (local)
-- ----------------------------------------------------------------------
-- function which returns also nil for empty strings
local function emptynil( x ) return x ~= "" and x or nil end


-- ----------------------------------------------------------------------
-- Widget Class
-- ----------------------------------------------------------------------

function GnomTECWidgetDeviceNixie(init)

	-- call base class
	local self, protected = GnomTECWidget(init)
	
	-- public fields go in the instance table
	-- self.field = value

	-- protected fields go in the protected table
	-- protected.field = value
	protected.text = nil
	protected.length = nil
	protected.on = false
	
	-- private fields are implemented using locals
	-- they are faster than table access, and are truly private, so the code that uses your class can't get them
	-- local field
	local sizeWidth = 64
	local sizeHeight = 32
	local nixieFrames = {}
	local nixieTextures = {}
	
	local timePause = 0
	local timeElapsed = 0
	local nixieOffset = 0
	
	-- private methods
	-- local function f()
	local function OnUpdate(frame, elapsed)
		if (protected.text) then
			timeElapsed = timeElapsed + elapsed
			if (timePause > 0) then
				if (timeElapsed > timePause) then
					timeElapsed = timeElapsed - timePause
					timePause = 0
				end
			elseif (timeElapsed > 0.3) then
				timeElapsed = timeElapsed - 0.3
				nixieOffset = nixieOffset + 1
				if (nixieOffset > #protected.text) then
					nixieOffset = -protected.length
				end
				self.SetText(protected.text)
			end
		else
			timeElapsed = 0
			nixieOffset = 0
		end
	end

	local function setNixie(num, char)
		if (nixieTextures[num]) then
			local x, y
			
			if (NIXIE_OFFSET[char]) then
				x = NIXIE_OFFSET[char][1]
				y = NIXIE_OFFSET[char][2]
			else
				x = NIXIE_OFFSET_UNKNOWN[1]
				y = NIXIE_OFFSET_UNKNOWN[2]
			end			
			nixieTextures[num]:SetTexCoord(x,x+23/1024,y,y+39/128)
		end
	end
	
	-- protected methods
	-- function protected.f()
	
	-- public methods
	-- function self.f()
	function self.LogMessage(logLevel, message, ...)
		protected.LogMessage(CLASS_WIDGET, logLevel, "GnomTECWidgetDeviceNixie", message, ...)
	end

	function self.GetMinReseize()
		local minWidth = sizeWidth
		local minHeight = sizeHeight
		
		return minWidth, minHeight
	end

	function self.GetMaxReseize()		
		local maxWidth = sizeWidth
		local maxHeight = sizeHeight

		return maxWidth, maxHeight
	end

	function self.IsHeightDependingOnWidth()
		return false -- should be true when layouter is complete implemented
	end

	function self.IsWidthDependingOnHeight()
		return false -- should be true when layouter is complete implemented
	end

	function self.ResizeByWidth(pixelWidth, pixelHeight)
		protected.widgetFrame:SetWidth(sizeWidth)
		protected.widgetFrame:SetHeight(sizeHeight)

		return sizeWidth, sizeHeight
	end

	function self.ResizeByHeight(pixelWidth, pixelHeight)
		protected.widgetFrame:SetWidth(sizeWidth)
		protected.widgetFrame:SetHeight(sizeHeight)

		return sizeWidth, sizeHeight
	end
	
	function self.On()
		protected.on = true
		self.SetText(protected.text)
	end

	function self.Off()
		protected.on = false
		self.SetText(protected.text)
	end
	
	function self.IsOn()
		return protected.on
	end

	function self.SetText(text, offset, pause)
		protected.text = emptynil(text)
		timePause = pause or 0
		timeElapsed = 0
		nixieOffset = offset or nixieOffset
		local c
		for i = 1, protected.length do
			if (not protected.on) then
				c = ' '
			elseif (i+nixieOffset >0) then
  		  		c = emptynil(string.sub(text,i+nixieOffset,i+nixieOffset))
  		  	else
  		  		c = ' '
  		  	end
 			setNixie(i, c or ' ')
 		end
	end
	
	function self.GetText()
		return emptynil(protected.text)
	end	
		
	-- constructor
	do
		if (not init) then
			init = {}
		end
				
		local widgetFrame = CreateFrame("Frame", protected.widgetUID, UIParent, "T_GNOMTECWIDGETDEVICENIXIE")
		widgetFrame:Hide()

		protected.widgetFrame = widgetFrame 
		
		if (init.length) then
			protected.length = init.length
		else
			protected.length = 1
		end
		sizeWidth = protected.length * 15 + 32
		if ((sizeWidth % 48) > 0) then
			sizeWidth = (floor((sizeWidth / 32)) + 1) * 32
		end
		
		if (sizeWidth < 64) then
			sizeWidth = 64
		end
		
		local x,y
		for t=1, protected.length do
			nixieFrames[t] = CreateFrame("Frame", nil, widgetFrame)
			nixieFrames[t]:SetWidth(15)
			nixieFrames[t]:SetHeight(16)			
			nixieFrames[t]:SetPoint("CENTER", (t - 0.5 - (protected.length  / 2))  * 15, 0)
			nixieTextures[t] = nixieFrames[t]:CreateTexture()
			nixieTextures[t]:SetAllPoints()
			nixieTextures[t]:SetTexture([[Interface/AddOns/GnomTEC/GnomTEC/Textures/device_nixie]])
			setNixie(t, '*')
		end
		
		
		-- should be configurable later eg. saveable
		widgetFrame:SetPoint("CENTER")		
		widgetFrame:SetWidth(sizeWidth)		
		widgetFrame:SetHeight(sizeHeight)
		
		if (init.on) then
			self.On()
		end
		
		self.SetText(init.text)
		
		widgetFrame:SetScript("OnUpdate",OnUpdate)

		
		if (init.parent) then
			init.parent.AddChild(self, protected)
		end

		protected.LogMessage(CLASS_WIDGET, LOG_DEBUG, "GnomTECWidgetDeviceNixie", "New instance created (%s)", protected.UID)
	end
	
	-- return the instance
	return self
end


