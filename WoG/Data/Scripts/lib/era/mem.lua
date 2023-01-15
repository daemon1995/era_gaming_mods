local ffi     = require('ffi')
local inspect = require('inspect')

local mem = {}

local pvoid   = ffi.typeof('void*')
local pchar   = ffi.typeof('char*');
local intptr  = ffi.typeof('intptr_t')
local pfloat  = ffi.typeof('float*')
local pdouble = ffi.typeof('double*')
local pi32    = ffi.typeof('int32_t*')
local pi16    = ffi.typeof('int16_t*')
local pi8     = ffi.typeof('int8_t*')
local pu32    = ffi.typeof('uint32_t*')
local pu16    = ffi.typeof('uint16_t*')
local pu8     = ffi.typeof('uint8_t*')

local pvalue = ffi.typeof([[union {
  int        v;
  void*      ptr;
  float*     f32;
  double*    f64;
  int32_t*   i32;
  uint32_t*  u32;
  int16_t*   i16;
  uint16_t*  u16;
  int8_t*    i8;
  uint8_t*   u8;
  char*      text;
}]])

mem.pvoid   = pvoid
mem.pchar   = pchar
mem.intptr  = intptr
mem.pfloat  = pfloat
mem.pdouble = pdouble
mem.pi32    = pi32
mem.pi16    = pi16
mem.pi8     = pi8
mem.pu32    = pu32
mem.pu16    = pu16
mem.pu8     = pu8
mem.null    = ffi.cast(pvoid, 0)
mem.pvalue  = pvalue

function mem.float (ptr, value)
  if value then
    ffi.cast(pfloat, ptr)[0] = value
    return value
  else
    return ffi.cast(pfloat, ptr)[0]
  end
end

function mem.double (ptr, value)
  if value then
    ffi.cast(pdouble, ptr)[0] = value
    return value
  else
    return ffi.cast(pdouble, ptr)[0]
  end
end

function mem.i32 (ptr, value)
  if value then
    ffi.cast(pi32, ptr)[0] = value
    return value
  else
    return ffi.cast(pi32, ptr)[0]
  end
end

function mem.i16 (ptr, value)
  if value then
    ffi.cast(pi16, ptr)[0] = value
    return value
  else
    return ffi.cast(pi16, ptr)[0]
  end
end

function mem.i8 (ptr, value)
  if value then
    ffi.cast(pi8, ptr)[0] = value
    return value
  else
    return ffi.cast(pi8, ptr)[0]
  end
end

function mem.u32 (ptr, value)
  if value then
    ffi.cast(pu32, ptr)[0] = value
    return value
  else
    return ffi.cast(pu32, ptr)[0]
  end
end

function mem.u16 (ptr, value)
  if value then
    ffi.cast(pu16, ptr)[0] = value
    return value
  else
    return ffi.cast(pu16, ptr)[0]
  end
end

function mem.u8 (ptr, value)
  if value then
    ffi.cast(pu8, ptr)[0] = value
    return value
  else
    return ffi.cast(pu8, ptr)[0]
  end
end

function mem.addr (ptr)
  if type(ptr) == 'number' then
    return ptr
  else 
    return tonumber(ffi.cast(intptr, ptr))
  end
end

function mem.val (ptr)
  local result = pvalue()
  result.v     = mem.addr(ptr)

  return result
end

function mem.ptr (ptr)
  return ffi.cast(pvoid, ptr)
end

function mem.ofs (ptr, offset)
  local result = pvalue()
  result.v     = mem.addr(ptr) + offset

  return result
end

function mem.str (ptr, str, bufSize)
  if str then
    bufSize = bufSize or 2147483647

    if bufSize < 0 then
      error('Invalid bufSize argument: ' .. inspect(bufSize))
    elseif bufSize == 0 then
      return 0
    end

    str          = tostring(str)
    local strLen = math.min(#str + 1, bufSize) - 1

    if strLen > 0 then
      ffi.copy(ffi.cast(pu8, ptr), str, strLen)
    end

    mem.ofs(ptr, strLen).u8[0] = 0

    return strLen
  else
    return ffi.string(ffi.cast(pu8, ptr))
  end -- .else
end -- .function mem.str

ffi.metatype(pvalue, {
  __index = {
    str = function (self, value, bufSize)
      return mem.str(self.ptr, value, bufSize)
    end
  }
})

-- FIXME later, refactor to core era library all generic functions and dll variable
local dll = ffi.load('era.dll')

local function getTableKeys (table)
  local result = {}
  local i      = 1

  for key in pairs(table) do
    result[i] = key
    i         = i + 1
  end

  return result;
end

local function copyTable (table)
  local result = {}

  for key, value in pairs(table) do
    result[key] = value
  end

  return result
end

local hexToBinMap = {['0'] = 0, ['1'] = 1, ['2'] = 2, ['3'] = 3, ['4'] = 4, ['5'] = 5, ['6'] = 6, ['7'] = 7, ['8'] = 8, ['9'] = 9, ['a'] = 10, ['b'] = 11, ['c'] = 12, ['d'] = 13, ['e'] = 14,
                     ['f'] = 15, ['A'] = 10, ['B'] = 11, ['C'] = 12, ['D'] = 13, ['E'] = 14, ['F'] = 15}

do
  local mapCopy = copyTable(hexToBinMap)

  for key, value in pairs(mapCopy) do
    hexToBinMap[key:byte()] = value
  end
end

local function hexToBin (str)
  local result = {}

  if #str % 2 == 1 then
    error('hexToBin cannot process string with odd length: ' .. era.toDebugStr(str))
  end

  local j = 1

  for i = 1, #str, 2 do
    local high = hexToBinMap[str:byte(i)]
    local low  = hexToBinMap[str:byte(i + 1)]

    if low and high then
      result[j] = string.char(low + high * 16)
    else
      error('Invalid string for hexToBin: ' .. era.ToDebugStr(str))
    end

    j = j + 1
  end

  return table.concat(result)
end -- .function hexToBin

function mem.writeHex (ptr, data)
  local dataType = type(data)

  if dataType == 'string' then
    local binData = hexToBin(data)
    dll.WriteAtCode(#binData, binData, mem.ptr(ptr))
  else
    error('Only hex string is currently supported as era.writeHex data argument')
  end
end

function mem.writeByte (ptr, value)
  value = ffi.new('uint8_t[1]', value)
  dll.WriteAtCode(1, value, mem.ptr(ptr))
end

function mem.writeWord (ptr, value)
  value = ffi.new('uint16_t[1]', value)
  dll.WriteAtCode(2, ffi.cast('char*', value), mem.ptr(ptr))
end

function mem.writeInt (ptr, value)
  value = ffi.new('uint32_t[1]', value)
  dll.WriteAtCode(4, ffi.cast('char*', value), mem.ptr(ptr))
end

return mem