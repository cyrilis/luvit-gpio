# GPIO for Luvit

A GPIO Library for Luvit 

## Usage:

```lua

-- Write 
DigitalPin = require("GPIO")

pin = DigitalPin:new({
	pin = 13
	mode = "w"
})

pin:connect()
pin:setHigh()  -- or pin:digitalWrite(1)
pin:on("digitalWrite", function()
	p("Write Success")
end)

-- Read

pin2 = DigitalPin:new({
	pin = 14
	mode = "r"
})

pin2:connect()
pin2:digitalRead(1000) -- read data every 1000 ms
pin2:on("digitalRead", function(data)
	p(data)
end)

```

## License

(The MIT License)

Copyright (c) 2015 Cyril Hou <houshoushuai@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.