--魔導研究所
--Magic Lab
--Script by nekrozar
function c101005062.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c101005062.ctcon)
	e2:SetOperation(c101005062.ctop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(94243005,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c101005062.thtg)
	e3:SetOperation(c101005062.thop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c101005062.reptg)
	c:RegisterEffect(e4)
end
function c101005062.ctfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
		and bit.band(c:GetPreviousTypeOnField(),TYPE_PENDULUM)~=0 and c:IsPreviousSetCard(0x10d)
end
function c101005062.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101005062.ctfilter,1,nil)
end
function c101005062.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1,2)
end
function c101005062.thfilter1(c,tp)
	local lv=c:GetLevel()
	return (c:IsLocation(LOCATION_DECK) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))) and lv>0 and c:IsCanAddCounter(0x1,1,false,LOCATION_MZONE)
		and Duel.IsCanRemoveCounter(tp,1,0,0x1,lv,REASON_COST) and c:IsAbleToHand()
end
function c101005062.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101005062.thfilter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c101005062.thfilter1,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,tp)
	local lvt={}
	local tc=g:GetFirst()
	while tc do
		local tlv=tc:GetLevel()
		lvt[tlv]=tlv
		tc=g:GetNext()
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101005062,1))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	Duel.RemoveCounter(tp,1,0,0x1,lv,REASON_COST)
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c101005062.thfilter2(c,lv)
	return (c:IsLocation(LOCATION_DECK) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM))) and c:IsCanAddCounter(0x1,1,false,LOCATION_MZONE)
		and c:GetLevel()==lv and c:IsAbleToHand()
end
function c101005062.thop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101005062.thfilter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,lv)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101005062.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_EFFECT) and Duel.IsCanRemoveCounter(tp,1,0,0x1,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.RemoveCounter(tp,1,0,0x1,1,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
