///////////////////////////////////////////
/                                         /
/ XXXXX X     X   X xxxxx xxxx            /
/ X     X      X X  x     x   x           /
/ XXX   X       X   xxx   xxxx            /
/ X     X      X X  x     x  x            /
/ X     XXXXX X   X xxxxx x   x     MIDI  /
/                                         /
///////////////////////////////////////////

- Connect midi device

- Run midiToFLxER.jar	java -jar midiToFLxER.jar

ASSIGN FUNCTIONS

- Select "Trace"

- Select the device and press start

- Open file "preferences/midiPref.xml"

- Copy the lines with the functions that you want to use in FLxER in "preferences/midiPref.xml" from the list below and asign the midiID and midiVal (minVal,MaxVal OR 0) values from midiToFLxER.jar trace:

<root>
	<midiCtrl midiID="" fnz="hiQuality" midiVal="0" />
	<midiCtrl midiID="" fnz="fullScreen" midiVal="0" />
	<midiCtrl midiID="" fnz="mouseShowHide" midiVal="0" />
	<midiCtrl midiID="" fnz="topBarShowHide" midiVal="0" />
	<midiCtrl midiID="" fnz="bottomBarShowHide" midiVal="0" />
	<midiCtrl midiID="" fnz="moveDown" ch="auto" midiVal="0" />
	<!--
	<midiCtrl midiID="" fnz="moveDown" ch="1" midiVal="0" />
	<midiCtrl midiID="" fnz="moveDown" ch="2" midiVal="0" />
	<midiCtrl midiID="" fnz="moveDown" ch="3" midiVal="0" />
	<midiCtrl midiID="" fnz="moveDown" ch="4" midiVal="0" />
	<midiCtrl midiID="" fnz="moveDown" ch="5" midiVal="0" />
	<midiCtrl midiID="" fnz="moveDown" ch="6" midiVal="0" />
	<midiCtrl midiID="" fnz="moveDown" ch="7" midiVal="0" />
	>-->
	<midiCtrl midiID="" fnz="moveUp" ch="auto" midiVal="0" />
	
	<midiCtrl midiID="" fnz="live" ch="auto" midiVal="0" />
	<midiCtrl midiID="" fnz="hideShow" ch="auto" midiVal="0" />
	<midiCtrl midiID="" fnz="stopPlay" ch="auto" midiVal="0" />
	<midiCtrl midiID="" fnz="rewind" ch="auto" midiVal="0" />
	<midiCtrl midiID="" fnz="tap" ch="auto" midiVal="0" />
	<midiCtrl midiID="" fnz="eject" ch="auto" midiVal="0" />
	<midiCtrl midiID="" fnz="reset" ch="auto" midiVal="0" />
	<midiCtrl midiID="" fnz="lockWipes" ch="auto" midiVal="0" />
	<midiCtrl midiID="" fnz="libraryScroller" val="1" ch="auto" midiVal="0" />	
	<midiCtrl midiID="" fnz="libraryScroller" val="-1" ch="auto" midiVal="0" />
	<midiCtrl midiID="" fnz="zoomOneByOne" val="1,-1" ch="auto" midiVal="0" />
	<midiCtrl midiID="" fnz="sliderOneByOne" val="1,-1" ch="auto" midiVal="0" />
	<midiCtrl midiID="" fnz="zoom" val="1,1600" ch="auto" midiVal="0,7F" />
	<midiCtrl midiID="" fnz="rotate" val="1,1600" ch="auto" midiVal="0,7F" />
	<midiCtrl midiID="" fnz="scratch" val="0,800" ch="auto" midiVal="0,7F" />
	<midiCtrl midiID="" fnz="slider" val="0,100" ch="auto" midiVal="0,7F" />
	<midiCtrl midiID="" fnz="movieScroller" val="1,-1" ch="auto" midiVal="0" />
	<midiCtrl midiID="" fnz="changeChannel" val="2,7" ch="auto" midiVal="0" />

	<midiCtrl midiID="" fnz="redMovie" val="-255,255" ch="auto" midiVal="0,7F" />
	<midiCtrl midiID="" fnz="greenMovie" val="-255,255" ch="auto" midiVal="0,7F" />
	<midiCtrl midiID="" fnz="bluMovie" val="-255,255" ch="auto" midiVal="0,7F" />

	<midiCtrl midiID="" fnz="bkgOnOff" ch="auto" midiVal="0" />
	<midiCtrl midiID="" fnz="redMovieB" val="-255,255" ch="auto" midiVal="0,7F" />
	<midiCtrl midiID="" fnz="greenMovieB" val="-255,255" ch="auto" midiVal="0,7F" />
	<midiCtrl midiID="" fnz="bluMovieB" val="-255,255" ch="auto" midiVal="0,7F" />

	<midiCtrl midiID="" fnz="blendScroller" val="-1" ch="auto" midiVal="0" />
	<midiCtrl midiID="" fnz="blendScroller" val="1" ch="auto" midiVal="0" />

	<midiCtrl midiID="" fnz="wipeScroller" val="-1" ch="auto" midiVal="0" />	
	<midiCtrl midiID="" fnz="wipeScroller" val="1" ch="auto" midiVal="0" />	

	<midiCtrl midiID="" fnz="quickContent" val="1" ch="auto" />
	<midiCtrl midiID="" fnz="quickContent" val="2" ch="auto" />
	<midiCtrl midiID="" fnz="quickContent" val="3" ch="auto" />

	<midiCtrl midiID="" fnz="rotate" val="1,1600" ch="auto" midiVal="0,7F" />	


	<midiCtrl midiID="" fnz="soloPress" val="127" ch="auto" midiVal="0" />	
	<midiCtrl midiID="" fnz="soloRelease" val="0" ch="auto" midiVal="0" />	

	<midiCtrl midiID="" fnz="hueMovie" val="0,360" ch="auto" midiVal="0,7F" />
	<midiCtrl midiID="" fnz="satMovie" val="-300,300" ch="auto" midiVal="0,7F" />
	<midiCtrl midiID="" fnz="conMovie" val="-200,500" ch="auto" midiVal="0,7F" />
	<midiCtrl midiID="" fnz="briMovie" val="-255,255" ch="auto" midiVal="0,7F" />
	<midiCtrl midiID="" fnz="thrMovie" val="0,255" ch="auto" midiVal="0,7F" />
	<midiCtrl midiID="" fnz="thrOnOff" ch="auto" midiVal="0" />
</root>

- Close and save the file "preferences/midiPref.xml"

- Unselect "Trace"

- Press start

- Run FLxER

- Activate MIDI from top right

- EnjoyMidi



Used software:
java version "1.5.0_06"
Java(TM) 2 Runtime Environment, Standard Edition (build 1.5.0_06-b05)
Java HotSpot(TM) Client VM (build 1.5.0_06-b05, mixed mode)