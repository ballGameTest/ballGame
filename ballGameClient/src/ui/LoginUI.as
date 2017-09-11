/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class LoginUI extends View {
		public var pro:ProgressBar;
		public var txt_proInfo:Label;
		public var txt_title:Label;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"y":0,"x":0,"width":1334,"height":750},"child":[{"type":"Image","props":{"top":0,"skin":"ui/img_blank.png","sizeGrid":"6,7,6,6","right":0,"left":0,"bottom":0}},{"type":"ProgressBar","props":{"width":640,"var":"pro","skin":"ui/progress.png","sizeGrid":"0,9,0,5","height":14,"centerY":37,"centerX":0.5}},{"type":"Label","props":{"width":512,"var":"txt_proInfo","text":"资源正在加载中...","height":28,"fontSize":28,"font":"SimHei","color":"#ffffff","centerY":90,"centerX":0.5,"bold":true,"align":"center"}},{"type":"Label","props":{"width":464,"var":"txt_title","text":"球球大作战","height":62,"fontSize":60,"font":"SimHei","color":"#ffffff","centerY":-90,"centerX":0.5,"bold":true,"align":"center"}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}