package msgs
{
	import game.net.MessageBase;
	
	/**
	 * 创建地图物品群消息
	 * @author CHENZHENG
	 */	
	public class GameCreateMsg extends MessageBase
	{
		public var roomId:int=0;
		public var gameTime:int=0;
		public var mapId:int=-1;
		public var itemDataArray:Array=[];
		
		public function GameCreateMsg()
		{
		}
		
		public static const DES:Array = [
			["roomId", MessageBase.UINT8],
			["gameTime", MessageBase.UINT32],
			["mapId", MessageBase.INT8],
			["itemDataArray", MessageBase.ARRAY,[MessageBase.CLASS,ItemDataMsg]]
		];
	}
}