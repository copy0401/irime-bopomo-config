--[[
  - { when: composing, accept: space, send: Control+Return }
  - lua_filter@second_in_adv
--]]

local function filter(input, env)
    local liu_index = 0
    for cand in input:iter() do
       local liu_str    = cand:get_genuine().text
       -- 一個中文字 大小 = 3
       for s, r in pairs(charset) do -- s is CJK
           if (     liu_index == 1 and #liu_str == 3 ) then
              cand:get_genuine().comment = "[V]" .." ".. cand.comment
           elseif ( liu_index == 2 and #liu_str == 3 ) then
              cand:get_genuine().comment = "[R]" .." ".. cand.comment
           elseif ( liu_index == 3 and #liu_str == 3 ) then
              cand:get_genuine().comment = "[S]" .." ".. cand.comment
           elseif ( liu_index == 4 and #liu_str == 3 ) then
              cand:get_genuine().comment = "[F]" .." ".. cand.comment
           else
              cand:get_genuine().comment =  cand.comment 
           end
           break
       end
       liu_index = liu_index + 1 
       yield(cand)
    end
    
end--function

return { func = filter }
