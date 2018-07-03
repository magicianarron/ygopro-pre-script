--銀河の修道師
--Galaxy Cleric
--Script by dest
function c101006010.initial_effect(c)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101006010,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101006010)
	e1:SetTarget(c101006010.mattg)
	e1:SetOperation(c101006010.matop)
	c:RegisterEffect(e1)
	--shuffle & draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101006010,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,101006010)
	e2:SetTarget(c101006010.drtg)
	e2:SetOperation(c101006010.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c101006010.matfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x55) or c:IsSetCard(0x7b)) and c:IsType(TYPE_XYZ)
end
function c101006010.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101006010.matfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101006010.matfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101006010.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101006010.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function c101006010.filter(c)
	return (c:IsSetCard(0x55) or c:IsSetCard(0x7b)) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function c101006010.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101006010.filter(chkc) end
	local g=Duel.GetMatchingGroup(c101006010.filter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=5 and Duel.IsPlayerCanDraw(tp,2) end
	local sg=Group.CreateGroup()
	for i=1,5 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			sg:AddCard(tc)
			g:Remove(Card.IsCode,nil,tc:GetCode())
		end
	end
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c101006010.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=5 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==5 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end