package {
	import flash.filesystem.File;
	import flash.system.Capabilities;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	import FLxER.comp.Alt;
	import FLxER.core.FlxerInterface;
	import FLxER.core.KeyboardIn;
	import FLxER.core.Monitor;
	import FLxER.panels.GlobalCtrl;
	// grep -lR 'Preferences.pref.monitorTrgt' --include '*.as' * | xargs sed -i 's/Preferences.pref.monitorTrgt/Preferences.monitorTrgt/g'
	public class Preferences {
		
		public static var pref:Object;
		public static var myFont:String;
		public static var myFonts:XMLDocument;
		public static var ts:TextFormat;
		public static var th:TextFormat;
		public static var monObj:Object;
		public static var monObjDefault:Object;
		public static var pos:Object; //Sequencer
		public static var msVal:Object; //Sequencer
		//
		public static var lastTime:Number = 0;
		public static var centra_onoff:Boolean = true;
		public static var myLoop:Boolean = true;
		public static var myBufferType:String = "";
		public static var myBufferTimeVal:Number = 0;
		public static var startDelay:Number = 0;
		public static var OSCactive:Boolean = false;
		public static var MIDIactive:Boolean = false;
		
		public static var stereo:Boolean;
		public static var myPreviewActive:Boolean = true;
		
		public static var colWhite:Object;
		public static var colBlack:Object;
		public static var nLoadErr:Object;
		public static var currentMedia:Object;
		
		public static var myGlobalCtrl:GlobalCtrl;
		public static var myKeyboardIn:KeyboardIn;
		public static var interfaceTrgt:FlxerInterface;
		public static var starterTrgt:FLxER6;
		public static var monitorOut:*;
		public static var monitorOutFS:Boolean;
		public static var monitorTrgt:Monitor;
		public static var myAlt:Alt;
		
		public static var sequencerPattern:XMLDocument;
		public static var wipes:XMLDocument;
		public static var dvin:XMLDocument;
		public static var readers:XMLDocument;
		public static var libraryList:XMLDocument;
		public static var modules:XMLDocument;
		public static var midiMaps:XMLDocument;
		public static var oscMaps:XMLDocument;
		public static var blendList:XMLDocument;
		public static var myCameras:XMLDocument;
		public static var basepath:String;
		public static var midi:Object;
		
		public function Preferences():void {
			//		[Embed(source="fonts/HOOG0555.ttf", 	fontName="HOOG0555", 		mimeType="application/x-font")]
		}
		
		public static function createPref():void {
			pref = new Object();
			basepath = (Capabilities.os.indexOf("Mac") >= 0) ? "file://" : "";
			/*
			pref.nCh = 7;
			pref.eyesDistance = 100;
			pref.resizzaMode = 1;
			pref.serverLibrary = {useServer:false, value:"http://www.flxer.net/warehouse/_flxer/"};
			pref.osc = {server:"127.0.0.1",port:"9001"};
			pref.bitmap = false;
			pref.vKS = true;
			pref.smoothStop = true;
			pref.zvalue = 300;
			pref.zalpha = true;
			pref.web = false;
			
			pref.myCol = new Object();
			pref.myCol.altBrd 		= "0x000000";
			pref.myCol.brdCol 		= "0x333333";
			pref.myCol.altBkg 		= "0xFFFF00";
			pref.myCol.altCol 		= "0x000000";
			pref.myCol.bkgColOver 	= "0x990000";
			pref.myCol.bkgCol 		= "0x000000";
			pref.myCol.monCol 		= "0x000000";
			pref.myCol.col 			= "0x999999";
			pref.myCol.pltCol 		= "0x909090";
			//
			//os = Capabilities.os;
			
			colWhite = new Object();
			colWhite.col = "0x000000";
			colWhite.bkgCol = "0xFFFFFF";
			colWhite.bkgColOver = "0xFF0000";
			colWhite.brdCol = "0x999999";
			colWhite.pltCol = "0x909090";
			colWhite.monCol = "0xFFFFFF";
			//
			colBlack = new Object();
			colBlack.col = "0x999999";
			colBlack.bkgCol = "0x000000";
			colBlack.bkgColOver = "0x990000";
			colBlack.brdCol = "0x333333";
			colBlack.pltCol = "0x909090";
			colBlack.monCol = "0x000000";
			//
			*/
			pos = new Object();
			msVal = new Object();
			var embeddedFontsArray:Array = Font.enumerateFonts(false);
			ts = new TextFormat();
			with (ts) {
				font = embeddedFontsArray[0].fontName;
				size = 8;
				color = 0x000000;
				leading = -2;
				leftMargin = 1;
				rightMargin = 0;
			}
			th = new TextFormat();
			with (th) {
				//font = embeddedFontsArray[0].fontName;
				font = embeddedFontsArray[0].fontName;
				size = 8;
				color = 0x000000;
				leading = -2;
				leftMargin = 1;
				rightMargin = 0;
			}
			
			var lista_font:Array = Font.enumerateFonts(true);
			lista_font.shift();
			myFont = lista_font[0].fontName;
			myFonts = new XMLDocument("<lib><lib></lib></lib>");
			for (var a:int = 0; a < lista_font.length; a++) {
				var lib:XMLNode = myFonts.createElement("lib");
				myFonts.childNodes[0].childNodes[0].appendChild(lib);
				myFonts.childNodes[0].childNodes[0].childNodes[a].attributes.m = (a==0 ? "ReaderFont" : lista_font[a].fontName);
			}
			/////////////////////////           
		}
		public static function updateColObj():void {
			ts.color 				= pref.myCol.col;
			th.color 				= pref.myCol.col;
			myAlt  = new Alt();
		}
		/*
		public static function updateColObj(obj:Object):void {
		pref.myCol.col 			= obj.col;
		ts.color 				= obj.col;
		th.color 				= obj.col;
		pref.myCol.bkgCol 		= obj.bkgCol;
		pref.myCol.bkgColOver 	= obj.bkgColOver;
		pref.myCol.brdCol 		= obj.brdCol;
		pref.myCol.pltCol 		= obj.pltCol;
		pref.myCol.monCol 		= obj.monCol;
		}
		public static function updateCol():void {
		pref.myCol.col 			= pref.flxerPref.childNodes[0].attributes.col;
		ts.color 			= pref.myCol.col;
		th.color 			= pref.myCol.col;
		pref.myCol.bkgCol 		= pref.flxerPref.childNodes[0].attributes.bkgCol;
		pref.myCol.bkgColOver 	= pref.flxerPref.childNodes[0].attributes.bkgColOver;
		pref.myCol.brdCol 		= pref.flxerPref.childNodes[0].attributes.brdCol;
		pref.myCol.pltCol 		= pref.flxerPref.childNodes[0].attributes.pltCol;
		pref.myCol.monCol 		= pref.flxerPref.childNodes[0].attributes.monCol;
		}
		public static function createXMLnode(f:String,valid:Array):XMLDocument {
		var folder:File = File.documentsDirectory.resolvePath(f);
		return createXML(folder,valid);
		}
		*/
		public static function createXMLnodeAbsolute(f:String,valid:Array):XMLDocument {
			var folder:File = new File(); 
			folder.nativePath = f;
			return createXML(folder,valid);
		}
		public static function createXML(folder:File,valid:Array):XMLDocument {
			var files:Array = folder.getDirectoryListing();
			var list:String = <lib><a m="NO Content" /></lib>;
			var xmlnode:XMLDocument = new XMLDocument();
			xmlnode.ignoreWhite = true;
			xmlnode.parseXML(list);
			if (files) {
				for (var a:int=0; a<files.length;a++) {
					var ext:String = files[a].name.substring(files[a].name.lastIndexOf(".")+1, files[a].name.length).toLowerCase();
					if (valid.length && valid.indexOf(ext)>=0 || valid.length==0 && files[a].isDirectory){
						if (xmlnode.childNodes[0].childNodes[0].attributes.m!="NO Content"){
							xmlnode.childNodes[0].appendChild(xmlnode.childNodes[0].childNodes[0].cloneNode(true));
						}
						xmlnode.childNodes[0].childNodes[xmlnode.childNodes[0].childNodes.length-1].attributes.m = files[a].name
						xmlnode.childNodes[0].childNodes[xmlnode.childNodes[0].childNodes.length-1].attributes.val = files[a].nativePath
					}
				}
			}
			return xmlnode;
		}
		public static function myReplace(str:String, search:String, replace:String):String {
			var temparray:Array = str.split(search);
			str = temparray.join(replace);
			return str;
		}
		public static function deepTrace( obj : *, level : int = 0 ) : void{
			var tabs : String = "";
			for ( var i : int = 0 ; i < level ; i++ ) tabs += "\t"; 
			
			for ( var prop : String in obj ){
				trace( tabs + "[" + prop + "] -> " + obj[ prop ] );
				deepTrace( obj[ prop ], level + 1 );
			}
		}
	}
}