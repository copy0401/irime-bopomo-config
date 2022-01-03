local function check_stroke(cand, inp, db)
    -- local inp_stroke = inp:match("[viuoa]+")
    local inp_stroke = inp:match("\\[abcdefghijklmnopqrstuvwxyz]+")
    if not inp_stroke then
        return false
    end
    if not db then
        return false
    end
    local lookup = db:lookup(cand.text)
    -- lookup = lookup:gsub("h", "v") # 輸入viuoa 轉換成 筆畫用的 hspnz
    -- lookup = lookup:gsub("s", "i")
    -- lookup = lookup:gsub("p", "u")
    -- lookup = lookup:gsub("n", "u")
    -- lookup = lookup:gsub("z", "i")
    return lookup:match("^" .. inp_stroke)
end

local function filter(input, env)
    local input_text = env.engine.context.input
    for cand in input:iter() do
        local cand_inp = input_text:sub(cand.start + 1, cand._end)
        -- local has_stroke = cand_inp:match("[viuoa]")
        local has_stroke = cand_inp:match("\\[abcdefghijklmnopqrstuvwxyz]")
        if not has_stroke then
            yield(cand)
        elseif check_stroke(cand, cand_inp, env.stroke_db) then
            yield(cand)
        end
    end
end

local function init(env)
    -- env.stroke_db = ReverseDb("build/stroke.reverse.bin")
    env.stroke_db = ReverseDb("build/liur.extended.reverse.bin")
end

return { init = init, func = filter }
