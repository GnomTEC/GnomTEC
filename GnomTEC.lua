-- **********************************************************************
-- GnomTEC (GnomTEC Addon Framework)
-- Version: 10.0.7.21
-- Author: Peter Jack
-- URL: http://www.gnomtec.de/
-- **********************************************************************
-- Copyright © 2014-2023 by Peter Jack
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

-- load localization first.
local L = LibStub("AceLocale-3.0"):GetLocale("GnomTEC_")

-- ----------------------------------------------------------------------
-- Addon Info Constants (local)
-- ----------------------------------------------------------------------
-- addonInfo for addon registration to GnomTEC API
local addonInfo = {
	["Name"] = "GnomTEC (Addon Framework)",
	["Description"] = L["L_DESCRIPTION"],	
	["Version"] = "10.0.7.21",
	["Date"] = "2023-03-22",
	["Author"] = "Peter Jack",
	["Email"] = "info@gnomtec.de",
	["Website"] = "https://www.gnomtec.de/",
	["Copyright"] = "© 2014-2023 by Peter Jack",
	["License"] = "European Union Public Licence (EUPL v.1.1)",
	["FrameworkRevision"] = 20
}

-- ----------------------------------------------------------------------
-- Addon Global Constants (local)
-- ----------------------------------------------------------------------
-- Class levels
local CLASS_BASE	= 0
local CLASS_CLASS	= 1
local CLASS_WIDGET	= 2
local CLASS_ADDON	= 3

-- Log levels
local LOG_FATAL = 0
local LOG_ERROR	= 1
local LOG_WARN	= 2
local LOG_INFO 	= 3
local LOG_DEBUG	= 4

-- ----------------------------------------------------------------------
-- Addon Static Variables (local)
-- ----------------------------------------------------------------------


-- ----------------------------------------------------------------------
-- Addon Startup Initialization
-- ----------------------------------------------------------------------


-- ----------------------------------------------------------------------
-- Helper Functions (local)
-- ----------------------------------------------------------------------


-- ----------------------------------------------------------------------
-- Addon Class
-- ----------------------------------------------------------------------

local function GnomTECAddonFramework()
	local self = {}
	
	-- call addon base class
	local addon, protected = GnomTECAddon("GnomTEC", addonInfo)
	
	-- public fields go in the instance table
	-- self.field = value

	-- protected fields go in the protected table
	-- protected.field = value
	
	-- private fields are implemented using locals
	-- they are faster than table access, and are truly private, so the code that uses your class can't get them
	-- local field
	
	-- protected methods
	-- function protected.f()
	function protected.OnInitialize()
	 	-- Code that you want to run when the addon is first loaded goes here.
	end

	function protected.OnEnable()
  	  -- Called when the addon is enabled
	end

	function protected.OnDisable()
		-- Called when the addon is disabled
	end
	
	-- public methods
	-- function self.f()

	-- constructor
	do
		addon.LogMessage(LOG_INFO, L["L_WELCOME"])
	end
	
	-- return the instance table
	return self
end

-- ----------------------------------------------------------------------
-- Addon Instantiation
-- ----------------------------------------------------------------------

GnomTEC_AddonFramework = GnomTECAddonFramework()
