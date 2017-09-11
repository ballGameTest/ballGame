/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class ControlUI extends View {
		public var ctr_Split:Button;
		public var ctr_lostProp:Button;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":400,"right":0,"height":200,"bottom":0},"child":[{"type":"Button","props":{"width":130,"var":"ctr_Split","stateNum":2,"skin":"controller/btn_attack.png","right":58,"height":133,"bottom":31}},{"type":"Button","props":{"width":130,"var":"ctr_lostProp","stateNum":2,"skin":"controller/btn_attack.png","right":208,"height":133,"bottom":31}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}