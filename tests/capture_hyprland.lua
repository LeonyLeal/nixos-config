-- Execute the generated configuration without a graphical session and record
-- the calls it would send to Hyprland (including dispatcher arguments/flags).
local result = { binds = {}, rules = {}, config = {}, monitors = {}, env = {}, startup = {} }
local function merge(target, source)
    for key, value in pairs(source) do
        if type(value) == "table" and type(target[key]) == "table" then
            merge(target[key], value)
        else
            target[key] = value
        end
    end
end
local function dispatcher(path)
    return setmetatable({}, {
        __index = function(_, key) return dispatcher(path == "" and key or path .. "." .. key) end,
        __call = function(_, ...) return { name = path, args = {...} } end,
    })
end
hl = {
    dsp = dispatcher(""),
    bind = function(key, action, options)
        table.insert(result.binds, { key = key, action = action, options = options })
    end,
    window_rule = function(rule) table.insert(result.rules, rule) end,
    config = function(settings) merge(result.config, settings) end,
    monitor = function(settings) table.insert(result.monitors, settings) end,
    env = function(key, value) result.env[key] = value end,
    on = function(_, callback) callback() end,
    exec_cmd = function(command) table.insert(result.startup, command) end,
}
dofile(arg[1])

local function encode(value)
    local kind = type(value)
    if kind == "string" then
        return '"' .. value:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('\n', '\\n'):gsub('\r', '\\r'):gsub('\t', '\\t') .. '"'
    elseif kind == "boolean" or kind == "number" then
        return tostring(value)
    elseif kind == "table" then
        local parts = {}
        if #value > 0 then
            for _, item in ipairs(value) do table.insert(parts, encode(item)) end
            return "[" .. table.concat(parts, ",") .. "]"
        end
        local keys = {}
        for key in pairs(value) do table.insert(keys, key) end
        table.sort(keys)
        for _, key in ipairs(keys) do table.insert(parts, encode(key) .. ":" .. encode(value[key])) end
        return "{" .. table.concat(parts, ",") .. "}"
    end
    error("Unsupported value in Hyprland configuration: " .. kind)
end
print(encode(result))
