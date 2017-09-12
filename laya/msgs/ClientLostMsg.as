package msgs
{
	import game.net.MessageBase;
	
	public class ClientLostMsg extends MessageBase
	{
		public var clientId:int;
		public var propDataArray:Array=[];
		
		public function ClientLostMsg()
		{
		}
		
		public static const DES:Array = [
			["clientId", MessageBase.UINT16],
			["propDataArray", MessageBase.ARRAY,[MessageBase.CLASS,PropDataMsg]]
		];
	}
}