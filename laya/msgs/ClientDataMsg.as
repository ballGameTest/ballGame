package msgs
{
	import game.net.MessageBase;
	
	/**
	 * 玩家信息消息 
	 * @author CHENZHENG
	 * 
	 */	
	public class ClientDataMsg extends MessageBase
	{
		/**所属房间Id****/
		public var roomId:int=0;
		/**是否在房间****/
		public var isInRoom:Boolean=false;
		/**客户端Id****/
		public var clientId:int=0;
		/**是否是游戏发起人****/
		public var isOriginator:Boolean=false;
		/***昵称***/
		public var nickname:String="";
		/***头像Id***/
		public var headId:int=0;
		/***皮肤Id***/
		public var sourceId:int=0;
		
		public var x:int=0;
		public var y:int=0;
		public var speed:int=0;
		public var angle:int=0;
		
		/**
		 * 玩家信息消息  ****/
		public function ClientDataMsg(client:*)
		{
			if(client)
			{
				this.roomId=client.roomId;
				this.isInRoom=client.isInRoom;
				this.clientId=client.clientId;
				this.isOriginator=client.isOriginator;
				this.nickname=client.nickname;
				this.headId=client.headId;
				this.sourceId=client.sourceId;
				this.x=client.x;
				this.y=client.y;
				this.speed=client.speed;
				this.angle=client.angle;
			}
		}
		
		public static const DES:Array = [
			["roomId", MessageBase.UINT16],
			["clientId", MessageBase.UINT16],
			["isOriginator", MessageBase.BOOLEAN],
			["isInRoom", MessageBase.BOOLEAN],
			["nickname", MessageBase.STRING],
			["headId", MessageBase.UINT8],
			["sourceId", MessageBase.UINT8],
			["x", MessageBase.INT16],
			["y", MessageBase.INT16],
			["speed", MessageBase.INT16],
			["angle", MessageBase.INT16]
		];
	}
}