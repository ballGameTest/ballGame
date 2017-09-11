/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 
	import laya.display.Text;

	public class GameUI extends View {
		public var txt_weight:Text;
		public var txt_time:Text;
		public var txt_pos:Text;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"y":0,"x":0,"width":1334,"height":750},"child":[{"type":"Text","props":{"y":17,"x":121,"var":"txt_weight","text":"重量：100g","fontSize":30,"font":"SimHei","color":"#ffffff","bold":true}},{"type":"Image","props":{"y":11,"x":12,"width":80,"skin":"ui/img_headBg.png","height":80}},{"type":"Clip","props":{"y":19,"x":20,"width":64,"visible":false,"skin":"ui/clip_head.png","index":7,"height":64,"clipX":8}},{"type":"Text","props":{"y":17,"x":723,"var":"txt_time","text":"倒计时：2分30秒","fontSize":30,"font":"SimHei","color":"#ffffff","bold":false}},{"type":"Text","props":{"y":17,"x":390,"var":"txt_pos","text":"坐标：1000,1000","fontSize":30,"font":"SimHei","color":"#ffffff","bold":false}}]};
		override protected function createChildren():void {
			View.regComponent("Text",Text);
			super.createChildren();
			createView(uiView);
		}
	}
}