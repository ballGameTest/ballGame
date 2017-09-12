package msgs
{
	import game.net.MessageBase;
	
	public class ClientLostMsg extends MessageBase
	{
		public var clientId:int;
		public var itemDataArray:Array=[];
		
		public function ClientLostMsg()
		{
		}
		
		public static const DES:Array = [
			["clientId", MessageBase.UINT16],
			["itemDataArray", MessageBase.ARRAY,[MessageBase.CLASS,ItemDataMsg]]
		];
	}
}