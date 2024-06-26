Processor 
Type SynthChain ID Snap to Note Bypassed Gain 	      �?Balance 	        VoiceLimit 	      P@KillFadeTime 	      4@IconColour 0 packageName  BuildVersion �  EditorStates BodyShown 0 Visible 1 Solo 0 Folded 1  ChildProcessors  Processor Type MidiProcessorChain ID Midi Processor Bypassed EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors  Processor Type ScriptProcessor ID Interface Bypassed Script �const pluginWidth = 520;
const pluginHeight = 440;
Content.makeFrontInterface(pluginWidth, pluginHeight);


// Set Font
Engine.loadFontAs("{PROJECT_FOLDER}Fonts/Roboto-Regular.ttf", "Roboto-Regular");
Engine.setGlobalFont("Roboto-Regular");


// Includes
include("gui_LookAndFeel.js");
include("gui_Components.js");


// General Variables
var allowedNotes = [];
var allowNotesFlatted = 0;
reg midiKeyList = Engine.createMidiList();


const midiNotes = {
	// order by Note
    'C': [0, 12, 24, 36, 48, 60, 72, 84, 96, 108, 120],
    'C#': [1, 13, 25, 37, 49, 61, 73, 85, 97, 109, 121],
    'D': [2, 14, 26, 38, 50, 62, 74, 86, 98, 110, 122],
    'D#': [3, 15, 27, 39, 51, 63, 75, 87, 99, 111, 123],
    'E': [4, 16, 28, 40, 52, 64, 76, 88, 100, 112, 124],
    'F': [5, 17, 29, 41, 53, 65, 77, 89, 101, 113, 125],
    'F#': [6, 18, 30, 42, 54, 66, 78, 90, 102, 114, 126],
    'G': [7, 19, 31, 43, 55, 67, 79, 91, 103, 115, 127],
    'G#': [8, 20, 32, 44, 56, 68, 80, 92, 104, 116],
    'A': [9, 21, 33, 45, 57, 69, 81, 93, 105, 117],
    'A#': [10, 22, 34, 46, 58, 70, 82, 94, 106, 118],
    'B': [11, 23, 35, 47, 59, 71, 83, 95, 107, 119],
};


const midiKeysIsActive = {
	'C': false,
    'C#': false,
    'D': false,
    'D#': false,
    'E': false,
    'F': false,
    'F#': false,
    'G': false,
    'G#': false,
    'A': false,
    'A#': false,
    'B': false,
};


// Functions

/*
	checks which snap mode is active
	so that the midi note can be processed correctly
*/
inline function getOutputNoteBySnapMode(playedNote)
{
	if (allowNotesFlatted.length != 0 || isMidiPanicBtnActive == 1)
	{
		if (allowNotesFlatted.indexOf(playedNote) != -1)
		{
			return playedNote;
		}
		else
		{
			switch (snapMode.getValue())
			{
		  		case "1":
		  			return snapMode_auto(playedNote);
		    		break;
		    	case "2":
		    		return snapMode_lowestNote(playedNote);
			    	break;
				case "3":
					return snapMode_highestNote(playedNote);
			    	break;
			}
		}
	}
}


/*
	Automatically plays the nearest lower or highest note that is active
*/
inline function snapMode_auto(playedNote)
{  
	reg closestNumber = 0;
	reg differentiated = 999;
	reg currentDifference = 0;
	
    for (i = 0; i < allowNotesFlatted.length; i++)
    {
        currentDifference = playedNote - allowNotesFlatted[i];
        if (currentDifference < 0) currentDifference = currentDifference * -1; // Absolute Differenz
        if (currentDifference < differentiated) {
            differentiated = currentDifference;
            closestNumber = allowNotesFlatted[i];
        }
    }
    
    return closestNumber;
}


/*
	Plays the nearest highest note that is active
*/
inline function snapMode_highestNote(playedNote)
{
	reg nextHighestNote = 0;

    for (i = 0; i < allowNotesFlatted.length; i++)
    {
        if (allowNotesFlatted[i] > playedNote && (nextHighestNote === 0 || allowNotesFlatted[i] < nextHighestNote))
        {
            nextHighestNote = allowNotesFlatted[i];
        }
    }
    
    return nextHighestNote;
}


/*
	Plays the nearest lowest note that is active
*/
inline function snapMode_lowestNote(playedNote)
{
	reg nextLowerNote = 0;
	
    for (i = 0; i < allowNotesFlatted.length; i++)
    {
        if (allowNotesFlatted[i] < playedNote && (nextLowerNote === 0 || allowNotesFlatted[i] > nextLowerNote))
        {
            nextLowerNote = allowNotesFlatted[i];
        }
    }
    
	return nextLowerNote;
}


