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
local menuBtn1 = Lna.Menu.Button:new({text="Yo",ucolor=luC,scolor=lsC,font=f}, {w=300,h=50}, bc, sc, 10)
local menuBtn2 = Lna.Menu.Button:new({text="Exit",ucolor=luC,scolor=lsC,font=f}, {w=300,h=50}, bc, sc, 10)

local menuWnd = Lna.Menu.Window:new(10, 10, {r=20,g=20,b=20,a=255})
menuWnd:addMenuItem(menuBtn1)
menuWnd:addMenuItem(menuBtn2)
menu:setCurrentWindow(menu:addMenuWindow(menuWnd))
menu:setActive(true)

local scene = Lna.Scene:new()
scene:addActor(menuBtn1)
scene:addActor(menuBtn2)
scene:addActor(menuWnd)
scene:addActor(menu)

local stage = Lna.Stage:new()
stage:setCurrentScene(stage:addScene(scene))


-- Love2D calls
function love.load()
  stage:load()
  love.graphics.setBackgroundColor(200, 100, 100, 255)
end

function love.update(dt)
  stage:update(dt)
end

function love.keypressed(key)
  stage:signalCue(key)
end

function love.draw()
  stage:draw()
end
