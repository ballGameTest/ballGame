package msgs
{
	import game.net.MessageBase;
	/**
	 * 玩家离线消息
	 * @author CHENZHENG
	 */	
	public class ClientLeaveMsg extends MessageBase
	{
		public var id:int=0;
		
		public function ClientLeaveMsg()
		{
		}
		
		public static const DES:Array = [
			["id", MessageBase.UINT16]
		];
	}
}