-- **********************************************************************
-- GnomTEC Localization - deDE
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
local MAJOR, MINOR = "GnomTEC-deDE-1.0", 3
local localization, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not localization then return end -- No Upgrade needed.

-- German localization file for deDE.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("GnomTEC", "deDE")
if not L then return end

L["L_OPTIONS_TITLE"] = "GnomTEC Framework\n\n"
L["L_ERROR_FRAMEWORKREVISION"] = "Das installierte GnomTEC Framework scheint zu alt für einige Addons zu sein.\n\nDiese Addons werden nicht gestartet solange das Framework nicht aktualisiert wird.\n\nSiehe http://www.curse.com/addons/wow/gnomtec für eine neuere Version."



