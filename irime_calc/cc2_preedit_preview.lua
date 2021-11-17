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

local function reverse_lookup_filter(input, pydb, env)

end

local function filter(input, env)
  local commit = env.engine.context:get_commit_text()--输入的编码
  for cand in input:iter() do
    -- cand:get_genuine().preedit = cand.text.." [".. commit .."]"--首選項+編碼
    -- cand:get_genuine().preedit = cand.text --首選項
    -- cand:get_genuine().preedit = cand.text .."✍" --首选
    cand:get_genuine().preedit = cand.text
    yield(cand)
  end
end
return filter

