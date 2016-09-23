-- **********************************************************************
-- GnomTECClassChat
-- Version: 7.0.3.7
-- Author: Peter Jack
-- URL: http://www.gnomtec.de/
-- **********************************************************************
-- Copyright © 2014-2016 by Peter Jack
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
local MAJOR, MINOR = "GnomTECClassChat-1.0", 7
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
local CLASS_WIDGET		= 2
local CLASS_ADDON		= 3

-- Log levels
local LOG_FATAL 	= 0
local LOG_ERROR	= 1
local LOG_WARN		= 2
local LOG_INFO 	= 3
local LOG_DEBUG 	= 4

-- ----------------------------------------------------------------------
-- Class Static Variables
-- ----------------------------------------------------------------------
class.objects = {}

-- ----------------------------------------------------------------------
-- Class Startup Initialization
-- ----------------------------------------------------------------------
class.aceEvent = class.aceEvent or LibStub("AceEvent-3.0")

-- ----------------------------------------------------------------------
-- Helper Functions (local)
-- ----------------------------------------------------------------------
-- function which returns also nil for empty strings
local function emptynil( x ) return x ~= "" and x or nil end

local function fullunitname(unitName)
	if (nil ~= emptynil(unitName)) then
		local player, realm = strsplit( "-", unitName, 2 )
		if (not realm) then
			_,realm = UnitFullName("player")
		end
		unitName = player.."-"..realm
	end
	return unitName
end

-- ----------------------------------------------------------------------
-- Class Static Methods (local)
-- ----------------------------------------------------------------------
local function _LogMessage(logLevel, message, ...)
end

-- ----------------------------------------------------------------------
-- Class Static Event Handler (local)
-- ----------------------------------------------------------------------
function _CHAT_MSG_INSTANCE_CHAT(eventName, message, sender)	
	sender = fullunitname(sender)
	for key, value in pairs(class.objects) do
		value.SafeCall(value.OnInstance, message, sender)
	end
end

function _CHAT_MSG_CHANNEL(eventName, message, sender, language, channelString, target, flags, unknown, channelNumber, channelName)	
	sender = fullunitname(sender)
	for key, value in pairs(class.objects) do
		value.SafeCall(value.OnChannel, message, sender, channelNumber)
	end
end

function _CHAT_MSG_EMOTE(eventName, message, sender)	
	sender = fullunitname(sender)
	for key, value in pairs(class.objects) do
		value.SafeCall(value.OnEmote, message, sender)
	end
end

function _CHAT_MSG_GUILD(eventName, message, sender)	
	sender = fullunitname(sender)
	for key, value in pairs(class.objects) do
		value.SafeCall(value.OnGuild, message, sender)
	end
end

function _CHAT_MSG_OFFICER(eventName, message, sender)	
	sender = fullunitname(sender)
	for key, value in pairs(class.objects) do
		value.SafeCall(value.OnOfficer, message, sender)
	end
end

function _CHAT_MSG_PARTY(eventName, message, sender)	
	sender = fullunitname(sender)
	for key, value in pairs(class.objects) do
		value.SafeCall(value.OnParty, message, sender)
	end
end

function _CHAT_MSG_RAID(eventName, message, sender)	
	sender = fullunitname(sender)
	for key, value in pairs(class.objects) do
		value.SafeCall(value.OnRaid, message, sender)
	end
end

function _CHAT_MSG_SAY(eventName, message, sender)	
	sender = fullunitname(sender)
	for key, value in pairs(class.objects) do
		value.SafeCall(value.OnSay, message, sender)
	end
end

function _CHAT_MSG_WHISPER(eventName, message, sender)	
	sender = fullunitname(sender)
	for key, value in pairs(class.objects) do
		value.SafeCall(value.OnWhisper, message, sender)
	end
end

function _CHAT_MSG_YELL(eventName, message, sender)	
	sender = fullunitname(sender)
	for key, value in pairs(class.objects) do
		value.SafeCall(value.OnYell, message, sender)
	end
end

-- ----------------------------------------------------------------------
-- Register Class Static Event Handler (local)
-- ----------------------------------------------------------------------
class.aceEvent.RegisterEvent(class,"CHAT_MSG_INSTANCE_CHAT", _CHAT_MSG_INSTANCE_CHAT);
class.aceEvent.RegisterEvent(class,"CHAT_MSG_CHANNEL", _CHAT_MSG_CHANNEL);
class.aceEvent.RegisterEvent(class,"CHAT_MSG_EMOTE", _CHAT_MSG_EMOTE);
class.aceEvent.RegisterEvent(class,"CHAT_MSG_GUILD", _CHAT_MSG_GUILD);
class.aceEvent.RegisterEvent(class,"CHAT_MSG_OFFICER", _CHAT_MSG_OFFICER);
class.aceEvent.RegisterEvent(class,"CHAT_MSG_PARTY", _CHAT_MSG_PARTY);
class.aceEvent.RegisterEvent(class,"CHAT_MSG_RAID", _CHAT_MSG_RAID);
class.aceEvent.RegisterEvent(class,"CHAT_MSG_SAY", _CHAT_MSG_SAY);
class.aceEvent.RegisterEvent(class,"CHAT_MSG_WHISPER", _CHAT_MSG_WHISPER);
class.aceEvent.RegisterEvent(class,"CHAT_MSG_YELL", _CHAT_MSG_YELL);
		
-- ----------------------------------------------------------------------
-- Class
-- ----------------------------------------------------------------------
function GnomTECClassChat()
	-- call base class
	local self, protected = GnomTEC()
	table.insert(class.objects, self)
		
	-- public fields go in the instance table
	-- self.field = value

	-- protected fields go in the protected table
	-- protected.field = value
	
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
		protected.LogMessage(CLASS_CLASS, logLevel, "GnomTECClassChat", message, ...)
	end
	
	function self.Say(text)
		SendChatMessage(text, "SAY")
	end

	function self.Yell(text)
		SendChatMessage(text, "YELL")
	end
	
	function self.Emote(text)
		SendChatMessage(text, "EMOTE")
	end

	function self.Whisper(text, target)
		SendChatMessage(text, "WHISPER", nil, target)
	end

	function self.SendMessage(text, distribution, channel)
		if (distribution == "CHANNEL") then
			SendChatMessage(text, "CHANNEL", nil, channel)
		else
			SendChatMessage(text, distribution)
		end
	end

	function self.LocalMonsterWhisper(text, sender)
		if (sender) then
			sender = fullunitname(sender)
		else
			sender = fullunitname(UnitName("player"))
		end
		DEFAULT_CHAT_FRAME:AddMessage("|Hplayer:"..sender.."|h"..(text or "").."|h",ChatTypeInfo["MONSTER_WHISPER"].r,ChatTypeInfo["MONSTER_WHISPER"].g,ChatTypeInfo["MONSTER_WHISPER"].b,ChatTypeInfo["MONSTER_WHISPER"].id);
	end


	
	-- constructor
	do
		_LogMessage = self.LogMessage
		
		protected.LogMessage(CLASS_CLASS, LOG_DEBUG, "GnomTECClassChat", "New instance created (%s)", protected.UID)
	end
	
	-- return the instance table
	return self
end


