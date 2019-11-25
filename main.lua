function love.load()
  love.window.setTitle("The Very Silly Adventures of Duopus")
  -- setup push
  push = require "push"
  windowWidth, windowHeight = 800, 480
  love.graphics.setDefaultFilter("nearest", "nearest")
  gameWidth, gameHeight = 200,120
  push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {
    fullscreen = false,
    resizable = true,
    pixelperfect = true
  })
  push:setBorderColor{255,255,255}
  
  drawimg = love.graphics.draw
  newimg = love.graphics.newImage
  a = require "ezanim"
  state = "title"
  level = 1
  titleframe = 0
  introframe = 0
  j = 1
  jiggletime = 0
  t = 0
  dp = {x=0,y=0,anim=2,flip=false}
  temps ={
    duopus = {
      a.newtemplate("duopus.png",19,4),
      a.newtemplate("duopus bob.png",19,10),
      a.newtemplate("duopus dead.png",19,0)
    },
    arnold = {
      a.newtemplate("arnold bob.png",32,3),
      a.newtemplate("expandingcube.png",32,2)
    }
  }

  img={
    -- title screen
    controller = loadjiggle("title/controller"),
    ta = loadjiggle("title/ta"),
    ts = loadjiggle("title/ts"),
    xbc = newimg("title/XBC.png"),
    kbc = newimg("title/KBC.png"),
    -- intro cutscene
    i1 = loadjiggle("story/a"),
    i2 = loadjiggle("story/b"),
    i3 = loadjiggle("story/c"),
    i4 = loadjiggle("story/d"),
    i5 = loadjiggle("story/e"),
    --duopus
    duopus = {
      a.newanim(temps.duopus[1]),
      a.newanim(temps.duopus[2]),
      a.newanim(temps.duopus[3])
    }
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
    jiggletime = jiggletime - math.floor(jiggletime / 15) * 15
  end
  if love.keyboard.isDown("2") then
    state = "game"
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
      t = 0
    end
  end
  if state == "intro" then
    if t > 3 and love.keyboard.isDown("space") then
      introframe = introframe + 1
      t = 0
    end
    if introframe >= 5 then
      state = "game"
    end
  end
  if state == "game" then
    moving = false
    if love.keyboard.isDown("d") then
      dp.flip = false
      dp.x = dp.x + 1
      moving  = true
    end
    if love.keyboard.isDown("a") then
      dp.flip = true
      dp.x = dp.x - 1
      moving = true
    end
    if love.keyboard.isDown("s") then
      dp.y = dp.y + 1
      moving = true
    end
    if love.keyboard.isDown("w") then
      dp.y = dp.y - 1
      moving = true
    end
    if moving then
      dp.anim = 1
      a.resetanim(img.duopus[2])
      a.animupdate(img.duopus[1])
    else
      dp.anim = 2
      a.resetanim(img.duopus[1])
      a.animupdate(img.duopus[2])
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
  if state == "intro" then
    if introframe == 0 then
      drawimg(img.i1[j])
    end
    if introframe == 1 then
      drawimg(img.i2[j])
    end
    if introframe == 2 then
      drawimg(img.i3[j])
    end
    if introframe == 3 then
      drawimg(img.i4[j])
    end
    if introframe == 4 then
      drawimg(img.i5[j])
    end
  end
  if state == "game" then
    if dp.flip then
      a.animdraw(img.duopus[dp.anim],dp.x+19,dp.y,0,-1,1)
    else
      a.animdraw(img.duopus[dp.anim],dp.x,dp.y)
    end
  end
  push:apply("end")
end