-- **********************************************************************
-- GnomTECWidgetEditBox
-- Version: 8.1.0.13
-- Author: Peter Jack
-- URL: http://www.gnomtec.de/
-- **********************************************************************
-- Copyright © 2014-2019 by Peter Jack
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
local MAJOR, MINOR = "GnomTECWidgetEditBox-1.0", 13
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

function GnomTECWidgetEditBox(init)

	-- call base class
	local self, protected = GnomTECWidget(init)
	
	-- public fields go in the instance table
	-- self.field = value

	-- protected fields go in the protected table
	-- protected.field = value
	protected.scrollFrame = nil
	protected.editBox = nil
	protected.slider = nil
	protected.multiLine = nil
	
	-- private fields are implemented using locals
	-- they are faster than table access, and are truly private, so the code that uses your class can't get them
	-- local field
	local lockSliderOrScrollUpdate = false
				
	-- private methods
	-- local function f()
	local function OnMouseWheel(frame, delta)
		protected.slider:SetValue(protected.slider:GetValue() - delta*14);
	end

	local function OnMouseDown(frame, button)
		protected.editBox:SetFocus()
	end

	local function OnValueChanged(frame, value)
		if (not lockSliderOrScrollUpdate) then
			lockSliderOrScrollUpdate = true
			protected.scrollFrame:SetVerticalScroll(value);
			lockSliderOrScrollUpdate = false
		end
	end
	
    local function OnChangedSizeWidgetFrame(frame, width, height)
        protected.editBox:SetWidth(protected.scrollFrame:GetWidth())
        protected.editBox:SetHeight(protected.scrollFrame:GetHeight())    
    end


	local function OnSizeChangedEditBox(frame, width, height)
		protected.scrollFrame:UpdateScrollChildRect();
	end

	local function OnEscapePressed(frame)
		protected.editBox:ClearFocus();
	end
	
	local function OnScrollRangeChanged(frame, xExtent, yExtent)
		if (not lockSliderOrScrollUpdate) then
			lockSliderOrScrollUpdate = true
			protected.scrollFrame:UpdateScrollChildRect()
			protected.slider:SetMinMaxValues(0, protected.scrollFrame:GetVerticalScrollRange());
			protected.slider:SetValue(min(protected.scrollFrame:GetVerticalScroll(), protected.scrollFrame:GetVerticalScrollRange()));  
			protected.scrollFrame:SetVerticalScroll(protected.slider:GetValue());
			lockSliderOrScrollUpdate = false
		end
	end
	
	local function OnCursorChanged(frame, x, y, width, height)
		local widgetHeight = protected.widgetFrame:GetHeight()
		local offset = protected.slider:GetValue()
		
		if (offset > -y) then
			protected.slider:SetValue(-y)
		elseif (offset+widgetHeight < -y + height) then
			protected.slider:SetValue(-y+height-widgetHeight)
		end
	end
	
	-- protected methods
	-- function protected.f()
	
	-- public methods
	-- function self.f()
	function self.LogMessage(logLevel, message, ...)
		protected.LogMessage(CLASS_WIDGET, logLevel, "GnomTECWidgetEditBox", message, ...)
	end

	function self.GetMinReseize()
		local minWidth
		local minHeight

		if (protected.multiLine) then
			minWidth = 100
			minHeight = 100
		else
			minWidth = 24
			minHeight = 24
		end

		return minWidth, minHeight
	end

	function self.GetMaxReseize()		
		local maxWidth
		local maxHeight

		if (protected.multiLine) then
			maxWidth = floor(UIParent:GetWidth())
			maxHeight = floor(UIParent:GetHeight())
		else
			maxWidth = floor(UIParent:GetWidth())
			maxHeight = 24
		end
		
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
		
		if (not protected.multiLine) then
			protected.editBox:SetCursorPosition(0)
		end

		return pixelWidth, pixelHeight
	end

	function self.ResizeByHeight(pixelWidth, pixelHeight)
		protected.widgetFrame:SetWidth(pixelWidth)
		protected.widgetFrame:SetHeight(pixelHeight)

		if (not protected.multiLine) then
			protected.editBox:SetCursorPosition(0)
		end

		return pixelWidth, pixelHeight
	end
	
	function self.SetText(text)
		protected.editBox:SetText(text or "")
	end

	function self.GetText()
		return protected.editBox:GetText()
	end

	function self.SetFocus()
		protected.editBox:SetFocus()
	end
	
	
	
	-- constructor
	do
		if (not init) then
			init = {}
		end
		
		if (nil == init.multiLine) then
			protected.multiLine = true
		else
			protected.multiLine = init.multiLine
		end
		
		if (protected.multiLine) then
			local widgetFrame = CreateFrame("Frame", protected.widgetUID, UIParent,"T_GNOMTECWIDGETEDITBOX_MULTILINE")
			local scrollFrame = widgetFrame.scrollFrame
			local editBox = scrollFrame.editBox
			local slider = widgetFrame.slider
			widgetFrame:Hide()

			protected.widgetFrame = widgetFrame 
			protected.editBox = editBox 
			protected.scrollFrame = scrollFrame 
			protected.slider = slider

			widgetFrame:SetPoint("CENTER")		
			local w, r = self.GetWidth()
			if (not r) then
				widgetFrame:SetWidth(w)		
			else
				widgetFrame:SetWidth("100")		
			end

			local h, r = self.GetHeight()
			if (not r) then
				widgetFrame:SetHeight(h)		
			else
				widgetFrame:SetHeight("100")
			end
			
            widgetFrame:SetScript("OnSizeChanged", OnChangedSizeWidgetFrame)

			scrollFrame:SetScript("OnScrollRangeChanged", OnScrollRangeChanged)
			scrollFrame:SetScript("OnMouseWheel", OnMouseWheel)
			scrollFrame:SetScript("OnMouseDown", OnMouseDown)
	
            editBox:SetHeight(widgetFrame:GetHeight())    
            editBox:SetWidth(widgetFrame:GetWidth() - 16)    
			editBox:SetMultiLine(true)
			editBox:SetFontObject(ChatFontNormal)
			editBox:SetJustifyH("LEFT")
			editBox:EnableKeyboard(true);
			editBox:EnableMouse(true);			
			editBox:SetAutoFocus(false);			
			editBox:SetScript("OnMouseWheel", OnMouseWheel)
			editBox:SetScript("OnSizeChanged", OnSizeChangedEditBox)
			editBox:SetScript("OnEscapePressed", OnEscapePressed)
			editBox:SetScript("OnCursorChanged", OnCursorChanged)

			slider:SetScript("OnMouseWheel", OnMouseWheel)
			slider:SetScript("OnValueChanged", OnValueChanged)
			slider:SetValueStep(14)

			scrollFrame:UpdateScrollChildRect();
			slider:SetMinMaxValues(0, scrollFrame:GetVerticalScrollRange());
			slider:SetValue(scrollFrame:GetVerticalScroll());   
		else
			local widgetFrame = CreateFrame("Frame", protected.widgetUID, UIParent,"T_GNOMTECWIDGETEDITBOX")
			local editBox = widgetFrame.editBox
			widgetFrame:Hide()

			protected.widgetFrame = widgetFrame 
			protected.editBox = editBox
			
			widgetFrame:SetPoint("CENTER")		
			local w, r = self.GetWidth()
			if (not r) then
				widgetFrame:SetWidth(w)		
			else
				widgetFrame:SetWidth("24")		
			end
			protected.widgetHeight = 24
			protected.widgetHeightIsRelative = false
			widgetFrame:SetHeight(protected.widgetHeight)

			editBox:SetMultiLine(false)
			editBox:SetFontObject(ChatFontNormal)
			editBox:SetJustifyH("LEFT")
			editBox:EnableKeyboard(true);
			editBox:EnableMouse(true);			
			editBox:SetAutoFocus(false);			
			editBox:SetScript("OnEscapePressed", OnEscapePressed)
		end	

		self.SetText(init.text)
		
		if (init.parent) then
			init.parent.AddChild(self, protected)
		end

		protected.LogMessage(CLASS_WIDGET, LOG_DEBUG, "GnomTECWidgetEditBox", "New instance created (%s)", protected.UID)
	end
	
	-- return the instance
	return self
end


