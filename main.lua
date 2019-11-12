function love.load()
  -- setup push
  push = require "push"
  windowWidth, windowHeight = 800, 480
  love.graphics.setDefaultFilter("nearest", "nearest")
  gameWidth, gameHeight = 200,120
  push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {
    fullscreen = false,
    resizable = true,
    pixelperfect = false
  })
  push:setBorderColor{255,255,255}
  
  drawimg = love.graphics.draw
  newimg = love.graphics.newImage
  a = require "ezanim"
  state = "title"
  titleframe = 0
  jiggle = false
  jiggletime = 0
  t = 0
  
  img={
    controller = loadjiggle("controller"),
    ta1 = newimg("ta1.png"),
    ta2 = newimg("ta2.png"),
    ts1 = newimg("ts1.png"),
    ts2 = newimg("ts2.png"),
    xbc = newimg("XBC.png"),
    kbc = newimg("KBC.png"),
  }
end
function loadjiggle(fn)
  return {newimg(fn.."1.png"),newimg(fn.."2.png")}
  
end
function love.resize(w, h)
  push:resize(w, h)
end
function love.update(dt)
  t = t + dt
  jiggletime = jiggletime + dt*60
  if jiggletime >=15 then
    jiggle = not jiggle
    jiggletime = jiggletime - 15
  end
  if state == "title" then
    if titleframe == 0 and t > 5 then
      titleframe = 1
    end
    if titleframe == 1 and t > 13 then
      titleframe = 2
    end
  end
end

function love.draw()
  push:apply("start")
  if state == "title" then
    if titleframe == 0 then
      if jiggle then
        drawimg(img.controller[1])
      else
        drawimg(img.controller[2])
      end
    end
    if titleframe == 1 then
      if love.joystick.getJoystickCount() > 0 then
        drawimg(img.xbc)
      else
        drawimg(img.kbc)
      end
    end
    if titleframe == 2 then
      if love.joystick.getJoystickCount() > 0 then
        if jiggle then
          drawimg(img.ta1)
        else
          drawimg(img.ta2)
        end
      else
        if jiggle then
          drawimg(img.ts1)
        else
          drawimg(img.ts2)
        end
      end
    end
  end
  push:apply("end")
end