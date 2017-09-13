package
{
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.utils.Pool;
	
	import msgs.ClientAngleMsg;
	import msgs.ClientDataMsg;
	import msgs.ItemDataMsg;

	/**
	 * 游戏玩家，游戏玩家控制类，内含游戏角色（可控制多个角色）
	 * @author CHENZHENG
	 */	
	public class GamePlayer extends EventDispatcher
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
		
		public var txtName:Text;
		
		public var id:int=0;
		public var x:Number=0;
		public var y:Number=0;
		public var speed:int=0;
		public var angle:int=0;
		public var sourceId:int=0;

		public var radius:int=25;
		public var weight:int=0;
		public var roles:Object={};
		public var rolesCount:int=0;
		public var mainRole:GameItem;
		
		/**
		 * 游戏玩家，游戏玩家控制类，内含游戏角色（可控制多个角色）
		 * @author CHENZHENG
		 */	
		public function GamePlayer()
		{

		}
		
		/**
		 * 初始化玩家数据
		 * @param playerData 玩家数据消息
		 */		
		public function initPlayerData(playerData:ClientDataMsg):void
		{
			roomId=playerData.roomId;
			isInRoom=playerData.isInRoom;
			clientId=playerData.clientId;
			isOriginator=playerData.isOriginator;
			nickname=playerData.nickname;
			headId=playerData.headId;
			
			sourceId=playerData.sourceId;
			this.x=playerData.x;
			this.y=playerData.y;
			this.speed=playerData.speed;
			this.angle=playerData.angle;
		}
		
		/**
		 * 创建操控的角色
		 * @param clientId 角色玩家id
		 * @param id 角色唯一id
		 * @return   返回角色
		 */		
		public function createRole(itemData:*):GameRole
		{
			var role:GameRole=Pool.getItemByClass("gameRole",GameRole);
			role.on(GameEvent.EAT_ITEM,this,weightChange);
			
			role.visible=true;
			role.clientId=itemData.clientId;
			role.id=itemData.id;
			role.type=role.ROLE;
			role.initRadius=role.radius=itemData.radius;
			role.setSource(itemData.sourceId);
			
			role.x=itemData.x;
			role.y=itemData.y;
			role.angle=itemData.angle;
			
			rolesCount++;
			roles[role.id]=role;
			//如果是第一个角色,设置为主角色
//			if(id==this.clientId) mainRole=role;
			
			weightChange();
			return role;
		}
		
		/**
		 * 现有角色分裂 
		 * @return 返回分裂出的球的数组
		 */		
		public function playerSplit():Array
		{
			var roleArr:Array=[];
			for(var p:String in roles)
			{
				var role:GameRole=Pool.getItemByClass("gameRole",GameRole);
				role.on(GameEvent.EAT_ITEM,this,weightChange);
				role.visible=true;
				role.clientId=this.clientId;
				role.x=roles[p].x;
				role.y=roles[p].y;
				role.type=role.ROLE;
				role.angle=roles[p].angle;
				role.sourceId=this.sourceId;
				
				role.weight=roles[p].weight/2;
				roles[p].addWeight(Math.round(-roles[p].weight/2));
				role.radius=roles[p].radius/2;
				role.speed=roles[p].speed;
				roleArr.push(role);
			}
			return roleArr;
		}
		
		/***创建玩家名字框***/
		public function initNameText():Text
		{
			txtName=new Text();
			txtName.text=this.nickname;
			txtName.font="黑体";
			txtName.fontSize=35;
			txtName.color="#ffffff";
			return txtName;
		}
		
		/**
		 * 计算所有玩家角色的总重量
		 */		
		public function weightChange():void
		{
			this.weight=0;
			for(var id:String in roles)
			{
				this.weight+=roles[id].weight;
			}
			this.event(GameEvent.PLAYER_WEIGHT);
		}
		
		/**
		 * 玩家角色被吃了，删除角色，计算重量
		 * @param roleId 被吃角色的Id
		 */		
		public function roleByEat(roleId:int):void
		{
			if(roles[roleId])
			{
				roles[roleId].kill();
				delete roles[roleId];
				rolesCount--;
				weightChange();
			}
		}
		
		/**
		 * 游戏玩家更新
		 */		
		private function update():void
		{
			//所有玩家角色的移动更新
			for(var id:String in roles)
			{
				roleMove(roles[id]);
				roles[id].splitFly();
			}
			
			this.x=mainRole.x;
			this.y=mainRole.y;
			
			//玩家的名字框位置更新
			if(this.mainRole&&this.txtName)
			{
				var xx:Number=mainRole.x-txtName.width/2;
				var yy:Number=mainRole.y-mainRole.height;
				txtName.pos(xx,yy);
			}
		}
		
		/**
		 * 设置玩家的移动角度
		 * @param angle 移动角度
		 */		
		public function setAngle(msg:ClientAngleMsg):void
		{
			this.angle=msg.angle;
			for(var id:String in roles)
			{
				roles[id].angle=angle;
			}
		}
		
		
		/**
		 * 角色移动
		 * @param role 移动的某个角色
		 */		
		private function roleMove(role:GameItem):void
		{
			var radians:Number = Math.PI / 180 *role.angle;
			role.speedX=Math.sin(radians)*speed;  
			role.speedY=Math.cos(radians)*speed;
			
			role.x+=role.speedX;
			role.y+=role.speedY;
		}
		
		/**
		 * 游戏玩家死亡消失，回收 
		 */		
		public function kill():void
		{
			for(var id:String in roles)
			{
				roles[id].kill();
			}
			this.roles={};
			this.rolesCount=0;
			Pool.recover("gamePlayer",this);
		}
	}
}