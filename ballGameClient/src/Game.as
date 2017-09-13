package
{
	import game.manager.DataManager;
	import game.net.GameSocket;
	import game.net.IMessage;
	
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.events.EventDispatcher;
	import laya.utils.Pool;
	
	import msgs.ClientAngleMsg;
	import msgs.ClientLeaveMsg;
	import msgs.ClientLostMsg;
	import msgs.ClientReviveMsg;
	import msgs.ClientSplitMsg;
	import msgs.EatItemMsg;
	import msgs.GameCreateMsg;
	import msgs.GameOverMsg;
	import msgs.GameStartMsg;
	import msgs.ItemDataMsg;
	import msgs.PropDataMsg;
	
	import view.ControlView;
	import view.GameView;
	import view.ReviveView;
	import view.RockerView;
	

	/**
	 *游戏主逻辑 
	 * 1.根据服务器的消息控制战斗中的对象
	 * 2.向服务器发送用户操作数据
	 * @author CHENZHENG
	 * 
	 */	
	public class Game extends Sprite
	{
		private static var instance:Game;
		
		/***游戏中UI***/
		private var gameView:GameView;
		/***游戏操控摇杆***/
		private var rocker:RockerView;
		private var control:ControlView;
		private var reviveView:ReviveView;
		
		
		/***游戏房间Id***/
		public var roomId:int=0;
		
		/***游戏场景***/
		private var scene:GameScene;
		/***游戏玩家***/
		public static var player:GamePlayer=new GamePlayer();
		public static var players:Object={};
		
		private var gameTime:int=0;
		
		
		
		/***物品被吃消息***/
		private var eatItemMsg:EatItemMsg=new EatItemMsg();
		/***玩家方向角度变化消息***/
		private var clientAngleMsg:ClientAngleMsg=new ClientAngleMsg();
		/***玩家复活消息***/
		private var clientReviveMsg:ClientReviveMsg=new ClientReviveMsg();
		/***玩家丢道具消息***/
		private var clientLostMsg:ClientLostMsg=new ClientLostMsg();
		/***玩家分裂消息***/
		private var clientSplitMsg:ClientSplitMsg=new ClientSplitMsg();
		
		/**
		 * 游戏主逻辑 
		 */		
		public function Game()
		{
			var bg:Sprite=new Sprite();
			bg.graphics.drawRect(0,0,Laya.stage.width,Laya.stage.height,"#000000");
			this.addChild(bg);
			
			initMsgs();
			
			scene=new GameScene();
			this.addChild(scene);
			
			gameView=new GameView();
			gameView.init(player);
			this.addChild(gameView);
			
			rocker=new RockerView(gameView)
			rocker.on(GameEvent.ANGLE_CHANGE,this,onAngleChange);
			gameView.addChild(rocker);
			
			this.control=new ControlView();
			this.control.on(GameEvent.PLAYER_LOST,this,onPlayerLost);
			this.control.on(GameEvent.PLAYER_SPLIT,this,onPlayerSplit);
			this.addChild(control);
			control.pos(Laya.stage.width-control.width,Laya.stage.height-control.height);
			
			reviveView=new ReviveView();
			reviveView.visible=false;
			reviveView.on(GameEvent.PLAYER_REVIVE,this,onPlayerRevive);
			this.addChild(reviveView);
		}
		
		/**
		 * 游戏单例
		 */
		public static function I():Game
		{
			if(!instance) instance=new Game();
			return instance;
		}
		
		/**
		 * 初始化游戏消息监听
		 */		
		private function initMsgs():void
		{
			//游戏创建消息监听
			DataManager.listen(GameCreateMsg,this,onGameCreate);
			//游戏开始消息监听
			DataManager.listen(GameStartMsg,this,onGameStart);
			//游戏结束消息监听
			DataManager.listen(GameOverMsg,this,onGameOver);
			
			//玩家离开游戏监听
			DataManager.listen(ClientLeaveMsg,this,onPlayerLeave);			
			//玩家移动角度变化监听
			DataManager.listen(ClientAngleMsg,this,onPlayerAngle);
			//玩家吐球消息监听
			DataManager.listen(ClientLostMsg,this,onClientLost);
			//玩家复活消息监听
			DataManager.listen(ClientSplitMsg,this,onClientSplit);
			//玩家吃道具消息监听
			DataManager.listen(EatItemMsg,this,onItemEaten);
			
			//玩家复活消息监听
			DataManager.listen(ClientReviveMsg,this,onClientRevive);
		}
		
		/**
		 * 玩家方向事件监听回调
		 * @param angle 摇杆角度
		 */		
		private function onAngleChange(angle:int):void
		{
			clientAngleMsg.angle=angle;
			clientAngleMsg.clientId=player.clientId;
			send(clientAngleMsg);
		}
		
		/**
		 * 玩家方向角度变化
		 * @param msg 玩家角度变化消息
		 */		
		private function onPlayerAngle(msg:ClientAngleMsg):void
		{
			players[msg.clientId].setAngle(msg);
		}

		/**
		 * 初始化玩家丢道具消息并发送
		 */		
		private function onPlayerLost():void
		{
			if(player.weight<200) return;
			this.clientLostMsg.clientId=player.clientId;
			var itemArr:Array=[];
			for(var p:String in player.roles)
			{
				var prop:GameProp=player.roles[p].createProp();
				if(prop)
				{
					var propDataMsg:PropDataMsg=new PropDataMsg(prop);
					itemArr.push(propDataMsg);
					Pool.recover("gameProp",prop)
				}
			}
			if(itemArr.length>0)
			{
				this.clientLostMsg.propDataArray=itemArr;
				send(this.clientLostMsg);
				trace("发送了丢道具消息",player.weight,clientLostMsg);
			}
		}
		
		/**
		 * 收到玩家丢道具消息
		 * @param msg 玩家丢道具消息
		 */		
		private function onClientLost(msg:ClientLostMsg):void
		{
			var roles:Object=players[msg.clientId].roles;
			trace(msg.propDataArray,roles);
			var len:int=msg.propDataArray.length;
			for(var m:int=0;m<len;m++)
			{
				var prop:GameProp=Pool.getItemByClass("gameProp",GameProp);
				prop.init(msg.propDataArray[m]);
				
				scene.starLayer.addChild(prop);
				scene.props[prop.id]=prop;
				roles[msg.propDataArray[m].roleId].addWeight(-prop.weight);
			}
		}
		
		/**
		 * 初始化玩家分裂消息并发送
		 */	
		private function onPlayerSplit():void
		{
			this.clientSplitMsg.clientId=player.clientId;
			var arr:Array=player.playerSplit();
			for(var i:int=0;i<arr.length;i++)
			{
				var itemData:ItemDataMsg=new ItemDataMsg(arr[i]);
				this.clientSplitMsg.roles.push(itemData);
				Pool.recover("gameRole",arr[i]);
			}
			trace("发送分裂消息----",this.clientSplitMsg);
			send(this.clientSplitMsg);
//			this.clientSplitMsg.roles=[];
		}
		/**
		 * 收到玩家分裂消息
		 * @param msg 玩家分裂的消息
		 */		
		private function onClientSplit(msg:ClientSplitMsg):void
		{
			var len:int=msg.roles.length;
			for(var i:int=0;i<len;i++)
			{
				var role:GameRole=players[msg.clientId].createRole(msg.roles[i]);
				role.clientId=msg.clientId;
				scene.roleLayer.addChild(role);
				role.isFly=true;
				scene.roles[role.id]=role;
			}
			trace("玩家分裂了消息",msg,role);
		}	
		
		/**
		 * 玩家离开游戏消息处理
		 * @param msg 玩家离开游戏消息
		 */	
		private function onPlayerLeave(msg:ClientLeaveMsg):void
		{
			players[msg.id].kill();
			delete players[msg.id];
		}		
		
		
		/**
		 * 游戏正式开始
		 */	
		private function onGameStart(msg:GameStartMsg):void
		{
			this.event(GameEvent.GAME_START);
			initPlayerRole();
			
			scene.player=player;
			scene.setViewport();
			
			Laya.timer.loop(16,this,onFrame);
		}	
		
		/**
		 * 收到创建游戏消息（或创建游戏物品消息）
		 */	
		private function onGameCreate(msg:GameCreateMsg):void
		{
			this.roomId=msg.roomId;
			gameView.gameTime=msg.gameTime;
			
			trace(msg,"-------");
			//如果地图id不一样时才创建地图
			if(msg.mapId!=scene.currentMapId) 	scene.createMap(msg.mapId);
 
			scene.createItems(msg.itemDataArray);
		}
		
		/**
		 *创建玩家角色
		 */	
		private function initPlayerRole():void
		{
			for(var id:String in players)
			{
				var player1:GamePlayer=players[id];
				//根据玩家Id创建初始角色
				scene.roles[id]=player1.createRole(player1);
				player1.mainRole=scene.roles[id];
				trace("创建角色----",player1.roles[id]);
				scene.roleLayer.addChild(scene.roles[id]);
				
				//创建玩家昵称文本框
				var nameTxt:Text=player1.initNameText();
				scene.nameLayer.addChild(nameTxt);
				
				//设置玩家角色层级为最上层
				if(player1.clientId==player.clientId)
				{
					scene.roleLayer.setChildIndex(scene.roles[id],scene.roleLayer.numChildren-1);
				}
			}
		}
		
		/**
		 *游戏时间循环
		 */	
		private function onFrame():void
		{
			//场景更新
			scene.update();
			
			//游戏玩家更新
			for(var id:String in players)
			{
				players[id].update();
			};
			
			//UI更新
			gameView.update();
			
			//遍历所有角色,与本玩家角色之间碰撞检测(玩家吃玩家检测)
			for (var i:* in scene.roles) 
			{
				var role:GameRole=scene.roles[i] as GameRole;
				if(role.clientId===player.clientId) continue;
				for(var m:String in player.roles)
				{   
					if(!role.visible) continue;
					else if(Math.abs(role.x-player.roles[m].x-2)<=Math.abs(role.radius-player.roles[m].radius)
							&&Math.abs(role.y-player.roles[m].y-2)<=Math.abs(role.radius-player.roles[m].radius)
							&&Math.abs(role.weight-player.roles[m].weight)>25)
					{
						//判断主角是否吃了其他玩家角色
						if(role.weight<player.roles[m].weight)
						{
							trace(players[role.clientId].nickname+"玩家角色被你吃了!");
							role.visible=false;
							//发送吃角色消息
							this.eatItemMsg.roleId=player.roles[m].id;
							this.eatItemMsg.roleClientId=player.clientId;
							this.eatItemMsg.eatId=role.id;
							this.eatItemMsg.eatClientId=role.clientId;
							this.eatItemMsg.eatWeight=role.weight;
							this.eatItemMsg.eatType=role.type
							send(this.eatItemMsg);
							
							players[role.clientId].txtName.visible=false;
							player.roles[m].addWeight(role.weight);
							role.kill();
							delete scene.roles[role.id];
						}
					}
				}
			}
			
			//本玩家角色与星星碰撞检测（吃道具,吃星星）
			var len:int=scene.starLayer.numChildren;
			//遍历星星，碰撞检测
			for(var j:int=0;j<len;j++)
			{   
				var item:GameItem=scene.starLayer.getChildAt(j) as GameItem;
				if(item==null||!item.visible) continue;
				
				var myRoles:Object=player.roles;
				for (var n:String in myRoles) 
				{
					if(Math.abs(myRoles[n].x-item.x)<=Math.abs(myRoles[n].radius-item.radius)&&
						Math.abs(myRoles[n].y-item.y)<=Math.abs(myRoles[n].radius-item.radius))
					{
						item.visible=false;
						this.eatItemMsg.eatId=item.id;
						this.eatItemMsg.roleClientId=player.clientId;
						this.eatItemMsg.roleId=scene.roles[n].id;
						this.eatItemMsg.eatClientId=-1;
						this.eatItemMsg.eatWeight=item.weight;
						send(this.eatItemMsg);
						
						myRoles[n].addWeight(item.weight);
						if(item.type==item.PROP) delete scene.props[item.id];
						else delete scene.items[item.id];
						item.kill();
					}
				}
			}
		}
		
		/**
		 * 其他玩家角色吃到东西消息处理
		 */	
		private function onItemEaten(msg:EatItemMsg):void
		{
			trace(msg);
			//玩家角色被吃
			if(msg.eatClientId!=-1)
			{
				trace("“"+players[msg.eatClientId].nickname+"”角色被“"+players[msg.roleClientId].nickname+"”玩家角色吃了!");
				scene.roles[msg.roleId].addWeight(msg.eatWeight);
				
				if(msg.eatClientId==player.clientId) player.roleByEat(msg.eatId);
				
				//如果玩家没有角色了，显示复活界面
				if(player.rolesCount==0)
				{
					player.txtName.visible=false;
					rocker.visible=false;
					Laya.timer.once(1500,this,function():void
					{
						this.reviveView.visible=true;
					});
				}
				delete scene.roles[msg.eatId];
				
			}else//星星被吃
			{
				trace("星星"+msg.eatId+"被"+players[msg.roleClientId].nickname+"玩家角色吃了!");
				var role:GameRole=scene.roles[msg.roleId] as GameRole;
				role.addWeight(msg.eatWeight);
				var star:GameItem=scene.items[msg.eatId] as GameItem;
				delete scene.items[msg.eatId];
				star.kill();
			}
		}
		
		/***点击复活按钮事件回调,发送复活消息***/	
		private function onPlayerRevive():void
		{
			this.clientReviveMsg.roleId=player.clientId;
			this.clientReviveMsg.roleClientId=player.clientId;
			send(this.clientReviveMsg);
		}
		
		/***玩家复活消息处理***/		
		private function onClientRevive(msg:ClientReviveMsg):void
		{
			players[msg.roleClientId].x=msg.x;
			players[msg.roleClientId].y=msg.y;
			players[msg.roleClientId].txtName.visible=true;
			
			var role:GameItem=players[msg.roleClientId].createRole(msg.roleId);
			scene.roles[msg.roleId]=role;
			scene.roleLayer.addChild(role);
			
			this.reviveView.visible=false;
		}
		
		
		/**
		 * 发送消息
		 */	
		public static function send(msg:IMessage):void
		{
			BallGameClient.gameSocket.send(msg);
		}
		
		/**
		 * 游戏结束消息处理 
		 */
		private function onGameOver():void
		{
			this.event(GameEvent.GAME_OVER,[players]);
		}
		
		/**
		 * 游戏关闭，并初始化游戏
		 */		
		public function close():void
		{
			this.removeSelf();
			players={};
			scene.close();
			Laya.timer.clearAll(this);
		}
	}
}