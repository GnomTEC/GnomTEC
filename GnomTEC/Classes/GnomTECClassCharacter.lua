-- **********************************************************************
-- GnomTECClassCharacter
-- Version: 8.2.5.15
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
local MAJOR, MINOR = "GnomTECClassCharacter-1.0", 13
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
local LOG_ERROR		= 1
local LOG_WARN		= 2
local LOG_INFO 		= 3
local LOG_DEBUG 	= 4

-- ----------------------------------------------------------------------
-- Class Static Variables
-- ----------------------------------------------------------------------
class.characters = {}

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

-- function to detect that unit is a player from whom we could get a flag
-- Fix issue for NPC units for which the API function Fixed_UnitIsPlayer() don't return nil
-- (such as Wrathion quest line and Proving Grounds)
local function Fixed_UnitIsPlayer(unitId) 
	if (UnitIsPlayer(unitId)) then
		-- NPCs have no race (at least at the moment)
	   if (UnitRace(unitId)) then
	   	return true
	   else
	   	return false
	   end
	else
 	  return false
	end
end

-- generic sorted iterator
local function pairsByKeys (t, f)
	local a = {}
		for n in pairs(t) do table.insert(a, n) end
		table.sort(a, f)
		local i = 0      -- iterator variable
		local iter = function ()   -- iterator function
			i = i + 1
			if a[i] == nil then return nil
			else return a[i], t[a[i]]
			end
		end
	return iter
end

-- returns iterator for addonsList
-- local	function _pairsCommAddonsList()
--	return pairsByKeys(class.addonsList)
-- end

-- ----------------------------------------------------------------------
-- Class Static Methods (local)
-- ----------------------------------------------------------------------
local function _LogMessage(logLevel, message, ...)
end

local function _UpdateUnitPosition(unitName, unitPosition)
	local posX = nil, posY, posZ, instanceID
	local distance = nil
	local prefix = "party"
	
	if (IsInRaid()) then
		prefix = "raid"
	end
	if (GetNumGroupMembers() > 1) then
		for i=1, GetNumGroupMembers(), 1 do
			if (unitName == fullunitname(UnitName(prefix..i))) then
				posX, posY, posZ, instanceID = UnitPosition(prefix..i)
				if (posX) then
					local distanceSquared, checkedDistance = UnitDistanceSquared(prefix..i)
					if (checkedDistance) then
						distance = distanceSquared^0.5
					else
						posX = nil
					end
				end
			end	
		end
	end
	
	if (not posX) then
		if (unitName == fullunitname(UnitName("player"))) then
			posX, posY, posZ, instanceID = UnitPosition("player")
			if (posX) then
				distance = 0
			end
		end	
	end
	
	if (posX) then
		unitPosition.posX = posX
		unitPosition.posY = posY
		unitPosition.posZ = posZ
		unitPosition.instanceID = instanceID
		unitPosition.distance = distance
		return true
	end
	
	return false
end

-- ----------------------------------------------------------------------
-- Class Static Event Handler (local)
-- ----------------------------------------------------------------------

local function _UPDATE_MOUSEOVER_UNIT(eventName)
	if (not UnitIsUnit("mouseover", "player")) then
		if (Fixed_UnitIsPlayer("mouseover")) then
			local unitName = fullunitname(UnitName("mouseover"))
			-- update character information of unit
			GnomTECClassCharacter(unitName)
	 	end
 	end
 end
 
 function _CHAT_MSG_CHANNEL(eventName, message, sender)	
	-- update character information of sender
	sender = fullunitname(sender)
	
	if (emptynil(sender)) then
		GnomTECClassCharacter(sender)
	end
end

function _CHAT_MSG_CHANNEL_JOIN(eventName, arg1, sender)	
	-- update character information of sender
	sender = fullunitname(sender)
	
	if (emptynil(sender)) then
		GnomTECClassCharacter(sender)
	end
end

function _CHAT_MSG_EMOTE(eventName, message, sender)	
	-- update character information of sender
	sender = fullunitname(sender)
	
	if (emptynil(sender)) then
		GnomTECClassCharacter(sender)
	end
end

function _CHAT_MSG_GUILD(eventName, message, sender)	
	-- update character information of sender
	sender = fullunitname(sender)
	
	if (emptynil(sender)) then
		GnomTECClassCharacter(sender)
	end
end

function _CHAT_MSG_OFFICER(eventName, message, sender)	
	-- update character information of sender
	sender = fullunitname(sender)
	
	if (emptynil(sender)) then
		GnomTECClassCharacter(sender)
	end
end

function _CHAT_MSG_PARTY(eventName, message, sender)	
	-- update character information of sender
	sender = fullunitname(sender)
	
	if (emptynil(sender)) then
		GnomTECClassCharacter(sender)
	end
end

function _CHAT_MSG_RAID(eventName, message, sender)	
	-- update character information of sender
	sender = fullunitname(sender)
	
	if (emptynil(sender)) then
		GnomTECClassCharacter(sender)
	end
end

