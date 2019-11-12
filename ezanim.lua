local ezanim = {}
function ezanim.newanim(png,w,s,b)
  
  local a = {}
  a.w = w
  a.f = 1
  a.s = s
  a.b = b or 0
  a.img = love.graphics.newImage(png)
  a.h = a.img:getHeight()
  a.frames = a.img:getWidth()/(w+a.b)
  a.quads = {}
  offset = 0
  for i=0,a.frames - 1 do
    
    quad = love.graphics.newQuad(i * a.w + offset, 0 , a.w, a.h, a.img:getWidth(), a.img:getHeight())
    table.insert(a.quads, quad)
    offset = offset + a.b
  end
  a.time = 0
  return a
end
function ezanim.animupdate(a)
  a.time = a.time + love.timer.getDelta()*60
  if a.time >= a.s then
    a.time = a.time - a.s
    a.f = a.f + 1
  end
  if a.f >= a.frames + 1 then
    a.f = 1
  end 
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
  quad = a.quads[a.f]
  love.graphics.draw(a.img,quad,x,y,r,sx,sy,ox,oy,kx,ky)
end
function ezanim.resetanim(a)
  a.f=1
  a.time=0
end
return ezanim