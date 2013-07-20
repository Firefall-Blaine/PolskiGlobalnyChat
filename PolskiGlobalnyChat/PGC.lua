require "math";
require "string";
require "lib/lib_InterfaceOptions"
require "lib/lib_Slash"

--CONSTANTS
local FRAME = Component.GetFrame("Main");
local CONT= Component.GetWidget("CONTAINER");
local g_ScrollAmount=0;
local topOffset=0;
local chatMode=false;
local PGCtoggle = false;
local SLASH_CMDS = {};
local blinkCallback = nil;
local numerID = "0";
local LP=0;

--InterfaceOptions.StartGroup({label="Ustawienia Chatu", checkbox=true, id="Ustawienia Chatu", default=true});

InterfaceOptions.AddTextInput({id="NumerID", label="NumerID:", default=numerID, maxlen=128, whitespace=false});

--InterfaceOptions.StopGroup();

InterfaceOptions.AddMovableFrame({
	frame = FRAME,
	label = "PGC",
	scalable = true,
})

function OnComponentLoad()
--Component.SetInputMode("cursor");

	--FRAME:Show(true);

	autoUpdate(10);
	InterfaceOptions.SetCallbackFunc(function(id, val)
		log("setcallback: "..tostring(id.."->"..val))	
		if(id=="NumerID") then 
		numerID = val
		end
	end, "PGC")
	
	
	createWG("PGC System", "Witam w Polskiej Globalnej Chacie");	
	
	--local SLOT = MESSAGE:GetChild("FocusBox");
--SLOT:BindEvent("OnMouseDown", function() log("mouseDown") end);	
--SLOT:SetFocus();
	    --GLFRAME:SetText("text testowygggggggg gggggggggggggggggggggggggggggggggghhhhhhh hhhhhhhhhhhh sdfssdfgsdfg dsfgsdfgsdfgsdfg sdfgsdfgsgseghsdh sdhserhsehaehaehsrh awehgaerhaerhaerhaerha arehaerhaerhareharsh adrhaerh hhhhhhhhhhh hhhhhhhffffff fffffffff ffffffff fffffffffffffff ffffjjjjjjjj jjjjjjjjj jjjjjjjjjjjjjjjjjjjjjjj jjjjjjjjjjjfffff fffffffffffffffff fffuuuuuuuuuuuu uuuuuu uuuuuuuuuuuuuuuu uuuuuuuuuuuuuuu uuuuuueeeeeeeeeeeeeeeeee eeeeeeeeeeeeeeeeeeeee eeiiiiiii iiiiiiii iiiiiii iiiiiiiii");

	--local textBoxHeight = GLFRAME:GetTextDims().height;
	--MESSAGE:SetDims("height:"..90);
	
		SLASH_CMDS = 
	{
		{slash_list="/pgctoggle", description="w³acz/wy³acz automatyczne dodawanie /pgc", func=PGC_Toggle},
		{slash_list="/pgc", description="Napisz wiadomoœæ /pgc wiadomosc", func=PGC_Say},
		{slash_list="/pgchelp", description="Pokazuje pomoc", func=PGC_Help}
	};
	
		for i = 1, #SLASH_CMDS do
		LIB_SLASH.BindCallback(SLASH_CMDS[i]);
	end
	
end
function OnShow(args)

	--FRAME:ParamTo("alpha", tonumber(args.show), args.dur);
end

function OnMessage(args)

end

function PGC_OnMouseDown(args)
local gr = args.widget:GetName();
log(tostring(gr));
log("mouseDown");
	createWG("nazwa gracza3", "jakaswiadomosc3");	
end

function PGC_OnScroll(args)

	scrollit(args.amount*10);
end
function scrollit(amount)
if topOffset > FRAME:GetBounds().height then
g_ScrollAmount = g_ScrollAmount + amount;
log(tostring(g_ScrollAmount));	
if g_ScrollAmount > 0 then
g_ScrollAmount = 0;
elseif g_ScrollAmount < (topOffset - FRAME:GetBounds().height)*-1 then
g_ScrollAmount = (topOffset - FRAME:GetBounds().height)*-1;
end

	CONT:MoveTo("top:"..g_ScrollAmount, 0.01, 0.01, "linear");	
	log(tostring(g_ScrollAmount));	
end
end

function OnOptionsDisplay(args)
log(tostring(args.visible));
if args.visible==true then
FRAME:Hide();
else
FRAME:Show();
end
end

function PGC_OnMouseEnter(args)
log("mouseenter");
end

function PGC_OnMouseLeave(args)
log("mouseleave");
end

function createWG(player, message)

