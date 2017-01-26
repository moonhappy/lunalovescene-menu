local Class = require "lib.lunalovescene.lib.middleclass.middleclass"
local Lna = require "lib.lunalovescene.llscn"

--[[--
  Menu button whereby click, enter, or tap results in signal of cues to the Menu
  window.
]]

local LnaMenuButton = Class("LnaMenuButton", Lna.Actor)
function LnaMenuButton:initialize(label, size, color, selectedColor, cornerRadius)
  Lna.Actor.initialize(self, 5001)
  self.menuIdentifier = menuIdentifier
  local rad = cornerRadius or 0
  self.dims = {x=-size.w, y=-size.h, w=size.w, h=size.h, r=rad}
  self.color = color
  self.selectedColor = selectedColor
  self.label = label
  self.isSelected = false
  self.label.x = -1
  self.label.y = -1
  self.label.w = -1
  self:onMouseOver(self.dims, "_mouseOver")
end

function LnaMenuButton:_mouseOver(dt, mx, my)
  if self.director ~= nil and self._active then
    self.director:_selectMenuItem(self)
    return true
  else
    return false
  end
end

function LnaMenuButton:_selectMenuItem()
  self.isSelected = true
end

function LnaMenuButton:_unselectMenuItem()
  self.isSelected = false
end

function LnaMenuButton:update(dt)
  if self.label.x == -1 then
    local lw, lh, lx
    local f = self.label.font
    local tw = f:getWidth(self.label.text)
    local th = f:getHeight(self.label.text)
    if self.dims.w < tw then
      lw = tw
    else
      lw = self.dims.w
    end
    if self.dims.h < th then
      lh = th
    else
      lh = self.dims.h
    end
    self.label.x = self.dims.x
    self.label.y = self.dims.y + (self.dims.h / 2) - (lh / 4)
    self.label.w = lw
  end
end

function LnaMenuButton:draw()
  local bc = self.color
  local sc = self.selectedColor
  local dims = self.dims
  love.graphics.setColor(bc.r, bc.g, bc.b, bc.a)
  love.graphics.rectangle("fill", dims.x, dims.y, dims.w, dims.h, dims.r, dims.r)
  if self.isSelected then
    love.graphics.setColor(sc.r, sc.g, sc.b, sc.a)
    love.graphics.rectangle("line", dims.x, dims.y, dims.w, dims.h, dims.r)
  end
  if self.label.x ~= -1 then
    local lc = self.label.ucolor
    love.graphics.setColor(lc.r, lc.g, lc.b, lc.b)
    love.graphics.printf(self.label.text, self.label.x, self.label.y, self.label.w, "center")
  end
end


--[[--
  Menu window, groups menu elements as a singular view.
]]

local LnaMenuWindow = Class("LnaMenuWindow", Lna.Director)
function LnaMenuWindow:initialize(verticalSpacer, horizontalSpacer, color, cornerRadius)
  Lna.Director.initialize(self, 5000)
  local rad = cornerRadius or 0
  self.dims = { x=-verticalSpacer, y=-horizontalSpacer, w=verticalSpacer, h=horizontalSpacer, r=rad }
  self.color = color
  self.selectedMenuItem = nil
  self._active = false
  self._visible = false
  self._ready = false
  self._spacers = {v=verticalSpacer, h=horizontalSpacer}
end

function LnaMenuWindow:addMenuItem(item)
  self:addMenuItems({item})
end

function LnaMenuWindow:addMenuItems(items)
  if next(items) then
    local icount = #items
    for i=1,icount do
      items[i]:setVisible(self._visible)
      items[i]:setActive(self._active)
      self:addActor(items[i])
    end
    self._ready = false
  end
end

function LnaMenuWindow:_selectMenuItem(item)
  if self.selectedMenuItem ~= nil then
    self.selectedMenuItem:_unselectMenuItem()
  end
  self.selectedMenuItem = item
  if item ~= nil then
    item:_selectMenuItem()
  end
end

function LnaMenuWindow:setActive(active)
  Lna.Director.setActive(self, active)
  if next(self.actors) then
    local count = #self.actors
    for i=1,count do
      self.actors[i]:setActive(active)
    end
  end
end

function LnaMenuWindow:setVisible(visible)
  Lna.Director.setVisible(self, visible)
  if next(self.actors) then
    local count = #self.actors
    for i=1,count do
      self.actors[i]:setVisible(visible)
    end
  end
end

function LnaMenuWindow:configDimensions()
  local width, height, flags = love.window.getMode()
  local wndWidth = 0
  local wndHeight = self._spacers.h
  -- Determine window coordinates, first pass
  if next(self.actors) then
    local count = #self.actors
    for i=1,count do
      wndHeight = wndHeight + self.actors[i].dims.h + self._spacers.h
      if wndWidth < self.actors[i].dims.w then
        wndWidth = self.actors[i].dims.w
      end
    end
  end
  self.dims.w = wndWidth + (self._spacers.v * 2)
  self.dims.h = wndHeight
  self.dims.x = (width / 2) - (self.dims.w / 2)
  self.dims.y = (height / 2) - (self.dims.h / 2)
  -- Set XY position for menu items following window coordinates, second pass
  if next(self.actors) then
    local count = #self.actors
    local itemXpos = self.dims.x + self._spacers.v
    local itemYpos = self.dims.y
    local lastItemHeight = 0
    for i=1,count do
      itemYpos = itemYpos + lastItemHeight + self._spacers.h
      lastItemHeight = self.actors[i].dims.h
      self.actors[i].dims.x = itemXpos
      self.actors[i].dims.y = itemYpos
    end
  end
  self._ready = true
end

function LnaMenuWindow:update(dt)
  if not self._ready then
    self:configDimensions()
  end
end

function LnaMenuWindow:draw()
  if self._ready then
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
    love.graphics.rectangle("fill", self.dims.x, self.dims.y, self.dims.w, self.dims.h, self.dims.r, self.dims.r)
  end
end


--[[--
  Menu manages a menu prompt.
]]

local LnaMenu = Class("LnaMenu", Lna.Director)
function LnaMenu:initialize()
  Lna.Director.initialize(self)
  self._currentWindowIndex = -1
  self:setActive(false)
end

function LnaMenu:addMenuWindow(window)
  window:setActive(false)
  window:setVisible(false)
  return self:addActor(window)
end

function LnaMenu:setActive(active)
  Lna.Director.setActive(self, active)
  self:_setWindowState(self._currentWindowIndex, active)
end

function LnaMenu:setCurrentWindow(windowIndex)
  self:_setWindowState(self._currentWindowIndex, false)
  self._currentWindowIndex = windowIndex
  self:_setWindowState(self._currentWindowIndex, self.active)
end

function LnaMenu:_setWindowState(idx, state)
  if next(self.actors) and idx ~= -1 then
    self.actors[idx]:setActive(state)
    self.actors[idx]:setVisible(state)
  end
end

return {Button=LnaMenuButton, Window=LnaMenuWindow, Director=LnaMenu, DRAWLAYER=5000}
