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
local scene = Lna.Scene:new()
local menuBtn = Lna.Menu.Button:new("Yo", {w=200,h=50}, {r=200,g=200,b=100,a=255}, 10)
local menuWnd = Lna.Menu.Window:new(10, 10, {r=150,g=150,b=160,a=255})
menuWnd:addMenuItem(menuBtn)
local menu = Lna.Menu.Menu:new()
local wndIdx = menu:addMenuWindow(menuWnd)
menu:setCurrentWindow(wndIdx)

local menuWndIdx = scene:addActor(menuWnd)
local menuBtnIdx = scene:addActor(menuBtn)
local menuIdx = scene:addActor(menu)

local stage = Lna.Stage:new()
stage:setCurrentScene(stage:addScene(scene))


-- Love2D calls
function love.load()
  stage:load()
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
