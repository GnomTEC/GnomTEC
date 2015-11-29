-- **********************************************************************
-- GnomTECAddon Class
-- Version: 6.2.2.3
-- Author: Peter Jack
-- URL: http://www.gnomtec.de/
-- **********************************************************************
-- Copyright © 2014-2015 by Peter Jack
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
local MAJOR, MINOR = "GnomTECAddon-1.0", 3
local class, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not class then return end -- No Upgrade needed.

-- ----------------------------------------------------------------------
-- Class Global Constants (local)
-- ----------------------------------------------------------------------
-- localization
local L = LibStub("AceLocale-3.0"):GetLocale("GnomTEC")

-- texure path
local T = [[Interface\Addons\]].. ... ..[[\GnomTEC\Textures\]]

-- Class levels
local CLASS_BASE		= 0
local CLASS_CLASS		= 1
local CLASS_WIDGET	= 2
local CLASS_ADDON		= 3

-- Log levels
local LOG_FATAL 	= 0
local LOG_ERROR	= 1
local LOG_WARN		= 2
local LOG_INFO 	= 3
local LOG_DEBUG 	= 4

-- ----------------------------------------------------------------------
-- Class Static Variables (local)
-- ----------------------------------------------------------------------
class.FrameworkRevision = 3						-- update this every release
class.lastUID = class.lastUID or 0
class.dataObjects = class.dataObjects or {}

-- ----------------------------------------------------------------------
-- Class Startup Initialization
-- ----------------------------------------------------------------------
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local icon = LibStub("LibDBIcon-1.0")


-- ----------------------------------------------------------------------
-- Helper Functions (local)
-- ----------------------------------------------------------------------
-- function which returns also nil for empty strings
local function emptynil( x ) return x ~= "" and x or nil end

