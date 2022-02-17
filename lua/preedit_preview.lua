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


 -- "1" , "ㄅ"
 -- "2" , "ㄉ"
 -- "3" , "ˇ"
 -- "4" , "ˋ"
 -- "5" , "ㄓ"
 -- "6" , "ˊ"
 -- "7" , "˙"
 -- "8" , "ㄚ"
 -- "9" , "ㄞ"
 -- "0" , "ㄢ"
 -- "-" , "ㄦ"
 -- "q" , "ㄆ"
 -- "w" , "ㄊ"
 -- "e" , "ㄍ"
 -- "r" , "ㄐ"
 -- "t" , "ㄔ"
 -- "y" , "ㄗ"
 -- "u" , "ㄧ"
 -- "i" , "ㄛ"
 -- "o" , "ㄟ"
 -- "p" , "ㄣ"
 -- "a" , "ㄇ"
 -- "s" , "ㄋ"
 -- "d" , "ㄎ"
 -- "f" , "ㄑ"
 -- "g" , "ㄕ"
 -- "h" , "ㄘ"
 -- "j" , "ㄨ"
 -- "k" , "ㄜ"
 -- "l" , "ㄠ"
 -- ";" , "ㄤ"
 -- "z" , "ㄈ"
 -- "x" , "ㄌ"
 -- "c" , "ㄏ"
 -- "v" , "ㄒ"
 -- "b" , "ㄖ"
 -- "n" , "ㄙ"
 -- "m" , "ㄩ"
 -- "<" , "ㄝ"
 -- ">" , "ㄡ"
 -- "?" , "ㄥ"
 -- "," , "ㄝ"
 -- "." , "ㄡ"
 -- "/" , "ㄥ"


local function filter(input, env)
  local commit = env.engine.context:get_commit_text()--输入的编码
  commit=string.gsub(commit,"1","ㄅ");
  commit=string.gsub(commit,"2","ㄉ");
  commit=string.gsub(commit,"3","ˇ");
  commit=string.gsub(commit,"4","ˋ");
  commit=string.gsub(commit,"5","ㄓ");
  commit=string.gsub(commit,"6","ˊ");
  commit=string.gsub(commit,"7","˙");
  commit=string.gsub(commit,"8","ㄚ");
  commit=string.gsub(commit,"9","ㄞ");
  commit=string.gsub(commit,"0","ㄢ");
  commit=string.gsub(commit,"-","ㄦ");
  commit=string.gsub(commit,"q","ㄆ");
  commit=string.gsub(commit,"w","ㄊ");
  commit=string.gsub(commit,"e","ㄍ");
  commit=string.gsub(commit,"r","ㄐ");
  commit=string.gsub(commit,"t","ㄔ");
  commit=string.gsub(commit,"y","ㄗ");
  commit=string.gsub(commit,"u","ㄧ");
  commit=string.gsub(commit,"i","ㄛ");
  commit=string.gsub(commit,"o","ㄟ");
  commit=string.gsub(commit,"p","ㄣ");
  commit=string.gsub(commit,"a","ㄇ");
  commit=string.gsub(commit,"s","ㄋ");
  commit=string.gsub(commit,"d","ㄎ");
  commit=string.gsub(commit,"f","ㄑ");
  commit=string.gsub(commit,"g","ㄕ");
  commit=string.gsub(commit,"h","ㄘ");
  commit=string.gsub(commit,"j","ㄨ");
  commit=string.gsub(commit,"k","ㄜ");
  commit=string.gsub(commit,"l","ㄠ");
  commit=string.gsub(commit,";","ㄤ");
  commit=string.gsub(commit,"z","ㄈ");
  commit=string.gsub(commit,"x","ㄌ");
  commit=string.gsub(commit,"c","ㄏ");
  commit=string.gsub(commit,"v","ㄒ");
  commit=string.gsub(commit,"b","ㄖ");
  commit=string.gsub(commit,"n","ㄙ");
  commit=string.gsub(commit,"m","ㄩ");
  commit=string.gsub(commit,"<","ㄝ");
  commit=string.gsub(commit,">","ㄡ");
  commit=string.gsub(commit,"?","ㄥ");
  commit=string.gsub(commit,",","ㄝ");
  commit=string.gsub(commit,"[.]","ㄡ");
  commit=string.gsub(commit,"/","ㄥ");
  commit=string.gsub(commit," ","ˉ");
  
  for cand in input:iter() do
    -- cand:get_genuine().preedit = commit    -- 英文編碼
    -- cand:get_genuine().preedit = cand.text -- 首選項
    -- cand:get_genuine().preedit = commit.."".. cand.text ..""  -- 英文編碼 + 首選項
    -- cand:get_genuine().preedit = cand.text.."<".. commit ..""  -- 首選項+英文編碼 # 手機使用
    cand:get_genuine().preedit = cand.text.."\t".. commit ..""  -- 首選項+英文編碼 # 手機使用
    -- cand:get_genuine().preedit = cand.text .."✍" --首选
    yield(cand)
  end
end
return filter

