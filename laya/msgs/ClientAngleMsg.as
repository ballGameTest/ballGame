package msgs
{
	import game.net.MessageBase;
	
	/**
	 * 玩家角度变化消息
	 * @author CHENZHENG
	 */	
	public class ClientAngleMsg extends MessageBase
	{
		public var clientId:int=0;
		public var angle:int=0;
		
		
		public function ClientAngleMsg()
		{
		}
		
		public static const DES:Array = [
			["clientId", MessageBase.UINT16],
			["angle", MessageBase.UINT16]
		];
	}
}