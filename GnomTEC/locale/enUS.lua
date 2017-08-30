-- **********************************************************************
-- GnomTEC Localization - enUS / enGB
-- Version: 7.3.0.10
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
local MAJOR, MINOR = "GnomTEC-enUS-1.0", 10
local localization, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not localization then return end -- No Upgrade needed.

-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("GnomTEC", "enUS", true)
if not L then return end

L["L_OPTIONS_TITLE"] = "GnomTEC Framework\n\n"
L["L_ERROR_FRAMEWORKREVISION"] = "The installed version of GnomTEC framework seems to be to old for some addons.\n\nThese addons won't be started until you update the framework.\n\nSee http://www.curse.com/addons/wow/gnomtec for a newer version."
