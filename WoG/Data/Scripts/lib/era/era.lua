local ffi     = require('ffi')
local bitser  = require('bitser')
local mem     = require('era.mem')
local inspect = require('inspect').inspect

local era = {}

ffi.cdef[[
  typedef uint8_t boolean;
  
  int __stdcall MessageBoxA (int hwnd, const char message[], const char title[], int mesType);

  typedef struct THookContext {
    int edi, esi, ebp, esp, ebx, edx, ecx, eax;
    int retAddr;
  };

  typedef struct TEvent {
    char* name;
    void* data;
    int   dataSize;
  };

  typedef struct TGameState {
    int rootDlgId;
    int currentDlgId;
  };

  typedef void (__stdcall *TEventHandler) (struct TEvent* event);
  typedef int (__stdcall *THookHandler) (struct THookContext* context);

  bool  __stdcall PatchExists (const char PatchName[]);
  bool  __stdcall PluginExists (const char PluginName[]);
  bool  __stdcall ReadStrFromIni (const char Key[], const char SectionName[], const char FilePath[], uint8_t Res[]);
  bool  __stdcall SaveIni (const char FilePath[]);
  bool  __stdcall WriteStrToIni (const char Key[], const char Value[], const char SectionName[], const char FilePath[]);
  int   __stdcall GetButtonID (const char ButtonName[]);
  int   __stdcall ReadSavegameSection (int DataSize, void* Data, const char SectionName[]);
  void  __stdcall ClearAllIniCache ();
  void  __stdcall ClearIniCache (const char FileName[]);
  void  __stdcall ExecErmCmd (const char cmd[]);
  void  __stdcall ExtractErm ();
  void  __stdcall FatalError(const char text[]);
  void  __stdcall FireErmEvent (int EventId);
  void  __stdcall FireEvent (const char name[], void* data, int size);
  void  __stdcall ForceTxtUnload (const char Name[]);
  void  __stdcall GetGameState (struct TGameState* GameState);
  void  __stdcall GlobalRedirectFile (const char OldFileName[], const char NewFileName[]);
  void  __stdcall NameColor (int Color32, const char Name[]);
  void  __stdcall RedirectFile (const char OldFileName[], const char NewFileName[]);
  void  __stdcall RedirectMemoryBlock (void* OldAddr, int BlockSize, void* NewAddr);
  void  __stdcall RegisterHandler (TEventHandler, const char name[]);
  void  __stdcall ReloadErm ();
  void  __stdcall RestoreEventParams ();
  void  __stdcall SaveEventParams ();
  void  __stdcall WriteAtCode (int Count, const char* Src, void* Dst);
  void  __stdcall WriteSavegameSection (int DataSize, void* Data, const char SectionName[]);
  void* __stdcall ApiHook (THookHandler HandlerAddr, int HookType, void* CodeAddr);
  void* __stdcall GetRealAddr (void* Addr);
  void* __stdcall LoadTxt (const char Name[]);
  void* __stdcall LoadImageAsPcx16 (const char FilePath[], const char PcxName[], int width, int height);
  void  __stdcall ShowMessage (const char mes[]);
  boolean __stdcall Ask (const char question[]);
]]

era.dll   = ffi.load('era.dll')
local dll = era.dll

local function indexOf (table, needle)
  for i, v in ipairs(table) do
    if v == needle then
      return i
    end
  end

  return false
end

local function nilToDef (value, defValue)
  return value == nil and nil or defValue
end

local function toBool (value)
  if value then return true else return false end
end

local function copyList (list)
  local result = {}

  for i = 1, #list do
    result[i] = list[i]
  end

  return result
end

local function nilFunc ()
end

local function eventHandlersSorter (b, a)
  if not b or b.func == nilFunc or not a or a.func == nilFunc then
    return not a or a.func == nilFunc
  else
    local priorDiff = a.priority - b.priority
    return priorDiff > 0 or priorDiff == 0 and a.id > b.id
  end
