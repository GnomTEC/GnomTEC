-- **********************************************************************
-- GnomTECWidgetScrollingMessage
-- Version: 10.0.0.20
-- Author: Peter Jack
-- URL: http://www.gnomtec.de/
-- **********************************************************************
-- Copyright © 2014-2022 by Peter Jack
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
local MAJOR, MINOR = "GnomTECWidgetScrollingMessage-1.0", 20
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

-- ----------------------------------------------------------------------
-- Widget Static Variables (local)
-- ----------------------------------------------------------------------


-- ----------------------------------------------------------------------
-- Widget Startup Initialization
-- ----------------------------------------------------------------------


-- ----------------------------------------------------------------------
-- Helper Functions (local)
-- ----------------------------------------------------------------------


-- ----------------------------------------------------------------------
-- Widget Class
-- ----------------------------------------------------------------------

function GnomTECWidgetScrollingMessage(init)

	-- call base class
	local self, protected = GnomTECWidget(init)
	
	-- public fields go in the instance table
	-- self.field = value

	-- protected fields go in the protected table
	-- protected.field = value
	protected.scrollingMessageFrame = nil
	protected.slider = nil
	
	-- private fields are implemented using locals
	-- they are faster than table access, and are truly private, so the code that uses your class can't get them
	-- local field
	
	-- private methods
	-- local function f()
	local function OnMouseWheel(frame, delta)
		if IsControlKeyDown() then
			delta = delta * protected.scrollingMessageFrame:GetPagingScrollAmount(); 
		elseif IsShiftKeyDown() then
			delta = delta * 10;
		end 

		protected.scrollingMessageFrame:ScrollByAmount(delta);
	end

	local function OnScrollChanged(messageFrame, offset)
		local num = messageFrame:GetNumMessages()
		protected.slider:SetMinMaxValues(1, num)
		protected.slider:SetValue(num - offset)
	end

	local function OnValueChanged(frame, value)
		local num = protected.scrollingMessageFrame:GetNumMessages()
		local cur = num - floor(value)
		protected.scrollingMessageFrame:SetScrollOffset(cur)
	end

	local function OnShow(frame)
		local num = protected.scrollingMessageFrame:GetNumMessages()
		local offset = protected.scrollingMessageFrame:GetScrollOffset()
		if num > 0 then
			protected.slider:SetMinMaxValues(1, num)
			protected.slider:SetValue(num - offset)
		else
			protected.slider:SetMinMaxValues(1, 1)
			protected.slider:SetValue(1)
		end
	end
	-- protected methods
	-- function protected.f()
	
	-- public methods
	-- function self.f()
	function self.LogMessage(logLevel, message, ...)
		protected.LogMessage(CLASS_WIDGET, logLevel, "GnomTECWidgetScrollingMessage", message, ...)
	end

	function self.GetMinReseize()
		local minWidth = 100
		local minHeight = 100
		
		return minWidth, minHeight
	end

	function self.GetMaxReseize()		
		local maxWidth = floor(UIParent:GetWidth())
		local maxHeight = floor(UIParent:GetHeight())

		return maxWidth, maxHeight
	end

	function self.IsHeightDependingOnWidth()
		return false
	end

	function self.IsWidthDependingOnHeight()
		return false
	end

	function self.ResizeByWidth(pixelWidth, pixelHeight)
		protected.widgetFrame:SetWidth(pixelWidth)
		protected.widgetFrame:SetHeight(pixelHeight)

		return pixelWidth, pixelHeight
	end

	function self.ResizeByHeight(pixelWidth, pixelHeight)
		protected.widgetFrame:SetWidth(pixelWidth)
		protected.widgetFrame:SetHeight(pixelHeight)

		return pixelWidth, pixelHeight
	end
	
	function self.AddMessage(text, ...)
		protected.scrollingMessageFrame:AddMessage(text, ...)
	end

	function self.GetNumMessages(...)
		return protected.scrollingMessageFrame:GetNumMessages(...)
	end
	
	-- constructor
	do
		if (not init) then
			init = {}
		end
		
		local widgetFrame = CreateFrame("Frame", protected.widgetUID, UIParent, "T_GNOMTECWIDGETSCROLLINGMESSAGE")
		local scrollingMessageFrame = widgetFrame.scrollingMessageFrame	-- CreateFrame("ScrollingMessageFrame", nil, widgetFrame)
		local slider = widgetFrame.slider 	-- CreateFrame("Slider", nil, widgetFrame)
		
		protected.widgetFrame = widgetFrame 
		protected.scrollingMessageFrame = scrollingMessageFrame 
		protected.slider = slider 
		
		-- should be configurable later eg. saveable
		widgetFrame:SetPoint("CENTER")		
		local w, r = self.GetWidth()
		if (not r) then
			widgetFrame:SetWidth(w)		
		else
			widgetFrame:SetWidth("600")		
		end
		local h, r = self.GetHeight()
		if (not r) then
			widgetFrame:SetHeight(h)		
		else
			widgetFrame:SetHeight("400")
		end
		
		scrollingMessageFrame:SetIndentedWordWrap(true) 
		scrollingMessageFrame:SetMaxLines(1024)
		
		scrollingMessageFrame:SetScript("OnMouseWheel", OnMouseWheel)
		scrollingMessageFrame:SetOnScrollChangedCallback(OnScrollChanged);
		
		slider:SetScript("OnMouseWheel", OnMouseWheel)
		slider:SetScript("OnValueChanged", OnValueChanged)
		slider:SetScript("OnShow", OnShow)
		slider:SetMinMaxValues(1, 1)
		slider:SetValue(1)
		slider:SetValueStep(1)
				
		if (init.parent) then
			init.parent.AddChild(self, protected)
		end

		protected.LogMessage(CLASS_WIDGET, LOG_DEBUG, "GnomTECWidgetScrollingMessage", "New instance created (%s)", protected.UID)
	end
	
	-- return the instance
	return self
end


