local f = CreateFrame"Frame"
local dropdown, dropdownInit = CreateFrame( "Frame", "AraBrokerMoneyDD", nil, "UIDropDownMenuTemplate" )
local player = UnitName"player"
local tipshown, config, days, chars, classes, f1, f2, f3, emblemOfFrosts, emblemOfTriumps, emblemOfConquer, emblemOfBrave, emblemOfStrength
local t, sorted, defaultClass = {}, {}, { r=1, g=.8, b=0 }
local ByMoney = function(a,b) return a.money > b.money end
local ByName = function(a,b) return a.name < b.name end
local othersMoney, session, today = 0

local block = LibStub("LibDataBroker-1.1"):NewDataObject("AraMoney", {
	type = "data source",
	icon = "Interface\\Minimap\\Tracking\\Auctioneer",
	OnLeave = function()
		GameTooltipTextLeft1:SetFont( f1, f2, f3 )
		GameTooltipTextRight1:SetFont( f1, f2, f3 )
		tipshown = nil
		return GameTooltip:Hide()
	end,
	OnClick = function(self, button)
		if button == "RightButton" then
			GameTooltip:Hide()
			UIDropDownMenu_Initialize( dropdown, dropdownInit, "MENU" )
			return ToggleDropDownMenu( 1, nil, dropdown, self, 0, 0)
		end
	end
})

