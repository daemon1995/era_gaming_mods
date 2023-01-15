--[[
  Protect global variables from erroneous assignments. New globals creation is allowed only inside
  callback to global accessGlobals function.
--]]
do
  local publicGlobalsMt = {
    __index    = function (t, k)    return rawget(t, k) end,
    __newindex = function (t, k, v) rawset(t, k, v)     end
  }

  local protectedGlobalsMt = {
    __index    = function (t, k)    error('Global variable "' .. k .. '"" is undefined and must be declared local')                                                        end,
    __newindex = function (t, k, v) error('Global variables assignment is prohibited. Variable "' .. k .. '"" must be declared local or be wrapped in accessGlobals call') end
  }

  function accessGlobals (func)
    setmetatable(_G, publicGlobalsMt)
    func()
    setmetatable(_G, protectedGlobalsMt)
  end

  setmetatable(_G, protectedGlobalsMt)
end
-------- END Protect global variables from erroneous assignments --------

-- Initialize random number generator
math.randomseed(os.time())

-- Load necessary libraries for data serialization and low-level API access
local ffi    = require('ffi')
local bitser = require('bitser')

local mem = require('era/mem')
local era = require('era.era')
local erm = require('era.erm')
local dll = ffi.load('era.dll')

-- TESTING
if false then
  local v = erm.v

  local save = { loadings = 0 }

  era.on('OnLuaSavegameWrite', function ()
    era.writeSavegame(save, 'Testing.Era')
  end)

  era.on('OnLuaSavegameRead', function ()
    save = era.readSavegame('Testing.Era') or {}

    if not save.loadings then
      save.loadings = 0
    end

    save.loadings = save.loadings + 1

    print("You've loaded " .. save.loadings .. ' times')
  end)

  era.on('OnHeroScreenMouseClick', function (event, handler)
    erm.currHero():w(100, 888)
    erm('IF:W-1; IF:M^%W100^')

    local r = math.random(3)
    
    if r <= 2 then
      era.on('OnHeroScreenMouseClick', handler, { oneTime = true })
    end
  end, { oneTime = true })

  era.on('OnHeroScreenMouseClick', function (e, h, n)
    erm('VRz2:S^newmonth.wav^; SN:Pz2;')
    print('FIRST')
    era.off(n, h)
  end, { priority = -1 })

  era.on('OnGuiStart', function (event)
    erm.e[5] = 3.14
    --erm('IF:M^%E5^')
  end)
end -- .if