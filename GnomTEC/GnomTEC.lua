﻿-- **********************************************************************
-- GnomTEC Base Class
-- Version: 5.4.8.1
-- Author: GnomTEC
-- Copyright 2014 by GnomTEC
-- http://www.gnomtec.de/
-- **********************************************************************
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-- **********************************************************************
local MAJOR, MINOR = "GnomTEC-1.0", 1
local class, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not class then return end -- No Upgrade needed.

-- ----------------------------------------------------------------------
-- Class Global Constants (local)
-- ----------------------------------------------------------------------
-- localization (will be loaded from base class later)
local L = {}

-- texure path
local T = [[Interface\Addons\GnomTEC_Assistant\GnomTEC\Textures\]]

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
local lastUID = 0
local maxLogBuffer = 1024
local logBuffer = {}
local logReceivers = {}

local _timerFrame = nil

-- ----------------------------------------------------------------------
-- Class Startup Initialization
-- ----------------------------------------------------------------------
L = LibStub("AceLocale-3.0"):GetLocale("GnomTEC")

-- ----------------------------------------------------------------------
-- Helper Functions (local)
-- ----------------------------------------------------------------------


-- ----------------------------------------------------------------------
-- Class Static Methods (local)
-- ----------------------------------------------------------------------


-- ----------------------------------------------------------------------
-- Class Static Event Handler (local)
-- ----------------------------------------------------------------------
-- the global timer function
local function _OnUpdate(frame, elapsed)


end
 
 


-- ----------------------------------------------------------------------
-- Class
-- ----------------------------------------------------------------------

function GnomTEC()
	-- the new instance
	local self = {}
	
	-- public fields go in the instance table
	-- self.field = value

	-- create protected table
	local protected = {}

	-- protected fields go in the protected table
	-- protected.field = value
	protected.UID = nil
	
	-- private fields are implemented using locals
	-- they are faster than table access, and are truly private, so the code that uses your class can't get them
	-- local field
		
	-- private methods
	-- local function f()

	-- protected methods
	-- function protected.f()
	function protected.LogMessage(classLevel, logLevel, title, message, ...)
		local timestamp = date("%H:%M:%S")
		table.insert(logBuffer, {timestamp, classLevel, logLevel, title, message, ...})
		while (maxLogBuffer < #logBuffer) do
			table.remove(logBuffer, 1)
			for idx, value in ipairs(logReceivers) do
				if (logReceivers[idx].logReceived > 0) then
					logReceivers[idx].logReceived = logReceivers[idx].logReceived - 1
				end
			end
		end
		
		-- send log entries to all receivers which have not received them
		for idx, value in ipairs(logReceivers) do
			if (logReceivers[idx].logReceived < #logBuffer) then
				for i=logReceivers[idx].logReceived + 1, #logBuffer do
					value.func(unpack(logBuffer[i]))
				end
			end
			logReceivers[idx].logReceived = #logBuffer
		end
	end
	
	function protected.GetLocale()
		return L
	end

	function protected.GetTexturePath()
		return T
	end
	
	-- public methods
	-- function self.f()
	function self.LogMessage(logLevel, message, ...)
		protected.LogMessage(CLASS_BASE, logLevel, "GnomTEC", message, ...)
	end

	function self.SafeCall(func, ...)
		if type(func) == "function" then
			return func(...)
		end
	end

	function self.RegisterLogReceiver(logReceiver)
		if type(logReceiver) == "function" then
			self.UnregisterLogReceiver(logReceiver)
			table.insert(logReceivers, {func=logReceiver, logReceived=0})
			protected.LogMessage(CLASS_BASE, LOG_DEBUG, "GnomTEC", "log receiver registered")
		end
	end

	function self.UnregisterLogReceiver(logReceiver)
		if type(logReceiver) == "function" then
			local pos = 0
			for idx, value in ipairs(logReceivers) do
				if (value.func == logReceiver) then
					pos = idx
					break
				end
			end
			if (pos > 0) then
				table.remove(logReceivers, pos)
				protected.LogMessage(CLASS_BASE, LOG_DEBUG, "GnomTEC", "log receiver unregistered")
			end
		end
	end


	-- constructor
	do
		lastUID = lastUID + 1
		protected.UID = "GnomTECInstance"..lastUID
		
		if (not _timerFrame) then
			_timerFrame = CreateFrame("Frame", nil, UIParent)
		
			_timerFrame:SetPoint("BOTTOMLEFT")		
			_timerFrame:SetWidth(0)	
			_timerFrame:SetHeight(0)
			_timerFrame:SetScript("OnUpdate", _OnUpdate)	
		end
		
		protected.LogMessage(CLASS_BASE, LOG_DEBUG, "GnomTEC", "New instance created (%s)", protected.UID)
	end
	
	-- return the instance table
	return self, protected
end