local function sortChars(func)
	for k, v in next, sorted do
		t[#t+1], sorted[k], v.name, v.money = v
	end
	for k, v in next, chars do
		local i = tremove(t) or {}
		sorted[#sorted+1], i.name, i.money = i, k, v
	end
	sort( sorted, func )
	return sorted
end

local modes = { "full", "compact", "longText", "midText", "shortText", "color", "dotColor" }

local function GetMoneyText(money, mode)
	return	mode == "full" and ( money < 0 and "-"..GetCoinTextureString(-money, 0) or GetCoinTextureString(money, 0) ) or
		mode == "compact" and floor(money*.0001) or
		mode == "longText" and (
			(money>9999 or money<-9999) and format("%i|cffffd700g|r %.2i|cffc7c7cfs|r %.2i|cffeda55fc|r", floor(money*.0001), floor(money*.01)%100, money%100 ) or
			(money > 99 or money<  -99) and format("%i|cffc7c7cfs|r %.2i|cffeda55fc|r", floor(money*.01), money%100 ) or
			format("%i|cffeda55fc|r", money) ) or
		mode == "midText" and format("%.2f|cffffd700g|r", money*.0001) or
		mode == "shortText" and format("%i|cffffd700g|r", floor(money*.0001) ) or
		(money>9999 or money<-9999) and format(mode=="color"and"|cffffd700%i|r |cffc7c7cf%.2i|r |cffeda55f%.2i|r"or"|cffffd700%i|r.|cffc7c7cf%.2i|r.|cffeda55f%.2i|r", floor(money*.0001), floor(money*.01)%100, money%100 ) or
		(money > 99 or money<  -99) and format(mode=="color"and"|cffc7c7cf%i|r |cffeda55f%.2i|r"or"|cffc7c7cf%i|r.|cffeda55f%.2i|r", floor(money*.01), money%100 ) or
		format("|cffeda55f%i|r", money),
		money <= 0 and 1 or 0, money < 0 and 0 or 1, 0, 1,1,1
end
local icons = {
	"Interface\\Icons\\Inv_Misc_Coin_02",
	"Interface\\PVPFrame\\PVP-ArenaPoints-Icon",
	"Interface\\Icons\\Inv_Jewelry_Necklace_21",
	"Interface\\Icons\\Inv_Jewelry_Amulet_07",
	"Interface\\Icons\\Spell_Nature_EyeOfTheStorm",
	"Interface\\Icons\\INV_Jewelry_Necklace_27",
	"Interface\\Icons\\Inv_Jewelry_Amulet_01",
	"Interface\\Icons\\Inv_Misc_Rune_07",
	"Interface\\Icons\\Inv_Jewelry_Ring_66",
	"Interface\\Icons\\INV_Misc_Coin_16",
	"Interface\\Icons\\INV_Misc_Platnumdisks",
	"Interface\\Icons\\Spell_Holy_ChampionsBond",
	"Interface\\Icons\\Spell_Holy_ProclaimChampion",
	"Interface\\Icons\\Spell_Holy_ProclaimChampion_02",
	"Interface\\Icons\\Spell_Holy_ChampionsGrace",
	"Interface\\Icons\\Spell_Holy_SummonChampion",	
	"Interface\\Icons\\INV_Misc_Gem_Variety_01",
	"Interface\\Icons\\INV_Misc_Ribbon_01",
	"Interface\\Icons\\Ability_Paladin_ArtofWar",
	"Interface\\Icons\\Inv_Misc_Frostemblem_01"
}

block.OnEnter = function(self)
	tipshown = self
	local showBelow = select(2, self:GetCenter()) > UIParent:GetHeight()/2
	GameTooltip:SetOwner( self, "ANCHOR_NONE" )
	GameTooltip:SetPoint( showBelow and "TOP" or "BOTTOM", self, showBelow and "BOTTOM" or "TOP" )
	local text = " "

	local itemCount41596 = GetItemCount("41596")
	local itemCount43016 = GetItemCount("43016")
	local itemCount44990 = GetItemCount("44990")
	local itemCount29434 = GetItemCount("29434")
	if itemCount41596>0 or itemCount43016>0 or itemCount44990>0 then
		GameTooltip:AddLine"기타"
		if itemCount41596>0 then
			local text = format( "%s \124T%s:13\124t", itemCount41596, icons[17])
			GameTooltip:AddDoubleLine("달라란 보석세공사의 징표:", text, 1,1,1, 1,1,1)
		end
		if itemCount43016>0 then
			local text = format( "%s \124T%s:13\124t", itemCount43016, icons[18])
			GameTooltip:AddDoubleLine("달라란 요리상:", text, 1,1,1, 1,1,1)
		end
		if itemCount44990>0 then
			local text = format( "%s \124T%s:13\124t", itemCount44990, icons[19])
			GameTooltip:AddDoubleLine("용사의 인장:", text, 1,1,1, 1,1,1)
		end
		if itemCount29434>0 then
			local text = format( "%s \124T%s:13\124t", itemCount29434, icons[12])
			GameTooltip:AddDoubleLine("정의의 휘장:", text, 1,1,1, 1,1,1)
		end
		GameTooltip:AddLine" "
	end
	
	local itemCount40752 = GetItemCount("40752")
	local itemCount40753 = GetItemCount("40753")
	local itemCount45624 = GetItemCount("45624")
	local itemCount47241 = GetItemCount("47241")
	local itemCount49426 = GetItemCount("49426")

	GameTooltip:AddLine"던전 및 공격대"
	if itemCount29434>0 or itemCount40752>0 or itemCount40753>0 or itemCount45624>0 or itemCount47241>0 or itemCount49426>0 then
		if itemCount49426>0 then
			local text = format( "%s \124T%s:13\124t", itemCount49426, icons[20])
			GameTooltip:AddDoubleLine("서리의 문장:", text, 1,1,1, 1,1,1)
		end
		if itemCount40752>0 then
			local text = format( "%s \124T%s:13\124t", itemCount40752, icons[13])
			GameTooltip:AddDoubleLine("무용의 문장:", text, 1,1,1, 1,1,1)
		end
		if itemCount40753>0 then
			local text = format( "%s \124T%s:13\124t", itemCount40753, icons[14])
			GameTooltip:AddDoubleLine("용맹의 문장:", text, 1,1,1, 1,1,1)
		end
		if itemCount45624>0 then
			local text = format( "%s \124T%s:13\124t", itemCount45624, icons[15])
			GameTooltip:AddDoubleLine("정복의 문장:", text, 1,1,1, 1,1,1)
		end
		if itemCount47241>0 then
			local text = format( "%s \124T%s:13\124t", itemCount47241, icons[16])
			GameTooltip:AddDoubleLine("승전의 문장:", text, 1,1,1, 1,1,1)
		end
		GameTooltip:AddLine" "
	end

	-- Show 서리/승전 for all players
	local t_eof, t_eot, t_eoc, t_eob, t_eos = 0, 0, 0, 0, 0
	for _, char in ipairs(sortChars(ByName)) do
		local class = RAID_CLASS_COLORS[classes[char.name]] or defaultClass
		local eof, eot, eoc, eob, eos = emblemOfFrosts[char.name], emblemOfTriumps[char.name], emblemOfConquer[char.name], emblemOfBrave[char.name], emblemOfStrength[char.name]

		local text = format( "%s \124T%s:13\124t %s \124T%s:13\124t %s \124T%s:13\124t %s \124T%s:13\124t %s \124T%s:13\124t",
					eof, icons[20], eot, icons[16], eoc, icons[15], eob, icons[14], eos, icons[13])
		GameTooltip:AddDoubleLine( char.name, text, class.r, class.g, class.b, 1,1,1)
		t_eof = t_eof + eof
		t_eot = t_eot + eot
		t_eoc = t_eoc + eoc
		t_eob = t_eob + eob
		t_eos = t_eos + eos
	end
	local text2 = format( "%s \124T%s:13\124t %s \124T%s:13\124t %s \124T%s:13\124t %s \124T%s:13\124t %s \124T%s:13\124t",
				t_eof, icons[20], t_eot, icons[16], t_eoc, icons[15], t_eob, icons[14], t_eos, icons[13])
	GameTooltip:AddDoubleLine( "\n전체", "\n"..text2, 1,.8,0, 1,1,1 )

	GameTooltip:AddLine" "
	local itemCountHonor = GetHonorCurrency()
	local itemCount43228 = GetItemCount("43228")
	local itemCount37836 = GetItemCount("37836")
	local itemCountArena = GetArenaCurrency()
	if itemCountHonor>0 or itemCount43228>0 or itemCount37836>0 or itemCountArena>0 then
		GameTooltip:AddLine"플레이어 대 플레이어"
		if itemCountHonor>0 then
			local text = format( "%s \124T%s:13\124t", itemCountHonor, icons[1])
			GameTooltip:AddDoubleLine("명예 점수:", text, 1,1,1, 1,1,1)
		end
		if itemCount43228>0 then
			local text = format( "%s \124T%s:13\124t", itemCount43228, icons[11])
			GameTooltip:AddDoubleLine("바위 문지기의 조각:", text, 1,1,1, 1,1,1)
		end
		if itemCount37836>0 then
			local text = format( "%s \124T%s:13\124t", itemCount37836, icons[10])
			GameTooltip:AddDoubleLine("투자개발회사 주화:", text, 1,1,1, 1,1,1)
		end
		if itemCountArena>0 then
			local text = format( "%s \124T%s:13\124t", itemCountArena, icons[2])
			GameTooltip:AddDoubleLine("투기장 점수:", text, 1,1,1, 1,1,1)
		end
		GameTooltip:AddLine" "
	end
	local itemCount20560 = GetItemCount("20560")
	local itemCount20559 = GetItemCount("20559")
	local itemCount29024 = GetItemCount("29024")
	local itemCount47395 = GetItemCount("47395")
	local itemCount42425 = GetItemCount("42425")
	local itemCount20558 = GetItemCount("20558")
	local itemCount43589 = GetItemCount("43589")
	if itemCount20560>0 or itemCount20559>0 or itemCount29024>0 or itemCount47395>0 or itemCount42425>0  or itemCount20558>0  or itemCount43589>0  then
		GameTooltip:AddLine"명예 훈장"
		if itemCount20560>0 then
			local text = format( "%s \124T%s:13\124t", itemCount20560, icons[3])
			GameTooltip:AddDoubleLine("알터렉 계곡 명예 훈장:", text, 1,1,1, 1,1,1)
		end
		if itemCount20559>0 then
			local text = format( "%s \124T%s:13\124t", itemCount20559, icons[4])
			GameTooltip:AddDoubleLine("아라시 분지 명예 훈장:", text, 1,1,1, 1,1,1)
		end
		if itemCount29024>0 then
			local text = format( "%s \124T%s:13\124t", itemCount29024, icons[5])
			GameTooltip:AddDoubleLine("폭풍의 눈 명예 훈장:", text, 1,1,1, 1,1,1)
		end
		if itemCount47395>0 then
			local text = format( "%s \124T%s:13\124t", itemCount47395, icons[6])
			GameTooltip:AddDoubleLine("정복의 섬 명예 훈장:", text, 1,1,1, 1,1,1)
		end
		if itemCount42425>0 then
			local text = format( "%s \124T%s:13\124t", itemCount42425, icons[7])
			GameTooltip:AddDoubleLine("고대의 해안 명예 훈장:", text, 1,1,1, 1,1,1)
		end
		if itemCount20558>0 then
			local text = format( "%s \124T%s:13\124t", itemCount20558, icons[8])
			GameTooltip:AddDoubleLine("전쟁노래 협곡 명예 훈장:", text, 1,1,1, 1,1,1)
		end
		if itemCount43589>0 then
			local text = format( "%s \124T%s:13\124t", itemCount43589, icons[9])
			GameTooltip:AddDoubleLine("겨울 손아귀 명예 훈장:", text, 1,1,1, 1,1,1)
		end
		GameTooltip:AddLine" "
	end
	GameTooltip:AddLine"소지금 상세정보"
	local total, mode = othersMoney + chars[player], config.tipMode
	GameTooltip:AddDoubleLine( "현재접속",	GetMoneyText( total	   - session, mode ) )
	GameTooltip:AddDoubleLine( "오늘",	GetMoneyText( total	   - days[today], mode ) )
	GameTooltip:AddDoubleLine( "어제",	GetMoneyText( days[today]  - days[today-1], mode ) )
	GameTooltip:AddDoubleLine( "이번주",	GetMoneyText( total	   - days[today-6], mode ) )
	if days[today-29] then
		GameTooltip:AddDoubleLine( "이번달",GetMoneyText( total - days[today-29], mode ) )
	end
	GameTooltip:AddLine" "

	for _, char in ipairs(sortChars(ByName)) do
		local class = RAID_CLASS_COLORS[classes[char.name]] or defaultClass
		GameTooltip:AddDoubleLine( char.name, GetMoneyText(char.money, mode), class.r, class.g, class.b, 1,1,1 )
	end
	GameTooltip:AddDoubleLine( "\n전체", "\n"..GetMoneyText(total, mode), 1,.8,0, 1,1,1 )
	if IsInGuild() then
		GameTooltip:AddDoubleLine( "\n길드은행", "\n"..GetMoneyText(GetGuildBankMoney(), mode), 1,.8,0, 1,1,1 )
	end

	f1, f2, f3 = GameTooltipTextLeft1:GetFont()
	GameTooltipTextLeft1:SetFont( GameTooltipTextLeft2:GetFont() )
	GameTooltipTextRight1:SetFont( GameTooltipTextLeft2:GetFont() )
	return GameTooltip:Show()
end

local function OnEvent(self, event, addon)
	if event ~= "ADDON_LOADED" then
		if not days then return end
		local currentMoney = GetMoney()
		local d = date("*t") -- :'3
		today = (d.year-1970)*365+d.yday+floor((d.year-1973)/4) -- r9
		if not days[today] then
			local oldestDay, oldestMoney = today, othersMoney + currentMoney
			for day, money in next, days do
				if day < oldestDay then oldestDay, oldestMoney = day, money end
			end
			for day, money in next, days do
				if day < today-29 then
					if day > oldestDay then oldestDay, oldestMoney = day, money end
					days[day] = nil
				end
			end
			for i=today-29, today-1 do
				if days[i] then oldestMoney = days[i] else days[i] = oldestMoney end
			end
			days[today] = othersMoney + ( chars[player] or currentMoney )
		end
		chars[player] = currentMoney
		emblemOfFrosts[player] = GetItemCount("49426")
		emblemOfTriumps[player] = GetItemCount("47241")
		emblemOfConquer[player] = GetItemCount("45624")
		emblemOfBrave[player] = GetItemCount("40753")
		emblemOfStrength[player] = GetItemCount("40752")

		if not session then session = othersMoney + currentMoney end
		block.text = GetMoneyText(currentMoney, config.mode)
		return tipshown and block.OnEnter(tipshown)
	elseif addon ~= "Ara_Broker_Money" then return end

	AraBrokerMoneyDB = AraBrokerMoneyDB or {}
	config = AraBrokerMoneyDB
	config.mode = config.mode or "full" -- r5
	config.tipMode = config.tipMode or "full" -- r6
	local realm = GetRealmName()	
	if config.version ~= nil then		-- backward compatibility
		config[realm] = config[realm] or { days={}, chars={}, eofs={}, eots={}, eocs={}, eobs={}, eoss={} }
	else
		config[realm] = { days={}, chars={}, eofs={}, eots={}, eocs={}, eobs={}, eoss={} }
		config.version = 1
	end
	realm = config[realm]
	realm.classes = realm.classes or {}
	days, chars, classes = realm.days, realm.chars, realm.classes
	emblemOfFrosts, emblemOfTriumps, emblemOfConquer, emblemOfBrave, emblemOfStrength = realm.eofs, realm.eots, realm.eocs, realm.eobs, realm.eoss
	for k, v in next, chars do
		if k~=player then othersMoney = othersMoney + v end
	end
	classes[player] = select(2,UnitClass"player")
	return IsLoggedIn() and OnEvent(nil, "")
end

f:SetScript( "OnEvent", OnEvent )

f:RegisterEvent"ADDON_LOADED"
f:RegisterEvent"PLAYER_LOGIN"
f:RegisterEvent"PLAYER_MONEY"
f:RegisterEvent"PLAYER_TRADE_MONEY"
f:RegisterEvent"TRADE_MONEY_CHANGED"
f:RegisterEvent"SEND_MAIL_MONEY_CHANGED"
f:RegisterEvent"SEND_MAIL_COD_CHANGED"

local function RemoveChar(_, char)
	othersMoney, chars[char], classes[char] = othersMoney - chars[char]
	print( "[|cffffb366Ara|rBrokerMoney] |cff40ff40"..char.."|r 의 데이터가 제거되었습니다." )
end

local function SetMode(_, type, mode)
	config[type] = mode
	if type == "mode" then
		block.text = GetMoneyText(chars[player], mode)
	end
end

local options = {
 	{ text = "|cFFFFB366Ara|r Broker Money ("..GetAddOnMetadata( "Ara_Broker_Money", "Version" )..")", isTitle = true },
	{ text = "플러그인 금액 표기 방법",	submenu = "mode" },
	{ text = "툴팁 금액 표기 방법",	submenu = "tipMode" },
	{ text = "다른 케릭터정보 제거",		submenu = "chars" }
}

dropdownInit = function(self, level)
	level = level or 1
	local items, info = level > 1 and UIDROPDOWNMENU_MENU_VALUE or options
	local table = items=="chars" and sortChars(ByName) or (items=="mode" or items=="tipMode") and modes or items
	for _, v in ipairs(table) do
		if not v.name or v.name ~= player then
			info = UIDropDownMenu_CreateInfo()
			if items == "mode" or items == "tipMode" then
				info.checked = config[items] == v
				info.text = GetMoneyText(chars[player], v)
				info.func, info.arg1, info.arg2 = SetMode, items, v
			else
				info.text, info.hasArrow, info.value, info.isTitle = v.text, v.submenu, v.submenu, v.isTitle
				if items == "chars" then
					info.func, info.arg1 = RemoveChar, v.name
					local class = RAID_CLASS_COLORS[classes[v.name]] or defaultClass
					info.text = format("|cff%.2x%.2x%.2x%s|r  ("..GetMoneyText(chars[v.name], config.mode)..")",
						class.r*255, class.g*255, class.b*255, v.name)
				end
			end
			UIDropDownMenu_AddButton( info, level )
		end
	end
end
