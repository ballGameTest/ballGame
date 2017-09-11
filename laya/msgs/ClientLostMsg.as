package msgs
{
	import game.net.MessageBase;
	
	public class ClientLostMsg extends MessageBase
	{
		public var clientId:int;
		public var lostAngle:int;
		public var propId:int;
		
		public function ClientLostMsg()
		{
		}
		
		public static const DES:Array = [
			["clientId", MessageBase.UINT16],
			["lostAngle", MessageBase.INT16],
			["propId", MessageBase.UINT16]
		];
	}
}