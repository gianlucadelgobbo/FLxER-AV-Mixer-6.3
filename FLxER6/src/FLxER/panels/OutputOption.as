package FLxER.panels {
	import FLxER.comp.ButtonTxt;
	import FLxER.main.Txt;
	import FLxER.panels.Palette;
	
	//	import FLxER.panels.GlobalCtrl;
	//	import flash.filesystem.File;
	//	import flash.events.*;
	//	import flash.filesystem.*;
	public class OutputOption extends Palette {
		private var cntObj:Object;
		private var callback:Function;
		private var onclose:Function;
		public function OutputOption(w:uint,h:uint,t:String,fnz:Function,fnzclose:Function):void {
			super(w,h,t,"");
			callback = fnz;
			onclose = fnzclose;
			//var mode0 = new ButtonTxt(50, 55, 150, 15, "CLONE MONITOR", fnz, 0, "");
			//cntObj.addChild(mode0);
			//myXml = Preferences.pref.flxerPref;
			cntObj = new Object();
			cntObj.xPosL		= new Txt(5, 25, 0, 15, "Output X position", Preferences.ts, null);
			cntObj.xPos 		= new Txt(125, 25, 40, 15, "0", Preferences.th, "input");
			cntObj.yPosL		= new Txt(5, 45, 0, 15, "Output Y position", Preferences.ts, null);
			cntObj.yPos 		= new Txt(125, 45, 40, 15, "0", Preferences.th, "input");

			cntObj.widthL		= new Txt(5, 65, 0, 15, "Output Width", Preferences.ts, null);
			cntObj.w 			= new Txt(125, 65, 40, 15, "0", Preferences.th, "input");
			cntObj.heightL		= new Txt(5, 85, 0, 15, "Output Height", Preferences.ts, null);
			cntObj.h 			= new Txt(125, 85, 40, 15, "0", Preferences.th, "input");
			//
			cntObj.pulsSave 	= new ButtonTxt(5, 110, 50, 15, "SIMPLE FULLSCREEN", simpleFullscreen, null, null);
			cntObj.pulsCancel 	= new ButtonTxt(60, 110, 50, 15, "MANUAL", manualFullscreen, null, null);
			cntObj.pulsReset 	= new ButtonTxt(115, 110, 50, 15, "CLOSE", myCancel, null, null);
			for (var item:* in cntObj) {
				this.palette.stage.addChild(cntObj[item])
			}
		}
		private function simpleFullscreen(p:String):void {
			callback([]);
		}			
		private function manualFullscreen(p:String):void {
			callback([cntObj.xPos.text,cntObj.yPos.text,cntObj.w.text,cntObj.h.text]);
		}
		public function myCancel(p:String):void {
			this.palette.close();
			onclose();
		}
	}
}