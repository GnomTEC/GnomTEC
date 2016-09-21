-- **********************************************************************
-- GnomTEC (GnomTEC Addon Framework)
-- Version: 6.2.2.3
-- Author: Peter Jack
-- URL: http://www.gnomtec.de/
-- **********************************************************************
-- Copyright 2014-2015 Peter Jack
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

-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("GnomTEC_", "enUS", true)
if not L then return end

L["L_WELCOME"] = "Welcome to GnomTEC (GnomTEC Addon Framework)"

L["L_DESCRIPTION"] = "GnomTEC Addon Framework providing base functionalities to all GnomTEC Addons.\n\n"
