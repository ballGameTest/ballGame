package msgs
{
	import game.net.MessageBase;
	
	/**
	 * 游戏开始消息
	 * @author CHENZHENG
	 */	
	public class GameStartMsg extends MessageBase
	{
		public var roomId:int=0;
		
		public function GameStartMsg()
		{
		}
		
		public static const DES:Array = [
			["roomId", MessageBase.UINT16]
		];
	}
}