--フォーマッド・スキッパー
--Formud Skipper
--Scripted by Eerie Code
function c100225002.initial_effect(c)
	--link tag
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100225002,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100225002)
	e1:SetTarget(c100225002.target)
	e1:SetOperation(c100225002.operation)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCode(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,100225102)
	e2:SetCondition(c100225002.thcon)
	e2:SetTarget(c100225002.thtg)
	e2:SetOperation(c100225002.thop)
	c:RegisterEffect(e2)
end
function c100225002.cfilter(c,tc)
	return c:IsType(TYPE_LINK) and not c:IsCode(tc:GetLinkCode())
end
function c100225002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100225002.filter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
end
function c100225002.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c100225002.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
	if cg:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,cg)
	local code1,code2=cg:GetFirst():GetOriginalCodeRule()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_LINK_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(code1)
	c:RegisterEffect(e1)
	if code2 then
		local e2=e1:Clone()
		e2:SetValue(code2)
		c:RegisterEffect(e2)
	end
	local e3=e1:Clone()
	e3:SetCode(EFFECT_ADD_LINK_ATTRIBUTE)
	e3:SetValue(cg:GetFirst():GetOriginalAttribute())
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_ADD_LINK_RACE)
	e4:SetValue(cg:GetFirst():GetOriginalRace())
	c:RegisterEffect(e4)
end
function c100225002.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_LINK)
end
function c100225002.thfilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsLevelAbove(5) and c:IsAbleToHand()
end
function c100225002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100225002.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100225002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100225002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
