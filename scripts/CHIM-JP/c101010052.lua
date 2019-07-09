--転生炎獣の超転生

--Scripted by nekrozar
function c101010052.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101010052+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101010052.target)
	e1:SetOperation(c101010052.activate)
	c:RegisterEffect(e1)
end
function c101010052.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x119) and c:IsType(TYPE_LINK)
		and Duel.IsExistingMatchingCard(c101010052.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_LMATERIAL)
end
function c101010052.filter2(c,e,tp,mc)
	return c:IsSetCard(0x119) and c:IsType(TYPE_LINK) and c:IsCode(mc:GetCode()) and mc:IsCanBeLinkMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function c101010052.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101010052.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101010052.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c101010052.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101010052.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 or not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_LMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010052.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		sc:SetMaterial(Group.FromCards(tc))
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_MATERIAL+REASON_LINK)
		Duel.SpecialSummon(sc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
