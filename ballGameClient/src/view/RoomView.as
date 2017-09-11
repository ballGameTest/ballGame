package view
{
	import game.manager.DataManager;
	
	import laya.events.Event;
	import laya.utils.Pool;
	
	import msgs.ClientsCreateMsg;
	import msgs.GameStartMsg;
	
	import ui.RoomUI;
	
	
	/**
	 *游戏房间界面。创建房间，等待好友加入；创建随机地图。 
	 * @author CHENZHENG
	 * 
	 */	
	public class RoomView extends RoomUI
	{
		private static var instance:RoomView;
		/**房间中玩家数量****/ 
		private var playersCount:int=0;
		/**当前房间Id****/ 
		private var roomId:int=0;
		
		/**本游戏玩家是否为房间主控****/
		private var isOriginator:Boolean=false;
		
		/**游戏主角****/ 
		private var player:GamePlayer;	
		
		
		/**游戏开始消息****/ 
		private var gameStartMsg:GameStartMsg;
		
		public function RoomView()
		{
			player=Game.player;
			
			this.btn_go.disabled=true;
			
			//游戏开始事件监听
			this.btn_go.on(Event.MOUSE_DOWN,this,onGameStart);	
			//玩家列表消息监听
			DataManager.listen(ClientsCreateMsg,this,onEnterRoom);
		}
		
		/**
		 * 房间页面单例
		 */		
		public static function I():RoomView
		{
			if(!instance) instance=new RoomView();
			return instance;
		}
		
		/**
		 * 正式开始游戏
		 */		
		private function onGameStart():void
		{		
			//房间人数少于2个，不发送开始消息
//			if(this.playersCount<2) return;
			
			gameStartMsg=new GameStartMsg();
			gameStartMsg.roomId=this.roomId;
			BallGameClient.gameSocket.send(gameStartMsg);
			
		} 
		
		/**
		 * 进入房间服务器消息处理
		 * @param msg  进入房间消息
		 */		
		private function onEnterRoom(msg:ClientsCreateMsg):void
		{
			//当前房间Id
			roomId=msg.clients[0].roomId;
			//玩家总数
			playersCount=msg.clients.length;
			
			//在UI中显示玩家信息
			for(var i:int=0;i<playersCount;i++)
			{
				//设置UI上的头像、昵称
				this["head"+i].index=msg.clients[i].headId;
				this["head"+i].visible=true;
				this["nickname"+i].text=msg.clients[i].nickname;
				this["nickname"+i].visible=true;
				
				//如果是本机玩家的消息不需创建
				if(player.clientId==msg.clients[i].clientId)
				{
					player.initPlayerData(msg.clients[i]);
					//设置主控游戏界面开始按钮 可点击
					this.btn_go.disabled=!msg.clients[i].isOriginator;
					//加入玩家列表
					Game.players[msg.clients[i].clientId]=player;
					
				}else
				{
					//不是本机玩家则创建
					var otherPlayer:GamePlayer=Pool.getItemByClass("gamePlayer",GamePlayer);
					otherPlayer.initPlayerData(msg.clients[i]);
					Game.players[msg.clients[i].clientId]=otherPlayer;
				}
			}
			trace("房间人数："+playersCount,Game.players);
			
		}
		
		/**
		 * 关闭并清空房间页面
		 */		
		public function close():void
		{
			this.removeSelf();
			for(var i:int=0;i<4;i++)
			{
				this["head"+i].visible=false;
				this["nickname"+i].visible=false;
			}
		}
	}
}