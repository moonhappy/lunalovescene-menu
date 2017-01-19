local Class = require "lib.lunalovescene.lib.middleclass.middleclass"
local Lna = require "lib.lunalovescene.llscn"

--[[--
  Menu button whereby click, enter, or tap results in signal of cues to the Menu
  window.
]]

local LnaMenuButton = class("LnaMenuButton", Lna.Actor)
function LnaMenuButton:initialize(menuIdentifier)
  Lna.Actor.initialize(self)
  self.menuIdentifier = menuIdentifier
  self.dims = { x=-401, y=-101, w=400, h=100 }
  self.color = { r=255, g=100, b=100, a=255 }
end

function LnaMenuButton:update(dt)
end

function LnaMenuButton:draw()
  love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
  love.graphics.rectangle("fill", self.dims.x, self.dims.y, self.dims.w, self.dims.h)
end


--[[--
  Menu window, groups menu elements as a singular view.
]]

local LnaMenuWindow = class("LnaMenuWindow", Lna.Actor)
function LnaMenuWindow:initialize()
  Lna.Actor.initialize(self)
  self.dims = { x=-401, y=-101, w=400, h=100 }
  self.color = { r=100, g=20, b=20, a=255 }
  self.menuItems = {}
end

function LnaMenuWindow:addMenuItem(item)
  self.menuItems[#self.menuItems + 1] = item
  item.id = #self.menuItems
  item.scene = self.scene
  return #self.menuItems
end

function LnaMenuWindow:_doHandleCue(cueName)
  LnaActor:_doHandleCue(self, cueName)
  for i,v in pairs(self.menuItems) do
    v:_doHandleCue(cueName)
  end
end

function LnaMenuWindow:signalCue(cueName, signalTo)
  reciever = signalTo or self.scene
  reciever:_doHandleCue(cueName)
end

function LnaMenuWindow:_setAsCurrent()
  for i,v in pairs(self.actors) do
    v.id = i
    v.scene = self.scene
  end
end

function LnaMenuWindow:update(dt)
end

function LnaMenuWindow:draw()
  love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
  love.graphics.rectangle("fill", self.dims.x, self.dims.y, self.dims.w, self.dims.h)
end


--[[--
  Menu manages a menu prompt.
]]

local LnaMenu = class("LnaMenu", Lna.Actor)
function LnaMenu:initialize()
  Lna.Actor.initialize(self)
  self.menuWindows = {}
  self.currentWindowIdx = -1
  self.isLoaded = false
  self:onCue("llscn-scene-changed", "sceneChanged")
end

function LnaMenu:sceneChanged()
  if self.menuWindows[self.currentWindowIdx] then
    self.menuWindows[self.currentWindowIdx].scene = self.scene
    self.menuWindows[self.currentWindowIdx]:_setAsCurrent()
  end
end

function LnaMenu:addMenuWindow(wnd)
  self.menuWindows[#self.menuWindows + 1] = wnd
  wnd.id = #self.menuWindows
  wnd.scene = self.scene
  return #self.menuWindows
end

function LnaMenu:setCurrentMenuWindow(wndIdx)
  self.currentWindowIdx = wndIdx
  if self.isLoaded then
    self.menuWindows[wndIdx]:load()
  end
  self.menuWindows[wndIdx]:_setAsCurrent()
end

function LnaMenu:load()
  if self.menuWindows[self.currentWindowIdx] then
    self.menuWindows[self.currentWindowIdx]:load()
  end
  self.isLoaded = true
end

function LnaMenu:signalCue(eventName)
  if self.menuWindows[self.currentWindowIdx] then
    self.menuWindows[self.currentWindowIdx]:_doHandleCue(eventName)
  end
end

function LnaMenu:update(dt)
  if self.menuWindows[self.currentWindowIdx] then
    self.menuWindows[self.currentWindowIdx]:update(dt)
  end
end

function LnaMenu:draw()
  if self.menuWindows[self.currentWindowIdx] then
    self.menuWindows[self.currentWindowIdx]:draw()
  end
end
