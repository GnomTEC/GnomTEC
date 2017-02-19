-- **********************************************************************
-- GnomTECAddonModule Class
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
local MAJOR, MINOR = "GnomTECAddonModule-1.0", 8
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
local CLASS_BASE			= 0
local CLASS_CLASS			= 1
local CLASS_WIDGET			= 2
local CLASS_ADDON			= 3
local CLASS_ADDONMODULE		= 4

-- Log levels
local LOG_FATAL 	= 0
local LOG_ERROR		= 1
local LOG_WARN		= 2
local LOG_INFO 		= 3
local LOG_DEBUG 	= 4

-- ----------------------------------------------------------------------
-- Class Static Variables (local)
-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
-- Class Startup Initialization
-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
-- Helper Functions (local)
-- ----------------------------------------------------------------------
-- function which returns also nil for empty strings
local function emptynil( x ) return x ~= "" and x or nil end

-- ----------------------------------------------------------------------
-- Class
-- ----------------------------------------------------------------------
function GnomTECAddonModule(addon, moduleIdentifier)

	-- call base class
	local self, protected = GnomTEC()
	
	-- public fields go in the instance table
	-- self.field = value

	-- protected fields go in the protected table
	-- protected.field = value
	
	-- private fields are implemented using locals
	-- they are faster than table access, and are truly private, so the code that uses your class can't get them
	-- local field
	local addon = addon
	local moduleIdentifier = moduleIdentifier
		
	-- private methods
	-- local function f()

	-- protected methods
	-- function protected.f()
	
	-- public methods
	-- function self.f()
	function self.LogMessage(logLevel, message, ...)
		addon.LogMessage(logLevel, "<module> %s: "..message, moduleIdentifier, ...)
	end
	
	function self.OnInitialize()
	end

	function self.OnEnable()
	end
		
	function self.OnDisable()
	end

	function self.GetAddon()
		return addon
	end

	function self.GetModuleIdentifier()
		return moduleIdentifier
	end
	
	-- constructor
	do
		protected.LogMessage(CLASS_CLASS, LOG_DEBUG, "GnomTECAddonModule", "New instance created (%s)", protected.UID)
	end
	
	-- return the instance table
	return self
end


