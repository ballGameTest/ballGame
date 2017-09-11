/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 
	import laya.display.Text;

	public class MainUI extends View {
		public var btn_start:Button;
		public var txt_nickname1:TextInput;
		public var btn_nameChange:Button;
		public var icon_head:Clip;
		public var txt_nickname2:Text;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"y":0,"x":0,"width":1334,"height":750},"child":[{"type":"Image","props":{"y":0,"x":0,"width":1334,"skin":"ui/img_blank.png","sizeGrid":"6,7,6,6","height":750}},{"type":"Button","props":{"y":384,"width":360,"var":"btn_start","skin":"ui/button.png","sizeGrid":"20,26,30,32","labelSize":35,"labelFont":"SimHei","labelBold":true,"label":"开始游戏","height":120,"centerX":0.5}},{"type":"TextInput","props":{"y":252,"width":349,"var":"txt_nickname1","text":"我爱球球^_^","skin":"comp/textinput.png","height":107,"fontSize":35,"font":"SimHei","color":"#938e8d","centerX":0.5,"bold":true,"align":"center"}},{"type":"Button","props":{"y":250,"x":869,"width":116,"var":"btn_nameChange","skin":"ui/button.png","sizeGrid":"20,26,30,32","labelSize":35,"labelFont":"SimHei","labelBold":true,"label":"刷新","height":116}},{"type":"Box","props":{"y":35,"x":46},"child":[{"type":"Image","props":{"width":120,"skin":"ui/img_headBg.png","height":120}},{"type":"Clip","props":{"y":24,"x":18,"width":80,"var":"icon_head","skin":"ui/clip_head.png","index":7,"height":80,"clipX":8}},{"type":"Text","props":{"y":71,"x":137,"width":207,"text":"段位：青铜一阶","height":29,"fontSize":30,"font":"SimHei","color":"#f6fd5c"}},{"type":"Text","props":{"y":29,"x":137,"width":207,"var":"txt_nickname2","text":"昵称：我爱球球","height":29,"fontSize":30,"font":"SimHei","color":"#f6fd5c"}}]}]};
		override protected function createChildren():void {
			View.regComponent("Text",Text);
			super.createChildren();
			createView(uiView);
		}
	}
}