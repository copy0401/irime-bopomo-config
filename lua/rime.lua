-- Usage:
--  engine:
--    ...
--    translators:
--      ...
--      - lua_translator@lua_function3
--      - lua_translator@lua_function4
--      ...
--    filters:
--      ...
--      - lua_filter@lua_function1
--      - lua_filter@lua_function2
--      ...

-- ============== ============== ==============

--十进制转二进制
function Dec2bin(n)
	local t,t1,t2
	local tables={""}
	t=tonumber(n)
	while math.floor(t/2)>=1 do
		t1= math.fmod(t,2)
		if t1>0 then if #tables>0 then table.insert(tables,1,1) else tables[1]=1 end else if #tables>0 then table.insert(tables,1,0) else tables[1]=0 end end
		t=math.floor(t/2)
		if t==1 then if #tables>0 then table.insert(tables,1,1) else tables[1]=1 end end
	end
	return string.gsub(table.concat(tables),"^[0]+","")
end

--2/10/16进制互转
local function system(x,inPuttype,outputtype)
	local r
	if (tonumber(inPuttype)==2) then
		if (tonumber(outputtype) == 10) then  --2进制-->10进制
			r= tonumber(tostring(x), 2)
		elseif (tonumber(outputtype)==16) then  --2进制-->16进制
			r= bin2hex(tostring(x))
		end
	elseif (tonumber(inPuttype)==10) then
		if (tonumber(outputtype)==2) then   --10进制-->2进制
			r= Dec2bin(tonumber(x))
		elseif (tonumber(outputtype)==16) then  --10进制-->16进制
			r= string.format("%x",x)
		end
	elseif (tonumber(inPuttype)==16) then
		if (tonumber(outputtype)==2) then  --16进制-->2进制
			r= Dec2bin(tonumber(tostring(x), 16))
		elseif (tonumber(outputtype)==10) then  --16进制-->10进制
			r= tonumber(tostring(x), 16)
		end
	end
	return r
end

--农历16进制数据分解
local function Analyze(Data)
	local rtn1,rtn2,rtn3,rtn4
	rtn1=system(string.sub(Data,1,3),16,2)
	if string.len(rtn1)<12 then rtn1="0" .. rtn1 end
	rtn2=string.sub(Data,4,4)
	rtn3=system(string.sub(Data,5,5),16,10)
	rtn4=system(string.sub(Data,-2,-1),16,10)
	if string.len(rtn4)==3 then rtn4="0" .. system(string.sub(Data,-2,-1),16,10) end
	--string.gsub(rtn1, "^[0]*", "")
	return {rtn1,rtn2,rtn3,rtn4}
end

--年天数判断
local function IsLeap(y)
	local year=tonumber(y)
	if math.fmod(year,400)~=0 and math.fmod(year,4)==0 or math.fmod(year,400)==0 then return 366
	else return 365 end
end

--计算日期差，两个8位数日期之间相隔的天数，date2>date1
function diffDate(date1,date2)
	local t1,t2,n,total
	total=0 date1=tostring(date1) date2=tostring(date2)
	if tonumber(date2)>tonumber(date1) then
		n=tonumber(string.sub(date2,1,4))-tonumber(string.sub(date1,1,4))
		if n>1 then
			for i=1,n-1 do
				total=total+IsLeap(tonumber(string.sub(date1,1,4))+i)
			end
			total=total+leaveDate(tonumber(string.sub(date2,1,8)))+IsLeap(tonumber(string.sub(date1,1,4)))-leaveDate(tonumber(string.sub(date1,1,8)))
		elseif n==1 then
			total=IsLeap(tonumber(string.sub(date1,1,4)))-leaveDate(tonumber(string.sub(date1,1,8)))+leaveDate(tonumber(string.sub(date2,1,8)))
		else
			total=leaveDate(tonumber(string.sub(date2,1,8)))-leaveDate(tonumber(string.sub(date1,1,8)))
			--print(date1 .. "-" .. date2)
		end
	elseif tonumber(date2)==tonumber(date1) then
		return 0
	else
		return -1
	end
	return total
end

--返回当年过了多少天
function leaveDate(y)
	local day,total
	total=0
	if IsLeap(tonumber(string.sub(y,1,4)))>365 then day={31,29,31,30,31,30,31,31,30,31,30,31}
	else day={31,28,31,30,31,30,31,31,30,31,30,31} end
	if tonumber(string.sub(y,5,6))>1 then
		for i=1,tonumber(string.sub(y,5,6))-1 do total=total+day[i] end
		total=total+tonumber(string.sub(y,7,8))
	else
		return tonumber(string.sub(y,7,8))
	end
	return tonumber(total)
end

--公历转农历，支持转化范围公元1900-2100年
--公历日期 Gregorian:格式 YYYYMMDD
--<返回值>农历日期 中文 天干地支属相
function Date2LunarDate(Gregorian)
	--天干名称
	local cTianGan = {"甲","乙","丙","丁","戊","己","庚","辛","壬","癸"}
	--地支名称
	local cDiZhi = {"子","丑","寅","卯","辰","巳","午", "未","申","酉","戌","亥"}
	--属相名称
    -- local cShuXiang = {"鼠","牛","虎","兔","龙","蛇", "马","羊","猴","鸡","狗","猪"}
	local cShuXiang = {"鼠","牛","虎","兔","龍","蛇", "馬","羊","猴","雞","狗","豬"}
	--农历日期名
	local cDayName ={"初一","初二","初三","初四","初五","初六","初七","初八","初九","初十",
		"十一","十二","十三","十四","十五","十六","十七","十八","十九","二十",
		"廿一","廿二","廿三","廿四","廿五","廿六","廿七","廿八","廿九","三十"}
	--农历月份名
    -- local cMonName = {"正月","二月","三月","四月","五月","六月", "七月","八月","九月","十月","冬月","腊月"}
	local cMonName = {"正月","二月","三月","四月","五月","六月", "七月","八月","九月","十月","冬月","臘月"}
	-- 农历数据
	local wNongliData = {"AB500D2","4BD0883","4AE00DB","A5700D0","54D0581","D2600D8","D9500CC","655147D","56A00D5","9AD00CA","55D027A","4AE00D2"
		,"A5B0682","A4D00DA","D2500CE","D25157E","B5500D6","56A00CC","ADA027B","95B00D3","49717C9","49B00DC","A4B00D0","B4B0580"
		,"6A500D8","6D400CD","AB5147C","2B600D5","95700CA","52F027B","49700D2","6560682","D4A00D9","EA500CE","6A9157E","5AD00D6"
		,"2B600CC","86E137C","92E00D3","C8D1783","C9500DB","D4A00D0","D8A167F","B5500D7","56A00CD","A5B147D","25D00D5","92D00CA"
		,"D2B027A","A9500D2","B550781","6CA00D9","B5500CE","535157F","4DA00D6","A5B00CB","457037C","52B00D4","A9A0883","E9500DA"
		,"6AA00D0","AEA0680","AB500D7","4B600CD","AAE047D","A5700D5","52600CA","F260379","D9500D1","5B50782","56A00D9","96D00CE"
		,"4DD057F","4AD00D7","A4D00CB","D4D047B","D2500D3","D550883","B5400DA","B6A00CF","95A1680","95B00D8","49B00CD","A97047D"
		,"A4B00D5","B270ACA","6A500DC","6D400D1","AF40681","AB600D9","93700CE","4AF057F","49700D7","64B00CC","74A037B","EA500D2"
		,"6B50883","5AC00DB","AB600CF","96D0580","92E00D8","C9600CD","D95047C","D4A00D4","DA500C9","755027A","56A00D1","ABB0781"
		,"25D00DA","92D00CF","CAB057E","A9500D6","B4A00CB","BAA047B","AD500D2","55D0983","4BA00DB","A5B00D0","5171680","52B00D8"
		,"A9300CD","795047D","6AA00D4","AD500C9","5B5027A","4B600D2","96E0681","A4E00D9","D2600CE","EA6057E","D5300D5","5AA00CB"
		,"76A037B","96D00D3","4AB0B83","4AD00DB","A4D00D0","D0B1680","D2500D7","D5200CC","DD4057C","B5A00D4","56D00C9","55B027A"
		,"49B00D2","A570782","A4B00D9","AA500CE","B25157E","6D200D6","ADA00CA","4B6137B","93700D3","49F08C9","49700DB","64B00D0"
		,"68A1680","EA500D7","6AA00CC","A6C147C","AAE00D4","92E00CA","D2E0379","C9600D1","D550781","D4A00D9","DA400CD","5D5057E"
		,"56A00D6","A6C00CB","55D047B","52D00D3","A9B0883","A9500DB","B4A00CF","B6A067F","AD500D7","55A00CD","ABA047C","A5A00D4"
		,"52B00CA","B27037A","69300D1","7330781","6AA00D9","AD500CE","4B5157E","4B600D6","A5700CB","54E047C","D1600D2","E960882"
		,"D5200DA","DAA00CF","6AA167F","56D00D7","4AE00CD","A9D047D","A2D00D4","D1500C9","F250279","D5200D1"
	}
	Gregorian=tostring(Gregorian)
	local Year,Month,Day,Pos,Data0,Data1,MonthInfo,LeapInfo,Leap,Newyear,Data2,Data3,LYear,thisMonthInfo
	Year =tonumber(Gregorian.sub(Gregorian,1,4))  Month =tonumber(Gregorian.sub(Gregorian,5,6))
	Day =tonumber(Gregorian.sub(Gregorian,7,8))
	if (Year>2100 or Year<1899 or Month>12 or Month<1 or Day<1 or Day>31 or string.len(Gregorian)<8) then
        -- return "无效日期"
		return "無效日期"
	end
	--print(Year .. "-" .. Month .. "-" .. Day)
	--获取两百年内的农历数据
	Pos=Year-1900+2  Data0 =wNongliData[Pos-1]  Data1 =wNongliData[Pos]
	--判断农历年份
	local tb1=Analyze(Data1)
	MonthInfo=tb1[1] LeapInfo=tb1[2] Leap=tb1[3] Newyear=tb1[4]
	Date1 =Year .. Newyear  Date2 =Gregorian
	Date3 =diffDate(Date1,Date2)   --和当年农历新年相差的天数
	--print(Date3 .. "-11")
	if (Date3<0) then
		--print(Data0 .. "-2")
		tb1=Analyze(Data0)  Year=Year-1
		MonthInfo=tb1[1] LeapInfo=tb1[2] Leap=tb1[3] Newyear=tb1[4]
		Date1 =Year .. Newyear  Date2=Gregorian
		Date3=diffDate(Date1,Date2)
		--print(Date2 .. "--" .. Date1 .. "--" .. Date3)
	end
	--print(MonthInfo .. "-" .. LeapInfo .. "-" .. Leap .. "-" .. Newyear .. "-" .. Year)
	Date3=Date3+1
	LYear=Year	--农历年份，就是上面计算后的值
	if Leap>0 then	--有闰月
		thisMonthInfo=string.sub(MonthInfo,1,Leap) .. LeapInfo .. string.sub(MonthInfo,Leap+1)
	else
		thisMonthInfo=MonthInfo
	end
	local thisMonth,thisDays,LDay,Isleap,LunarYear,LunarMonth
	for i=1,13 do
		thisMonth=string.sub(thisMonthInfo,i,i)  thisDays=29+thisMonth
		if (Date3>thisDays) then
			Date3=Date3-thisDays
		else
			if (Leap>0) then
				if (Leap>=i) then
					LMonth=i  Isleap=0
				else
					LMonth=i-1
					if i-Leap==1 then Isleap=1 else Isleap=0 end
				end
			else
				LMonth=i  Isleap=0
			end
			LDay=math.floor(Date3)
			break
		end
	end
	--print(LYear .. "-" .. LMonth .. "-" .. LDay)
	if Isleap>0 then
        -- LunarMonth="闰" .. cMonName[LMonth] else LunarMonth=cMonName[LMonth]
        LunarMonth="閏" .. cMonName[LMonth] else LunarMonth=cMonName[LMonth] 
	end
	--print(LDay)
	LunarYear=cTianGan[math.fmod(LYear-4,10)+1] .. cDiZhi[math.fmod(LYear-4,12)+1] .."(" .. cShuXiang[math.fmod(LYear-4,12)+1] .. ")" .. "年" .. LunarMonth .. cDayName[LDay]
	--print(LunarYear)
	return LunarYear
