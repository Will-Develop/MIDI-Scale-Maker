// Background Panel
const var backgroundPanel = Content.addPanel("backgroundPanel");
backgroundPanel.setPosition(0, 0, pluginWidth, pluginHeight);
backgroundPanel.setPaintRoutine(function(g)
{
	// Fill with Background Color
    g.fillAll(colorPalet.background);
    
    // Draw Title
	g.setFont("", 25.0);
	g.setColour(Colours.withAlpha(colorPalet.btn_text_color, colorPalet.colorAlpha));
	g.drawAlignedText(Engine.getName(), [15, 0, pluginWidth, 50], "left");
	
	// Draw Version number
	g.setFont("", 15.0);
	g.setColour(Colours.withAlpha(colorPalet.btn_text_color, colorPalet.colorAlpha));
	g.drawAlignedText("v." + Engine.getVersion(), [15, 0, 300, 145], "left");
	
	// Draw Sub Title
	g.setFont("", 15.0);
	g.setColour(Colours.withAlpha(colorPalet.btn_text_color, colorPalet.colorAlpha));
	g.drawAlignedText("by Will Develop", [15, 0, 300, 100], "left");
	
	// Draw Snap Mode Label
	g.setFont("", 15.0);
	g.setColour(Colours.withAlpha(colorPalet.btn_text_color, colorPalet.colorAlpha));
	g.drawAlignedText("Snap Mode", [288, 5, 123, 43], "centred");
});


// FloatingTile for UI Scale
const ft_uiScale = Content.addFloatingTile("ft_uiScale", 0, 0);
ft_uiScale.setPosition(15, 370, 265, 50);


// Selectbox Snap Mode
const snapMode = Content.addComboBox("snapMode", 150, 400);
snapMode.setPosition(290, 40, 123, 43);
const snapMode_items =
[
	"Auto",
	"Lowest Note",
	"Highest Note",
	"Off",
];
snapMode.set("items", snapMode_items.join("\n"));


// ReaScale Export Btn
const exportBtn = Content.addButton("exportBtn").setPosition(430, 40, 70, 43);

// MIDI Panic Btn
const midiPanicBtn = Content.addButton("midiPanicBtn").setPosition(204, 40, 70, 43);
var isMidiPanicBtnActive = midiPanicBtn.getValue;

// MIDI Panic Btn Timer
const midiPanicBtn_timer = Engine.createTimerObject();
midiPanicBtn_timer.setTimerCallback(function(){
	var panicBtn = Content.getComponent("midiPanicBtn");
	
	isMidiPanicBtnActive = 0;
	panicBtn.sendRepaintMessage();
	midiPanicBtn_timer.stopTimer();
});


// Note Buttons
const keyBounders = {
	width: 70,
	height: 275,
	black_width: 57.5,
	black_height: 170,
	key_posY: 100,
	key_posX_start: 15,
};
const noteBtn_c = Content.addButton("noteBtn_c").setPosition(keyBounders.key_posX_start, keyBounders.key_posY, keyBounders.width, keyBounders.height);
const noteBtn_csharp = Content.addButton("noteBtn_csharp").setPosition(keyBounders.key_posX_start + 42, keyBounders.key_posY, keyBounders.black_width, keyBounders.black_height);
const noteBtn_d = Content.addButton("noteBtn_d").setPosition(keyBounders.key_posX_start + 70, keyBounders.key_posY, keyBounders.width, keyBounders.height);
const noteBtn_dsharp = Content.addButton("noteBtn_dsharp").setPosition(keyBounders.key_posX_start + 112, keyBounders.key_posY, keyBounders.black_width, keyBounders.black_height);
const noteBtn_e = Content.addButton("noteBtn_e").setPosition(keyBounders.key_posX_start + 140, keyBounders.key_posY, keyBounders.width, keyBounders.height);
const noteBtn_f = Content.addButton("noteBtn_f").setPosition(keyBounders.key_posX_start + 210, keyBounders.key_posY, keyBounders.width, keyBounders.height);
const noteBtn_fsharp = Content.addButton("noteBtn_fsharp").setPosition(keyBounders.key_posX_start + 252, keyBounders.key_posY, keyBounders.black_width, keyBounders.black_height);
const noteBtn_g = Content.addButton("noteBtn_g").setPosition(keyBounders.key_posX_start + 280, keyBounders.key_posY, keyBounders.width, keyBounders.height);
const noteBtn_gsharp = Content.addButton("noteBtn_gsharp").setPosition(keyBounders.key_posX_start + 322, keyBounders.key_posY, keyBounders.black_width, keyBounders.black_height);
const noteBtn_a = Content.addButton("noteBtn_a").setPosition(keyBounders.key_posX_start + 350, keyBounders.key_posY, keyBounders.width, keyBounders.height);
const noteBtn_asharp = Content.addButton("noteBtn_asharp").setPosition(keyBounders.key_posX_start + 392, keyBounders.key_posY, keyBounders.black_width, keyBounders.black_height);
const noteBtn_b = Content.addButton("noteBtn_b").setPosition(keyBounders.key_posX_start + 420, keyBounders.key_posY, keyBounders.width, keyBounders.height);