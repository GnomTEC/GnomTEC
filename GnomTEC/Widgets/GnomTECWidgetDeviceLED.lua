-- **********************************************************************
-- GnomTECWidgetDeviceLED
-- Version: 7.2.0.9
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
local MAJOR, MINOR = "GnomTECWidgetDeviceLED-1.0", 9
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

function GnomTECWidgetDeviceLED(init)

	-- call base class
	local self, protected = GnomTECWidget(init)
	
	-- public fields go in the instance table
	-- self.field = value

	-- protected fields go in the protected table
	-- protected.field = value
	
	-- private fields are implemented using locals
	-- they are faster than table access, and are truly private, so the code that uses your class can't get them
	-- local field
	local size = 32
	
	-- private methods
	-- local function f()
	local function OnClick(frame, button)
		self.SafeCall(self.OnClick, self, button)
	end

	-- protected methods
	-- function protected.f()
	
	-- public methods
	-- function self.f()
	function self.LogMessage(logLevel, message, ...)
		protected.LogMessage(CLASS_WIDGET, logLevel, "GnomTECWidgetDeviceLED", message, ...)
	end

	function self.GetMinReseize()
		local minWidth = size
		local minHeight = size
		
		return minWidth, minHeight
	end

	function self.GetMaxReseize()		
		local maxWidth = size
		local maxHeight = size

		return maxWidth, maxHeight
	end

	function self.IsHeightDependingOnWidth()
		return false -- should be true when layouter is complete implemented
	end

	function self.IsWidthDependingOnHeight()
		return false -- should be true when layouter is complete implemented
	end

	function self.ResizeByWidth(pixelWidth, pixelHeight)
		protected.widgetFrame:SetWidth(size)
		protected.widgetFrame:SetHeight(size)

		return size, size
	end

	function self.ResizeByHeight(pixelWidth, pixelHeight)
		protected.widgetFrame:SetWidth(size)
		protected.widgetFrame:SetHeight(size)

		return size, size
	end
	
	function self.On()
		protected.widgetFrame:SetChecked(true)
	end

	function self.Off()
		protected.widgetFrame:SetChecked(false)
	end
	
	function self.IsOn()
		return protected.widgetFrame:GetChecked()
	end

	
	-- constructor
	do
		if (not init) then
			init = {}
		end
				
		local widgetFrame = CreateFrame("CheckButton", protected.widgetUID, UIParent, "T_GNOMTECWIDGETDEVICELED")
		widgetFrame:Hide()

		protected.widgetFrame = widgetFrame 
		
		-- should be configurable later eg. saveable
		widgetFrame:SetPoint("CENTER")		
		widgetFrame:SetWidth(size)		
		widgetFrame:SetHeight(size)

		-- a LED should not be clickable
		widgetFrame:Disable()
		
		if (init.on) then
			self.On()
		end
		
		if (init.parent) then
			init.parent.AddChild(self, protected)
		end

		protected.LogMessage(CLASS_WIDGET, LOG_DEBUG, "GnomTECWidgetDeviceLED", "New instance created (%s)", protected.UID)
	end
	
	-- return the instance
	return self
end


