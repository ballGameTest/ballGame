package
{
	import game.manager.DataManager;
	
	import laya.events.EventDispatcher;
	import laya.utils.Pool;
	
	import msgs.ClientDataMsg;
	import msgs.ClientsCreateMsg;
	import msgs.EnterRoomMsg;
	import msgs.GameStartMsg;

	
	/**
	 * 游戏房间管理器
	 * @author CHENZHENG
	 */	
	public class RoomManager
	{
		private static var instance:RoomManager;
		/**服务器事件中心****/
		private var eventServer:EventDispatcher;
		/**在线用户列表****/
		private var clients:Object={};
		
		/**游戏房间列表****/	
		private var rooms:Object={};
		/**房间Id****/
		private var roomId:int=0;
		/**在线房间数量****/
		private var roomCount:int=0;
		
		
		public function RoomManager()
		{
			//监听进入房间消息
			DataManager.listen(EnterRoomMsg,this,onEnterRoom);
			//监听游戏开始消息
			DataManager.listen(GameStartMsg,this,onRoomStart);
		}
		
		/**
		 * 房间管理单例
		 */		
		public static function I():RoomManager
		{
			if(!instance) instance=new RoomManager();
			return instance;
		}
		
		/**
		 * 初始化房间管理全局信息
		 */	
		public function init(eventSer:EventDispatcher,clients:Object):void
		{
			this.eventServer=eventSer;
			this.clients=clients;
			//监听游戏结束事件
			eventServer.on(ServerEvent.GAME_OVER,this,onRoomOver);
		}
		
		/**
		 * 房间游戏开始
		 */	
		private function onRoomStart(msg:GameStartMsg):void
		{
			trace("---------玩家请求开始游戏，房间Id为："+msg.roomId)
			if(rooms[msg.roomId]) rooms[msg.roomId].gameStart();
		}
		
		/**
		 * 房间游戏结束，移除房间
		 */	
		private function onRoomOver(room:ServerRoom):void
		{
			delete rooms[room.roomId];
			roomCount--;
			if(roomCount==0||roomCount<0)
			{
				roomCount=0;
				roomId=0;
			}

			Pool.recover("serverRoom",room);

			trace("房间"+room.roomId+"----游戏结束！ 目前房间数为："+roomCount);
		}		
		
		/**
		 * 玩家进入房间消息，进入现有房间或创建新房间
		 */		
		private function onEnterRoom(msg:EnterRoomMsg):void
		{
			//发消息的客户端
			var client:ServerPlayer=clients[msg.clientDataMsg.clientId];
			//需加入的房间
			var serverRoom:ServerRoom;
			
			//遍历房间,加入未满员房间
			for(var i:String in rooms)
			{
				serverRoom=rooms[i];
				//如果房间未满和未开始游戏，加入房间
				if(serverRoom.clientsCount<serverRoom.roomMaxCount&&!serverRoom.roomStart)
				{
					client.isOriginator=false;
					serverRoom.clientToRoom(client,serverRoom.roomId);						
					trace("玩家----"+client.nickname+"----加入了房间"+serverRoom.roomId,"----目前房间人数:"+serverRoom.clientsCount);
					break;
				}
			}
			//如果客户端未加入已有房间，创建新的房间并加入
			if(!client.isInRoom)
			{
				roomCount++;
				serverRoom=Pool.getItemByClass("serverRoom",ServerRoom);
				serverRoom.init(roomId,eventServer);
				rooms[roomId]=serverRoom;
				client.isOriginator=true;
				serverRoom.clientToRoom(client,roomId);
				//下一个房间的Id
				roomId++;
				trace("玩家----"+client.nickname+"----创建了房间"+serverRoom.roomId);
			}

		}		
		
		/**
		 * 移除房间中离开游戏的玩家
		 * @param client
		 */		
		public function clientRemove(client:ServerPlayer):void
		{
			//如果玩家在房间内
			if(client.isInRoom)
			{
				//从房间内移除
				var room:ServerRoom=rooms[client.roomId];
				room.clientRemove(client);
				trace("玩家----"+client.nickname+"----离开了游戏房间Id:"+room.roomId,"----目前房间人数:"+room.clientsCount);
				//判断游戏房间是否有人，无人则删除房间
				if(room.clientsCount==0) 
				{
					onRoomOver(room);
					trace("游戏房间中无人了，取消房间！   目前房间数为："+this.roomCount)
				}
			}
		}
		
		

	}
}