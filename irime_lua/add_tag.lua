--[[
  - { when: composing, accept: space, send: Control+Return }
  - lua_filter@second_in_adv
--]]

local function filter(input, env)
    local temp_table = {}
    for cand in input:iter() do
        table.insert(temp_table, cand)
    end--for

    for i, cand in ipairs(temp_table) do
	    if (i < #temp_table) then
		    cand.comment = cand.comment.." "..(i+1).."."
		end
        yield(cand)
    end
end--function


return { func = filter }
