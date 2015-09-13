--[[
	-- GPIO for luvit
	-- a GPIO Lib for Luvit, reimplemented for Cylonjs

	Title: GPIO.lua
	author: Name: Cyril Hou
	author: Github: cyrilis
	author: Twitter: cyr1l
	author: Email: houshoushuai@gmail.com
	created_at: 2015-09-13 04:23:22
--]]

local FS = require("fs");

local Emitter = require("core").Emitter

local GPIO_PATH = "/sys/class/gpio"

local GPIO_READ = "in"
local GPIO_WRITE = "out"

local DigitalPin = Emitter:extend()

module.exports = DigitalPin

function DigitalPin:initialize( opts )
	self.pinNum = tostring(opts.pin)
	self.status = "low"
	self.ready = false
	self.mode = opts.mode
end

function DigitalPin:connect( mode )
	if self.mode == null then
		self.mode = mode
	end

	FS.exists(self:_pinPath(), function ( exists )
		if exists then
			self:_openPin()
		else
			self:_createGPIOPin()
		end
	end)
end

function DigitalPin:close( )
	FS.writeFile(self:_unexportPath(), self.pinNum, function( err )
		self:_closeCallback(err)
	end)
end

function DigitalPin:closeSync( )
	fs.writeFileSync(self:_unexportPath(), self.pinNum)
	self:_closeCallback(false)
end

function DigitalPin:digitalWrite( value )
	if self.mode ~= "w" then
		self:_setMode("w")
	end

	self.status = (value == 1 and "high" or "low")

	FS.writeFile(self._valuePath(), value, function ( err )
		if err then
			local str = "Error occored while writing value"
			str = str .. value .. " to pin " .. self.pinNum

			self.emit("Error", str)
		else
			self:emit("digitalWrite")
		end
	end)
end

function DigitalPin:digitalRead( interVal )
	if self.mode ~= 'r' then
		self:_setMode("r")
	end

	that = self
	setInterval(function ( )
		FS.readFile(that:_valuePath(), function ( err, data )
			if err then
				local error = "Error occurred while reading from pin " .. that.pinNum
				that:emit("error", error)
			else
				local readData = tonumber(tostring(data))
				that:emit("digitalRead", readData)
			end
		end)
	end)
end

function DigitalPin:setHigh( )
	self:digitalWrite(1)
end

function DigitalPin:setLow( )
	self:digitalWrite(0)
end

function DigitalPin:toggle( )
	if selt.status == 'low' then
		self:setHigh()
	else
		self:setLow()
	end
end

function DigitalPin:_createGPIOPin( )
	FS.writeFile(self:_exportPath(), self.pinNum, function ( err )
		if err then 
			self:emit("error", "Error whil createing pin files")
		else
			self:_openPin()
		end
	end)
end

function DigitalPin:_openPin( )
	self:_setMode(self.mode, true)
	self:emit("open")
end

function DigitalPin:_closeCallback( err )
	if err then
		self:emit("error", "Error while close pin files")
	else
		self:emit("close", self.pinNum)
	end
end

function DigitalPin:_setMode( mode, emitConnect )
	if emitConnect == nil then
		emitConnect = false
	end

	self.mode = mode

	local data = GPIO_READ
	if mode == 'w'
		then data = GPIO_WRITE
	end

	FS.writeFile(self:_directionPath(), data, function( )
		self:_setModeCallback(err, emitConnect);
	end)
end

function DigitalPin:_setModeCallback( err, emitConnect )
	if err then 
		return self:emit("error", "Setting up pin direction failed")
	end

	self.ready = true

	if emitConnect then
		self:emit("connect", self.mode)
	end
end

function DigitalPin:_directionPath( )
	return self:_pinPath() .. "/direction"
end

function DigitalPin:_valuePath()
	return self:_pinPath() .. "/value"
end

function DigitalPin:_pinPath( )
	return GPIO_PATH .. "/gpio" .. self.pinNum
end

function DigitalPin:_exportPath( )
	return GPIO_PATH .. "/export"
end

function DigitalPin:_unexportPath( )
	return GPIO_PATH .. "/unexport"
end
