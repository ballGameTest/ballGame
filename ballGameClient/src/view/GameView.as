package view
{
	import ui.GameUI;
	
	/**
	 * 游戏进行中UI
	 * @author CHENZHENG
	 */	
	public class GameView extends GameUI
	{
		public var player:GamePlayer;
		public var gameTime:int=0;
		
		public function GameView()
		{
		}
		
		public function init(gamePlayer:GamePlayer):void
		{
			this.player=gamePlayer;
			player.on(GameEvent.PLAYER_WEIGHT,this,onPlayerWeight);
		}
		
		/**
		 * 玩家重量发生变化，更新UI
		 */
		private function onPlayerWeight():void
		{
			if(player.weight<1000)
			{
				this.txt_weight.text="重量："+player.weight+"g";
			}else if(player.weight>1000&&player.weight<1000000)
			{
				this.txt_weight.text="重量："+player.weight/1000+"kg";
			}
		}
		
		public function update():void
		{
			var xx:Number =parseInt(player.x as String);
			var yy:Number =parseInt(player.y as String);
			this.txt_pos.text="坐标："+xx+","+yy;
			
			this.gameTime-=16;
			var second:int=parseInt(this.gameTime/1000 as String);
			var min:int=Math.floor(second/60);
			this.txt_time.text="倒计时："+min+":"+second%60;
		}
		
	}
}