end

--Date日期参数格式YYMMDD，dayCount累加的天数
--返回值：公历日期
local function GettotalDay(Date,dayCount)
	local Year,Month,Day,days,total,t
	Date=tostring(Date)
	Year=tonumber(Date.sub(Date,1,4))
	Month=tonumber(Date.sub(Date,5,6))
	Day=tonumber(Date.sub(Date,7,8))
	if IsLeap(Year)>365 then days={31,29,31,30,31,30,31,31,30,31,30,31}
	else days={31,28,31,30,31,30,31,31,30,31,30,31} end
	if dayCount>days[Month]-Day then
		total=dayCount-days[Month]+Day Month=Month+1
		if Month>12 then Month=Month-12 Year=Year+1 end
		for i=Month,12+Month do
			if IsLeap(Year)>365 then days={31,29,31,30,31,30,31,31,30,31,30,31}
			else days={31,28,31,30,31,30,31,31,30,31,30,31} end
			if i>11 then t=i-12 else t=i end
			--print("<" ..i ..">" ..days[t+1] .. "-".. t+1)
			if (total>days[t+1]) then
				total=total-days[Month]
				Month=Month+1
				if Month>12 then Month=Month-12 Year=Year+1 end
				--print(Month .. "-" ..days[Month])
				--print(Year .. Month .. total)
			else
				break
			end
		end
	else
		total=Day+dayCount
	end
	--if string.len(Month)==1 then Month="0"..Month end
	--if string.len(total)==1 then total="0"..total end
	return Year .. "年" .. Month .. "月" .. total .. "日"
end

--农历转公历
--农历 Gregorian:数字格式 YYYYMMDD
--<返回值>公历日期 格式YYYY年MM月DD日
--农历日期月份为闰月需指定参数IsLeap为1，非闰月需指定参数IsLeap为0
function LunarDate2Date(Gregorian,IsLeap)
	LunarData={"AB500D2","4BD0883",
		"4AE00DB","A5700D0","54D0581","D2600D8","D9500CC","655147D","56A00D5","9AD00CA","55D027A","4AE00D2",
		"A5B0682","A4D00DA","D2500CE","D25157E","B5500D6","56A00CC","ADA027B","95B00D3","49717C9","49B00DC",
		"A4B00D0","B4B0580","6A500D8","6D400CD","AB5147C","2B600D5","95700CA","52F027B","49700D2","6560682",
		"D4A00D9","EA500CE","6A9157E","5AD00D6","2B600CC","86E137C","92E00D3","C8D1783","C9500DB","D4A00D0",
		"D8A167F","B5500D7","56A00CD","A5B147D","25D00D5","92D00CA","D2B027A","A9500D2","B550781","6CA00D9",
		"B5500CE","535157F","4DA00D6","A5B00CB","457037C","52B00D4","A9A0883","E9500DA","6AA00D0","AEA0680",
		"AB500D7","4B600CD","AAE047D","A5700D5","52600CA","F260379","D9500D1","5B50782","56A00D9","96D00CE",
		"4DD057F","4AD00D7","A4D00CB","D4D047B","D2500D3","D550883","B5400DA","B6A00CF","95A1680","95B00D8",
		"49B00CD","A97047D","A4B00D5","B270ACA","6A500DC","6D400D1","AF40681","AB600D9","93700CE","4AF057F",
		"49700D7","64B00CC","74A037B","EA500D2","6B50883","5AC00DB","AB600CF","96D0580","92E00D8","C9600CD",
		"D95047C","D4A00D4","DA500C9","755027A","56A00D1","ABB0781","25D00DA","92D00CF","CAB057E","A9500D6",
		"B4A00CB","BAA047B","AD500D2","55D0983","4BA00DB","A5B00D0","5171680","52B00D8","A9300CD","795047D",
		"6AA00D4","AD500C9","5B5027A","4B600D2","96E0681","A4E00D9","D2600CE","EA6057E","D5300D5","5AA00CB",
		"76A037B","96D00D3","4AB0B83","4AD00DB","A4D00D0","D0B1680","D2500D7","D5200CC","DD4057C","B5A00D4",
		"56D00C9","55B027A","49B00D2","A570782","A4B00D9","AA500CE","B25157E","6D200D6","ADA00CA","4B6137B",
		"93700D3","49F08C9","49700DB","64B00D0","68A1680","EA500D7","6AA00CC","A6C147C","AAE00D4","92E00CA",
		"D2E0379","C9600D1","D550781","D4A00D9","DA400CD","5D5057E","56A00D6","A6C00CB","55D047B","52D00D3",
		"A9B0883","A9500DB","B4A00CF","B6A067F","AD500D7","55A00CD","ABA047C","A5A00D4","52B00CA","B27037A",
		"69300D1","7330781","6AA00D9","AD500CE","4B5157E","4B600D6","A5700CB","54E047C","D1600D2","E960882",
		"D5200DA","DAA00CF","6AA167F","56D00D7","4AE00CD","A9D047D","A2D00D4","D1500C9","F250279","D5200D1"
	}
	Gregorian=tostring(Gregorian)
	local Year,Month,Day,Pos,Data,MonthInfo,LeapInfo,Leap,Newyear,Sum,thisMonthInfo,GDate
	Year=tonumber(Gregorian.sub(Gregorian,1,4))  Month=tonumber(Gregorian.sub(Gregorian,5,6))
	Day=tonumber(Gregorian.sub(Gregorian,7,8))
	if (Year>2100 or Year<1900 or Month>12 or Month<1 or Day>30 or Day<1 or string.len(Gregorian)<8) then
		return "无效日期"
	end

	--获取当年农历数据
	Pos=(Year-1899)+1    Data=LunarData[Pos]
	--print(Data)
	--判断公历日期
	local tb1=Analyze(Data)
	MonthInfo=tb1[1]  LeapInfo=tb1[2]  Leap=tb1[3]  Newyear=tb1[4]
	--计算到当天到当年农历新年的天数
	Sum=0

	if Leap>0 then    --有闰月
		thisMonthInfo=string.sub(MonthInfo,1,Leap) .. LeapInfo .. string.sub(MonthInfo,Leap+1)
		if (Leap~=Month and tonumber(IsLeap)==1) then
			return "该月不是闰月！"
		end
		if (Month<=Leap and tonumber(IsLeap)==0) then
			for i=1,Month-1 do Sum=Sum+29+string.sub(thisMonthInfo,i,i) end
		else
			for i=1,Month do Sum=Sum+29+string.sub(thisMonthInfo,i,i) end
		end
	else
		if (tonumber(IsLeap)==1) then
			return "该年没有闰月！"
		end
		for i=1,Month-1 do
			thisMonthInfo=MonthInfo
			Sum=Sum+29+string.sub(thisMonthInfo,i,i)
		end
	end
	Sum=math.floor(Sum+Day-1)
	GDate=Year .. Newyear
	GDate=GettotalDay(GDate,Sum)

	return GDate
end

-- ============== ============== ==============

