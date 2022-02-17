-- /lua/preedit_preview3.lua
--
-- /rime.lua
-- 在rime.lua 加入一行 preedit_preview3 = require("preedit_preview3")
--
-- 方案.schema.yaml
-- 方案
-- engine:
--   filters: 最后加一行
--    - lua_filter@preedit_preview3
--   就是要放在  uniquifier 之後

-- local function reverse_lookup_filter(input, pydb, env)
--
-- end

local function filter(input, env)
  local commit = env.engine.context:get_commit_text()--输入的编码
  
  for cand in input:iter() do
    local up_commit = string.upper(commit)
    cand:get_genuine().preedit = "".. cand.text .."\t".. up_commit .." ".. cand:get_genuine().comment
                                        -- 首选            -- 编码            -- 註解
                                        -- 測              -- WMBR            -- {ㄘㄜˋ}
                                        -- 試              -- IAXI            -- {ㄕㄧˋ}
    yield(cand)
  end
end
return filter
