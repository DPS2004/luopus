local ezanim = {}
function ezanim.newtemplate(png,w,s,b)
  local t = {}
  t.w = w

  t.s = s
  t.b = b or 0
  t.img = love.graphics.newImage(png)
  t.h = t.img:getHeight()
  t.frames = t.img:getWidth()/(w+t.b)
  t.quads = {}
  offset = 0
  for i=0,t.frames - 1 do
    
    quad = love.graphics.newQuad(i * t.w + offset, 0 , t.w, t.h, t.img:getWidth(), t.img:getHeight())
    table.insert(t.quads, quad)
    offset = offset + t.b
  end

  return t
end
function ezanim.newanim(temp)
  local a = {}
  a.temp = temp
  a.f = 1
  a.time = 0
  return a
end
function ezanim.animupdate(a)
  a.time = a.time + love.timer.getDelta()*60
  if a.temp.s ~= 0 then
    if a.time >= a.temp.s then
      framesmissed = math.floor(a.time / a.temp.s)
      a.f = a.f + framesmissed
      a.time = a.time - framesmissed * a.temp.s
      
    end
    while a.f >= a.temp.frames + 1 do
      a.f = a.f - a.temp.frames
    end 
  else
    a.f = 1
  end
end
function ezanim.outlinedraw(a,x,y,t,c1,c2,r,sx,sy,ox,oy,kx,ky)

  x = x or 0
  y = y or 0
  c1 = c1 or {0,0,0,1}
  c2 = c2 or {1,1,1,1}
  t = t or false

  r = r or 0
  sx = sx or 1
  sy = sy or sx
  ox = ox or 0
  oy = oy or 0
  kx = kx or 0
  ky = ky or 0
  quad = a.temp.quads[a.f]
  love.graphics.setColor(c1)
  if t then
    for i1=-1,1 do
      for i2=-1,1 do
        love.graphics.draw(a.temp.img,quad,x+i1,y+i2,r,sx,sy,ox,oy,kx,ky)
      end
    end
  else
    love.graphics.draw(a.temp.img,quad,x+1,y,r,sx,sy,ox,oy,kx,ky)
    love.graphics.draw(a.temp.img,quad,x-1,y,r,sx,sy,ox,oy,kx,ky)
    love.graphics.draw(a.temp.img,quad,x,y+1,r,sx,sy,ox,oy,kx,ky)
    love.graphics.draw(a.temp.img,quad,x,y-1,r,sx,sy,ox,oy,kx,ky)
  end
  love.graphics.setColor(c2)

  love.graphics.draw(a.temp.img,quad,x,y,r,sx,sy,ox,oy,kx,ky)
  love.graphics.setColor(1,1,1,1)

end
function ezanim.animdraw(a,x,y,r,sx,sy,ox,oy,kx,ky)
  x = x or 0
  y = y or 0
  r = r or 0
  sx = sx or 1
  sy = sy or sx
  ox = ox or 0
  oy = oy or 0
  kx = kx or 0
  ky = ky or 0
  quad = a.temp.quads[a.f]
  love.graphics.draw(a.temp.img,quad,x,y,r,sx,sy,ox,oy,kx,ky)
end
function ezanim.resetanim(a)
  a.f=1
  a.time=0
end
return ezanim