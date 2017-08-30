-- **********************************************************************
-- GnomTECWidgetBook
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
local MAJOR, MINOR = "GnomTECWidgetBook-1.0", 10
local _widget, _oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not _widget then return end -- No Upgrade needed.

-- ----------------------------------------------------------------------
-- Widget Global Constants (local)
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
-- Widget Static Variables (local)
-- ----------------------------------------------------------------------


-- ----------------------------------------------------------------------
-- Widget Startup Initialization
-- ----------------------------------------------------------------------


-- ----------------------------------------------------------------------
-- Helper Functions (local)
-- ----------------------------------------------------------------------


-- ----------------------------------------------------------------------
-- Widget Class
-- ----------------------------------------------------------------------

function GnomTECWidgetBook(init)

	-- call base class
	local self, protected = GnomTECWidget(init)
	
	-- public fields go in the instance table
	-- self.field = value

	-- protected fields go in the protected table
	-- protected.field = value
	protected.widgetFrame = nil
	protected.simpleHTML = nil
	protected.prevPage = nil
	protected.nextPage = nil
	protected.recite = nil

	
	protected.book = {pages = {""}}

	-- private fields are implemented using locals
	-- they are faster than table access, and are truly private, so the code that uses your class can't get them
	-- local field
	local sizeWidth = 512
	local sizeHeight = 512
	local pageParagraphs = {{""}}
	local actualPage = 1
	local actualParagraph = 0
	local chat = GnomTECClassChat();
	
	-- private methods
	-- local function f()
	local function OnMouseUp(frame, button)
		local x, y = GetCursorPosition()
		local s = protected.simpleHTML:GetEffectiveScale()

		x, y = x/s, y/s;

		if ((x >= protected.simpleHTML:GetLeft()) and (x <= protected.simpleHTML:GetRight()) and (y >= protected.simpleHTML:GetBottom()) and (y <= protected.simpleHTML:GetTop())) then
			y = protected.simpleHTML:GetTop() - y
			local py = 0
			for p, paragraph in ipairs(pageParagraphs) do
				if (py < y) then
					actualParagraph = p
				else
					break
				end
				py = py + ((#paragraph) * (24 + protected.simpleHTML:GetSpacing()))
			end
		else
			actualParagraph = 0
		end
		self.ShowPage(actualPage, actualParagraph)

	end

	local function OnClick_PrevPage(frame, button, down)
		actualPage = actualPage - 1
		self.ShowPage(actualPage)
		PlaySound("igAbiliityPageTurn");
	end

	local function OnClick_NextPage(frame, button, down)
		actualPage = actualPage + 1
		self.ShowPage(actualPage)
		PlaySound("igAbiliityPageTurn");
	end

	local function OnClick_Recite(frame, button, down)
		if (actualParagraph <= #pageParagraphs)  then
			-- recite paragraph
			local text = "{rt3} "
			for p, paragraph in ipairs(pageParagraphs) do
				for l, line in ipairs(paragraph) do
					if ((p == actualParagraph) and (line ~= "")) then
						text = text..line.." {rt3} "
					end
				end
			end

			chat.Say(text)
			
			-- forward marker to next paragraph
			actualParagraph = actualParagraph  + 1
			if (actualParagraph > #pageParagraphs) then
				if (actualPage < #(protected.book.pages)) then
					actualPage = actualPage + 1
					actualParagraph = 1
					PlaySound("igAbiliityPageTurn");
				end
			end
			self.ShowPage(actualPage, actualParagraph)
		end
	end

	-- protected methods
	-- function protected.f()
	
	-- public methods
	-- function self.f()
	function self.LogMessage(logLevel, message, ...)
		protected.LogMessage(CLASS_WIDGET, logLevel, "GnomTECWidgetDeviceLED", message, ...)
	end

	function self.GetMinReseize()
		local minWidth = sizeWidth
		local minHeight = sizeHeight
		
		return minWidth, minHeight
	end

	function self.GetMaxReseize()		
		local maxWidth = sizeWidth
		local maxHeight = sizeHeight

		return maxWidth, maxHeight
	end

	function self.IsHeightDependingOnWidth()
		return false -- should be true when layouter is complete implemented
	end

	function self.IsWidthDependingOnHeight()
		return false -- should be true when layouter is complete implemented
	end

	function self.ResizeByWidth(pixelWidth, pixelHeight)
		protected.widgetFrame:SetWidth(sizeWidth)
		protected.widgetFrame:SetHeight(sizeHeight)

		return sizeWidth, sizeHeight
	end

	function self.ResizeByHeight(pixelWidth, pixelHeight)
		protected.widgetFrame:SetWidth(sizeWidth)
		protected.widgetFrame:SetHeight(sizeHeight)

		return sizeWidth, sizeHeight
	end
	
	function self.ShowPage(pageNumber,markParagraph)
		local book = protected.book
		local page = "<html><body>"
		
		if (pageNumber > #(book.pages)) then
			pageNumber = #(book.pages)
		end
		
		markParagraph = markParagraph or 0

		-- generate pageParagraphs from book page
		if (pageNumber > 0) then
			pageParagraphs = {}
			for p in string.gmatch(book.pages[pageNumber],[[<p>(.-)</p>]]) do
				local paragraph = {}
				for line in string.gmatch(p,[[(.-)<br/>]]) do
					table.insert(paragraph,line)
				end
				table.insert(pageParagraphs,paragraph)
			end
		else
			pageParagraphs = {{""}}
		end

		-- create simpleHTML text to display out of pageParagraphs
		for p, paragraph in ipairs(pageParagraphs) do
			page = page.."<p>"
			for l, line in ipairs(paragraph) do
				if (p == markParagraph) then
					page = page.."|cFF0000FF"..line.."|r<br/>"
				else
					page = page..line.."<br/>"
				end
			end
			page = page.."</p>"
		end
		page = page .. "</body></html>"
		
		-- set page content
		protected.simpleHTML:SetText(page)

		actualPage = pageNumber
		actualParagraph = markParagraph
		
		-- enable/disable prev/next buttons
		if (pageNumber > 1) then
			protected.prevPage:Enable()
		else
			protected.prevPage:Disable()
		end
		if (pageNumber < #(book.pages)) then
			protected.nextPage:Enable()
		else
			protected.nextPage:Disable()
		end

		-- enable/disable recite button
		if ((actualParagraph <= #pageParagraphs) and (actualParagraph > 0)) then
			protected.recite:Enable()
		else
			protected.recite:Disable()
		end
	end
	
	function self.SetBook(book)
		protected.book = book
		actualPage = 1
		actualParagraph = 0
		self.ShowPage(actualPage, actualParagraph)
	end
	-- constructor
	do
		if (not init) then
			init = {}
		end
				
		local widgetFrame = CreateFrame("Frame", protected.widgetUID, UIParent, "T_GNOMTECWIDGETBOOK")
		local simpleHTML = widgetFrame.simpleHTML
		local prevPage = widgetFrame.prevPage
		local nextPage = widgetFrame.nextPage
		local recite = widgetFrame.recite
		widgetFrame:Hide()

		widgetFrame:SetScript("OnMouseUp", OnMouseUp)
		prevPage:SetScript("OnClick", OnClick_PrevPage)
		nextPage:SetScript("OnClick", OnClick_NextPage)
		recite:SetScript("OnClick", OnClick_Recite)

		protected.widgetFrame = widgetFrame 
		protected.simpleHTML = simpleHTML 
		protected.prevPage = prevPage 
		protected.nextPage = nextPage
		protected.recite = recite
		
		-- should be configurable later eg. saveable
		widgetFrame:SetPoint("CENTER")		
		widgetFrame:SetWidth(sizeWidth)		
		widgetFrame:SetHeight(sizeHeight)

		if (init.parent) then
			init.parent.AddChild(self, protected)
		end
		
		if (init.book) then
			self.SetBook(init.book)
		end
		
		protected.LogMessage(CLASS_WIDGET, LOG_DEBUG, "GnomTECWidgetBook", "New instance created (%s)", protected.UID)
	end
	
	-- return the instance
	return self
end


