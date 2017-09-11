/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class ReviveUI extends View {
		public var btn_revive:Button;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"width":1334,"height":750},"child":[{"type":"Sprite","props":{"y":0,"x":0,"width":1334,"height":750,"alpha":0.5},"child":[{"type":"Rect","props":{"y":0,"x":0,"width":1334,"lineWidth":0,"height":750,"fillColor":"#0a0909"}}]},{"type":"Image","props":{"y":172,"x":311,"width":712,"skin":"ui/img_blank.png","sizeGrid":"6,7,6,6","height":400}},{"type":"Button","props":{"y":353,"width":360,"var":"btn_revive","skin":"ui/button.png","sizeGrid":"20,26,30,32","labelSize":35,"labelFont":"SimHei","labelBold":true,"label":"立即复活","height":120,"centerX":4}},{"type":"Label","props":{"y":244,"x":435,"width":464,"text":"您阵亡了！","height":62,"fontSize":60,"font":"SimHei","color":"#ffffff","centerY":-100,"centerX":43,"bold":true,"align":"center"}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}