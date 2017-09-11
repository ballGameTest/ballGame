/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class RockerUI extends View {
		public var knob:Image;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":200,"height":200},"child":[{"type":"Image","props":{"y":0,"x":0,"skin":"controller/control_base.png"}},{"type":"Image","props":{"y":101,"x":105,"var":"knob","skin":"controller/control_knob.png","anchorY":0.5,"anchorX":0.5,"alpha":0.5}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}