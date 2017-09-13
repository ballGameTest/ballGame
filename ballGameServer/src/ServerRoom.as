package
{
	import game.manager.DataManager;
	import game.net.MessageBase;
	
	import laya.events.EventDispatcher;
	import laya.utils.Pool;
	
	import msgs.ClientAngleMsg;
	import msgs.ClientDataMsg;
	import msgs.ClientLeaveMsg;
	import msgs.ClientLostMsg;
	import msgs.ClientReviveMsg;
	import msgs.ClientSplitMsg;
	import msgs.ClientsCreateMsg;
	import msgs.EatItemMsg;
	import msgs.GameCreateMsg;
	import msgs.GameOverMsg;
	import msgs.GameStartMsg;
	import msgs.ItemDataMsg;

	/**
	 * 游戏房间，游戏消息转发、时间同步等
	 * @author CHENZHENG
	 */	
	public class ServerRoom
	{
		/**服务器事件中心****/
		public var eventServer:EventDispatcher;
		
		/**时间循环***/
		private var timer:Object={};
		
		/**房间id****/
		public var roomId:int=0;
		/**当前房间人数****/	
		public var clientsCount:int=0;
		public var clients:Object={};
		public var rolesCount:int=0;
		/**房间最大允许人数****/
		public var roomMaxCount:int=4;
		/**房间游戏是否开始****/
		public var roomStart:Boolean=false;
		
		/**房间游戏总时间****/
		private var roomTime:int=360000;
		/**服务器配置文件****/	
//		public var clients:Vector.<ServerPlayer>=new Vector.<ServerPlayer>;
		
		private var mapId:int=0;
		private var starCount:int=100
		private var thornCount:int=10;
		private var items:Object={};
		
		private const STAR:int=0;
		private const THORN:int=1;
		private const ROLE:int=2;
		private const PROP:int=3;
		
		private var itemId:int=0;
		
			
		/**房间客户端列表消息****/
		private var roomClientsMsg:ClientsCreateMsg;
		/***游戏开始消息***/
		private var gameStartMsg:GameStartMsg;
		/***游戏结束消息***/
		private var gameOverMsg:GameOverMsg;
		
		
		private var itemDataMsg:ItemDataMsg;
		private var gameCreateMsg:GameCreateMsg;
		private var clientLeaveMsg:ClientLeaveMsg;
		/***玩家复活消息***/
		private var clientReviveMsg:ClientReviveMsg;
		
		
		public function ServerRoom()
		{
			//玩家移动角度变化监听
			DataManager.listen(ClientAngleMsg,this,onPlayerAngle);
			//玩家吐球消息监听
			DataManager.listen(ClientLostMsg,this,onClientLost);
			//玩家吃道具监听
			DataManager.listen(EatItemMsg,this,onItemEaten);
			
			//玩家复活消息监听
			DataManager.listen(ClientReviveMsg,this,onClientRevive);
			//玩家复活消息监听
			DataManager.listen(ClientSplitMsg,this,onClientSplit);
		}
		
		/***转发玩家角度变化消息***/
		private function onPlayerAngle(msg:ClientAngleMsg):void
		{
			this.broadcastToRoom(msg);
		}
		
		/***转发玩家吐道具消息***/
		private function onClientLost(msg:ClientLostMsg):void
		{
			var len:int=msg.propDataArray.length;
			for(var i:int=0;i<len;i++)
			{
				//分配道具的id
				msg.propDataArray[i].id=this.itemId++;
			}
			this.broadcastToRoom(msg);
		}
		
		
		/***转发玩家分裂消息***/
		private function onClientSplit(msg:ClientSplitMsg):void
		{
			var len:int=msg.roles.length;
			for(var i:int=0;i<len;i++)
			{
				//分配新角色的id
				msg.roles[i].id=this.rolesCount++;
			}
			this.broadcastToRoom(msg);
		}	
		
		
		/***道具被吃消息处理***/
		private function onItemEaten(msg:EatItemMsg):void
		{
			if(msg.eatClientId==-1)
			{
				if(msg.eatType===this.STAR) 
				{
					starCount--;
//					delete items[msg.eatId];
				}
				else if(msg.eatType===this.THORN) 
				{
					thornCount--;
//					delete items[msg.eatId];
				}
				
//				Pool.recover("serverItem",items[msg.eatId]);
			}
			//排除吃角色的玩家
			this.broadcastToRoom(msg,clients[msg.roleClientId]);
			
			//如果星星少于80，继续创建
			if(this.starCount<=80)
			{			
				trace("------星星数："+starCount,"创建20个！！");
				this.createItems(this.STAR,20);
				this.broadcastToRoom(this.gameCreateMsg);
				this.starCount+=20;
			}
		}
		
		/***转发玩家复活消息***/		
		private function onClientRevive(msg:ClientReviveMsg):void
		{
			this.clientReviveMsg=msg;
			this.clientReviveMsg.x=Math.ceil(Math.random()*2450+100);
			this.clientReviveMsg.y=Math.ceil(Math.random()*2450+100);
			this.broadcastToRoom(clientReviveMsg);
		}	
		
		/**
		 * 游戏房间初始化 
		 * @param roomId  房间Id
		 * @param eventSer  服务器事件中心
		 * 
		 */		
		public function init(roomId:int,eventSer:EventDispatcher):void
		{
			this.roomId=roomId;
			this.eventServer=eventSer;
			
			//游戏房间地图Id初始化
			mapId=Math.ceil(Math.random()*2);
			//创建房间游戏物品
//			var msgArray1:Array=createItems(this.THORN,10);
			createItems(this.STAR,starCount);
		}
		
		
		/**
		 * 房间时间循环
		 */		
		public function onFrame():void
		{
			roomTime-=16;
//			trace(roomTime);
			//房间倒计时小于0，结束游戏
			if(roomTime<=0)  gameOver();
		}
		
		/**
		 * 房间游戏结束，游戏对象还原并回收
		 */		
		public function gameOver():void
		{
			//广播游戏结束消息
			gameOverMsg=new GameOverMsg();
			this.broadcastToRoom(gameOverMsg);			
			this.eventServer.event(ServerEvent.GAME_OVER,[this]);
			
			this.timer=__JS__("clearInterval(this.timer);");
			this.roomId=0;
			this.clientsCount=0;
			this.starCount=100;
			this.itemId=0;
			this.roomStart=false;
			this.roomTime=360000;
			for(var m:String  in clients)
			{
				clients[m].isInRoom=false;
			}
			clients={};
		}
		
		/**房间游戏开始****/
		public function gameStart():void
		{
			//房间人数少于2个，不发送消息
//			if(this.clientsCount<2) return;
			
			roomStart=true;
			//游戏开始消息，初始化游戏时间、游戏地图编号
			gameStartMsg=new GameStartMsg();
			
			//发送游戏开始消息
			broadcastToRoom(gameStartMsg);
			
			trace("房间"+roomId+"----开始游戏,游戏总时间为："+this.roomTime)
			
			//游戏房间计时开始
			timer=__JS__("setInterval(this.onFrame.bind(this),16);");
		}
		
		/**
		 * 根据类型创建游戏物品与相关消息。星星、刺球
		 * @param type   类型
		 * @param count  数量
		 */		
		private function createItems(type:int,count:int):void
		{
			var msgArray:Array=[];
			for(var i:int=0;i<count;i++)
			{
				var itemDataMsg:ItemDataMsg=new ItemDataMsg();
//				var item:ServerItem=Pool.getItemByClass("serverItem",ServerItem);
				if(type===this.THORN)
				{
					itemDataMsg.type=this.THORN;
					itemDataMsg.weight=Math.ceil(Math.random()*1000+300);
					itemDataMsg.radius=128;
				}else
				{
					itemDataMsg.type=this.STAR;
					itemDataMsg.weight=Math.ceil(Math.random()*50+20);
					itemDataMsg.radius=16;
				}
				itemDataMsg.id=itemId;
				itemDataMsg.sourceId=Math.ceil(Math.random()*6);
				itemDataMsg.x=Math.ceil(Math.random()*2520+20);
				itemDataMsg.y=Math.ceil(Math.random()*2520+20);
				
//				items[itemId]=item;				
				itemId++;

				msgArray.push(itemDataMsg);
			}
			
			//游戏房间创建消息
			gameCreateMsg=new GameCreateMsg();
			gameCreateMsg.itemDataArray=msgArray;
			gameCreateMsg.gameTime=roomTime;
			gameCreateMsg.roomId=roomId;
			gameCreateMsg.mapId=mapId;
		}
		
		
		/***玩家加入房间****/
		public function clientToRoom(client:ServerPlayer,roomId:int):void
		{
			client.type=this.ROLE;
			clients[client.clientId]=client;
			client.isInRoom=true;
			client.roomId=roomId;
			client.x=Math.ceil(Math.random()*2560);
			client.y=Math.ceil(Math.random()*2560);
			client.speed=2;
			client.angle=Math.ceil(Math.random()*360);
			
			this.clientsCount++;
			this.rolesCount++;
			
			//发送游戏房间物品表
			client.send(gameCreateMsg);
			
			//加入房间的客户端信息列表
			var arr:Array=[];
			for(var m:String in clients)
			{
				var clientDataMsg:ClientDataMsg=new ClientDataMsg(clients[m]);
				arr.push(clientDataMsg);
			}
			
			//客户端列表消息广播
			roomClientsMsg=new ClientsCreateMsg();
			roomClientsMsg.clients=arr;
			//广播玩家列表消息
			broadcastToRoom(roomClientsMsg);
		}
		
		/**
		 *玩家移除房间
		 */		
		public function clientRemove(client:ServerPlayer):void
		{
			//广播玩家离线消息
			this.clientLeaveMsg=new ClientLeaveMsg();
			this.clientLeaveMsg.id=client.clientId;
			this.broadcastToRoom(clientLeaveMsg,client);
			
			//删除房间中的客户端
			delete this.clients[client.clientId];
			client.isInRoom=false;
			this.clientsCount--;

			//如果房间客户端小于两人，游戏结束
			if(clientsCount<=1)
			{
				this.gameOver();
			}
		}
		
		/**
		 * 广播消息(房间) 
		 * @param msg 发送的消息
		 * @param exclude 排除的消息接收者
		 */		
		public function broadcastToRoom(msg:MessageBase,exclude:ServerPlayer=null):void
		{
			//遍历所有客户端并发送消息
			for(var i:* in clients)
			{
				if(exclude!=null&&i==exclude.clientId) continue;
				this.clients[i].send(msg); 
			}
		}
		
	}
}