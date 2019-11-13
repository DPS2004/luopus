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
  j = 1
  jiggletime = 0
  t = 0
  
  img={
    -- title screen
    controller = loadjiggle("title/controller"),
    ta = loadjiggle("title/ta"),
    ts = loadjiggle("title/ts"),
    xbc = newimg("title/XBC.png"),
    kbc = newimg("title/KBC.png"),
    -- intro cutscene
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
    if j == 1 then
      j = 2
    else
      j = 1
    end
    jiggletime = jiggletime - 15
  end
  if state == "title" then
    if titleframe == 0 and t > 5 then
      titleframe = 1
    end
    if titleframe == 1 and t > 13 then
      titleframe = 2
    end
    if titleframe == 2 and love.keyboard.isDown("space") then
      state = "intro"
    end
  end
end

function love.draw()
  push:apply("start")
  if state == "title" then
    if titleframe == 0 then
      drawimg(img.controller[j])
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
        drawimg(img.ta[j])
      else
        drawimg(img.ts[j])
      end
    end
  end
  push:apply("end")
end