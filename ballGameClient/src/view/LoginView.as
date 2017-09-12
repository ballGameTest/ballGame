package view
{
	import game.manager.Database;
	import laya.utils.Handler;
	
	import ui.LoginUI;
	
	public class LoginView extends LoginUI
	{
		private var gameAssets:Array=[
			"res/atlas/comp.atlas",
			"res/atlas/controller.atlas",
			"res/atlas/map.atlas",
			"config/gameSource.json"
		];
		
		private var gameData:Array=[
			"config/gameElement.bd"
		]
		
		private var progress:int=0;
		
		
		public function LoginView()
		{
			//加载游戏资源
			Laya.loader.load(gameAssets,Handler.create(this,onAssetsOk));
			
			Database.load(gameData,Handler.create(this,onDataComplete));
			//进度增加的帧循环
			Laya.timer.loop(10,this,onLoop);
		}
		
		private function onAssetsOk():void
		{
//			this.event(GameEvent.ASSETS_LOADED);
		}
		
		private function onDataComplete():void
		{
			trace(Database.getSheet("gameElement"))
		}
		
		/**
		 * 资源加载进度模拟（假进度）
		 */		
		private function onLoop():void
		{
			//进度增加
			progress++;
			//最高100%进度
			if(progress>100)
			{
				progress=100;
				this.txt_proInfo.text="游戏加载完毕，即将进入游戏..."
				Laya.timer.clearAll(this);
				this.removeSelf();	
				this.event(GameEvent.ASSETS_LOADED);
			}else
			{
				this.pro.value=progress/100;
				this.txt_proInfo.text="游戏正在加载中，当前进度为："+progress+"%!"
			}

		}
	}
}