inline function sendNoteToMidiOut(outputNote)
{
	Message.setNoteNumber(outputNote);
	Message.sendToMidiOut();
}function onNoteOn()
{
	const receivedNote = Message.getNoteNumber();
	var outputNote = getOutputNoteBySnapMode(receivedNote);
	midiKeyList.setValue(receivedNote, outputNote);
	
	sendNoteToMidiOut(outputNote);
}function onNoteOff()
{
	const receivedNote = Message.getNoteNumber();
	var outputNote = getOutputNoteBySnapMode(receivedNote);
	
	
	midiKeyList.setValue(receivedNote, -1); // set pressed Note in midiList to -1
	if (midiKeyList.getValueAmount(outputNote) <= 0)
	{
		sendNoteToMidiOut(outputNote);
	}

	
	if (isMidiPanicBtnActive == 1)
	{
		for(i=0; i<128; i++)
		{
			Console.print(i);
			Message.setNoteNumber(i);
			Message.sendToMidiOut();
		}
	}
}function onController()
{
	Message.sendToMidiOut();
}
 function onTimer()
{
	
}
 function onControl(number, value)
{
	var id = number.getId();
	
	switch(id)
	{
		// Note Buttons
		case 'noteBtn_c':
			addToArrayIfActive(value, midiNotes["C"], "C");
	    	break;
	  	case 'noteBtn_csharp':
	   		addToArrayIfActive(value, midiNotes["C#"], "C#");
	    	break;
		case 'noteBtn_d':
		 	addToArrayIfActive(value, midiNotes["D"], "D");
		  	break;
		case 'noteBtn_dsharp':
		 	addToArrayIfActive(value, midiNotes["D#"], "D#");
		  	break;  	
		case 'noteBtn_e':
		 	addToArrayIfActive(value, midiNotes["E"], "E");
		  	break;	
		case 'noteBtn_f':
		 	addToArrayIfActive(value, midiNotes["F"], "F");
		  	break;	
		case 'noteBtn_fsharp':
		 	addToArrayIfActive(value, midiNotes["F#"], "F#");
		  	break;	
		case 'noteBtn_g':
			addToArrayIfActive(value, midiNotes["G"], "G");
		  	break;	
		case 'noteBtn_gsharp':
			addToArrayIfActive(value, midiNotes["G#"], "G#");
		  	break;	
		case 'noteBtn_a':
			addToArrayIfActive(value, midiNotes["A"], "A");
		 	break;	  	  	  		  	  	  	
		case 'noteBtn_asharp':
			addToArrayIfActive(value, midiNotes["A#"], "A#");
		  	break;	  	  	  	    	  	  	
		case 'noteBtn_b':
			addToArrayIfActive(value, midiNotes["B"], "B");
		  	break;
		  	
		 // Export Button
		 case 'exportBtn':
			if(value == 1)
			{
				exportAsReaScale();
			}
		 	break;
		 	
		 // Panic Button
		 case 'midiPanicBtn':
		 	if(isMidiPanicBtnActive == 0)
		 	{
			 	isMidiPanicBtnActive = 1;
			 	midiPanicBtn_timer.startTimer(1000);
		 	}
		 	break;
	}
	
	var allowNotesFlatted = flattenArray(allowedNotes);
}


function flattenArray(array)
{
	var return_array = [];

	for (i = 0; i < array.length; i++)
	{
		return_array.concat(array[i]);
	}
	
	return_array.sort();
	return return_array;
}


function addToArrayIfActive(btnValue, toPushArray, key)
{
	if (btnValue == 1) 
	{
		allowedNotes.pushIfNotAlreadyThere(toPushArray);
		midiKeysIsActive[key] = true;
	}
	
	if (btnValue == 0)
	{
		allowedNotes.remove(toPushArray);
		midiKeysIsActive[key] = false;
	}
}


function exportAsReaScale()
{
	FileSystem.browse(FileSystem.Desktop, true, ".reascale", function (exportFile)
	{
		var comment = 
"# This file was generated by the plugin "+ Engine.getName() +" v."+ Engine.getVersion() +" by Will Develop.
# .reascale files can be loaded into the REAPER MIDI editor, via the Key Snap dropdown list.


"; // Do not format differently, affects the display in the file

		var scale = "";
			
		if (midiKeysIsActive["C"] == true) {scale = scale + "1";} else {scale = scale + "0";}
		if (midiKeysIsActive["C#"] == true) {scale = scale + "1";} else {scale = scale + "0";}
		if (midiKeysIsActive["D"] == true) {scale = scale + "1";} else {scale = scale + "0";}
		if (midiKeysIsActive["D#"] == true) {scale = scale + "1";} else {scale = scale + "0";}
		if (midiKeysIsActive["E"] == true) {scale = scale + "1";} else {scale = scale + "0";}
		if (midiKeysIsActive["F"] == true) {scale = scale + "1";} else {scale = scale + "0";}
		if (midiKeysIsActive["F#"] == true) {scale = scale + "1";} else {scale = scale + "0";}
		if (midiKeysIsActive["G"] == true) {scale = scale + "1";} else {scale = scale + "0";}
		if (midiKeysIsActive["G#"] == true) {scale = scale + "1";} else {scale = scale + "0";}
		if (midiKeysIsActive["A"] == true) {scale = scale + "1";} else {scale = scale + "0";}
		if (midiKeysIsActive["A#"] == true) {scale = scale + "1";} else {scale = scale + "0";}
		if (midiKeysIsActive["B"] == true) {scale = scale + "1";} else {scale = scale + "0";}
		
		exportFile.writeString(comment + '0 ' + exportFile.toString(1) + '	' + scale);
	});
}
  EditorStates BodyShown 1 Visible 1 Solo 0 contentShown 1 onInitOpen 1  ChildProcessors   Content  Control type ScriptButton id noteBtn_c value 	      �? Control type ScriptButton id noteBtn_d value 	         Control type ScriptButton id noteBtn_e value 	         Control type ScriptButton id noteBtn_f value 	         Control type ScriptButton id noteBtn_g value 	         Control type ScriptButton id noteBtn_a value 	         Control type ScriptButton id noteBtn_b value 	         Control type ScriptButton id noteBtn_dsharp value 	         Control type ScriptButton id noteBtn_csharp value 	         Control type ScriptButton id noteBtn_asharp value 	         Control type ScriptButton id noteBtn_gsharp value 	         Control type ScriptButton id noteBtn_fsharp value 	         Control type ScriptComboBox id 