local function rqzdx1(a)
-- 日期轉大寫1
--a=1(二〇一九年)、2(六月)、3(二十三日)、12(二〇一九年六月)、23(六月二十三日)、其它為(二〇一九年六月二十三日)
-- 二〇一九年六月二十三日
  result = ""
  number = { [0] = "〇", "一", "二", "三", "四", "五", "六", "七", "八", "九" }
  year0=os.date("%Y")
  for i= 0, 9 do
    year0= string.gsub(year0,i,number[i])
  end
  monthnumber = { [0] = "〇", "一", "二", "三", "四", "五", "六", "七", "八", "九" , "十", "十一", "十二"}
  month0=monthnumber[os.date("%m")*1]
  daynumber = { [0] = "〇", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十", "二十一", "二十二", "二十三", "二十四", "二十五", "二十六", "二十七", "二十八", "二十九", "三十", "三十一" }
  day0=daynumber[os.date("%d")*1]
  if a == 1 then
    result = year0.."年"
  elseif a == 2 then
    result = month0.."月"
  elseif a == 3 then
    result = day0.."日"
  elseif a == 12 then
    result = year0.."年"..month0.."月"
  elseif a == 23 then
    result = month0.."月"..day0.."日"
  else
    result = year0.."年"..month0.."月"..day0.."日"
  end
  return result;
end

local function rqzdx2(a)
-- 日期轉大寫2
-- 貳零零玖年零陸月貳拾叁日
--a=1(貳零壹玖年)、2(零陸月)、3(貳拾叁日)、12(貳零壹玖年零陆月)、23(零陸月貳拾叁日)、其它为(貳零壹玖年零陸月貳拾叁日)
  result = ""
  number = { [0] = "零", "壹", "貳", "叁", "肆", "伍", "陸", "柒", "捌", "玖", "拾" }
  year0=os.date("%Y")
  for i= 0, 9 do
    year0= string.gsub(year0,i,number[i])
  end
-- for i= 1, 4 do
   -- year0=  string.gsub(year0,string.sub(year0,i,1),number[string.sub(year0,i,1)*1])
-- end
  monthnumber = { [0] = "零", "零壹", "零貳", "零叁", "零肆", "零伍", "零陸", "零柒", "零捌", "零玖", "零壹拾", "壹拾壹", "壹拾貳" }
  month0=monthnumber[os.date("%m")*1]
  daynumber = { [0] = "零", "零壹", "零貳", "零叁", "零肆", "零伍", "零陸", "零柒", "零捌", "零玖", "零壹拾", "壹拾壹", "壹拾貳", "壹拾叁", "壹拾肆", "壹拾伍", "壹拾陆", "壹拾柒", "壹拾捌", "壹拾玖", "贰拾", "贰拾壹", "贰拾贰", "贰拾叁", "贰拾肆", "贰拾伍", "贰拾陆", "贰拾柒", "贰拾捌", "贰拾玖", "叁拾", "叁拾壹" }
  day0=daynumber[os.date("%d")*1]
  if a == 1 then
    result = year0.."年"
  elseif a == 2 then
    result = month0.."月"
  elseif a == 3 then
    result = day0.."日"
  elseif a == 12 then
    result = year0.."年"..month0.."月"
  elseif a == 23 then
    result = month0.."月"..day0.."日"
  else
    result = year0.."年"..month0.."月"..day0.."日"
  end
  return result;
end



--- date/t translator `
function t_translator(input, seg)
  if (string.match(input, "`")~=nil) then
  if(input=="`") then
      -- yield(Candidate("date", seg.start, seg._end, "f/y/m/d/w/n/t 擴展模式" , ""))
      yield(Candidate("date", seg.start, seg._end, "y〔年〕" , ""))
      yield(Candidate("date", seg.start, seg._end, "m〔月〕" , ""))
      yield(Candidate("date", seg.start, seg._end, "d〔日〕" , ""))
      yield(Candidate("date", seg.start, seg._end, "w〔週〕" , ""))
      yield(Candidate("date", seg.start, seg._end, "n〔時:分〕" , ""))
      yield(Candidate("date", seg.start, seg._end, "t〔時:分:秒〕" , ""))
      yield(Candidate("date", seg.start, seg._end, "f〔年月日〕" , ""))
      yield(Candidate("date", seg.start, seg._end, "ym〔年月" , ""))
      yield(Candidate("date", seg.start, seg._end, "md〔月日〕" , ""))
      yield(Candidate("date", seg.start, seg._end, "fw〔年月日週〕" , ""))
      yield(Candidate("date", seg.start, seg._end, "mdw〔月日週〕" , ""))
      yield(Candidate("date", seg.start, seg._end, "fn〔年月日 時:分〕" , ""))
      yield(Candidate("date", seg.start, seg._end, "ft〔年月日 時:分:秒〕" , ""))
      yield(Candidate("date", seg.start, seg._end, "*/*/*〔*年*月*日〕" , ""))
      yield(Candidate("date", seg.start, seg._end, "*/*〔*月*日〕" , ""))
      yield(Candidate("date", seg.start, seg._end, "*-*-*〔*年*月*日" , ""))
      yield(Candidate("date", seg.start, seg._end, "*-*〔*月*日〕" , ""))
      return
  end
  if (input == "`gza") then
    yield(Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), " 現在時間 (時:分:秒)"))
    -- yield(Candidate("time", seg.start, seg._end, os.date("%H:%M"), " 現在時間 (時:分) ~m"))
    return
  end

  if (input == "`tm") then
    yield(Candidate("time", seg.start, seg._end, os.date("%H:%M"), " 現在時間 (時:分)"))
    return
  end

  if (input == "`n") then
    yield(Candidate("time", seg.start, seg._end, os.date("%H:%M"), " 現在時間 (時:分)"))
    -- yield(Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), " 現在時間 (時:分:秒) ~s"))
    return
  end

  -- if (input == "`ns") then
  --   yield(Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), " 現在時間 (時:分:秒)"))
  --   return
  -- end

  if (input == "`f") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d"), "〔年月日〕 ~s"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), "〔年月日〕 ~c"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d"), "〔年月日〕 ~d"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), "〔年月日〕 ~m"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y_%m_%d"), "〔年月日〕 ~u"))
    yield(Candidate("date", seg.start, seg._end, rqzdx1(), "〔年月日〕 ~z"))
    return
  end

