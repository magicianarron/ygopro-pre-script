--DDD深淵王ビルガメス
--D/D/D Abyss King Gilgamesh
--Script by nekrozar
function c100235066.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xaf),2)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100235066,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,100235066)
	e1:SetTarget(c100235066.settg)
	e1:SetOperation(c100235066.setop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100235066,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,100235166)
	e2:SetCondition(c100235066.spcon)
	e2:SetTarget(c100235066.sptg)
	e2:SetOperation(c100235066.spop)
	c:RegisterEffect(e2)
end
function c100235066.setfilter1(c,tp)
	return c:IsSetCard(0xaf) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(c100235066.setfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c100235066.setfilter2(c,code)
	return c:IsSetCard(0xaf) and not c:IsCode(code) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c100235066.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)
		and Duel.IsExistingMatchingCard(c100235066.setfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function c100235066.setop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100235066.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) or not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g1=Duel.SelectMatchingCard(tp,c100235066.setfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc1=g1:GetFirst()
	if not tc1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g2=Duel.SelectMatchingCard(tp,c100235066.setfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
	local tc2=g2:GetFirst()
	Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.Damage(tp,1000,REASON_EFFECT)
end
function c100235066.splimit(e,c)
	return not c:IsSetCard(0xaf)
end
function c100235066.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsPreviousLocation(LOCATION_MZONE)
		and (c:IsReason(REASON_EFFECT) and rp==1-tp or c:IsReason(REASON_BATTLE) and Duel.GetAttacker():IsControler(1-tp))
end
function c100235066.spfilter(c,e,tp)
	return c:IsSetCard(0xaf) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100235066.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if chk==0 then return loc~=0 and Duel.IsExistingMatchingCard(c100235066.spfilter,tp,loc,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function c100235066.spop(e,tp,eg,ep,ev,re,r,rp)
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100235066.spfilter),tp,loc,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