snapMode value 	      �? UIData  ContentProperties DeviceType 	Desktop Component type ScriptPanel id backgroundPanel x     y     width   height �   Component type ScriptButton id noteBtn_c x    y d   width F   height   isPluginParameter pluginParameterName Key C  Component type ScriptButton id noteBtn_d x U   y d   width F   height   pluginParameterName Key D isPluginParameter  Component type ScriptButton id noteBtn_e x �   y d   width F   height   isPluginParameter pluginParameterName Key E  Component type ScriptButton id noteBtn_f x �   y d   width F   height   isPluginParameter pluginParameterName Key F  Component type ScriptButton id noteBtn_g x '  y d   width F   height   isPluginParameter pluginParameterName Key G  Component type ScriptButton id noteBtn_a x m  y d   width F   height   isPluginParameter pluginParameterName Key A  Component type ScriptButton id noteBtn_b x �  y d   width F   height   isPluginParameter pluginParameterName Key B  Component type ScriptButton id noteBtn_dsharp x    y d   width 9   height �   isPluginParameter pluginParameterName Key D#  Component type ScriptButton id noteBtn_csharp x 9   y d   width 9   height �   isPluginParameter pluginParameterName Key C#  Component type ScriptButton id noteBtn_asharp x �  y d   width 9   height �   isPluginParameter pluginParameterName Key A#  Component type ScriptButton id noteBtn_gsharp x Q  y d   width 9   height �   isPluginParameter pluginParameterName Key G#  Component type ScriptButton id noteBtn_fsharp x   y d   width 9   height �   isPluginParameter pluginParameterName Key F#  Component type ScriptComboBox id 
snapMode x "  y (   max    items #Auto
Lowest Note
Highest Note
Off width {   height +   isPluginParameter pluginParameterName Snap Mode enableMidiLearn  Component 
type ScriptButton id exportBtn x �  y (   width F   height +   saveInPreset isMomentary enableMidiLearn isVertical  Component 
type ScriptButton id midiPanicBtn x �   y (   width F   height +   isPluginParameter pluginParameterName Panic Button saveInPreset isMomentary  Component type ScriptFloatingTile id ft_uiScale x    y r  updateAfterInit ContentType CustomSettings bgColour 	   �    itemColour 	        itemColour2 	        height 2   width 	  Data �{
  "Driver": false,
  "Device": false,
  "Output": false,
  "BufferSize": false,
  "SampleRate": false,
  "GlobalBPM": false,
  "StreamingMode": false,
  "ScaleFactor": true,
  "VoiceAmountMultiplier": false,
  "ClearMidiCC": false,
  "SampleLocation": false,
  "DebugMode": false,
  "UseOpenGL": false,
  "ScaleFactorList": [
    0.5,
    0.75,
    1.0,
    1.25,
    1.5,
    2.0
  ]
}  Processor Type ModulatorChain ID GainModulation Bypassed Intensity 	      �?EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors   Processor Type ModulatorChain ID PitchModulation Bypassed Intensity 	        EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors   Processor Type EffectChain ID FX Bypassed EditorStates BodyShown 1 Visible 0 Solo 0  ChildProcessors   RoutingMatrix NumSourceChannels    Channel0     Send0 ����Channel1    Send1 ���� macro_controls  macro name 	Macro 1 value 0.0 midi_cc -1  macro name 	Macro 2 value 0.0 midi_cc -1  macro name 	Macro 3 value 0.0 midi_cc -1  macro name 	Macro 4 value 0.0 midi_cc -1  macro name 	Macro 5 value 0.0 midi_cc -1  macro name 	Macro 6 value 0.0 midi_cc -1  macro name 	Macro 7 value 0.0 midi_cc -1  macro name 	Macro 8 value 0.0 midi_cc -1  MidiAutomation   MPEData Enabled  