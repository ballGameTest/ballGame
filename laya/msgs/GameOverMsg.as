package msgs
{
	import game.net.MessageBase;
	
	/**
	 * 游戏结束消息
	 * @author CHENZHENG
	 */	
	public class GameOverMsg extends MessageBase
	{
		public var gameOver:Boolean=true;
		
		public function GameOverMsg()
		{
		}
		public static const DES:Array = [
			["gameOver", MessageBase.BOOLEAN]
		];
	}
}