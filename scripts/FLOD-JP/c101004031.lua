--ヤジロベーダー
--Yajirovader
--Script by nekrozar
function c101004031.initial_effect(c)
	--self destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c101004031.descon)
	e1:SetOperation(c101004031.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101004031,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101004031.seqcon)
	e3:SetOperation(c101004031.seqop)
	c:RegisterEffect(e3)
	--move
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101004031,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c101004031.mvcon)
	e4:SetTarget(c101004031.mvtg)
	e4:SetOperation(c101004031.mvop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function c101004031.descon(e)
	return e:GetHandler():GetSequence()~=2
end
function c101004031.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c101004031.seqcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function c101004031.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
	local seq=c:GetSequence()
	if seq>4 then return end
	if (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)) then
		local flag=0
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=bit.replace(flag,0x1,seq-1) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=bit.replace(flag,0x1,seq+1) end
		flag=bit.bxor(flag,0xff)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
		local nseq=0
		if s==1 then nseq=0
		elseif s==2 then nseq=1
		elseif s==4 then nseq=2
		elseif s==8 then nseq=3
		else nseq=4 end
		Duel.MoveSequence(c,nseq)
	end
end
function c101004031.mvcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and eg:GetFirst():IsControler(1-tp)
end
function c101004031.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=eg:GetFirst()
	tc:CreateEffectRelation(e)
end
function c101004031.desfilter(c,g)
	return g:IsContains(c)
end
function c101004031.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp)
	 	or not tc:IsRelateToEffect(e) or tc:IsControler(tp) then return end
	local seq1=c:GetSequence()
	local seq2=tc:GetSequence()
	if seq1>4 then return end
	if seq2==5 then seq2=1 end
	if seq2==6 then seq2=3 end
	seq2=4-seq2
	if (seq1>seq2 and Duel.CheckLocation(tp,LOCATION_MZONE,seq1-1))
		or (seq1<seq2 and Duel.CheckLocation(tp,LOCATION_MZONE,seq1+1)) then
		local nseq=0
		if seq1>seq2 and Duel.CheckLocation(tp,LOCATION_MZONE,seq1-1) then nseq=seq1-1
		else nseq=seq1+1 end
		Duel.MoveSequence(c,nseq)
		local cg=c:GetColumnGroup()
		local g=Duel.GetMatchingGroup(c101004031.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,cg)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
