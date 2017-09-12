package msgs
{
	import game.net.MessageBase;
	
	/**
	 * 物品被吃消息 
	 * @author CHENZHENG
	 * 
	 */	
	public class EatItemMsg extends MessageBase
	{
		public var roleId:int;
		public var roleClientId:int;
		public var eatId:int;
		public var eatClientId:int=-1;
		public var eatWeight:int;
		public var eatType:int=0;
		
		public function EatItemMsg()
		{
		}
		public static const DES:Array = [
			["roleId", MessageBase.UINT16],
			["roleClientId", MessageBase.INT16],
			["eatId", MessageBase.UINT16],
			["eatClientId", MessageBase.INT16],
			["eatWeight", MessageBase.UINT16],
			["eatType", MessageBase.UINT8]
		];
	}
}