local bpMessageGR = 
					[[<Group dimensions="left:0; top:0; width:100%; height:36;">
						<StillArt name="playerBack" dimensions="left:0; top:0; width:100%; height:18" style="texture:colors; region:black; alpha:0.8"/>
						<StillArt name="messageBack" dimensions="left:0; top:18; height:100%; width:100%;" style="texture:colors; region:black; alpha:0.6"/>
						<Text name="PlayerBox" dimensions="left:0; top:0; width:100%; height:18;" style="font:UbuntuBold_9; halign:left; valign:top; wrap:true;"/>
						<Text name="MessageBox" dimensions="left:0; top:18; height:100%; width:100%;" style="font:UbuntuBold_9; halign:center; valign:top; wrap:true;"/>
								<FocusBox name="FocusPlayer" dimensions="left:0; top:0; width:100%; height:18">
									<Events>
										<OnMouseDown bind="PGC_OnMouseDown"/>
										<OnMouseEnter bind="PGC_OnMouseEnter"/>
										<OnMouseLeave bind="PGC_OnMouseLeave"/>
										<OnScroll bind="PGC_OnScroll"/>
									</Events>
								</FocusBox>
								<FocusBox name="FocusMessage" dimensions="left:0; top:18; height:100%; width:100%;">
									<Events>
										<OnMouseDown bind="PGC_OnMouseDown"/>
										<OnMouseEnter bind="PGC_OnMouseEnter"/>
										<OnMouseLeave bind="PGC_OnMouseLeave"/>
										<OnScroll bind="PGC_OnScroll"/>
									</Events>
								</FocusBox>
					</Group>]];

local widget = Component.CreateWidget(bpMessageGR, CONT);
local playerWG = widget:GetChild("PlayerBox");
local messageWG = widget:GetChild("MessageBox");
local playerBackWG = widget:GetChild("playerBack");
local messageBackWG = widget:GetChild("messageBack");
playerWG:SetText(player);
messageWG:SetText(message);
local widgetHeight= messageWG:GetTextDims().height+playerWG:GetTextDims().height+18;
local contHeight = CONT:GetBounds().height;
log(tostring(messageWG:GetTextDims().height+playerWG:GetTextDims().height));
log(tostring(widgetHeight));
--CONT:SetDims("height:"..contHeight+widgetHeight..";");
widget:SetDims("height:"..widgetHeight.."; top:"..topOffset..";");
log(tostring(widget:GetBounds()));
topOffset= topOffset+widgetHeight;


scrollit((topOffset - FRAME:GetBounds().height)*-1);	
blink(5);
end

function blink (czas)
FRAME:Show();
if (blinkCallback == nil) then
blinkCallback = callback(frameHide,nil,czas);
else
cancel_callback(blinkCallback);
blinkCallback=callback(frameHide,nil,czas);
end
end

function OnBeginChat (args)
	if (PGCtoggle) then
		Component.GenerateEvent("MY_BEGIN_CHAT", {command=false, reply=false, text="/pgc "});
		end
FRAME:Show();
chatMode = true;
log("chat begin: "..tostring(args));
end

function OnModeChange (args)
if(args.mode=="game" and chatMode==true) then
chatMode=false;
log("chat end: "..tostring(args));
blink(5);
end
end

function frameHide (args)
if(chatMode==false) then
FRAME:Hide();
blinkCallback = nil;
end
end

function PGC_Toggle(args)
PGCtoggle = not PGCtoggle;
end

function PGC_Say(args)
local sendArray = {};
local name, faction, race, sex, pid, costam = Player.GetInfo()
sendArray.url="http://poligon.firefall.pl/PGC/getset.php";
sendArray.method = "POST";
sendArray.params ={ID=tostring(numerID), Name=name, message=args.text, online="1", lastLP=LP};
sendArray.onsuccess = responceSuccess;
sendArray.onfail = responceError;
sendHTTPrequest(sendArray);
log(tostring(sendArray.params));
end

function PGC_Help (args)
	local msg = "-========== PGC Help =========-\n";
	for i = 1, #SLASH_CMDS do
		msg = msg .. SLASH_CMDS[i].slash_list .. " : " .. SLASH_CMDS[i].description .. "\n";
	end
	msg = msg .. "-========== PGC Help =========-";

	Component.GenerateEvent("MY_SYSTEM_MESSAGE", {text=msg});
end

function sendHTTPrequest (args)
local Collision_Timer = {Low=5,High=25};
	if not HTTP.IsRequestPending() then
		local url = args.url
		local method = args.method
		local params = args.params
		local onsuccess = args.onsuccess
		local onfail = args.onfail
		HTTP.IssueRequest(url, method, params, function(args,err) if args then onsuccess(args) else onfail(err) end end)
	else
		if not args.tries then args.tries = 0 end
		args.tries = args.tries + 1
		
		if args.tries <= 5 then
			-- Anti-Collision Timer
			local Timer = math.random(Collision_Timer.Low, Collision_Timer.High) / 10
			callback(sendHTTPRequest, args, Timer)
		end
	end
end

function responceSuccess (args)
local jstable = args
log(tostring(jstable))
for i,v in ipairs(args) do
createWG(v.PlayerName,v.Wiadomosc)
LP=v.LP
end


end
function responceError (args)
log("PGC responce error"..tostring(args));
end

function autoUpdate(interwal)
log("->refreshing<-")
PGC_Say({text=''})
callback(autoUpdate2, interwal, interwal)
end
function autoUpdate2(interwal)
callback(autoUpdate, interwal, 2)
end
