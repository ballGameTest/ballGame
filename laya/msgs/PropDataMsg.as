package msgs
{
	import game.net.MessageBase;
	
	public class PropDataMsg extends MessageBase
	{
		public var id :Number=0;
		public var type :int=0;
		public var sourceId :int=0;
		public var weight :Number=0;
		public var radius :Number=-1;
		public var speed :Number=0;	
		public var x:int=0;
		public var y:int=0;
		
		public function PropDataMsg()
		{
		}
		
		public static const DES:Array = [
			["id", MessageBase.UINT16],
			["type", MessageBase.UINT8],
			["sourceId", MessageBase.UINT8],
			["weight", MessageBase.UINT32],
			["radius", MessageBase.UINT16],
			["speed", MessageBase.UINT8],
			["x", MessageBase.UINT16],
			["y", MessageBase.UINT16]
		];
	}
}