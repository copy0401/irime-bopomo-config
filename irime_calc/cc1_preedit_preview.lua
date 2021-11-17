-- /lua/preedit_preview.lua
--
-- /rime.lua
-- 在rime.lua 加入一行 preedit_preview = require("preedit_preview")
--
-- 方案.schema.yaml
-- 方案
-- engine:
--   filters: 最后加一行
--    - lua_filter@preedit_preview
--   就是要放在  uniquifier 之後



local function reverse_lookup_filter(input, pydb)
  for cand in input:iter() do
     cand:get_genuine().preedit =  cand.text
     yield(cand)
  end
end

--[[
如下，filter 除 `input` 外，可以有第二个参数 `env`。
--]]
local function filter(input, env)
   --[[ 从 `env` 中拿到拼音的反查库 `pydb`。
        `env` 是一个表，默认的属性有（本例没有使用）：
          - engine: 输入法引擎对象
          - name_space: 当前组件的实例名
        `env` 还可以添加其他的属性，如本例的 `pydb`。
   --]]
   reverse_lookup_filter(input, env.pydb)
end
return filter
