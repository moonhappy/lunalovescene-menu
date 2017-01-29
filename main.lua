--[[--
  Simple demonstration of the Luna-Love-Scene paradigm.
]]

local Class = require "lib.lunalovescene.lib.middleclass.middleclass"
local Lna = require "lib.lunalovescene.llscn"
Lna.Menu = require "llscn-menu"

--[[
  Example menu.
  Shows a welcome title and exit button.
]]

-- Construct the scene
local f = love.graphics.setNewFont(18)
local bc = {r=100,g=100,b=100,a=255}
local sc = {r=200,g=200,b=100,a=255}
local lsC = {r=255,g=255,b=100,a=255}
local luC = {r=255,g=255,b=255,a=255}

local menu = Lna.Menu.Director:new()

local OuchButton = Class("OuchButton", Lna.Menu.Button)
function OuchButton:initialize()
  Lna.Menu.Button.initialize(self, {text="Button 1",ucolor=luC,scolor=lsC,font=f}, {w=300,h=50}, bc, sc, 10)
  self:onCue("hit", "ouch")
end
function OuchButton:ouch()
  if self.label.text ~= "Ouch" then
    self.label.text = "Ouch"
  else
    self:signalCue("menuChangeWindow", 2)
  end
end
local menuBtn1 = OuchButton:new()

local ExitButton = Class("ExitButton", Lna.Menu.Button)
function ExitButton:initialize()
  Lna.Menu.Button.initialize(self, {text="Exit",ucolor=luC,scolor=lsC,font=f}, {w=300,h=50}, bc, sc, 10)
  self:onCue("hit", "exitOut")
end
function ExitButton:exitOut()
  love.event.quit(0)
end
local menuBtn2 = ExitButton:new()

local menuBtn3 = Lna.Menu.Button:new({text="Boo",ucolor=luC,scolor=lsC,font=f}, {w=300,h=50}, bc, sc, 10)

local menuWnd1 = Lna.Menu.Window:new(10, 10, {r=20,g=20,b=20,a=255})
menuWnd1:addMenuItem(menuBtn1)
menuWnd1:addMenuItem(menuBtn3)
menuWnd1:addMenuItem(menuBtn2)


-- sub menu window

local BackButton = Class("BackButton", Lna.Menu.Button)
function BackButton:initialize()
  Lna.Menu.Button.initialize(self, {text="Go Back",ucolor=luC,scolor=lsC,font=f}, {w=300,h=50}, bc, sc, 10)
  self:onCue("hit", "back")
end
function BackButton:back()
  self:signalCue("menuChangeWindow", 1)
end
local menuBtnBack = BackButton:new()

local menuWnd2 = Lna.Menu.Window:new(10, 10, {r=20,g=20,b=20,a=255})
menuWnd2:addMenuItem(menuBtnBack)



local stage = Lna.Stage:new()


-- Love2D calls
function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  -- Put it all together
  local scene = Lna.Scene:new()
  scene:addActor(menu)
  local wnd1idx = menu:addMenuWindow(menuWnd1)
  local wnd2idx = menu:addMenuWindow(menuWnd2)
  menu:setCurrentWindow(wnd1idx)
  menu:setActive(true)
  stage:setCurrentScene(stage:addScene(scene))
  stage:load()
  love.graphics.setBackgroundColor(200, 100, 100, 255)
end

function love.update(dt)
  stage:update(dt)
end

function love.keyreleased(key)
  stage:signalCue(key)
end

function love.mousepressed(x, y, button, isTouch)
  stage:signalMouseCue(button, x, y, isTouch)
end

function love.draw()
  stage:draw()
end