-- 年月日 
  if (input == "`smb") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d"), "〔年月日〕 ~s"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), "〔年月日〕 ~c"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d"), "〔年月日〕 ~d"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), "〔年月日〕 ~m"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y_%m_%d"), "〔年月日〕 ~u"))
    yield(Candidate("date", seg.start, seg._end, rqzdx1(), "〔年月日〕 ~z"))
    return
  end

  if (input == "`s") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d"), "〔年月日〕 ~s"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), "〔年月日〕 ~c"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d"), "〔年月日〕 ~d"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), "〔年月日〕 ~m"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y_%m_%d"), "〔年月日〕 ~u"))
    yield(Candidate("date", seg.start, seg._end, rqzdx1(), "〔年月日〕 ~z"))
    return
  end


  if (input == "`b") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d"), "〔年月日〕 ~s"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), "〔年月日〕 ~c"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d"), "〔年月日〕 ~d"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), "〔年月日〕 ~m"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y_%m_%d"), "〔年月日〕 ~u"))
    yield(Candidate("date", seg.start, seg._end, rqzdx1(), "〔年月日〕 ~z"))
    return
  end

  if (input == "`fc") then
    yield(Candidate("date", seg.start, seg._end, os.date(" %Y 年 %m 月 %d 日"), "〔年月日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date(" %d 日 %m 月 %Y 年"), "〔日月年〕"))
    yield(Candidate("date", seg.start, seg._end, os.date(" %m 月 %d 日 %Y 年"), "〔月日年〕"))
    return
  end

  if (input == "`fd") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d"), "〔年月日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d%m%Y"), "〔日月年〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m%d%Y"), "〔月日年〕"))
    return
  end

  if (input == "`fm") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), "〔年月日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d-%m-%Y"), "〔日月年〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m-%d-%Y"), "〔月日年〕"))
    return
  end

  if (input == "`fs") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d"), "〔年月日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d/%m/%Y"), "〔日月年〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m/%d/%Y"), "〔月日年〕"))
    return
  end

  if (input == "`fu") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y_%m_%d"), "〔年月日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d_%m_%Y"), "〔日月年〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m_%d_%Y"), "〔月日年〕"))
    return
  end

  if (input == "`fz") then
    yield(Candidate("date", seg.start, seg._end, rqzdx1(), "〔年月日〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx2(), "〔年月日〕"))
    return
  end

  if (input == "`fn") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日 %H:%M"), "〔年月日 時:分〕 ~c"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d %H:%M"), "〔年月日 時:分〕 ~d"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d %H:%M"), "〔年月日 時:分〕 ~s"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d %H:%M"), "〔年月日 時:分〕 ~m"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y_%m_%d %H:%M"), "〔年月日 時:分〕 ~u"))
    yield(Candidate("date", seg.start, seg._end, rqzdx1().." "..os.date("%H:%M"), "〔年月日 時:分〕 ~z"))
    return
  end

  if (input == "`fnc") then
    yield(Candidate("date", seg.start, seg._end, os.date(" %Y 年 %m 月 %d 日  %H : %M"), "〔年月日 時:分〕"))
    yield(Candidate("date", seg.start, seg._end, os.date(" %d 日 %m 月 %Y 年  %H : %M"), "〔日月年 時:分〕"))
    yield(Candidate("date", seg.start, seg._end, os.date(" %m 月 %d 日 %Y 年  %H : %M"), "〔月日年 時:分〕"))
    return
  end

  if (input == "`fnd") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d %H:%M"), "〔年月日 時:分〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d%m%Y %H:%M"), "〔日月年 時:分〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m%d%Y %H:%M"), "〔月日年 時:分〕"))
    return
  end

  if (input == "`fns") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d %H:%M"), "〔年月日 時:分〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d/%m/%Y %H:%M"), "〔日月年 時:分〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m/%d/%Y %H:%M"), "〔月日年 時:分〕"))
    return
  end

  if (input == "`fnm") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d %H:%M"), "〔年月日 時:分〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d-%m-%Y %H:%M"), "〔日月年 時:分〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m-%d-%Y %H:%M"), "〔月日年 時:分〕"))
    return
  end

  if (input == "`fnu") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y_%m_%d %H:%M"), "〔年月日 時:分〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d_%m_%Y %H:%M"), "〔日月年 時:分〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m_%d_%Y %H:%M"), "〔月日年 時:分〕"))
    return
  end

  if (input == "`fnz") then
    yield(Candidate("date", seg.start, seg._end, rqzdx1().." "..os.date("%H:%M"), "〔年月日 時:分〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx2().." "..os.date("%H:%M"), "〔年月日 時:分〕"))
    return
  end

  if (input == "`ft") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日 %H:%M:%S"), "〔年月日 時:分:秒〕 ~c"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d %H:%M:%S"), "〔年月日 時:分:秒〕 ~d"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d %H:%M:%S"), "〔年月日 時:分:秒〕 ~s"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d %H:%M:%S"), "〔年月日 時:分:秒〕 ~m"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y_%m_%d %H:%M:%S"), "〔年月日 時:分:秒〕 ~u"))
    yield(Candidate("date", seg.start, seg._end, rqzdx1().." "..os.date("%H:%M:%S"), "〔年月日 時:分:秒〕 ~z"))
    return
  end

  if (input == "`ftc") then
    yield(Candidate("date", seg.start, seg._end, os.date(" %Y 年 %m 月 %d 日  %H : %M : %S"), "〔年月日 時:分:秒〕"))
    yield(Candidate("date", seg.start, seg._end, os.date(" %d 日 %m 月 %Y 年  %H : %M : %S"), "〔日月年 時:分:秒〕"))
    yield(Candidate("date", seg.start, seg._end, os.date(" %m 月 %d 日 %Y 年  %H : %M : %S"), "〔月日年 時:分:秒〕"))
    return
  end

  if (input == "`ftd") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d %H:%M:%S"), "〔年月日 時:分:秒〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d%m%Y %H:%M:%S"), "〔日月年 時:分:秒〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m%d%Y %H:%M:%S"), "〔月日年 時:分:秒〕"))
    return
  end

  if (input == "`fts") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d %H:%M:%S"), "〔年月日 時:分:秒〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d/%m/%Y %H:%M:%S"), "〔日月年 時:分:秒〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m/%d/%Y %H:%M:%S"), "〔月日年 時:分:秒〕"))
    return
  end

  if (input == "`ftm") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d %H:%M:%S"), "〔年月日 時:分:秒〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d-%m-%Y %H:%M:%S"), "〔日月年 時:分:秒〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m-%d-%Y %H:%M:%S"), "〔月日年 時:分:秒〕"))
    return
  end

  if (input == "`ftu") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y_%m_%d %H:%M:%S"), "〔年月日 時:分:秒〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d_%m_%Y %H:%M:%S"), "〔日月年 時:分:秒〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m_%d_%Y %H:%M:%S"), "〔月日年 時:分:秒〕"))
    return
  end

  if (input == "`ftz") then
    yield(Candidate("date", seg.start, seg._end, rqzdx1().." "..os.date("%H:%M:%S"), "〔年月日 時:分:秒〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx2().." "..os.date("%H:%M:%S"), "〔年月日 時:分:秒〕"))
    return
  end

  if (input == "`y") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y年"), "〔年〕"))
    yield(Candidate("date", seg.start, seg._end, os.date(" %Y 年"), "〔年〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y"), "〔年〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx1(1), "〔年〕 ~z"))
    -- yield(Candidate("date", seg.start, seg._end, rqzdx2(1), "〔年〕"))
    return
  end

  if (input == "`yz") then
    yield(Candidate("date", seg.start, seg._end, rqzdx1(1), "〔年〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx2(1), "〔年〕"))
    return
  end

  if (input == "`m") then
    yield(Candidate("date", seg.start, seg._end, os.date("%m月"), "〔月〕"))
    yield(Candidate("date", seg.start, seg._end, os.date(" %m 月"), "〔月〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m"), "〔月〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx1(2), "〔月〕 ~z"))
    -- yield(Candidate("date", seg.start, seg._end, rqzdx2(2), "〔月〕"))
    return
  end

  if (input == "`mz") then
    yield(Candidate("date", seg.start, seg._end, rqzdx1(2), "〔月〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx2(2), "〔月〕"))
    return
  end

  if (input == "`d") then
    yield(Candidate("date", seg.start, seg._end, os.date("%d日"), "〔日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date(" %d 日"), "〔日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d"), "〔日〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx1(3), "〔日〕 ~z"))
    -- yield(Candidate("date", seg.start, seg._end, rqzdx2(3), "〔日〕"))
    return
  end

  if (input == "`dz") then
    yield(Candidate("date", seg.start, seg._end, rqzdx1(3), "〔日〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx2(3), "〔日〕"))
    return
  end

  if (input == "`md") then
    yield(Candidate("date", seg.start, seg._end, os.date("%m月%d日"), "〔月日〕 ~c"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m%d"), "〔月日〕 ~d"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m/%d"), "〔月日〕 ~s"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m-%d"), "〔月日〕 ~m"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m_%d"), "〔月日〕 ~u"))
    yield(Candidate("date", seg.start, seg._end, rqzdx1(23), "〔月日〕 ~z"))
    return
  end

  if (input == "`mdc") then
    yield(Candidate("date", seg.start, seg._end, os.date(" %m 月 %d 日"), "〔月日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date(" %d 日 %m 月"), "〔日月〕"))
    return
  end

  if (input == "`mdd") then
    yield(Candidate("date", seg.start, seg._end, os.date("%m%d"), "〔月日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d%m"), "〔日月〕"))
    return
  end

  if (input == "`mds") then
    yield(Candidate("date", seg.start, seg._end, os.date("%m/%d"), "〔月日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d/%m"), "〔日月〕"))
    return
  end

  if (input == "`mdm") then
    yield(Candidate("date", seg.start, seg._end, os.date("%m-%d"), "〔月日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d-%m"), "〔日月〕"))
    return
  end

  if (input == "`mdu") then
    yield(Candidate("date", seg.start, seg._end, os.date("%m_%d"), "〔月日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d_%m"), "〔日月〕"))
    return
  end

  if (input == "`mdz") then
    yield(Candidate("date", seg.start, seg._end, rqzdx1(23), "〔月日〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx2(23), "〔月日〕"))
    return
  end

  if (input == "`mdw") then
    if (os.date("%w") == "0") then
      weekstr = "日"
    end
    if (os.date("%w") == "1") then
      weekstr = "一"
    end
    if (os.date("%w") == "2") then
      weekstr = "二"
    end
    if (os.date("%w") == "3") then
      weekstr = "三"
    end
    if (os.date("%w") == "4") then
      weekstr = "四"
    end
    if (os.date("%w") == "5") then
      weekstr = "五"
    end
    if (os.date("%w") == "6") then
      weekstr = "六"
    end
    yield(Candidate("date", seg.start, seg._end, os.date("%m月%d日").." ".."星期"..weekstr.." ", "〔月日週〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx1(23).." ".."星期"..weekstr.." ", "〔月日週〕 ~z"))
    -- yield(Candidate("date", seg.start, seg._end, rqzdx2(23).." ".."星期"..weekstr.." ", "〔月日週〕"))
    return
  end

  if (input == "`mdwz") then
    if (os.date("%w") == "0") then
      weekstr = "日"
    end
    if (os.date("%w") == "1") then
      weekstr = "一"
    end
    if (os.date("%w") == "2") then
      weekstr = "二"
    end
    if (os.date("%w") == "3") then
      weekstr = "三"
    end
    if (os.date("%w") == "4") then
      weekstr = "四"
    end
    if (os.date("%w") == "5") then
      weekstr = "五"
    end
    if (os.date("%w") == "6") then
      weekstr = "六"
    end
    yield(Candidate("date", seg.start, seg._end, rqzdx1(23).." ".."星期"..weekstr.." ", "〔月日週〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx2(23).." ".."星期"..weekstr.." ", "〔月日週〕"))
    return
  end

  if (input == "`ym") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月"), "〔年月〕 ~c"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y%m"), "〔年月〕 ~d"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m"), "〔年月〕 ~s"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m"), "〔年月〕 ~m"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y_%m"), "〔年月〕 ~u"))
    yield(Candidate("date", seg.start, seg._end, rqzdx1(12), "〔年月〕 ~z"))
    return
  end

  if (input == "`ymc") then
    yield(Candidate("date", seg.start, seg._end, os.date(" %Y 年 %m 月"), "〔年月〕"))
    yield(Candidate("date", seg.start, seg._end, os.date(" %m 月 %Y 年"), "〔月年〕"))
    return
  end

  if (input == "`ymd") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y%m"), "〔年月〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m%Y"), "〔月年〕"))
    return
  end

  if (input == "`yms") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m"), "〔年月〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m/%Y"), "〔月年〕"))
    return
  end

  if (input == "`ymm") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m"), "〔年月〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m-%Y"), "〔月年〕"))
    return
  end

  if (input == "`ymu") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y_%m"), "〔年月〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m_%Y"), "〔月年〕"))
    return
  end

  if (input == "`ymz") then
    yield(Candidate("date", seg.start, seg._end, rqzdx1(12), "〔年月〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx2(12), "〔年月〕"))
    return
  end

-- function week_translator0(input, seg)
  if (input == "`w") then
    if (os.date("%w") == "0") then
      weekstr = "日"
    end
    if (os.date("%w") == "1") then
      weekstr = "一"
    end
    if (os.date("%w") == "2") then
      weekstr = "二"
    end
    if (os.date("%w") == "3") then
      weekstr = "三"
    end
    if (os.date("%w") == "4") then
      weekstr = "四"
    end
    if (os.date("%w") == "5") then
      weekstr = "五"
    end
    if (os.date("%w") == "6") then
      weekstr = "六"
    end
    yield(Candidate("qsj", seg.start, seg._end, " ".."星期"..weekstr.." ", "〔週〕"))
    return
  end
-- function week_translator1(input, seg)
  if (input == "`fw") then
    if (os.date("%w") == "0") then
      weekstr = "日"
    end
    if (os.date("%w") == "1") then
       weekstr = "一"
    end
    if (os.date("%w") == "2") then
      weekstr = "二"
    end
    if (os.date("%w") == "3") then
      weekstr = "三"
    end
    if (os.date("%w") == "4") then
      weekstr = "四"
    end
    if (os.date("%w") == "5") then
      weekstr = "五"
    end
    if (os.date("%w") == "6") then
      weekstr = "六"
    end
    yield(Candidate("qsj", seg.start, seg._end, os.date("%Y年%m月%d日").." ".."星期"..weekstr.." ", "〔年月日週〕"))
    yield(Candidate("qsj", seg.start, seg._end, rqzdx1().." ".."星期"..weekstr.." ", "〔年月日週〕 ~z"))
    -- yield(Candidate("qsj", seg.start, seg._end, rqzdx2().." ".."星期"..weekstr.." ", "〔年月日週〕"))
    return
  end

  if (input == "`fwz") then
    if (os.date("%w") == "0") then
      weekstr = "日"
    end
    if (os.date("%w") == "1") then
       weekstr = "一"
    end
    if (os.date("%w") == "2") then
      weekstr = "二"
    end
    if (os.date("%w") == "3") then
      weekstr = "三"
    end
    if (os.date("%w") == "4") then
      weekstr = "四"
    end
    if (os.date("%w") == "5") then
      weekstr = "五"
    end
    if (os.date("%w") == "6") then
      weekstr = "六"
    end
    yield(Candidate("qsj", seg.start, seg._end, rqzdx1().." ".."星期"..weekstr.." ", "〔年月日週〕"))
    yield(Candidate("qsj", seg.start, seg._end, rqzdx2().." ".."星期"..weekstr.." ", "〔年月日週〕"))
    return
  end
-- function week_translator2(input, seg)
  if (input == "`fwt") then
    if (os.date("%w") == "0") then
      weekstr = "日"
    end
    if (os.date("%w") == "1") then
      weekstr = "一"
    end
    if (os.date("%w") == "2") then
      weekstr = "二"
    end
    if (os.date("%w") == "3") then
      weekstr = "三"
    end
    if (os.date("%w") == "4") then
      weekstr = "四"
    end
    if (os.date("%w") == "5") then
      weekstr = "五"
    end
    if (os.date("%w") == "6") then
      weekstr = "六"
    end
    yield(Candidate("qsj", seg.start, seg._end, os.date("%Y年%m月%d日").." ".."星期"..weekstr.." "..os.date("%H:%M:%S"), "〔年月日週 時:分:秒〕"))
    yield(Candidate("qsj", seg.start, seg._end, rqzdx1().." ".."星期"..weekstr.." "..os.date("%H:%M:%S"), "〔年月日週 時:分:秒〕 ~z"))
    -- yield(Candidate("qsj", seg.start, seg._end, rqzdx2().." ".."星期"..weekstr.." "..os.date("%H:%M:%S"), "〔年月日週 時:分:秒〕"))
    return
  end

  if (input == "`fwtz") then
    if (os.date("%w") == "0") then
      weekstr = "日"
    end
    if (os.date("%w") == "1") then
      weekstr = "一"
    end
    if (os.date("%w") == "2") then
      weekstr = "二"
    end
    if (os.date("%w") == "3") then
      weekstr = "三"
    end
    if (os.date("%w") == "4") then
      weekstr = "四"
    end
    if (os.date("%w") == "5") then
      weekstr = "五"
    end
    if (os.date("%w") == "6") then
      weekstr = "六"
    end
    yield(Candidate("qsj", seg.start, seg._end, rqzdx1().." ".."星期"..weekstr.." "..os.date("%H:%M:%S"), "〔年月日週 時:分:秒〕"))
    yield(Candidate("qsj", seg.start, seg._end, rqzdx2().." ".."星期"..weekstr.." "..os.date("%H:%M:%S"), "〔年月日週 時:分:秒〕"))
    return
  end
-- function week_translator3(input, seg)
  if (input == "`fwn") then
    if (os.date("%w") == "0") then
      weekstr = "日"
    end
    if (os.date("%w") == "1") then
      weekstr = "一"
    end
    if (os.date("%w") == "2") then
      weekstr = "二"
    end
    if (os.date("%w") == "3") then
      weekstr = "三"
    end
    if (os.date("%w") == "4") then
      weekstr = "四"
    end
    if (os.date("%w") == "5") then
      weekstr = "五"
    end
    if (os.date("%w") == "6") then
      weekstr = "六"
    end
    yield(Candidate("qsj", seg.start, seg._end, os.date("%Y年%m月%d日").." ".."星期"..weekstr.." "..os.date("%H:%M"), "〔年月日週 時:分〕"))
    yield(Candidate("qsj", seg.start, seg._end, rqzdx1().." ".."星期"..weekstr.." "..os.date("%H:%M"), "〔年月日週 時:分〕 ~z"))
    -- yield(Candidate("qsj", seg.start, seg._end, rqzdx2().." ".."星期"..weekstr.." "..os.date("%H:%M"), "〔年月日週 時:分〕"))
    return
  end

  if (input == "`fwnz") then
    if (os.date("%w") == "0") then
      weekstr = "日"
    end
    if (os.date("%w") == "1") then
      weekstr = "一"
    end
    if (os.date("%w") == "2") then
      weekstr = "二"
    end
    if (os.date("%w") == "3") then
      weekstr = "三"
    end
    if (os.date("%w") == "4") then
      weekstr = "四"
    end
    if (os.date("%w") == "5") then
      weekstr = "五"
    end
    if (os.date("%w") == "6") then
      weekstr = "六"
    end
    yield(Candidate("qsj", seg.start, seg._end, rqzdx1().." ".."星期"..weekstr.." "..os.date("%H:%M"), "〔年月日週 時:分〕"))
    yield(Candidate("qsj", seg.start, seg._end, rqzdx2().." ".."星期"..weekstr.." "..os.date("%H:%M"), "〔年月日週 時:分〕"))
    return
  end

  y, m, d = string.match(input, "`(%d+)/(%d?%d)/(%d?%d)$")
  if(y~=nil) then
    yield(Candidate("date", seg.start, seg._end, y.."年"..m.."月"..d.."日" , " 日期"))
    return
  end

  m, d = string.match(input, "`(%d?%d)/(%d?%d)$")
  if(m~=nil) then
    yield(Candidate("date", seg.start, seg._end, m.."月"..d.."日" , " 日期"))
    return
  end

  y, m, d = string.match(input, "`(%d+)-(%d?%d)-(%d?%d)$")
  if(y~=nil) then
    yield(Candidate("date", seg.start, seg._end, y.."年"..m.."月"..d.."日" , "〔日期〕"))
    return
  end

  m, d = string.match(input, "`(%d?%d)-(%d?%d)$")
  if(m~=nil) then
    yield(Candidate("date", seg.start, seg._end, m.."月"..d.."日" , "〔日期〕"))
    return
  end

  end
end

--- date/t2 translator '/
function t2_translator(input, seg)
  if (string.match(input, "'/")~=nil) then
      -- Candidate(type, start, end, text, comment)
  if (input == "'/t") then
    yield(Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), "〔時:分:秒〕"))
    -- yield(Candidate("time", seg.start, seg._end, os.date("%H:%M"), "〔時:分〕 ~m"))
    return
  end

  -- if (input == "'/tm") then
  --   yield(Candidate("time", seg.start, seg._end, os.date("%H:%M"), "〔時:分〕"))
  --   return
  -- end

  if (input == "'/n") then
    yield(Candidate("time", seg.start, seg._end, os.date("%H:%M"), "〔時:分〕"))
    -- yield(Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), "〔時:分:秒〕 ~s"))
    return
  end

  -- if (input == "'/ns") then
  --   yield(Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), "〔時:分:秒〕"))
  --   return
  -- end

  if (input == "'/f") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), "〔年月日〕 ~c"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d"), "〔年月日〕 ~d"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d"), "〔年月日〕 ~s"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), "〔年月日〕 ~m"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y_%m_%d"), "〔年月日〕 ~u"))
    yield(Candidate("date", seg.start, seg._end, rqzdx1(), "〔年月日〕 ~z"))
    return
  end

  if (input == "'/fc") then
    yield(Candidate("date", seg.start, seg._end, os.date(" %Y 年 %m 月 %d 日"), "〔年月日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date(" %d 日 %m 月 %Y 年"), "〔日月年〕"))
    yield(Candidate("date", seg.start, seg._end, os.date(" %m 月 %d 日 %Y 年"), "〔月日年〕"))
    return
  end

  if (input == "'/fd") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d"), "〔年月日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d%m%Y"), "〔日月年〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m%d%Y"), "〔月日年〕"))
    return
  end

  if (input == "'/fm") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), "〔年月日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d-%m-%Y"), "〔日月年〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m-%d-%Y"), "〔月日年〕"))
    return
  end

  if (input == "'/fs") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d"), "〔年月日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d/%m/%Y"), "〔日月年〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m/%d/%Y"), "〔月日年〕"))
    return
  end

  if (input == "'/fu") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y_%m_%d"), "〔年月日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d_%m_%Y"), "〔日月年〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m_%d_%Y"), "〔月日年〕"))
    return
  end

  if (input == "'/fz") then
    yield(Candidate("date", seg.start, seg._end, rqzdx1(), "〔年月日〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx2(), "〔年月日〕"))
    return
  end

  if (input == "'/fn") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日 %H:%M"), "〔年月日 時:分〕 ~c"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d %H:%M"), "〔年月日 時:分〕 ~d"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d %H:%M"), "〔年月日 時:分〕 ~s"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d %H:%M"), "〔年月日 時:分〕 ~m"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y_%m_%d %H:%M"), "〔年月日 時:分〕 ~u"))
    yield(Candidate("date", seg.start, seg._end, rqzdx1().." "..os.date("%H:%M"), "〔年月日 時:分〕 ~z"))
    return
  end

  if (input == "'/fnc") then
    yield(Candidate("date", seg.start, seg._end, os.date(" %Y 年 %m 月 %d 日  %H : %M"), "〔年月日 時:分〕"))
    yield(Candidate("date", seg.start, seg._end, os.date(" %d 日 %m 月 %Y 年  %H : %M"), "〔日月年 時:分〕"))
    yield(Candidate("date", seg.start, seg._end, os.date(" %m 月 %d 日 %Y 年  %H : %M"), "〔月日年 時:分〕"))
    return
  end

  if (input == "'/fnd") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d %H:%M"), "〔年月日 時:分〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d%m%Y %H:%M"), "〔日月年 時:分〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m%d%Y %H:%M"), "〔月日年 時:分〕"))
    return
  end

  if (input == "'/fns") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d %H:%M"), "〔年月日 時:分〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d/%m/%Y %H:%M"), "〔日月年 時:分〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m/%d/%Y %H:%M"), "〔月日年 時:分〕"))
    return
  end

  if (input == "'/fnm") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d %H:%M"), "〔年月日 時:分〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d-%m-%Y %H:%M"), "〔日月年 時:分〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m-%d-%Y %H:%M"), "〔月日年 時:分〕"))
    return
  end

  if (input == "'/fnu") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y_%m_%d %H:%M"), "〔年月日 時:分〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d_%m_%Y %H:%M"), "〔日月年 時:分〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m_%d_%Y %H:%M"), "〔月日年 時:分〕"))
    return
  end

  if (input == "'/fnz") then
    yield(Candidate("date", seg.start, seg._end, rqzdx1().." "..os.date("%H:%M"), "〔年月日 時:分〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx2().." "..os.date("%H:%M"), "〔年月日 時:分〕"))
    return
  end

  if (input == "'/ft") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日 %H:%M:%S"), "〔年月日 時:分:秒〕 ~c"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d %H:%M:%S"), "〔年月日 時:分:秒〕 ~d"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d %H:%M:%S"), "〔年月日 時:分:秒〕 ~s"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d %H:%M:%S"), "〔年月日 時:分:秒〕 ~m"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y_%m_%d %H:%M:%S"), "〔年月日 時:分:秒〕 ~u"))
    yield(Candidate("date", seg.start, seg._end, rqzdx1().." "..os.date("%H:%M:%S"), "〔年月日 時:分:秒〕 ~z"))
    return
  end

  if (input == "'/ftc") then
    yield(Candidate("date", seg.start, seg._end, os.date(" %Y 年 %m 月 %d 日  %H : %M : %S"), "〔年月日 時:分:秒〕"))
    yield(Candidate("date", seg.start, seg._end, os.date(" %d 日 %m 月 %Y 年  %H : %M : %S"), "〔日月年 時:分:秒〕"))
    yield(Candidate("date", seg.start, seg._end, os.date(" %m 月 %d 日 %Y 年  %H : %M : %S"), "〔月日年 時:分:秒〕"))
    return
  end

  if (input == "'/ftd") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d %H:%M:%S"), "〔年月日 時:分:秒〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d%m%Y %H:%M:%S"), "〔日月年 時:分:秒〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m%d%Y %H:%M:%S"), "〔月日年 時:分:秒〕"))
    return
  end

  if (input == "'/fts") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d %H:%M:%S"), "〔年月日 時:分:秒〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d/%m/%Y %H:%M:%S"), "〔日月年 時:分:秒〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m/%d/%Y %H:%M:%S"), "〔月日年 時:分:秒〕"))
    return
  end

  if (input == "'/ftm") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d %H:%M:%S"), "〔年月日 時:分:秒〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d-%m-%Y %H:%M:%S"), "〔日月年 時:分:秒〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m-%d-%Y %H:%M:%S"), "〔月日年 時:分:秒〕"))
    return
  end

  if (input == "'/ftu") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y_%m_%d %H:%M:%S"), "〔年月日 時:分:秒〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d_%m_%Y %H:%M:%S"), "〔日月年 時:分:秒〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m_%d_%Y %H:%M:%S"), "〔月日年 時:分:秒〕"))
    return
  end

  if (input == "'/ftz") then
    yield(Candidate("date", seg.start, seg._end, rqzdx1().." "..os.date("%H:%M:%S"), "〔年月日 時:分:秒〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx2().." "..os.date("%H:%M:%S"), "〔年月日 時:分:秒〕"))
    return
  end

  if (input == "'/y") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y年"), "〔年〕"))
    yield(Candidate("date", seg.start, seg._end, os.date(" %Y 年"), "〔年〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y"), "〔年〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx1(1), "〔年〕 ~z"))
    -- yield(Candidate("date", seg.start, seg._end, rqzdx2(1), "〔年〕"))
    return
  end

  if (input == "'/yz") then
    yield(Candidate("date", seg.start, seg._end, rqzdx1(1), "〔年〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx2(1), "〔年〕"))
    return
  end

  if (input == "'/m") then
    yield(Candidate("date", seg.start, seg._end, os.date("%m月"), "〔月〕"))
    yield(Candidate("date", seg.start, seg._end, os.date(" %m 月"), "〔月〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m"), "〔月〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx1(2), "〔月〕 ~z"))
    -- yield(Candidate("date", seg.start, seg._end, rqzdx2(2), "〔月〕"))
    return
  end

  if (input == "'/mz") then
    yield(Candidate("date", seg.start, seg._end, rqzdx1(2), "〔月〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx2(2), "〔月〕"))
    return
  end

  if (input == "'/d") then
    yield(Candidate("date", seg.start, seg._end, os.date("%d日"), "〔日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date(" %d 日"), "〔日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d"), "〔日〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx1(3), "〔日〕 ~z"))
    -- yield(Candidate("date", seg.start, seg._end, rqzdx2(3), "〔日〕"))
    return
  end

  if (input == "'/dz") then
    yield(Candidate("date", seg.start, seg._end, rqzdx1(3), "〔日〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx2(3), "〔日〕"))
    return
  end

  if (input == "'/md") then
    yield(Candidate("date", seg.start, seg._end, os.date("%m月%d日"), "〔月日〕 ~c"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m%d"), "〔月日〕 ~d"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m/%d"), "〔月日〕 ~s"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m-%d"), "〔月日〕 ~m"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m_%d"), "〔月日〕 ~u"))
    yield(Candidate("date", seg.start, seg._end, rqzdx1(23), "〔月日〕 ~z"))
    return
  end

  if (input == "'/mdc") then
    yield(Candidate("date", seg.start, seg._end, os.date(" %m 月 %d 日"), "〔月日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date(" %d 日 %m 月"), "〔日月〕"))
    return
  end

  if (input == "'/mdd") then
    yield(Candidate("date", seg.start, seg._end, os.date("%m%d"), "〔月日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d%m"), "〔日月〕"))
    return
  end

  if (input == "'/mds") then
    yield(Candidate("date", seg.start, seg._end, os.date("%m/%d"), "〔月日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d/%m"), "〔日月〕"))
    return
  end

  if (input == "'/mdm") then
    yield(Candidate("date", seg.start, seg._end, os.date("%m-%d"), "〔月日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d-%m"), "〔日月〕"))
    return
  end

  if (input == "'/mdu") then
    yield(Candidate("date", seg.start, seg._end, os.date("%m_%d"), "〔月日〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%d_%m"), "〔日月〕"))
    return
  end

  if (input == "'/mdz") then
    yield(Candidate("date", seg.start, seg._end, rqzdx1(23), "〔月日〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx2(23), "〔月日〕"))
    return
  end

  if (input == "'/mdw") then
    if (os.date("%w") == "0") then
      weekstr = "日"
    end
    if (os.date("%w") == "1") then
      weekstr = "一"
    end
    if (os.date("%w") == "2") then
      weekstr = "二"
    end
    if (os.date("%w") == "3") then
      weekstr = "三"
    end
    if (os.date("%w") == "4") then
      weekstr = "四"
    end
    if (os.date("%w") == "5") then
      weekstr = "五"
    end
    if (os.date("%w") == "6") then
      weekstr = "六"
    end
    yield(Candidate("date", seg.start, seg._end, os.date("%m月%d日").." ".."星期"..weekstr.." ", "〔月日週〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx1(23).." ".."星期"..weekstr.." ", "〔月日週〕 ~z"))
    -- yield(Candidate("date", seg.start, seg._end, rqzdx2(23).." ".."星期"..weekstr.." ", "〔月日週〕"))
    return
  end

  if (input == "'/mdwz") then
    if (os.date("%w") == "0") then
      weekstr = "日"
    end
    if (os.date("%w") == "1") then
      weekstr = "一"
    end
    if (os.date("%w") == "2") then
      weekstr = "二"
    end
    if (os.date("%w") == "3") then
      weekstr = "三"
    end
    if (os.date("%w") == "4") then
      weekstr = "四"
    end
    if (os.date("%w") == "5") then
      weekstr = "五"
    end
    if (os.date("%w") == "6") then
      weekstr = "六"
    end
    yield(Candidate("date", seg.start, seg._end, rqzdx1(23).." ".."星期"..weekstr.." ", "〔月日週〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx2(23).." ".."星期"..weekstr.." ", "〔月日週〕"))
    return
  end

  if (input == "'/ym") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月"), "〔年月〕 ~c"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y%m"), "〔年月〕 ~d"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m"), "〔年月〕 ~s"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m"), "〔年月〕 ~m"))
    yield(Candidate("date", seg.start, seg._end, os.date("%Y_%m"), "〔年月〕 ~u"))
    yield(Candidate("date", seg.start, seg._end, rqzdx1(12), "〔年月〕 ~z"))
    return
  end

  if (input == "'/ymc") then
    yield(Candidate("date", seg.start, seg._end, os.date(" %Y 年 %m 月"), "〔年月〕"))
    yield(Candidate("date", seg.start, seg._end, os.date(" %m 月 %Y 年"), "〔月年〕"))
    return
  end

  if (input == "'/ymd") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y%m"), "〔年月〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m%Y"), "〔月年〕"))
    return
  end

  if (input == "'/yms") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y/%m"), "〔年月〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m/%Y"), "〔月年〕"))
    return
  end

  if (input == "'/ymm") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m"), "〔年月〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m-%Y"), "〔月年〕"))
    return
  end

  if (input == "'/ymu") then
    yield(Candidate("date", seg.start, seg._end, os.date("%Y_%m"), "〔年月〕"))
    yield(Candidate("date", seg.start, seg._end, os.date("%m_%Y"), "〔月年〕"))
    return
  end

  if (input == "'/ymz") then
    yield(Candidate("date", seg.start, seg._end, rqzdx1(12), "〔年日〕"))
    yield(Candidate("date", seg.start, seg._end, rqzdx2(12), "〔年日〕"))
    return
  end

-- function week_translator0(input, seg)
  if (input == "'/w") then
    if (os.date("%w") == "0") then
      weekstr = "日"
    end
    if (os.date("%w") == "1") then
      weekstr = "一"
    end
    if (os.date("%w") == "2") then
      weekstr = "二"
    end
    if (os.date("%w") == "3") then
      weekstr = "三"
    end
    if (os.date("%w") == "4") then
      weekstr = "四"
    end
    if (os.date("%w") == "5") then
      weekstr = "五"
    end
    if (os.date("%w") == "6") then
      weekstr = "六"
    end
    yield(Candidate("qsj", seg.start, seg._end, " ".."星期"..weekstr.." ", "〔週〕"))
    return
  end
-- function week_translator1(input, seg)
  if (input == "'/fw") then
    if (os.date("%w") == "0") then
      weekstr = "日"
    end
    if (os.date("%w") == "1") then
       weekstr = "一"
    end
    if (os.date("%w") == "2") then
      weekstr = "二"
    end
    if (os.date("%w") == "3") then
      weekstr = "三"
    end
    if (os.date("%w") == "4") then
      weekstr = "四"
    end
    if (os.date("%w") == "5") then
      weekstr = "五"
    end
    if (os.date("%w") == "6") then
      weekstr = "六"
    end
    yield(Candidate("qsj", seg.start, seg._end, os.date("%Y年%m月%d日").." ".."星期"..weekstr.." ", "〔年月日週〕"))
    yield(Candidate("qsj", seg.start, seg._end, rqzdx1().." ".."星期"..weekstr.." ", "〔年月日週〕 ~z"))
    -- yield(Candidate("qsj", seg.start, seg._end, rqzdx2().." ".."星期"..weekstr.." ", "〔年月日週〕"))
    return
  end

  if (input == "'/fwz") then
    if (os.date("%w") == "0") then
      weekstr = "日"
    end
    if (os.date("%w") == "1") then
       weekstr = "一"
    end
    if (os.date("%w") == "2") then
      weekstr = "二"
    end
    if (os.date("%w") == "3") then
      weekstr = "三"
    end
    if (os.date("%w") == "4") then
      weekstr = "四"
    end
    if (os.date("%w") == "5") then
      weekstr = "五"
    end
    if (os.date("%w") == "6") then
      weekstr = "六"
    end
    yield(Candidate("qsj", seg.start, seg._end, rqzdx1().." ".."星期"..weekstr.." ", "〔年月日週〕"))
    yield(Candidate("qsj", seg.start, seg._end, rqzdx2().." ".."星期"..weekstr.." ", "〔年月日週〕"))
    return
  end
-- function week_translator2(input, seg)
  if (input == "'/fwt") then
    if (os.date("%w") == "0") then
      weekstr = "日"
    end
    if (os.date("%w") == "1") then
      weekstr = "一"
    end
    if (os.date("%w") == "2") then
      weekstr = "二"
    end
    if (os.date("%w") == "3") then
      weekstr = "三"
    end
    if (os.date("%w") == "4") then
      weekstr = "四"
    end
    if (os.date("%w") == "5") then
      weekstr = "五"
    end
    if (os.date("%w") == "6") then
      weekstr = "六"
    end
    yield(Candidate("qsj", seg.start, seg._end, os.date("%Y年%m月%d日").." ".."星期"..weekstr.." "..os.date("%H:%M:%S"), "〔年月日週 時:分:秒〕"))
    yield(Candidate("qsj", seg.start, seg._end, rqzdx1().." ".."星期"..weekstr.." "..os.date("%H:%M:%S"), "〔年月日週 時:分:秒〕 ~z"))
    -- yield(Candidate("qsj", seg.start, seg._end, rqzdx2().." ".."星期"..weekstr.." "..os.date("%H:%M:%S"), "〔年月日週 時:分:秒〕"))
    return
  end

  if (input == "'/fwtz") then
    if (os.date("%w") == "0") then
      weekstr = "日"
    end
    if (os.date("%w") == "1") then
      weekstr = "一"
    end
    if (os.date("%w") == "2") then
      weekstr = "二"
    end
    if (os.date("%w") == "3") then
      weekstr = "三"
    end
    if (os.date("%w") == "4") then
      weekstr = "四"
    end
    if (os.date("%w") == "5") then
      weekstr = "五"
    end
    if (os.date("%w") == "6") then
      weekstr = "六"
    end
    yield(Candidate("qsj", seg.start, seg._end, rqzdx1().." ".."星期"..weekstr.." "..os.date("%H:%M:%S"), "〔年月日週 時:分:秒〕"))
    yield(Candidate("qsj", seg.start, seg._end, rqzdx2().." ".."星期"..weekstr.." "..os.date("%H:%M:%S"), "〔年月日週 時:分:秒〕"))
    return
  end
-- function week_translator3(input, seg)
  if (input == "'/fwn") then
    if (os.date("%w") == "0") then
      weekstr = "日"
    end
    if (os.date("%w") == "1") then
      weekstr = "一"
    end
    if (os.date("%w") == "2") then
      weekstr = "二"
    end
    if (os.date("%w") == "3") then
      weekstr = "三"
    end
    if (os.date("%w") == "4") then
      weekstr = "四"
    end
    if (os.date("%w") == "5") then
      weekstr = "五"
    end
    if (os.date("%w") == "6") then
      weekstr = "六"
    end
    yield(Candidate("qsj", seg.start, seg._end, os.date("%Y年%m月%d日").." ".."星期"..weekstr.." "..os.date("%H:%M"), "〔年月日週 時:分〕"))
    yield(Candidate("qsj", seg.start, seg._end, rqzdx1().." ".."星期"..weekstr.." "..os.date("%H:%M"), "〔年月日週 時:分〕 ~z"))
    -- yield(Candidate("qsj", seg.start, seg._end, rqzdx2().." ".."星期"..weekstr.." "..os.date("%H:%M"), "〔年月日週 時:分〕"))
    return
  end

  if (input == "'/fwnz") then
    if (os.date("%w") == "0") then
      weekstr = "日"
    end
    if (os.date("%w") == "1") then
      weekstr = "一"
    end
    if (os.date("%w") == "2") then
      weekstr = "二"
    end
    if (os.date("%w") == "3") then
      weekstr = "三"
    end
    if (os.date("%w") == "4") then
      weekstr = "四"
    end
    if (os.date("%w") == "5") then
      weekstr = "五"
    end
    if (os.date("%w") == "6") then
      weekstr = "六"
    end
    yield(Candidate("qsj", seg.start, seg._end, rqzdx1().." ".."星期"..weekstr.." "..os.date("%H:%M"), "〔年月日週 時:分〕"))
    yield(Candidate("qsj", seg.start, seg._end, rqzdx2().." ".."星期"..weekstr.." "..os.date("%H:%M"), "〔年月日週 時:分〕"))
    return
  end

  if(input=="'/") then
    -- yield(Candidate("date", seg.start, seg._end, "f/y/m/d/w/n/t 擴展模式" , ""))
    yield(Candidate("date", seg.start, seg._end, "y〔年〕" , ""))
    yield(Candidate("date", seg.start, seg._end, "m〔月〕" , ""))
    yield(Candidate("date", seg.start, seg._end, "d〔日〕" , ""))
    yield(Candidate("date", seg.start, seg._end, "w〔週〕" , ""))
    yield(Candidate("date", seg.start, seg._end, "n〔時:分〕" , ""))
    yield(Candidate("date", seg.start, seg._end, "t〔時:分:秒〕" , ""))
    yield(Candidate("date", seg.start, seg._end, "f〔年月日〕" , ""))
    yield(Candidate("date", seg.start, seg._end, "ym〔年月" , ""))
    yield(Candidate("date", seg.start, seg._end, "md〔月日〕" , ""))
    yield(Candidate("date", seg.start, seg._end, "fw〔年月日週〕" , ""))
    yield(Candidate("date", seg.start, seg._end, "mdw〔月日週〕" , ""))
    yield(Candidate("date", seg.start, seg._end, "fn〔年月日 時:分〕" , ""))
    yield(Candidate("date", seg.start, seg._end, "ft〔年月日 時:分:秒〕" , ""))
    yield(Candidate("date", seg.start, seg._end, "*/*/*〔 * 年 * 月 * 日〕" , ""))
    yield(Candidate("date", seg.start, seg._end, "*/*〔 * 月 * 日〕" , ""))
    yield(Candidate("date", seg.start, seg._end, "*-*-*〔*年*月*日" , ""))
    yield(Candidate("date", seg.start, seg._end, "*-*〔*月*日〕" , ""))
    -- yield(Candidate("date", seg.start, seg._end, "┃ f〔年月日〕┇ ym〔年月〕┇ md〔月日〕┇ fw〔年月日週〕┇ mdw〔月日週〕" , ""))
    -- yield(Candidate("date", seg.start, seg._end, "┃ y〔年〕┇ m〔月〕┇ d〔日〕┇ w〔週〕┇ n〔時:分〕┇ t〔時:分:秒〕" , ""))
    -- yield(Candidate("date", seg.start, seg._end, "┃ fn〔年月日 時:分〕┇ ft〔年月日 時:分:秒〕" , ""))
    -- yield(Candidate("date", seg.start, seg._end, "┃ fwn〔年月日週 時:分〕┇ fwt〔年月日週 時:分:秒〕" , ""))
    -- yield(Candidate("date", seg.start, seg._end, "┃ */*/*〔 * 年 * 月 * 日〕┇ */*〔 * 月 * 日〕" , ""))
    -- yield(Candidate("date", seg.start, seg._end, "┃ *-*-*〔*年*月*日〕┇ *-*〔*月*日〕" , ""))
    return
  end

  y, m, d = string.match(input, "'/(%d+)/(%d?%d)/(%d?%d)$")
  if(y~=nil) then
    yield(Candidate("date", seg.start, seg._end, " "..y.." 年 "..m.." 月 "..d.." 日" , "〔日期〕"))
    return
  end

  m, d = string.match(input, "'/(%d?%d)/(%d?%d)$")
  if(m~=nil) then
    yield(Candidate("date", seg.start, seg._end, " "..m.." 月 "..d.." 日" , "〔日期〕"))
    return
  end

  y, m, d = string.match(input, "'/(%d+)-(%d?%d)-(%d?%d)$")
  if(y~=nil) then
    yield(Candidate("date", seg.start, seg._end, y.."年"..m.."月"..d.."日" , "〔日期〕"))
    return
  end

  m, d = string.match(input, "'/(%d?%d)-(%d?%d)$")
  if(m~=nil) then
    yield(Candidate("date", seg.start, seg._end, m.."月"..d.."日" , "〔日期〕"))
    return
  end

  end
end

--- date/time translator ``
function date_translator(input, seg)
  if (string.match(input, "``")~=nil) then
    yield(Candidate("date", seg.start, seg._end, "" , "擴充模式"))
    if (input == "``fn" or input == "``") then
      if (os.date("%w") == "0") then
        weekstr = "日"
      end
      if (os.date("%w") == "1") then
        weekstr = "一"
      end
      if (os.date("%w") == "2") then
        weekstr = "二"
      end
      if (os.date("%w") == "3") then
        weekstr = "三"
      end
      if (os.date("%w") == "4") then
        weekstr = "四"
      end
      if (os.date("%w") == "5") then
        weekstr = "五"
      end
      if (os.date("%w") == "6") then
        weekstr = "六"
      end
      yield(Candidate("	", seg.start, seg._end, os.date("%Y/%m/%d("..weekstr..")"), "日期"))
      yield(Candidate("	", seg.start, seg._end, os.date("%H:%M:%S"), "時間"))
      yield(Candidate("	", seg.start, seg._end, Date2LunarDate(os.date("%Y%m%d")), "農曆"))
      yield(Candidate("	", seg.start, seg._end, "\t" , "tab"))
      yield(Candidate("	", seg.start, seg._end, "\n" , "tab"))
      yield(Candidate("	", seg.start, seg._end, "```" , "markdown"))
      yield(Candidate("	", seg.start, seg._end, "#"   , "yaml")) 
      yield(Candidate("	", seg.start, seg._end, "--"  , "lua")) 
      yield(Candidate("	", seg.start, seg._end, "//"  , "c")) 
      yield(Candidate("	", seg.start, seg._end, "default.yaml"  , "iRime")) 
      yield(Candidate("	", seg.start, seg._end, "default.custom.yaml"  , "iRime"))
      yield(Candidate("	", seg.start, seg._end, "SharedSupport"  , "iRime")) 
      yield(Candidate("	", seg.start, seg._end, "sync"  , "iRime")) 
      yield(Candidate("	", seg.start, seg._end, "sync_dir"  , "iRime")) 
      yield(Candidate("	", seg.start, seg._end, "squirrel"  , "iRime")) 
      yield(Candidate("	", seg.start, seg._end, "iRime"  , "iRime")) 
      yield(Candidate("	", seg.start, seg._end, "installation.yaml"  , "iRime")) 
      yield(Candidate("	", seg.start, seg._end, "installation_id"  , "iRime")) 
      yield(Candidate("	", seg.start, seg._end, ".dict.yaml"  , "iRime")) 
      yield(Candidate("	", seg.start, seg._end, "方案名.custom.yaml"  , "iRime")) 
      yield(Candidate("	", seg.start, seg._end, "方案名.schema.yaml"  , "iRime")) 
      yield(Candidate("	", seg.start, seg._end, "方案名.userdb.txt"  , "iRime")) 
      yield(Candidate("	", seg.start, seg._end, "/theme/你的主題/port/theme.yaml"  , "iRime")) 
      return
    end

    if (input == "``q") then
      yield(Candidate("	", seg.start, seg._end, "	" , "TAB")) 
      return
    end

    if (input == "``w") then
      yield(Candidate("	", seg.start, seg._end, "	" , "TAB")) 
      return
    end

    if (input == "``t") then
      yield(Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), " 現在時間 (時:分:秒)"))
      return
    end

    if (input == "``g") then
      yield(Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), " 現在時間 (時:分:秒)"))
      return
    end
	
    y, m, d = string.match(input, "``(%d+)/(%d?%d)/(%d?%d)$")
    if(y~=nil) then
      yield(Candidate("date", seg.start, seg._end, y.."年"..m.."月"..d.."日" , " 日期"))
      return
    end
    m, d = string.match(input, "``(%d?%d)/(%d?%d)$")
    if(m~=nil) then
      yield(Candidate("date", seg.start, seg._end, m.."月"..d.."日" , " 日期"))
      return
    end
	
  end
end


--- charset filter
charset = {
   ["CJK"] = { first = 0x4E00, last = 0x9FFF },
   ["ExtA"] = { first = 0x3400, last = 0x4DBF },
   ["ExtB"] = { first = 0x20000, last = 0x2A6DF },
   ["ExtC"] = { first = 0x2A700, last = 0x2B73F },
   ["ExtD"] = { first = 0x2B740, last = 0x2B81F },
   ["ExtE"] = { first = 0x2B820, last = 0x2CEAF },
   ["ExtF"] = { first = 0x2CEB0, last = 0x2EBEF },
   ["Compat"] = { first = 0x2F800, last = 0x2FA1F } }

function exists(single_filter, text)
  for i in utf8.codes(text) do
     local c = utf8.codepoint(text, i)
     if (not single_filter(c)) then
  return false
     end
  end
  return true
end

function is_charset(s)
   return function (c)
      return c >= charset[s].first and c <= charset[s].last
   end
end

function is_cjk_ext(c)
   return is_charset("ExtA")(c) or is_charset("ExtB")(c) or
      is_charset("ExtC")(c) or is_charset("ExtD")(c) or
      is_charset("ExtE")(c) or is_charset("ExtF")(c) or
      is_charset("Compat")(c)
end

function charset_filter(input)
   for cand in input:iter() do
      if (not exists(is_cjk_ext, cand.text))
      then
         yield(cand)
      end
   end
end

--- charset filter2 把 opencc 轉換成「᰼」(或某個符號)，再用 lua 功能去除「᰼」
-- charset2 = {
--    ["Deletesymbol"] = { first = 0x1C3C } }

-- function exists2(single_filter2, text)
--   for i in utf8.codes(text) do
--      local c = utf8.codepoint(text, i)
--      if (not single_filter2(c)) then
--   return false
--      end
--   end
--   return true
-- end

-- function is_charset2(s)
--    return function (c)
--       return c == charset2[s].first
--    end
-- end

-- function is_symbol_ext(c)
--    return is_charset2("Deletesymbol")(c)
-- end

-- function charset_filter2(input)
--    for cand in input:iter() do
--       if (not exists2(is_symbol_ext, cand.text))
--       then
--         yield(cand)
--       end
--    end
-- end

function charset_filter2(input)
   for cand in input:iter() do
      if (not string.find(cand.text, '᰼' ))
      -- if (not string.find(cand.text, '.*᰼.*' ))
        then
        yield(cand)
      end
   end
end

--- charset comment filter
function charset_comment_filter(input)
   for cand in input:iter() do
      for s, r in pairs(charset) do
   if (exists(is_charset(s), cand.text)) then
      cand:get_genuine().comment = cand.comment .. " " .. s
      break
   end
      end
      yield(cand)
   end
end


--- single_char_filter
function single_char_filter(input)
   local l = {}
   for cand in input:iter() do
      if (utf8.len(cand.text) == 1) then
   yield(cand)
      else
   table.insert(l, cand)
      end
   end
   for i, cand in ipairs(l) do
      yield(cand)
   end
end

--- reverse_lookup_filter
-- bopomo_onion.extended.reverse.bin
-- cangjie5.reverse.bin
-- liur_TradToSimp.reverse.bin
-- liur_Trad.reverse.bin
pydb = ReverseDb("build/terra_pinyin.reverse.bin")

-- liudb = ReverseDb("build/liur_Trad.reverse.bin")
-- liudb = ReverseDb("build/liur.extended.reverse.bin")
liudb = ReverseDb("build/openxiami.extended.reverse.bin")

--- 將讀音 轉換顯示格式   zhi4 改 zhì
function xform_py(inp) 
   if inp == "" then return "" end
   inp = string.gsub(inp, "([aeiou])(ng?)([1234])", "%1%3%2")
   inp = string.gsub(inp, "([aeiou])(r)([1234])", "%1%3%2")
   inp = string.gsub(inp, "([aeo])([iuo])([1234])", "%1%3%2")
   inp = string.gsub(inp, "a1", "ā")
   inp = string.gsub(inp, "a2", "á")
   inp = string.gsub(inp, "a3", "ǎ")
   inp = string.gsub(inp, "a4", "à")
   inp = string.gsub(inp, "e1", "ē")
   inp = string.gsub(inp, "e2", "é")
   inp = string.gsub(inp, "e3", "ě")
   inp = string.gsub(inp, "e4", "è")
   inp = string.gsub(inp, "o1", "ō")
   inp = string.gsub(inp, "o2", "ó")
   inp = string.gsub(inp, "o3", "ǒ")
   inp = string.gsub(inp, "o4", "ò")
   inp = string.gsub(inp, "i1", "ī")
   inp = string.gsub(inp, "i2", "í")
   inp = string.gsub(inp, "i3", "ǐ")
   inp = string.gsub(inp, "i4", "ì")
   inp = string.gsub(inp, "u1", "ū")
   inp = string.gsub(inp, "u2", "ú")
   inp = string.gsub(inp, "u3", "ǔ")
   inp = string.gsub(inp, "u4", "ù")
   inp = string.gsub(inp, "v1", "ǖ")
   inp = string.gsub(inp, "v2", "ǘ")
   inp = string.gsub(inp, "v3", "ǚ")
   inp = string.gsub(inp, "v4", "ǜ")
   inp = string.gsub(inp, "([nljqxy])v", "%1ü")
   inp = string.gsub(inp, "eh[0-5]?", "ê")
   return "(" .. inp .. ")"
end

--- 將讀音 轉換顯示格式   zhi4 改 zhì
function xform_liu(inp) 
   if inp == "" then return "" end
   inp = string.upper(inp)
   return "(" .. inp .. ")"
end


--- reverse_lookup_filter 使用方式
--- engine/filters 加行  - lua_filter@reverse_lookup_filter
function reverse_lookup_filter(input)
   for cand in input:iter() do
      -- cand:get_genuine().comment = cand.comment .. " " .. xform_py(pydb:lookup(cand.text))
      cand:get_genuine().comment = cand.comment .. " " .. xform_liu(liudb:lookup(cand.text))
      yield(cand)
   end
end


--- composition
function myfilter(input)
   local input2 = Translation(charset_comment_filter, input)
   reverse_lookup_filter(input2)
end

function mytranslator(input, seg)
   date_translator(input, seg)
   time_translator(input, seg)
end

calculator_translator = require("calculator_translator")
preedit_preview = require("preedit_preview")
preedit_preview2 = require("preedit_preview2")
-- add_tag = require("add_tag")
-- quad_filter = require("quad_filter")


-- module1={
--   {module = "command"    , module_name = "cammand_proc"    , name_space = "command" },
--   {module = "conjunctive", module_name = "conjunctive_proc", name_space = "conjunctive"},
-- }
--
-- init_processor= require 'init_processor'