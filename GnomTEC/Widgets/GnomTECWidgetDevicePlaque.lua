﻿-- **********************************************************************
-- GnomTECWidgetDevicePlaque
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
local MAJOR, MINOR = "GnomTECWidgetDevicePlaque-1.0", 20
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
-- function which returns also nil for empty strings
local function emptynil( x ) return x ~= "" and x or nil end


-- ----------------------------------------------------------------------
-- Widget Class
-- ----------------------------------------------------------------------

function GnomTECWidgetDevicePlaque(init)

	-- call base class
	local self, protected = GnomTECWidget(init)
	
	-- public fields go in the instance table
	-- self.field = value

	-- protected fields go in the protected table
	-- protected.field = value
	protected.text = nil
	protected.textFontString = nil
	
	-- private fields are implemented using locals
	-- they are faster than table access, and are truly private, so the code that uses your class can't get them
	-- local field
	
	-- private methods
	-- local function f()

	-- protected methods
	-- function protected.f()
	
	-- public methods
	-- function self.f()
	function self.LogMessage(logLevel, message, ...)
		protected.LogMessage(CLASS_WIDGET, logLevel, "GnomTECWidgetDevicePlaque", message, ...)
	end

	function self.GetMinReseize()
		local minWidth = 64
		local minHeight = 32
		
		if (protected.textFontString) then
			minWidth = max(minWidth, ceil(protected.textFontString:GetStringWidth() + 32))
			minHeight = 32
		end
		
		return minWidth, minHeight
	end

	function self.GetMaxReseize()		
		local maxWidth = floor(UIParent:GetWidth())
		local maxHeight = 32

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
	
	function self.SetText(text)
		protected.text = emptynil(text)
		if (protected.textFontString) then
			protected.textFontString:SetText(protected.text or "")
			self.TriggerResize(self, 0, 0)
		end
	end
	
	function self.GetText()
		return emptynil(protected.title)
	end	
	
	-- constructor
	do
		if (not init) then
			init = {}
		end
		
		local widgetFrame = CreateFrame("Frame", protected.widgetUID, UIParent, "T_GNOMTECWIDGETDEVICEPLAQUE")
		widgetFrame:Hide()

		local textFontString = widgetFrame:CreateFontString()
		
		protected.widgetFrame = widgetFrame 
		protected.textFontString = textFontString 
		
		-- should be configurable later eg. saveable
		widgetFrame:SetPoint("CENTER")		
		local w, r = self.GetWidth()
		if (not r) then
			widgetFrame:SetWidth(w)		
		else
			widgetFrame:SetWidth("64")		
		end
		local h, r = self.GetHeight()
		if (not r) then
			widgetFrame:SetHeight(h)		
		else
			widgetFrame:SetHeight("32")
		end
		
		textFontString:SetFontObject(init.fontObject or GameFontNormal)
		textFontString:SetJustifyH(init.justifyH or "CENTER")
		textFontString:SetTextColor(1.0, 1.0, 1.0, 1.0)
		textFontString:SetWidth("32")		
		textFontString:SetHeight("14")
		textFontString:SetPoint("TOPLEFT")
		textFontString:SetPoint("BOTTOMRIGHT")

		self.SetText(init.text)
						
		if (init.parent) then
			init.parent.AddChild(self, protected)
		end

		protected.LogMessage(CLASS_WIDGET, LOG_DEBUG, "GnomTECWidgetDevicePlaque", "New instance created (%s)", protected.UID)
	end
	
	-- return the instance
	return self
end


