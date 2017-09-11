/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 
	import laya.display.Text;

	public class RoomUI extends View {
		public var btn_go:Button;
		public var head0:Clip;
		public var nickname0:Text;
		public var head1:Clip;
		public var nickname1:Text;
		public var head2:Clip;
		public var nickname2:Text;
		public var head3:Clip;
		public var nickname3:Text;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"y":0,"x":0,"width":1334,"height":750},"child":[{"type":"Image","props":{"y":20,"x":20,"width":1334,"top":0,"skin":"ui/img_blank.png","sizeGrid":"6,7,6,6","right":0,"left":0,"height":750,"bottom":0}},{"type":"Button","props":{"y":548,"width":360,"var":"btn_go","skin":"ui/button.png","sizeGrid":"20,26,30,32","labelSize":35,"labelFont":"SimHei","labelBold":true,"label":"立即开始","height":100,"centerX":0.5}},{"type":"Box","props":{"y":223,"x":272,"name":"item0"},"child":[{"type":"Image","props":{"y":48,"width":160,"skin":"ui/img_headBg.png","height":160}},{"type":"Clip","props":{"y":80,"x":29,"width":100,"visible":false,"var":"head0","skin":"ui/clip_head.png","index":7,"height":100,"clipX":8}},{"type":"Text","props":{"y":-2,"x":5,"width":150,"visible":false,"var":"nickname0","text":"玩家昵称","height":38,"fontSize":35,"font":"SimHei","align":"center"}}]},{"type":"Box","props":{"y":223,"x":482,"name":"item1"},"child":[{"type":"Image","props":{"y":48,"width":160,"skin":"ui/img_headBg.png","height":160}},{"type":"Clip","props":{"y":80,"x":29,"width":100,"visible":false,"var":"head1","skin":"ui/clip_head.png","index":7,"height":100,"clipX":8}},{"type":"Text","props":{"y":-2,"x":5,"width":150,"visible":false,"var":"nickname1","text":"玩家昵称","height":38,"fontSize":35,"font":"SimHei","align":"center"}}]},{"type":"Box","props":{"y":223,"x":692,"name":"item2"},"child":[{"type":"Image","props":{"y":48,"width":160,"skin":"ui/img_headBg.png","height":160}},{"type":"Clip","props":{"y":80,"x":29,"width":100,"visible":false,"var":"head2","skin":"ui/clip_head.png","index":7,"height":100,"clipX":8}},{"type":"Text","props":{"y":-2,"x":5,"width":150,"visible":false,"var":"nickname2","text":"玩家昵称","height":38,"fontSize":35,"font":"SimHei","align":"center"}}]},{"type":"Box","props":{"y":223,"x":902,"name":"item3"},"child":[{"type":"Image","props":{"y":48,"width":160,"skin":"ui/img_headBg.png","height":160}},{"type":"Clip","props":{"y":80,"x":29,"width":100,"visible":false,"var":"head3","skin":"ui/clip_head.png","index":7,"height":100,"clipX":8}},{"type":"Text","props":{"y":-2,"x":5,"width":150,"visible":false,"var":"nickname3","text":"玩家昵称","height":38,"fontSize":35,"font":"SimHei"}}]},{"type":"Label","props":{"y":47,"width":464,"text":"进入房间","height":62,"fontSize":60,"font":"SimHei","color":"#ffffff","centerY":-297,"centerX":0.5,"bold":true,"align":"center"}}]};
		override protected function createChildren():void {
			View.regComponent("Text",Text);
			super.createChildren();
			createView(uiView);
		}
	}
}