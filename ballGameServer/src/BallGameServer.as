package
{
	import game.manager.DataManager;
	import game.net.MessageBase;
	import msgs.MessageInit;
	
	import laya.events.EventDispatcher;
	import laya.utils.Pool;
	
	import msgs.ClientDataMsg;
	import msgs.EnterRoomMsg;
	import msgs.GameStartMsg;
	
	/**
	 * 游戏服务器
	 * @author CHENZHENG
	 */	
	public class BallGameServer
	{
		/**socket服务器****/		
		private var socketServer:SocketServer;		
		/**服务器事件中心****/
		private var eventServer:EventDispatcher;
		/**游戏房间管理****/
		private var roomManager:RoomManager;
		
		
		/**在线客户端列表****/	
		private var clients:Object={};
		/**客户端Id****/
		private var clientId:int=0;
		/**在线客户端数量****/
		private var clientCount:int=0;
		/**玩家初始数据消息****/
		private var clientDataMsg:ClientDataMsg;
		
		
		/**服务器配置文件地址表****/
		private var config:Array=[];
		/**服务器配置信息****/
		private var serverConfig:Object={};
		
		/**
		 * 游戏服务器
		 * @author CHENZHENG
		 */	
		public function BallGameServer()
		{
			//注册所有消息(否则接收不到)
			MessageInit.init();
			
			//初始化服务器socket
			socketServer=new SocketServer();
			//初始化事件中心
			eventServer=new EventDispatcher();
			//初始化客户端监听
			initClientEvent();
			
			//初始化房间管理器
			roomManager=RoomManager.I();
			roomManager.init(eventServer,clients);
		}
		
		/**
		 * 初始化客户端连接、断开监听
		 */		
		private function initClientEvent():void
		{
			//监听客户端上线事件
			socketServer.on(ServerEvent.CLIENT_CONNECT,this,onConnect);
			//监听客户端下线事件
			eventServer.on(ServerEvent.CLIENT_CLOSE,this,onClose);
		}
		
		
		/**
		 * 玩家上线消息，创建客户端
		 * @param webSocket 服务器为客户端分配的对应webSocket
		 */		
		private function onConnect(webSocket:Object):void
		{
			clientId++;
			clientCount++;
			//创建客户端
			var serverClient:ServerPlayer=new ServerPlayer();
			serverClient.init(webSocket,this.eventServer);
			//随机分配昵称与头像
			serverClient.nickname="测试昵称"+Math.round(Math.random()*100);
			serverClient.headId=Math.round(Math.random()*7);
			serverClient.sourceId=Math.round(Math.random()*3);
			
			//分配客户端Id并进入列表
			serverClient.clientId=clientId;			
			clients[clientId]=serverClient;
			
			//初始化客户端属性消息并发送
			clientDataMsg=new ClientDataMsg(serverClient);
			serverClient.send(clientDataMsg);
			
			var num:int=0;
			for(var p:String in clients)  num++;
			trace("玩家----"+serverClient.nickname+"----上线了！在线人数为："+num);
		}

		
		/**
		 * 玩家离开游戏
		 * @param serverClient 离线的客户端
		 */	
		private function onClose(client:ServerPlayer):void
		{
			//移除房间中的此玩家
			roomManager.clientRemove(client);

			//删除离开的客户端，如果在线人数无，clientId清零
			delete clients[client.clientId];
			clientCount--;
			if(clientCount==0) this.clientId=0;
			trace("有客户端离线了！在线人数为："+clientCount);
			
			client=null;
		}
		
	}
}