function _CHAT_MSG_SAY(eventName, message, sender)	
	-- update character information of sender
	sender = fullunitname(sender)
	
	if (emptynil(sender)) then
		GnomTECClassCharacter(sender)
	end
end

function _CHAT_MSG_TEXT_EMOTE(eventName, message, sender)	
	-- update character information of sender
	sender = fullunitname(sender)
	
	if (emptynil(sender)) then
		GnomTECClassCharacter(sender)
	end
end

function _CHAT_MSG_WHISPER(eventName, message, sender)	
	-- update character information of sender
	sender = fullunitname(sender)
	
	if (emptynil(sender)) then
		GnomTECClassCharacter(sender)
	end
end

function _CHAT_MSG_YELL(eventName, message, sender)	
	-- update character information of sender
	sender = fullunitname(sender)
	
	if (emptynil(sender)) then
		GnomTECClassCharacter(sender)
	end
end

-- ----------------------------------------------------------------------
-- Register Class Static Event Handler (local)
-- ----------------------------------------------------------------------
class.aceEvent.RegisterEvent(class,"UPDATE_MOUSEOVER_UNIT", _UPDATE_MOUSEOVER_UNIT)
class.aceEvent.RegisterEvent(class,"CHAT_MSG_CHANNEL", _CHAT_MSG_CHANNEL);
class.aceEvent.RegisterEvent(class,"CHAT_MSG_CHANNEL_JOIN", _CHAT_MSG_CHANNEL_JOIN);
class.aceEvent.RegisterEvent(class,"CHAT_MSG_EMOTE", _CHAT_MSG_EMOTE);
class.aceEvent.RegisterEvent(class,"CHAT_MSG_GUILD", _CHAT_MSG_GUILD);
class.aceEvent.RegisterEvent(class,"CHAT_MSG_OFFICER", _CHAT_MSG_OFFICER);
class.aceEvent.RegisterEvent(class,"CHAT_MSG_PARTY", _CHAT_MSG_PARTY);
class.aceEvent.RegisterEvent(class,"CHAT_MSG_RAID", _CHAT_MSG_RAID);
class.aceEvent.RegisterEvent(class,"CHAT_MSG_SAY", _CHAT_MSG_SAY);
class.aceEvent.RegisterEvent(class,"CHAT_MSG_TEXT_EMOTE", _CHAT_MSG_TEXT_EMOTE);
class.aceEvent.RegisterEvent(class,"CHAT_MSG_WHISPER", _CHAT_MSG_WHISPER);
class.aceEvent.RegisterEvent(class,"CHAT_MSG_YELL", _CHAT_MSG_YELL);
		
-- ----------------------------------------------------------------------
-- Class
-- ----------------------------------------------------------------------
function GnomTECClassCharacter(unitName)

	unitName = fullunitname(unitName)

	-- if a object for this unit exists then do not create new one
	if ( class.characters[unitName] ) then
		return class.characters[unitName]
	end
	
	-- call base class
	local self, protected = GnomTEC()
	class.characters[unitName] = self
		
	-- public fields go in the instance table
	-- self.field = value

	-- protected fields go in the protected table
	-- protected.field = value
	
	-- private fields are implemented using locals
	-- they are faster than table access, and are truly private, so the code that uses your class can't get them
	-- local field
	local unitName = unitName
	local	unitPosition = {
		posX = nil,
		posY = nil,
		posZ = nil,
		instanceID = nil,
		distance = nil
	}
			
	-- private methods
	-- local function f()

	-- protected methods
	-- function protected.f()
	
	-- public methods
	-- function self.f()
	function self.LogMessage(logLevel, message, ...)
		protected.LogMessage(CLASS_CLASS, logLevel, "GnomTECClassCharacter", message, ...)
	end
	
	function self.GetPosition(notCached)
		local updated = _UpdateUnitPosition(unitName, unitPosition)
		
		if (updated or (not notCached)) then
			return unitPosition.posX, unitPosition.posY, unitPosition.posZ, unitPosition.instanceID
		else
			return nil
		end
	end

	function self.GetDistance(notCached)
		local updated = _UpdateUnitPosition(unitName, unitPosition)

		if (updated or (not notCached)) then
			return unitPosition.distance
		else
			return nil
		end
	end
	
	function self.SetPosition(posX, posY, posZ, instanceID)
		local playerPosX, playerPosY, playerPosZ, playerInstanceID
		local distance

		playerPosX, playerPosY, playerPosZ, playerInstanceID = UnitPosition("player")
		
		if (playerPosX and posX and (playerInstanceID == instanceID)) then
			distance = ((playerPosX - posX)^2 + (playerPosY - posY)^2)^0.5
		else
			distance = nil
		end

		unitPosition.posX = posX
		unitPosition.posY = posY
		unitPosition.posZ = posZ
		unitPosition.instanceID = instanceID
		unitPosition.distance = distance
	end

	
	-- constructor
	do
		_LogMessage = self.LogMessage
		
		protected.LogMessage(CLASS_CLASS, LOG_DEBUG, "GnomTECClassCharacter", "New instance created (%s) for unit (%s)", protected.UID, unitName)
	end
	
	-- return the instance table
	return self
end


