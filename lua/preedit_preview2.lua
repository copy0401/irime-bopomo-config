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
  local commit = env.engine.context:get_commit_text() --输入的编码
  local liu_index = 0
  local liu_key = -1  -- 用來判斷是否是連續的 VRSF 如果不連續就不要添加
  
  for cand in input:iter() do
    local up_commit = string.upper(commit)
    -- " ▉ ▊ ▋ ▋ ▌ ▍ ▎ ▏ ▐ ░ ▒ "
    -- cand:get_genuine().preedit =  up_commit  --英文編碼  --預設
    -- cand:get_genuine().preedit = cand.text --首選項
    -- cand:get_genuine().preedit = "".. up_commit .." ".. cand.text .."" --英文編碼+首選項
    -- cand:get_genuine().preedit = "".. up_commit .."\t".. cand.text .."" --首選項+英文編碼
    -- cand:get_genuine().preedit = "".. cand.text .."▹".. up_commit .."" --首選項+英文編碼
    cand:get_genuine().preedit = "".. cand.text .."(".. up_commit ..")" --首選項+英文編碼
    -- cand:get_genuine().preedit = "".. cand.text .."₌".. up_commit .."" --首選項+英文編碼
    -- cand:get_genuine().preedit = "".. cand.text .."\t".. up_commit .."" --首選項+英文編碼
    -- cand:get_genuine().preedit = "".. cand.text .."\t▌".. up_commit .."" --首選項+英文編碼
    -- cand:get_genuine().preedit = "".. cand.text .."<".. up_commit .."▌" --首選項+英文編碼
    -- cand:get_genuine().preedit = "".. cand.text .."✍" --首选
    -- cand:get_genuine().preedit = "".. cand.text .."\t".. up_commit .." ".. cand:get_genuine().comment
    
    
    -- 𝖠𝖡𝖢𝖣𝖤𝖥𝖦𝖧𝖨𝖩𝖪𝖫𝖬𝖭𝖮𝖯𝖰𝖱𝖲𝖳𝖴𝖵𝖶𝖷𝖸𝖹
    -- 𝖺𝖻𝖼𝖽𝖾𝖿𝗀𝗁𝗂𝗃𝗄𝗅𝗆𝗇𝗈𝗉𝗊𝗋𝗌𝗍𝗎𝗏𝗐𝗑𝗒𝗓
    -- 𝗔𝗕𝗖𝗗𝗘𝗙𝗚𝗛𝗜𝗝𝗞𝗟𝗠𝗡𝗢𝗣𝗤𝗥𝗦𝗧𝗨𝗩𝗪𝗫𝗬𝗭
    -- 𝗮𝗯𝗰𝗱𝗲𝗳𝗴𝗵𝗶𝗷𝗸𝗹𝗺𝗻𝗼𝗽𝗾𝗿𝘀𝘁𝘂𝘃𝘄𝘅𝘆𝘇
    -- 𝚊𝚋𝚌𝚍𝚎𝚏𝚐𝚑𝚒𝚓𝚔𝚕𝚖𝚗𝚘𝚙𝚚𝚛𝚜𝚝𝚞𝚟𝚠𝚡𝚢𝚣
    -- 𝙰𝙱𝙲𝙳𝙴𝙵𝙶𝙷𝙸𝙹𝙺𝙻𝙼𝙽𝙾𝙿𝚀𝚁𝚂𝚃𝚄𝚅𝚆𝚇𝚈𝚉
    -- ₁₂₃₄₅₆₇₈₉₀
    
    local liu_str      = cand:get_genuine().text -- 國 一個中文字大小為 3
    local liu_comment  = cand:get_genuine().comment -- {ㄓㄨˋ} 
    local liu_find     = string.find (liu_comment, "{") -- {ㄓㄨˋ} 有 { 代表是注音符號
    
    -- for s, r in pairs(charset) do -- s is CJK
        if (     liu_index == 0 and #liu_str == 3 and liu_find == 2 and liu_key == -1) then
           cand:get_genuine().comment = "₀" .. cand.comment 
           -- cand:get_genuine().comment = cand.comment
           liu_key = 0
        elseif ( liu_index == 1 and #liu_str == 3 and liu_find == 2 and liu_key == 0) then
           cand:get_genuine().comment = "₁" .. cand.comment 
           liu_key = 1
        elseif ( liu_index == 2 and #liu_str == 3 and liu_find == 2 and liu_key == 1) then
           cand:get_genuine().comment = "₂" .. cand.comment 
           liu_key = 2
        elseif ( liu_index == 3 and #liu_str == 3 and liu_find == 2 and liu_key == 2) then
           cand:get_genuine().comment = "₃" .. cand.comment 
           liu_key = 3
        elseif ( liu_index == 4 and #liu_str == 3 and liu_find == 2 and liu_key == 3) then
           cand:get_genuine().comment = "₄" .. cand.comment 
           liu_key = 4
        else
           liu_key = 5
           -- cand:get_genuine().comment =  cand.comment .. " " .. liu_index
           cand:get_genuine().comment =  "".. cand.comment
           -- ❄ ❅ ❆ ☯ 𓃥 ✢ ✣ ✤ ✥ ◍ ➠ ➟ ϟ ❋ ❖ ◉ ❍ ◒ ◓ ▸▹
        end --if
        -- break
        -- end --for cjk
        liu_index = liu_index + 1 
        yield(cand)
    end --for cand

end -- function

return filter

