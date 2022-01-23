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

-- local function reverse_lookup_filter(input, pydb, env)
--
-- end

local function filter(input, env)
  local commit = env.engine.context:get_commit_text()--输入的编码
  
  local liu_index = 0
  local liu_key = -1  -- 用來判斷是否是連續的 VRSF 如果不連續就不要添加
  
  for cand in input:iter() do
    local up_commit = string.upper(commit)
    -- " ▉ ▊ ▋ ▋ ▌ ▍ ▎ ▏ ▐ ░ ▒ "
    -- cand:get_genuine().preedit =  up_commit  --英文編碼  --預設
    -- cand:get_genuine().preedit = cand.text --首選項
    -- cand:get_genuine().preedit = "".. up_commit .." ".. cand.text .."" --英文編碼+首選項
    -- cand:get_genuine().preedit = "".. cand.text .."<".. up_commit .."" --首選項+英文編碼
    cand:get_genuine().preedit = "".. cand.text .."\t".. up_commit .."" --首選項+英文編碼
    -- cand:get_genuine().preedit = "".. cand.text .."<".. up_commit .."▌" --首選項+英文編碼
    -- cand:get_genuine().preedit = cand.text .."✍" --首选
    
    local liu_str    = cand:get_genuine().text -- 國 一個中文字大小為 3
    local liu_comment    = cand:get_genuine().comment -- {ㄓㄨˋ} 
    local liu_find =   string.find (liu_comment, "{") -- {ㄓㄨˋ} 有 { 代表是注音符號
    
    -- for s, r in pairs(charset) do -- s is CJK
        if (     liu_index == 0 and #liu_str == 3 and liu_find == 2 and liu_key == -1) then
           -- cand:get_genuine().comment = "[O]" .. cand.comment
           cand:get_genuine().comment = cand.comment
           liu_key = 0
        elseif ( liu_index == 1 and #liu_str == 3 and liu_find == 2 and liu_key == 0) then
           -- cand:get_genuine().comment = ">[v]" .. cand.comment
           cand:get_genuine().comment = "[V]" .. cand.comment
           liu_key = 1
        elseif ( liu_index == 2 and #liu_str == 3 and liu_find == 2 and liu_key == 1) then
           -- cand:get_genuine().comment = ">[r]" .. cand.comment
           cand:get_genuine().comment = "[R]" .. cand.comment
           liu_key = 2
        elseif ( liu_index == 3 and #liu_str == 3 and liu_find == 2 and liu_key == 2) then
           -- cand:get_genuine().comment = ">[s]" .. cand.comment
           cand:get_genuine().comment = "[S]" .. cand.comment
           liu_key = 3
        elseif ( liu_index == 4 and #liu_str == 3 and liu_find == 2 and liu_key == 3) then
           -- cand:get_genuine().comment = ">[f]" .. cand.comment 
           cand:get_genuine().comment = "[F]" .. cand.comment 
           liu_key = 4
        else
           liu_key = 5
           -- cand:get_genuine().comment =  cand.comment .. " " .. liu_index
           cand:get_genuine().comment =  "".. string.upper(cand.comment)
           -- ❄ ❅ ❆ ☯ 𓃥 ✢ ✣ ✤ ✥ ◍ ➠ ➟ ϟ ❋ ❖ ◉ ❍ ◒ ◓ ▸▹
        -- end--if
        -- break
    end--for
    liu_index = liu_index + 1 
    
    yield(cand)
  end
end
return filter

