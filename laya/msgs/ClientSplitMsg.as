package msgs
{
	import game.net.MessageBase;
	
	public class ClientSplitMsg extends MessageBase
	{
		public var clientId:int=0;
		public var roles:Array=[];
		
		public function ClientSplitMsg()
		{
		}
		public static const DES:Array = [
			["clientId", MessageBase.UINT8],
			["roles", MessageBase.ARRAY, [MessageBase.CLASS,ItemDataMsg]]
		];
	}
}