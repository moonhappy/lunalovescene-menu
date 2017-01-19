--[[--
  Simple demonstration of the Luna-Love-Scene paradigm.
]]

local class = require("lib.middleclass.middleclass")
require "llscn-menu"

--[[
  Example menu.
  Shows a welcome title and exit button.
]]

local ExampleMenuButton = class("ExampleMenuButton", LnaMenuButton)
function ExampleMenuButton:initialize()
  LnaMenuButton.initialize(self)
  self:onCue("llscn-menu-click", "onClick")
end
function ExampleMenuButton:onClick()
  love.event.quit(0)
end

-- Construct the scene
local scene = LnaScene:new()
local menuWnd = LnaMenuWindow:new()
menuWnd:addMenuItem(ExampleMenuButton:new())
local menu = LnaMenu:new()
local menuIdx = scene:addActor(menu)

local stage = LnaStage:new()
local sceneIdx = stage:addScene(scene)
stage:setCurrentScene(sceneIdx)


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
