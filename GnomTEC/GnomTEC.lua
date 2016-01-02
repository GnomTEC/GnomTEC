-- **********************************************************************
-- GnomTEC Base Class
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
local MAJOR, MINOR = "GnomTEC-1.0", 3
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
-- Class Static Variables
-- ----------------------------------------------------------------------
class.lastUID = class.lastUID or 0
class.maxLogBuffer = 1024
class.logBuffer = class.logBuffer or {}
class.logReceivers = class.logReceivers or {}
class.timerFrame = class.timerFrame
class.timer = class.timer or {}
class.timerId = class.timerId or 0

-- ----------------------------------------------------------------------
-- Class Startup Initialization
-- ----------------------------------------------------------------------


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

	local remove = {}

	for key, value in pairs(class.timer) do
		value.timeElapsed = value.timeElapsed + elapsed
		if (value.timeElapsed  > value.delay) then
			value.timeElapsed  =  value.timeElapsed - value.delay
			if (value.once) then
				remove[key] = true
			end
			if type(value.func) == "function" then
				value.func()
			end
		end
	end

	for key, value in pairs(remove) do
		class.timer[key] = nil
	end
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
	local eventHandlers = {}
		
	-- private methods
	-- local function f()

	-- protected methods
	-- function protected.f()
	function protected.LogMessage(classLevel, logLevel, title, message, ...)
		local timestamp = date("%H:%M:%S")
		table.insert(class.logBuffer, {timestamp, classLevel, logLevel, title, message, ...})
		while (class.maxLogBuffer < #class.logBuffer) do
			table.remove(class.logBuffer, 1)
			for idx, value in ipairs(class.logReceivers) do
				if (class.logReceivers[idx].logReceived > 0) then
					class.logReceivers[idx].logReceived = class.logReceivers[idx].logReceived - 1
				end
			end
		end
		
		-- send log entries to all receivers which have not received them
		for idx, value in ipairs(class.logReceivers) do
			if (class.logReceivers[idx].logReceived < #class.logBuffer) then
				for i=class.logReceivers[idx].logReceived + 1, #class.logBuffer do
					value.func(unpack(class.logBuffer[i]))
				end
			end
			class.logReceivers[idx].logReceived = #class.logBuffer
		end
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
			table.insert(class.logReceivers, {func=logReceiver, logReceived=0})
		end
	end

	function self.UnregisterLogReceiver(logReceiver)
		if type(logReceiver) == "function" then
			local pos = 0
			for idx, value in ipairs(class.logReceivers) do
				if (value.func == logReceiver) then
					pos = idx
					break
				end
			end
			if (pos > 0) then
				table.remove(class.logReceivers, pos)
				protected.LogMessage(CLASS_BASE, LOG_DEBUG, "GnomTEC", "log receiver unregistered")
			end
		end
	end

	function self.RegisterEvent(event, eventHandler)
		if (eventHandlers[event] == nil) then
			eventHandlers[event] = {}
		end
		eventHandlers[event][eventHandler] = true
	end

	function self.UnregisterEvent(event, eventHandler)
  		if (eventHandlers[event] ~= nil) then
	   	eventHandlers[event][eventHandler] = nil
		end
	end

	function self.UnregisterAllEvents(eventHandler)
	 	for event, _ in pairs(eventHandlers) do
	   	eventHandlers[event][eventHandler] = nil
		end
	end

	function self.TriggerEvent(event, ...)
		if (eventHandlers[event] ~= nil) then
   		for eventHandler, _ in pairs(eventHandlers[event]) do
   			self.SafeCall(eventHandler, self, event, ...)
   		end
   	end
	end
	
	function self.ScheduleTimer(func, delay)
		class.timerId = class.timerId + 1
		
		class.timer[class.timerId] = {}
		class.timer[class.timerId].timeElapsed = 0
		class.timer[class.timerId].once = true
		class.timer[class.timerId].func = func
		class.timer[class.timerId].delay = delay
	end

	function self.ScheduleRepeatingTimer(func, delay)
		class.timerId = class.timerId + 1
		
		class.timer[class.timerId] = {}
		class.timer[class.timerId].timeElapsed = 0
		class.timer[class.timerId].func = func
		class.timer[class.timerId].delay = delay
	end

	-- constructor
	do
		class.lastUID = class.lastUID + 1
		protected.UID = "GnomTECInstance"..class.lastUID
		
		if (not class.timerFrame) then
			class.timerFrame = CreateFrame("Frame", nil, UIParent)
		
			class.timerFrame:SetPoint("BOTTOMLEFT")		
			class.timerFrame:SetWidth(0)	
			class.timerFrame:SetHeight(0)
			class.timerFrame:SetScript("OnUpdate", _OnUpdate)	
		end
		
		protected.LogMessage(CLASS_BASE, LOG_DEBUG, "GnomTEC", "New instance created (%s)", protected.UID)
	end
	
	-- return the instance table
	return self, protected
end


