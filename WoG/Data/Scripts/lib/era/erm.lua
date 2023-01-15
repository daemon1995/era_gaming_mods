local ffi     = require('ffi')
local mem     = require('era.mem')
local era     = require('era.era')
local inspect = require('inspect')

local eraDll = era.dll

local erm = setmetatable({}, {
  __call = function (self, cmds)
    eraDll.ExecErmCmd(cmds)
  end
})

erm.v = setmetatable({
  _values = ffi.cast(mem.pi32, 0x887668 - 4),

  addr = function (self, index)
    if index < 1 or index > 10000 then error('v-index out of range (1..10000): ' .. inspect(index)) end
    return mem.addr(self._values + index)
  end
}, {
  __index = function (t, k)
    if k < 1 or k > 10000 then error('v-index out of range (1..10000): ' .. inspect(k)) end
    return t._values[k]
  end,

  __newindex = function (t, k, v)
    if k < 1 or k > 10000 then error('v-index out of range (1..10000): ' .. inspect(k)) end
    t._values[k] = v
  end
}) -- .erm.v

erm.y = setmetatable({
  _values    = ffi.cast(mem.pi32, 0xA48D80 - 4),
  _negValues = ffi.cast(mem.pi32, 0xA46A30 - 4),

  addr = function (self, index)
    if not (index >= 1 and index <= 100 or index >= -100 and index <= -1) then error('y-index out of range (-100..-1, 1..100): ' .. inspect(index)) end

    if index > 0 then
      return mem.addr(self._values + index)
    else
      return mem.addr(self._negValues - index)
    end
  end
}, {
  __index = function (t, k)
    if not (k >= 1 and k <= 100 or k >= -100 and k <= -1) then error('y-index out of range (-100..-1, 1..100): ' .. inspect(index)) end
    
    if k > 0 then
      return t._values[k]
    else
      return t._negValues[-k]
    end
  end,

  __newindex = function (t, k, v)
    if not (k >= 1 and k <= 100 or k >= -100 and k <= -1) then error('y-index out of range (-100..-1, 1..100): ' .. inspect(index)) end
    
    if k > 0 then
      t._values[k] = v
    else
      t._negValues[-k] = v
    end
  end
}) -- .erm.y

erm.e = setmetatable({
  _values    = ffi.cast(mem.pfloat, 0xA48F18  - 4),
  _negValues = ffi.cast(mem.pfloat, 0x27F93B8 - 4),

  addr = function (self, index)
    if not (index >= 1 and index <= 100 or index >= -100 and index <= -1) then error('e-index out of range (-100..-1, 1..100): ' .. inspect(index)) end

    if index > 0 then
      return mem.addr(self._values + index)
    else
      return mem.addr(self._negValues - index)
    end
  end
}, {
  __index = function (t, k)
    if not (k >= 1 and k <= 100 or k >= -100 and k <= -1) then error('e-index out of range (-100..-1, 1..100): ' .. inspect(index)) end
    
    if k > 0 then
      return t._values[k]
    else
      return t._negValues[-k]
    end
  end,

  __newindex = function (t, k, v)
    if not (k >= 1 and k <= 100 or k >= -100 and k <= -1) then error('e-index out of range (-100..-1, 1..100): ' .. inspect(index)) end
    
    if k > 0 then
      t._values[k] = v
    else
      t._negValues[-k] = v
    end
  end
}) -- .erm.e

erm.f = setmetatable({
  _values = ffi.cast(mem.pu8, 0x91F2E0 - 1),

  addr = function (self, index)
    if index < 1 or index > 1000 then error('f-index out of range (1..1000): ' .. inspect(index)) end
    return mem.addr(self._values + index)
  end
}, {
  __index = function (t, k)
    if k < 1 or k > 1000 then error('f-index out of range (1..1000): ' .. inspect(k)) end
    return t._values[k]
  end,

  __newindex = function (t, k, v)
    if k < 1 or k > 1000 then error('f-index out of range (1..1000): ' .. inspect(k)) end
    t._values[k] = v
  end
}) -- .erm.f

local pzvars = ffi.typeof('struct { char strs[512][1000]; } * [1]')

erm.z = setmetatable({
  _values    = 0x9273E8 - 512,
  _negValues = 0xA46D28 - 512,

  addr = function (self, index)
    if not (index >= 1 and index <= 1000 or index >= -10 and index <= -1) then error('z-index out of range (-10..-1, 1..1000): ' .. inspect(index)) end

    if index > 0 then
      return self._values + index * 512
    else
      return self._negValues - index * 512
    end
  end
}, {
  __index = function (t, k)
    if not (k >= 1 and k <= 1000 or k >= -10 and k <= -1) then error('z-index out of range (-10..-1, 1..1000): ' .. inspect(index)) end
    
    if k > 0 then
      return mem.str(t._values + k * 512)
    else
      return mem.str(t._negValues - k * 512)
    end
  end,

  __newindex = function (t, k, v)
    if not (k >= 1 and k <= 1000 or k >= -10 and k <= -1) then error('z-index out of range (-10..-1, 1..1000): ' .. inspect(index)) end
    
    if k > 0 then
      mem.str(t._values + k * 512, v, 512)
    else
      mem.str(t._negValues - k * 512, v, 512)
    end
  end
}) -- .erm.z

local TErmHero = { className = 'TErmHero' }

TErmHero.mt = TErmHero

TErmHero.new = function (id)
  if id < 0 or id > 255 then
    error('Invalid hero ID: ' .. inspect(id))
  end

  return setmetatable({ id = id }, { __index = TErmHero })
end

TErmHero.w = function (self, index, value)
  local pval = ffi.cast(mem.pi32, 0xA4AB10 + self.id * (200 * 4) + (index - 1) * 4)

  if value then
    pval[0] = value
    return value
  else
    return pval[0]
  end
end

function erm.hero (id)
  return TErmHero.new(id)
end

function erm.currHero ()
  local phero = mem.i32(0x27F9970);

  if phero == 0 then
    return erm.hero(0)
  else
    return erm.hero(mem.i32(phero + 0x1A))
  end
end

return erm