-- ----------------------------------------------------------------------
-- Class
-- ----------------------------------------------------------------------
--[[
	addonInfo - table with addon informations as string
		["Name"] 					- name
		["Description"]			- decription
		["Version"] 				- version
		["Date"] = 					- date
		["Author"] 					- author
		["Email"] 					- contact email
		["Website"] 				- URL to addon website
		["Copyright"] 				- copyright information
		["License"] 				- license information
		["FrameworkRevision"]	- revision of GnomTEC framework against addon was builded
		
--]]
function GnomTECAddon(addonTitle, addonInfo , defaultsDb, optionsArray)

	-- call base class
	local self, protected = GnomTECComm(addonTitle, addonInfo)
	
	-- check if framework is compatible for this addon and stop if not
	if (addonInfo["FrameworkRevision"] > class.FrameworkRevision) then
		protected.LogMessage(CLASS_CLASS, LOG_FATAL, "GnomTECAddon", [[Framework revision (%d) is smaller then needed from addon "%s" (%d)]], class.FrameworkRevision, addonInfo["Name"], addonInfo["FrameworkRevision"])

		-- show the issue to user
		StaticPopupDialogs["GNOMTEC_FRAMEWORKREVISION_ERROR"] = {
  			text = L["L_ERROR_FRAMEWORKREVISION"],
  			button1 = "Ok",
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
  			preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
		}
		StaticPopup_Show ("GNOMTEC_FRAMEWORKREVISION_ERROR")
		return nil
	end

	local defaultsDb = defaultsDb
	local optionsArray = optionsArray
		
	-- public fields go in the instance table
	-- self.field = value

	-- protected fields go in the protected table
	-- protected.field = value
	
	-- private fields are implemented using locals
	-- they are faster than table access, and are truly private, so the code that uses your class can't get them
	-- local field
	local addonTitle = addonTitle
	local aceAddon = nil
	local aceOptionsMain = nil
	local minimapIconDataObject = nil
		
	-- private methods
	-- local function f()
	local function OnInitialize()
	 	-- Code that you want to run when the addon is first loaded goes here.
		self.db = LibStub("AceDB-3.0"):New(addonTitle.."DB", defaultsDb, true)
		if (not self.db.profile.GnomTECAddon) then
			self.db.profile.GnomTECAddon = {}
		end
		self.SafeCall(protected.OnInitialize)
	end

	local function OnEnable()
  	  -- Called when the addon is enabled
		self.SafeCall(protected.OnEnable)
	end

	local function OnDisable()
		-- Called when the addon is disabled
		self.SafeCall(protected.OnDisable)
		aceAddon:UnregisterAllEvents();
	end

	-- protected methods
	-- function protected.f()
	
	-- public methods
	-- function self.f()
	function self.LogMessage(logLevel, message, ...)
		protected.LogMessage(CLASS_ADDON, logLevel, addonTitle, message, ...)
	end

	function self.NewDataObject(name, dataObject)
		if (emptynil(name)) then
			name = addonTitle..": "..name
		else
			name = addonTitle
		end
		
		class.dataObject = ldb:NewDataObject(name, dataObject)
		class.dataObjects[addonTitle][name] = dataObject
		
		return dataObject 
	end
	
	function self.ShowMinimapIcon(dataObject)
		if (dataObject) and (not minimapIconDataObject) then
			minimapIconDataObject = dataObject
			if (not self.db.profile.GnomTECAddon.minimapIcon) then
				self.db.profile.GnomTECAddon.minimapIcon = {hide = false}
			end
			icon:Register(addonTitle, minimapIconDataObject, self.db.profile.GnomTECAddon.minimapIcon)
		end
		
		if (minimapIconDataObject) then
			self.db.profile.GnomTECAddon.minimapIcon.hide = false
			icon:Show(addonTitle)
		end
	end

	function self.HideMinimapIcon()
		if (minimapIconDataObject) then
			self.db.profile.GnomTECAddon.minimapIcon.hide = true
			icon:Hide(addonTitle)
		end
	end
	
	function self.GetAddonTitle()
		return addonTitle
	end
	
	function self.UnregisterAllEvents()
		aceAddon:UnregisterAllEvents()
	end
	
	function self.RegisterChatCommand(command, func)
		aceAddon:RegisterChatCommand(command, func)
	end
	
	function self.ScheduleTimer(func, delay)
		aceAddon:ScheduleTimer(func, delay)
	end
	
	-- constructor
	do
		class.lastUID = class.lastUID + 1
		protected.addonUID = "GnomTECAddonInstance"..class.lastUID
		
		class.dataObjects[addonTitle]= {}
		
		aceOptionsMain = {
			name = addonInfo["Name"],
			type = "group",
			args = {
				descriptionTitle = {
					order = 1,
					type = "description",
					name = addonInfo["Description"],
				},
				descriptionAbout = {
					name = "About",
					type = "group",
					guiInline = true,
					order = 2,
					args = {
						descriptionVersion = {
						order = 1,
						type = "description",			
						name = "|cffffd700".."Version"..": ".._G["GREEN_FONT_COLOR_CODE"]..addonInfo["Version"],
						},
						descriptionDate = {
						order = 2,
						type = "description",			
						name = "|cffffd700".."Date"..": ".._G["GREEN_FONT_COLOR_CODE"]..addonInfo["Date"],
						},
						descriptionAuthor = {
							order = 3,
							type = "description",
							name = "|cffffd700".."Author"..": ".."|cffff8c00"..addonInfo["Author"],
						},
						descriptionEmail = {
							order = 4,
							type = "description",
							name = "|cffffd700".."Email"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"]..addonInfo["Email"],
						},
						descriptionWebsite = {
							order = 5,
							type = "description",
							name = "|cffffd700".."Website"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"]..addonInfo["Website"],
						},
						descriptionCopyright = {
							order = 6,
							type = "description",
							name = "|cffffd700".."Copyright"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"]..addonInfo["Copyright"],
						},
						descriptionLicense = {
							order = 7,
							type = "description",
							name = "|cffffd700".."License"..": ".._G["HIGHLIGHT_FONT_COLOR_CODE"]..addonInfo["License"],
						},
					}
				},
			},
		}
		
		aceAddon = LibStub("AceAddon-3.0"):NewAddon(addonTitle, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceComm-3.0", "AceSerializer-3.0", "AceTimer-3.0")
		LibStub("AceConfig-3.0"):RegisterOptionsTable(addonInfo["Name"].." Main", aceOptionsMain)
		LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonInfo["Name"].." Main", addonInfo["Name"]);

		if (optionsArray) then
			for idx, value in ipairs (optionsArray) do
				LibStub("AceConfig-3.0"):RegisterOptionsTable(addonInfo["Name"].." "..value.name, value)
				LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonInfo["Name"].." "..value.name, value.name, addonInfo["Name"]);
			end
		end
			
		function aceAddon:OnInitialize()
			OnInitialize()
		end
		function aceAddon:OnEnable()
			OnEnable()
		end
		function aceAddon:OnDisable()
			OnDisable()
		end
		
		protected.LogMessage(CLASS_CLASS, LOG_DEBUG, "GnomTECAddon", "New instance created (%s / %s)", protected.UID, protected.addonUID)
	end
	
	-- return the instance table
	return self, protected
end


