--[[
  - { when: composing, accept: space, send: Control+Return }
  - lua_filter@second_in_adv
--]]

local function filter(input, env)
    local temp_table = {}
    local letters = {'' ,'[1V]' ,'[2R]' ,'[3S]','[4F]','[5]','[6]','[7]','[8]','[9]'} 
    -- 對應方案配置 xiapin_mtc.schema.yaml menu: page_size: 10
    for cand in input:iter() do
        table.insert(temp_table, cand)
    end--for
    
    -- for i, cand in ipairs(temp_table) do
    --     if (i < #temp_table) then
    --         cand.comment = cand.comment.." "..(i+1).."."
    --     end
    --     yield(cand)
    -- end
    
    for i, cand in ipairs(temp_table) do
        if (i <= #temp_table ) then
            if (i <= #letters) then
                cand.comment = letters[i]..cand.comment
            else
                cand.comment = cand.comment
            end
        end
        yield(cand)
    end--for
end--function


return { func = filter }
