package {
	import flash.desktop.NativeApplication;
	import flash.display.Loader;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.xml.XMLDocument;
	
	import FLxER.core.FlxerInterface;
	import FLxER.core.KeyboardIn;
	import FLxER.core.Midi;
	import FLxER.core.Monitor;
	import FLxER.core.OSC;
	import FLxER.core.Output;
	import FLxER.core.OutputBMP;
	import FLxER.core.OutputStereo;
	import FLxER.core.TreDengine;
	import FLxER.main.Rett;
	import FLxER.modules.MappingSVG.MappingSVGStarter;
	import FLxER.panels.GlobalCtrl;
	import FLxER.panels.Mess;
	import FLxER.panels.OptionsMidi;
	import FLxER.panels.OptionsOsc;
	import FLxER.panels.PrefOption;
	import FLxER.panels.Preloader;
	
	public class FLxER6 extends Sprite {
		[Embed(source="fonts/Standard0753.ttf", fontName="myfont", embedAsCFF= "false")]
		private var Standard0753:Class;
		public var myMidi					:Midi;
		public var myOSC					:OSC;
		public var monitor					:Monitor;
		public var monitorOut				:*;
		public var flxerInterface			:FlxerInterface;
		public var myGlobalCtrl				:GlobalCtrl;
		public var myTreDengine				:TreDengine;
		public var myKeyboard				:KeyboardIn;
		private var myPrefSO					:SharedObject;
		//public var myFlxerSSConnectorSender	:FlxerSSConnector;
		//
		private var c								:uint;
		private var splash							:Preloader;
		private var plugInLoader					:Loader;
		private var myOptionsOsc					:OptionsOsc;
		private var myOptionsMidi					:OptionsMidi;
		//var myOptionsRemote					:OptionsRemote;
		private var myAlert							:Mess;
		private var myPrefOption					:PrefOption;
		private var fondo							:Rett;
		private var fondino							:Rett;
		private var myLoader						:URLLoader
		private var firstTime						:Boolean = true;
		private var slider							:Rett;
		public var mainWindow						:NativeWindow
		public var outWindow						:NativeWindow
		private var plugInCnt:Array;
		private var MyFile:File
		private var loadDefaults					:Boolean = false
//		private var version							:Number = 6.3;
		public function FLxER6() {
			stage.showDefaultContextMenu = false;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.nativeWindow.width = stage.fullScreenWidth;
			stage.nativeWindow.height = stage.fullScreenHeight;
			NativeApplication.nativeApplication.autoExit = true;
			//Preferences.deepTrace(NativeApplication.nativeApplication)
			// Specifies whether the application should automatically terminate when all windows have been closed.
			
			Preferences.createPref();
			plugInCnt = new Array();
			
			// STORED PREFERENCES
			myPrefSO = SharedObject.getLocal("flxer6","/",false);
			trace("stocazzo");
			//delete myPrefSO.data.perf;
			
			// DEFAULT PREFERENCES
			var file:File = File.applicationDirectory.resolvePath("flxerPref.json"); 
			var fileStream:FileStream = new FileStream(); 
			fileStream.open(file, FileMode.READ);
			var json:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
			var defaultPreferences:Object = JSON.parse(json);

			var fileName:File = new File() 
			//Preferences.deepTrace(myPrefSO.data);
			if (myPrefSO.data.pref) {
				if (myPrefSO.data.pref.version < defaultPreferences.version) {
					for (var item in myPrefSO.data.pref) {
						//if (item!="version") 
						defaultPreferences[item] = myPrefSO.data.pref[item];
					}
					Preferences.pref = myPrefSO.data.pref = defaultPreferences;
					myPrefSO.flush();
				} else {
					Preferences.pref = myPrefSO.data.pref;
				}
			} else {
				loadDefaults = true
				var flxerFolder:File = File.documentsDirectory;
				flxerFolder = flxerFolder.resolvePath("FLxER-Folder");
				Preferences.pref = myPrefSO.data.pref = defaultPreferences;
				Preferences.pref.flxerFolder = flxerFolder.nativePath;				
			}
			splash = new Preloader(stage.loaderInfo.bytesTotal,stage.fullScreenWidth,stage.fullScreenHeight);
			this.addChild(splash);
			fileName.nativePath = Preferences.pref.flxerFolder; 
			//splash.t0.text = fileName.nativePath
			//Preferences.pref.flxerFolder = "/Users/admin/Documents/FLxER-Folder";				

			//trace("flxerFolder.exists "+fileName.exists);
			if(!fileName.exists) {
				var sourceFile:File = File.applicationDirectory;
				sourceFile = sourceFile.resolvePath("includes");
				//trace("sourceFile "+sourceFile.nativePath)
				try  {
					//trace("flxerFolder "+flxerFolder.nativePath);
					sourceFile.copyTo(fileName, true);
				}
				catch (error:Error) {
					trace("Error:", error.message);
				}
			}
			if (loadDefaults) {
				Preferences.pref = myPrefSO.data.pref = defaultPreferences;
				Preferences.pref.flxerFolder = fileName.nativePath; 
				myPrefSO.flush();
			}
			Preferences.updateColObj();
			Preferences.starterTrgt = this;
			starter();
			this.addEventListener(Event.CLOSING, closeWindow);
		}
		private function closeWindow(evt:Event):void {
			evt.preventDefault();
		}
		private function starter():void {
			updateLists();
			var list:String = <lib><a m="MappingSVG" /></lib>;
			var xmlnode:XMLDocument = new XMLDocument();
			xmlnode.ignoreWhite = true;
			xmlnode.parseXML(list);
			Preferences.modules = xmlnode;
			
			Preferences.blendList = new XMLDocument();
			Preferences.blendList.ignoreWhite = true;
			list = <lib><a m="normal" /><a m="layer" /><a m="multiply" /><a m="screen" /><a m="lighten" /><a m="darken" /><a m="difference" /><a m="add" /><a m="subtract" /><a m="invert" /><a m="alpha" /><a m="erase" /><a m="overlay" /><a m="hardlight" /></lib>;
			Preferences.blendList.parseXML(list);
			
			Preferences.myCameras = new XMLDocument();
			Preferences.myCameras.ignoreWhite = true;
			list = <lib><a m="NO Camera" /></lib>;
			Preferences.myCameras.parseXML(list);
			updateCameras();
			c = setInterval(removeSplash, 5000);
		}
		public function updateCameras():void {
			var cam:Array = Camera.names;
			if (cam) {
				for (var a:int=0; a<cam.length;a++) {
					if (a>0){
						Preferences.myCameras.childNodes[0].appendChild(Preferences.myCameras.childNodes[0].childNodes[0].cloneNode(true));
					}
					Preferences.myCameras.childNodes[0].childNodes[a].attributes.m = cam[a]
					Preferences.myCameras.childNodes[0].childNodes[a].attributes.val = a
				}
			}
		}
		public function refreshLists():void {
			updateLists();
			for (var a:int=0; a<Preferences.pref.nCh; a++) {
				Preferences.interfaceTrgt.chCnt["ch_"+a].myLibSel.avvia(Preferences.libraryList.childNodes[0]);
			}
		}
		private function updateLists():void {
			var file:File = new File(); 
			file.nativePath = Preferences.pref.flxerFolder+"/sequencer/sequencerPattern.xml"; 
			var fileStream:FileStream = new FileStream(); 
			fileStream.open(file, FileMode.READ); 
			Preferences.sequencerPattern = new XMLDocument();
			Preferences.sequencerPattern.ignoreWhite = true;
			Preferences.sequencerPattern.parseXML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			fileStream.close();

			Preferences.wipes 			= Preferences.createXMLnodeAbsolute(Preferences.pref.flxerFolder+"/wipes",["swf"]);
			Preferences.wipes.childNodes[0].insertBefore(Preferences.wipes.childNodes[0].childNodes[0].cloneNode(true),Preferences.wipes.childNodes[0].childNodes[0]);
			Preferences.wipes.childNodes[0].childNodes[0].attributes.m = "HORIZONTAL";
			Preferences.wipes.childNodes[0].insertBefore(Preferences.wipes.childNodes[0].childNodes[0].cloneNode(true),Preferences.wipes.childNodes[0].childNodes[0]);
			Preferences.wipes.childNodes[0].childNodes[0].attributes.m = "VERTICAL";
			Preferences.wipes.childNodes[0].insertBefore(Preferences.wipes.childNodes[0].childNodes[0].cloneNode(true),Preferences.wipes.childNodes[0].childNodes[0]);
			Preferences.wipes.childNodes[0].childNodes[0].attributes.m = "LOAD SVG MAP";
			Preferences.wipes.childNodes[0].insertBefore(Preferences.wipes.childNodes[0].childNodes[0].cloneNode(true),Preferences.wipes.childNodes[0].childNodes[0]);
			Preferences.wipes.childNodes[0].childNodes[0].attributes.m = "WIPE NONE (MIX)";
			
			Preferences.dvin 		= Preferences.createXMLnodeAbsolute(Preferences.pref.flxerFolder+"/dvin",["swf"]);
			Preferences.readers		= Preferences.createXMLnodeAbsolute(Preferences.pref.flxerFolder+"/readers",["swf"]);
			Preferences.libraryList = Preferences.createXMLnodeAbsolute(Preferences.pref.flxerFolder+"/library",[]);
			Preferences.midiMaps 	= Preferences.createXMLnodeAbsolute(Preferences.pref.flxerFolder+"/MIDI/MIDImaps",["xml"]);
			Preferences.oscMaps 	= Preferences.createXMLnodeAbsolute(Preferences.pref.flxerFolder+"/OSCmaps",["xml"]);
		}
		private function interfaceDrawer():void {
			var windowOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
			windowOptions.systemChrome = NativeWindowSystemChrome.NONE;
			windowOptions.type = NativeWindowType.NORMAL;
			mainWindow = new NativeWindow(windowOptions);
			mainWindow.stage.nativeWindow.addEventListener(Event.ACTIVATE, mainWindowFocus);
			mainWindow.stage.addEventListener(MouseEvent.MOUSE_OVER, mainWindowFocus);
			
			mainWindow.stage.scaleMode = StageScaleMode.NO_SCALE;
			mainWindow.stage.align = StageAlign.TOP_LEFT;
			var hhh:int = 300+23+(Preferences.pref.nCh*50)+1
			mainWindow.bounds = new Rectangle(0, 0, 1000,hhh);
			monitor = new Monitor(300, 23+((300-Preferences.pref.monObjDefault.monHeight)/2), Preferences.pref.monObjDefault.monWidth, Preferences.pref.monObjDefault.monHeight, Preferences.pref.nCh);
			Preferences.monitorTrgt = monitor;
			fondo = new Rett(0,0,1000,hhh,Preferences.pref.myCol.bkgCol,-1,1);
			fondino = new Rett(0,23,1000,300,0x333333,-1,1);
			mainWindow.stage.addChild(fondo);
			flxerInterface = new FlxerInterface();
			myGlobalCtrl = new GlobalCtrl();
			mainWindow.stage.addChild(flxerInterface);
			mainWindow.stage.addChild(fondino);
			mainWindow.stage.addChild(monitor);
			//stage.focus=stage;
			mainWindow.stage.addChild(myGlobalCtrl);
			myKeyboard = new KeyboardIn();
			//myKeyboard.myDisable()
			myTreDengine = new TreDengine();
			if (Preferences.pref.vKS) {
			}
			mainWindow.stage.nativeWindow.x = 45;
			mainWindow.stage.nativeWindow.y = 45;
			mainWindow.activate();
			if (hhh > stage.fullScreenHeight) {
				slider = new Rett(985, 323,15,60,0xFFFFFF,0x999999,0.7);
				mainWindow.stage.addChild(slider);
				slider.addEventListener(MouseEvent.MOUSE_DOWN,sliderDownHandler);
				slider.addEventListener(MouseEvent.MOUSE_UP,sliderUpHandler);
				slider.buttonMode = true;
			}
			monitorResize(Preferences.pref.monObjDefault.monWidth,Preferences.pref.monObjDefault.monHeight);
			/*
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE,rota);
			//myFullscreen(true)
			}
			private function rota(e:Event):void {
			trace(stage.stageWidth+" "+stage.stageHeight);
			trace(e)
			Preferences.pref.w = stage.stageWidth;
			Preferences.pref.h = stage.stageHeight;
			monitor.x = (Preferences.pref.w - 320)/2
			for (var i in Preferences.pref.objToResize) {
			trace("bella"+Preferences.pref.objToResize[i])
			Preferences.pref.objToResize[i].resizer(e)
			}
			slider.y = Preferences.pref.h-17
			sliderMoveHandler(null)*/
			//monitorResize(1280,720);
		}
		private function mainWindowFocus(event:Event):void {
			mainWindow.stage.addChild(Preferences.myAlt);
		}
		private function outWindowFocus(event:Event):void {
			outWindow.stage.addChild(Preferences.myAlt);
		}
		private function sliderDownHandler(event:Event):void {
			slider.startDrag(false, new Rectangle(985, 323, 0, stage.fullScreenHeight-slider.height-323-mainWindow.stage.nativeWindow.y))
			mainWindow.stage.addEventListener(MouseEvent.MOUSE_MOVE,sliderMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,sliderUpHandler);
		}
		private function sliderUpHandler(event:Event):void {
			slider.stopDrag();
			mainWindow.stage.removeEventListener(MouseEvent.MOUSE_MOVE,sliderMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP,sliderUpHandler);
		}
		private function sliderMoveHandler(event:Event):void {
			flxerInterface.height+323-stage.fullScreenHeight
			flxerInterface.y = -(slider.y-323)*((flxerInterface.height+323-stage.fullScreenHeight+mainWindow.stage.nativeWindow.y)/(stage.fullScreenHeight-323-slider.height-mainWindow.stage.nativeWindow.y));
			//myGlobalCtrl.x = -slider.y*((flxerInterface.height)/(stage.fullScreenHeight-323-slider.height));
		}
		private function removeSplash():void {
			if (getTimer() > Preferences.startDelay) {
				clearInterval(c);
				//this.removeChild(splash);
				stage.nativeWindow.close();
				interfaceDrawer();
				//c = setInterval(setMode, 500);
			}
		}
		public function savePref():void {
			/*
			var file:File = File.documentsDirectory.resolvePath("FLxER-Folder/preferences/flxerPref.json");
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(JSON.stringify(Preferences.pref));
			stream.close();
			trace("save")
			*/
			myPrefSO.data.pref = Preferences.pref;
			myPrefSO.flush();
		}
		/*
		private function avviamyFlxerSSConnectorSender(event:StatusEvent):void {
		myFlxerSSConnectorSender = new FLxER.core.FlxerSSConnector(loadPluginXml, null);
		myOptionsRemote = new OptionsRemote(400, 300, "REMOTE SENDER MODE OPTIONS", myFlxerSSConnectorSender,this);
		this.addChild(myOptionsRemote);
		}
		*/
		public function resizer(event:Event):void {
			monitorResize(outWindow.stage.stageWidth/(Preferences.stereo ? 2 : 1),outWindow.stage.stageHeight);
		}
		public function monitorResize(monWidth:int,monHeight:int):void {
			Preferences.pref.monObj.monWidth = monWidth;
			Preferences.pref.monObj.monHeight = monHeight;
			monitor.resizer();
			if (monitorOut) monitorOut.resizer();
			var ddd:Number;
			var www:int;
			var hhh:int;
			if (Preferences.pref.monObj.monWidth/Preferences.pref.monObj.monHeight > 1000/300) {
				trace("stocazzo1")
				ddd = Preferences.pref.monObj.monWidth/1000;
				www = 1000;
				hhh = int(Preferences.pref.monObj.monHeight/ddd);
			} else {
				ddd = Preferences.pref.monObj.monHeight/300;
				www = int(Preferences.pref.monObj.monWidth/ddd);
				hhh = 300
				trace("wwwww "+Preferences.pref.monObj.monWidth);
				trace("hhhhh "+Preferences.pref.monObj.monHeight);
				trace("stocazzo2"+ddd)
			}
			monitor.x = (1000-www) / 2
			monitor.y = 23+((300-hhh)/2)
			monitor.scaleX = monitor.scaleY = 1/ddd;
			//if (outWindow.stage.displayState == "fullScreen"){
			if (Preferences.monitorOutFS){
				outWindow.stage.removeEventListener(KeyboardEvent.KEY_DOWN, goFullKey);  
				outWindow.stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			} else {
 				if (outWindow) outWindow.stage.addEventListener(KeyboardEvent.KEY_DOWN, goFullKey);  
			}
		}
		public function goFullKey(event:Event):void {
			Preferences.monitorOutFS = true;
			outWindow.stage.displayState = "fullScreen";
			resizer(null);
			Preferences.monitorOut.myOutputOption.myCancel(true);
			outWindow.stage.addEventListener(Event.RESIZE, escFullscreen);
		}
		public function escFullscreen(event:Event):void {
			Preferences.monitorOutFS = false;
			outWindow.stage.removeEventListener(Event.RESIZE, escFullscreen);
			resizer(null);
			outWindow.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		public function manualOtuputSize(x,y,w,h):void {
			Preferences.monitorOutFS = true;
			trace("goFullKey");
			outWindow.stage.displayState = "normal";
			outWindow.x = x;
			outWindow.y = y;
			outWindow.width = w;
			outWindow.height = h;
			resizer(null)
		}
		public function myFullscreen(p:Boolean,stereo:Boolean):void {
			Preferences.stereo = stereo;
			if (p) {
				var windowOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
				windowOptions.systemChrome = NativeWindowSystemChrome.NONE;
				windowOptions.type = NativeWindowType.NORMAL;
				outWindow = new NativeWindow(windowOptions);
				outWindow.alwaysInFront = true;
				outWindow.stage.scaleMode = StageScaleMode.NO_SCALE;
				outWindow.stage.align = StageAlign.TOP_LEFT;
				//outWindow.stage.addEventListener(Event.RESIZE, resizer);
				outWindow.stage.addEventListener(KeyboardEvent.KEY_DOWN, goFullKey);  
				outWindow.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);  
				outWindow.stage.nativeWindow.addEventListener(Event.ACTIVATE, outWindowFocus);
				outWindow.stage.addEventListener(MouseEvent.MOUSE_OVER, outWindowFocus);
				if (stereo) {
					trace("myfull"+stereo);
					outWindow.bounds = new Rectangle(0, 0, Preferences.pref.monObjDefault.monWidth*2,Preferences.pref.monObjDefault.monHeight);
					monitorOut = new OutputStereo(0, 0, Preferences.pref.monObjDefault.monWidth,Preferences.pref.monObjDefault.monHeight, Preferences.pref.nCh);
				} else {
					outWindow.bounds = new Rectangle(0, 0, Preferences.pref.monObjDefault.monWidth,Preferences.pref.monObjDefault.monHeight);
					if (Preferences.pref.bitmap) {
						monitorOut = new OutputBMP(Preferences.pref.monObjDefault.monWidth,Preferences.pref.monObjDefault.monHeight);
					} else {
						monitorOut = new Output(0, 0, Preferences.pref.monObjDefault.monWidth,Preferences.pref.monObjDefault.monHeight, Preferences.pref.nCh);
					}
				}
				Preferences.monitorOut = monitorOut;
				//trace("numChildren "+monitorOut.mon.numChildren)
				outWindow.stage.addChild(monitorOut);
				outWindow.activate();
			} else {
				Preferences.monitorOut.myOutputOption.myCancel(true);
				outWindow.close();
				Preferences.starterTrgt.outWindow = null;
				Preferences.monitorOut = null;
			}
		}
		private function mouseDownHandler(event:MouseEvent):void {
			outWindow.startMove();
		}
		public function resetta():void {
			mainWindow.stage.removeChild(flxerInterface);
			mainWindow.stage.removeChild(monitor);
			if (Preferences.myAlt) {
				mainWindow.stage.removeChild(Preferences.myAlt);
			}
		}
		public function reDraw():void {
			mainWindow.stage.removeChild(flxerInterface);
			mainWindow.stage.removeChild(monitor);
			if (mainWindow.stage.contains(Preferences.myAlt)) {
				mainWindow.stage.removeChild(Preferences.myAlt);
			}
			mainWindow.close();
			interfaceDrawer()
		}
		public function addModule(p:String):void {
			loadPlugIn(p)
		}
		public function loadPlugIn(plugInName):void {
			switch(plugInName) {
				case "MappingSVG" :
					if (!plugInCnt.myMappingSVG) {
						plugInCnt.myMappingSVG = new MappingSVGStarter();
					}
					break;
			}
		}
		public function openPrefPanel():void {
			if (!myPrefOption) myPrefOption = new PrefOption(400, 425, "FLXER PREFERENCES", savePref,closePrefPanel);
		}
		private function closePrefPanel():void {
			myPrefOption = null;
		}
		public function openMIDIPanel(trgt):void {
			if (!myOptionsMidi) myOptionsMidi = new OptionsMidi(300,180,"MIDI", trgt, savePref,closeMIDIPanel);
		}
		private function closeMIDIPanel():void {
			myOptionsMidi = null;
		}
		/*
		*/
		public function midiOnOff(p:Boolean):void {
			if (p) {
				myMidi = new Midi();
			} else {
				myMidi = null;
			}
		}
		public function openOSCPanel(trgt):void {
			if (!myOptionsOsc) myOptionsOsc = new OptionsOsc(300,180,"OSC", trgt, savePref,closeOSCPanel);				
		}
		private function closeOSCPanel():void {
			myOptionsOsc = null;
		}
		public function oscOnOff(p:Boolean):void {
			if (p) {
				myOSC = new OSC();
			} else if (myOSC is OSC) {
				Preferences.OSCactive = false;
				myOSC.close();
				myOSC = null;
			}
		}
		public function moveFlxerFolder(flxerFolder:String):void {
			var sourceFile:File = new File(); 
			sourceFile.nativePath = Preferences.pref.flxerFolder; 
			var destination:File = new File();
			var myerror:Boolean = false;
			destination.nativePath = flxerFolder; 
			try {
				sourceFile.moveTo(destination, true);
			}
			catch (error:Error) {
				myerror = true;
				trace("Error:" + error.message);
			}
			if (!myerror) {
				Preferences.pref.flxerFolder = flxerFolder;
				//savePref();
				updateLists();
			}
		}
		/*
		public function addModule():void {
		var MyFile:File = File.documentsDirectory;
		MyFile = MyFile.resolvePath("FLxER-Folder/modules");
		MyFile.addEventListener(Event.SELECT, loadPlugIn);
		MyFile.browseForOpen("Open", [new FileFilter("Load Module", "*.swf")]);
		trace("addModule")
		}
		public function loadPlugIn(event:Event):void {
		var plugInName = event.target.nativePath.split("/");
		plugInName = plugInName[plugInName.length-1].split(".")[0];
		plugInCnt[plugInName] = new Module(plugInName,"file://"+event.target.nativePath)
		trace("loadPlugIn "+plugInName);
		}
		startup();
		}
		function xmlNotLoaded(event:Event):void {
		trace("Data not loaded."+event);
		}
		public function loadPluginXml() {
		trace(Preferences.pref.flxerFolder+"/preferences/plugIn.xml")
		myLoader = new URLLoader(new URLRequest(Preferences.pref.flxerFolder+"/preferences/plugIn.xml"));
		myLoader.addEventListener("complete", loadSeqPattern);
		myLoader.addEventListener("ioError", xmlNotLoaded);
		}
		public function loadSeqPattern(event:Event) {
		Preferences.pref.plugin = new XMLDocument();
		Preferences.pref.plugin.ignoreWhite = true;
		Preferences.pref.plugin.parseXML(myLoader.data);
		myLoader = new URLLoader(new URLRequest(Preferences.pref.flxerFolder+"/preferences/sequencerPattern.xml"));
		myLoader.addEventListener("complete", loadLib);
		myLoader.addEventListener("ioError", xmlNotLoaded);
		}
		public function loadLib(event:Event) {
		Preferences.sequencerPattern = new XMLDocument();
		Preferences.sequencerPattern.ignoreWhite = true;
		Preferences.sequencerPattern.parseXML(myLoader.data);
		myLoader = new URLLoader(new URLRequest(Preferences.pref.flxerFolder+"/preferences/playlists.xml"));
		myLoader.addEventListener("complete", startup);
		myLoader.addEventListener("ioError", xmlNotLoaded);
		}
		public function startup(event:Event) {
		Preferences.libraryList = new XMLDocument();
		Preferences.libraryList.ignoreWhite = true;
		Preferences.libraryList.parseXML(myLoader.data);
		//
		*/	
		/*
		function initHandlerPlugIn(event) {
		//if (plugInLoader.content) plugInLoader.content.avvia(Preferences);
		trace("initHandlerPlugIn"+event)
		}
		function errorHandlerPlugIn(event:Event) {
		trace("errorHandlerPlugIn"+event)
		}
		*/
	}
}/*
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.clearInterval;
import flash.utils.getTimer;
import flash.utils.setInterval;
*/
