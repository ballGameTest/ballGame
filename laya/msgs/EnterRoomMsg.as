package msgs
{
	import game.net.MessageBase;
	
	/**
	 * 玩家进入房间消息 
	 * @author CHENZHENG
	 * 
	 */	
	public class EnterRoomMsg extends MessageBase
	{
		public var clientDataMsg:ClientDataMsg;
		
		/**
		 * 玩家进入房间消息 ****/
		public function EnterRoomMsg()
		{
		}
		
		public static const DES:Array = [
			["clientDataMsg", MessageBase.CLASS, ClientDataMsg]
		];
	}
}