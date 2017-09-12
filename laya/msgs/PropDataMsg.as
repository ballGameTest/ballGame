package msgs
{
	import game.net.MessageBase;
	
	/**
	 * 吐的道具数据消息
	 */	
	public class PropDataMsg extends MessageBase
	{
		public var roleId:int=0;
		public var id :Number=0;
		public var type :int=0;
		public var sourceId :int=0;
		public var x:int=0;
		public var y:int=0;
		public var angle:int=0;
		
		public function PropDataMsg(prop:GameProp=null)
		{
			if(prop)
			{
				this.roleId=prop.roleId;
				this.x=prop.x;
				this.y=prop.y;
				this.angle=prop.angle;
				this.sourceId=prop.sourceId;
				this.type=prop.PROP;
			}
		}
		
		public static const DES:Array = [
			["roleId", MessageBase.UINT16],
			["id", MessageBase.UINT16],
			["type", MessageBase.UINT8],
			["sourceId", MessageBase.UINT8],
			["x", MessageBase.UINT16],
			["y", MessageBase.UINT16],
			["angle", MessageBase.INT16],
		];
	}
}