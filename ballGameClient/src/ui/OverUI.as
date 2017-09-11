/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class OverUI extends View {
		public var txt_title:Label;
		public var btn_back:Button;
		public var rankingList:List;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"View","props":{"y":0,"x":0,"width":1334,"height":750},"child":[{"type":"Image","props":{"y":0,"x":0,"width":1334,"top":0,"skin":"ui/img_blank.png","sizeGrid":"6,7,6,6","right":0,"left":0,"height":750,"bottom":0}},{"type":"Label","props":{"y":47,"x":435,"width":464,"var":"txt_title","text":"游戏结束","height":62,"fontSize":60,"font":"SimHei","color":"#ffffff","centerY":-297,"centerX":-5,"bold":true,"align":"center"}},{"type":"Button","props":{"y":605,"width":360,"var":"btn_back","skin":"ui/button.png","sizeGrid":"20,26,30,32","labelSize":35,"labelFont":"SimHei","labelBold":true,"label":"返回大厅","height":100,"centerX":0.5}},{"type":"List","props":{"y":152,"x":133,"width":1068,"var":"rankingList","spaceY":15,"height":397},"child":[{"type":"Box","props":{"renderType":"render"},"child":[{"type":"Image","props":{"y":0,"width":1068,"skin":"ui/img_bg2.png","sizeGrid":"19,21,19,16","height":88}},{"type":"Clip","props":{"y":21,"x":52,"width":45,"skin":"ui/clip_num.png","index":1,"height":60,"clipX":10}},{"type":"Clip","props":{"y":13,"x":163,"skin":"ui/clip_head.png","clipX":8}},{"type":"Label","props":{"y":24,"x":271,"width":201,"text":"玩家昵称","height":40,"fontSize":35,"font":"SimHei","color":"#1e7acf","centerY":0,"centerX":-162.5,"bold":true,"align":"center"}},{"type":"Label","props":{"y":24,"x":519,"width":201,"text":"玩家重量","height":40,"fontSize":35,"font":"SimHei","color":"#1e7acf","centerX":85.5,"bold":true,"align":"center"}},{"type":"Label","props":{"y":24,"x":751,"width":201,"text":"获得奖励","height":40,"fontSize":35,"font":"SimHei","color":"#1e7acf","centerX":317.5,"bold":true,"align":"center"}}]}]}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}