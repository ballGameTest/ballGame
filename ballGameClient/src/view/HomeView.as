package view
{
	import game.manager.DataManager;
	
	import laya.events.Event;
	
	import msgs.ClientDataMsg;
	import msgs.EnterRoomMsg;
	import msgs.ClientsCreateMsg;
	
	import ui.MainUI;
	
	/**
	 *游戏大厅主UI页 
	 * @author CHENZHENG
	 * 
	 */	
	public class HomeView extends MainUI
	{
	
		/**游戏主角****/ 
		private var player:GamePlayer;		
		
		/***进入房间消息***/
		private var enterRoomMsg:EnterRoomMsg;
		
		private static var instance:HomeView;

		
		public function HomeView()
		{
			player=Game.player;
			
			this.btn_nameChange.on(Event.MOUSE_DOWN,this,onNameChange);
			//开始游戏进入房间监听
			this.btn_start.on(Event.MOUSE_DOWN,this,onEnterGame);
			
			//监听服务器分配的玩家数据信息
			DataManager.listen(ClientDataMsg,this,onServerConnect);
		}
		/**
		 * 大厅页面单例
		 */		
		public static function I():HomeView
		{
			if(!instance) instance=new HomeView();
			return instance;
		}
		
		/**
		 * 连接服务器后收到的欢迎消息处理
		 * @param msg 服务器发送的欢迎消息
		 */		
		private function onServerConnect(msg:ClientDataMsg):void
		{
			player.initPlayerData(msg);
			player.clientId=msg.clientId;
			this.txt_nickname1.text=player.nickname=msg.nickname;
			this.txt_nickname2.text="昵称："+player.nickname;
			this.icon_head.index=player.headId=msg.headId;
			trace("----用户昵称与头像ID为：",player.nickname,player.headId,player.clientId);
		}
		
		private function onNameChange():void
		{
		}
		
		/**
		 * 点击开始游戏进入房间
		 */		
		private function onEnterGame():void
		{
			this.event(GameEvent.GAME_CREATE);
			
			enterRoomMsg=new EnterRoomMsg();
			
			enterRoomMsg.clientDataMsg=new ClientDataMsg(player);
			BallGameClient.gameSocket.send(enterRoomMsg);
		}
	}
} 