end

local eventAutoId = 1

local MEventHandler = {}

MEventHandler.new = function (func, opts)
  opts = opts or {}
  -- TODO use getOpts with options validation

  local result = {
    id        = eventAutoId,
    priority  = opts.priority or 0,
    removable = toBool(nilToDef(opts.removable, true)),
    oneTime   = toBool(opts.oneTime),
    func      = func
  }

  assert(not result.oneTime or result.removable, 'One-time handlers must be removable')

  eventAutoId = eventAutoId + 1

  return result
end -- .function MEventHandler.new

local MEventHandlers = {
  __index = {
    addHandler = function (self, handler)
      self.list[#self.list + 1] = handler

      if #self.list > 1 then
        self.sorted = false
      end

      return self
    end,

    removeHandler = function (self, handler)
      local list = self.list

      for i, v in ipairs(list) do
        if v.func == handler then
          list[i] = false
        end
      end

      return self
    end,

    sort = function (self)
      local list = self.list

      if not self.sorted then
        if #list > 1 then
          table.sort(list, eventHandlersSorter)
        end

        self.sorted = true
      end

      -- remove trailing garbage records
      if #list > 0 and (not list[#list] or list[#list].func == nilFunc) then
        for i = #list, 0, -1 do
          if not list[i] or list[i].func == nilFunc then
            list[i] = nil
          else
            break
          end
        end
      end

      return self
    end -- .function sort
  } -- .function __index
} -- .metatable MEventHandlers

MEventHandlers.new = function ()
  return setmetatable({ list = {}, sorted = true }, MEventHandlers)
end

local eventHandlers = {}
local hooks         = {}
local THookHandler  = ffi.typeof('THookHandler');

local function handleEvents (eventName, event)
  local handlers = eventHandlers[eventName]

  if handlers and #handlers.list > 0 then
    -- Fix handlers for current event. No modification will be made
    local handlersCopy = copyList(handlers:sort().list)

    for i, handler in ipairs(handlersCopy) do
      local result, err = xpcall(handler.func, function (err) return debug.traceback(err, 2) end, event, handler.func, eventName)

      if handler.oneTime then
        if handlers[i] == handler then
          handlers[i] = false
        else
          handler.func = nilFunc
        end
      end

      if not result then
        era.msg(err)
      end
    end -- .for
  end -- .if
end -- .function handleEvents

local handleEventsCallback = ffi.cast('TEventHandler', function (event)
  local eventName = ffi.string(event.name)

  handleEvents(eventName, event)
end);

function era.toStr (value)
  if value then
    if type(value) ~= 'string' then
      value = inspect(message)
    end
  else
    value = ''
  end

  return value
end

function era.toDebugStr (value)
  if value then
    if type(value) ~= 'string' then
      value = inspect(value)
    end
  elseif type(value) == 'false' then
    value = 'false'
  else
    value = 'nil'
  end

  return value
end

function era.profile (func)
  local startTime = os.clock()
  local result    = func()
  local endTime   = os.clock()

  print('Profiling ended in ' .. (endTime - startTime) .. ' seconds with result: ' .. era.toDebugStr(result))

  return result
end

function era.showSystemMessage (message, title)
  ffi.C.MessageBoxA(0, era.toDebugStr(message), era.toStr(title), 0)
end

function era.showSystemPrompt (question, title)
  local MB_YESNO = 4
  local IDNO     = 7
  
  return ffi.C.MessageBoxA(0, era.toDebugStr(question), era.toStr(title), MB_YESNO) ~= IDNO
end

local function prepareTextForNativeMsgBox (message, title)
  message = era.toDebugStr(message)

  if title then
    title = era.toStr(title)
    
    if title ~= '' then
      if title:find('[{}]') then
        message = title .. '\r\n' .. message
      else
        message = '{' .. title .. '}\r\n\r\n' .. message
      end
    end
  end

  return message
end -- .function prepareTextForNativeMsgBox

function era.showNativeMessage (message, title)
  dll.ShowMessage(prepareTextForNativeMsgBox(message, title))
end

function era.showNativePrompt (question, title)
  return dll.Ask(prepareTextForNativeMsgBox(question, title)) ~= 0
end

local function systemPrint (...)
  local args = {...}

  for i, v in ipairs(args) do
    args[i] = era.toDebugStr(args[i])
  end

  era.showSystemMessage(table.concat(args, ' '))
end

local function nativePrint (...)
  local args = {...}

  for i, v in ipairs(args) do
    args[i] = era.toDebugStr(args[i])
  end

  era.showNativeMessage(table.concat(args, ' '))
end

-- Provide short API for message boxes, redirect lua 'print' function
era.msg  = systemPrint
era.ask  = era.showSystemPrompt
_G.print = era.msg

function era.on (eventName, eventHandler, opts)
  opts = opts or {}

  if eventHandlers[eventName] == nil then
    dll.RegisterHandler(handleEventsCallback, eventName)
    eventHandlers[eventName] = MEventHandlers.new()
  end

  eventHandlers[eventName]:addHandler(MEventHandler.new(eventHandler, opts))

  return era
end

function era.off (eventName, eventHandler)
  local handlers = eventHandlers[eventName]

  if handlers then
    handlers:removeHandler(eventHandler)
  end

  return era
end

function era.bind (eventName, eventHandler, opts)
  opts           = opts or {}
  opts.removable = false

  return era.on(eventName, eventHandler, opts)
end

era.fire = handleEvents

function era.trigger (eventName, eventData, eventDataSize)
  dll.FireEvent(eventName, eventData or mem.null, eventDataSize or 0)
end

function era.bridge (ptr, callback)
  local HOOKTYPE_BRIDGE = 2
  callback = ffi.cast(THookHandler, callback)
  table.insert(hooks, { mem.addr(ptr), callback })
  
  return mem.addr(dll.ApiHook(callback, HOOKTYPE_BRIDGE, mem.ptr(ptr)))
end

ffi.metatype('struct THookContext', {
  __index = {
    arg = function (self, n, value)
      if value then
        return mem.i32(self.esp + 4 + 4 * n, value)
      else
        return mem.i32(self.esp + 4 + 4 * n)
      end
    end
  }
})

local savegameData = {}

function era.writeSavegame (table, tableName)
  savegameData[tableName] = table
end

function era.readSavegame (tableName)
  return savegameData[tableName]
end

local function pack (...)
  return {...}
end

era.bind('OnSavegameWrite', function ()
  era.fire('OnLuaSavegameWrite')

  local binData  = bitser.dumps(savegameData)
  local dataSize = ffi.new('int[1]');
  dataSize[0]    = #binData;
  
  dll.WriteSavegameSection(4, dataSize, 'Lua.Savegame');
  dll.WriteSavegameSection(#binData, mem.ptr(binData), 'Lua.Savegame');
end, { priority = -999999 })

era.bind('OnSavegameRead', function ()
  local dataSize  = ffi.new('int[1]');
  local bytesRead = tonumber(dll.ReadSavegameSection(4, dataSize, 'Lua.Savegame'));

  if bytesRead == 4 and dataSize[0] > 0 then
    local buf = ffi.new('char[?]', dataSize[0]);
    
    if dll.ReadSavegameSection(dataSize[0], buf, 'Lua.Savegame') == dataSize[0] then
      savegameData = bitser.loads(ffi.string(buf, dataSize[0]));
    else
      savegameData = {}
    end
  else
    savegameData = {}
  end

  era.fire('OnLuaSavegameRead')
end, { priority = -999999 }) -- .event OnSavegameRead

era.bridge(0x4EEEA5, function (context)
  -- Redirect message boxes to native game dialog system
  era.msg  = nativePrint
  era.ask  = era.showNativePrompt
  _G.print = era.msg
  
  era.trigger('OnGuiStart')
  
  return 1
end)

return era