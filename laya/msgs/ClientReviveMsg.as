package msgs
{
	import game.net.MessageBase;
	
	/**
	 * 玩家复活消息
	 * @author CHENZHENG
	 */	
	public class ClientReviveMsg extends MessageBase
	{
		public var roleClientId:int;
		public var roleId:int;
		public var x:int;
		public var y:int;
		
		public function ClientReviveMsg()
		{
		}
		
		public static const DES:Array = [
			["roleClientId", MessageBase.UINT16],
			["roleId", MessageBase.UINT16],
			["x", MessageBase.UINT16],
			["y", MessageBase.UINT16]
		];
	}
}