package
{
	import laya.utils.Pool;

	/**
	 * 玩家人角色
	 */	
	public class GameRole extends GameItem
	{
		public var propWeight:int=200;
		public var initRadius:int=0;
		public var initSpeed:int=0;
		private var flyDistance:int=100;
		public var isFly:Boolean=false;
		
		public function GameRole()
		{
		}
		
		/**
		 * 物品死亡消失
		 */		
		override public function kill():void
		{
			img.removeSelf();
			img=null;
			this.removeSelf();
			this.offAll();
			this.speed=this.speedX=this.speedY=0;
			Pool.recover("gameRole",this);
		}
		
		/**
		 * 创建吐球道具
		 */	
		public function createProp():GameProp
		{
			var prop:GameProp;
			if(this.weight-50<this.propWeight)
			{
				prop=null;
			}else
			{
				prop=Pool.getItemByClass("gameProp",GameProp);
				prop.angle=this.angle;
				var radians:Number = Math.PI / 180 *prop.angle;
				var dx:Number=Math.sin(radians)*(this.radius+prop.radius*2);  
				var dy:Number=Math.cos(radians)*(this.radius+prop.radius*2);
				
				prop.x=this.x+dx;
				prop.y=this.y+dy;
				
				prop.clientId=this.clientId;
				prop.roleId=this.id;
				prop.sourceId=this.sourceId;
				prop.type=this.PROP;
			}
			return prop;
		}
		
		/**
		 * 角色分裂时快速飞出
		 */		
		public function fly():void
		{
			if(!isFly) return;
			
			move(5);
			
			flyDistance-=5;
			if(this.flyDistance<=0)
			{
				isFly=false;
			}
		}
		/**
		 * 角色分裂
		 */		
		public function split():void
		{
			this.scaleNum/=3.1415926/2;
			this.scaleX=scaleNum;
			this.scaleY=scaleNum;
			this.initRadius=this.radius/=3.1415926/2;
			this.weight/=2;
			this.size(radius*2,radius*2);
			addSpeed(-this.weight*2);
			trace(this.speed,111111);
		}
		
		/**
		 * 角色合并
		 */	
		public function merge():void
		{
			
		}
		
		/**
		 * 角色移动
		 * @param role 移动的某个角色
		 */		
		public function move(_speed:int=0):void
		{
			var mySpeed:int;
			if(_speed!=0) mySpeed=_speed;
			else mySpeed=this.speed;

			var radians:Number = Math.PI / 180 *this.angle;
			this.speedX=Math.sin(radians)*mySpeed;  
			this.speedY=Math.cos(radians)*mySpeed;
			
			this.x+=this.speedX;
			this.y+=this.speedY;
		}
		
		/**
		 * 游戏物品增加或减少重量，扩大减小半径
		 * @param addWeight 增加的重量
		 */		
		public function addWeight(addWeight:int):void
		{
			this.weight+=addWeight;
			this.event(GameEvent.PLAYER_WEIGHT);
			
			if(this.weight<1000)
			{
				this.scaleNum+=addWeight/1000;
				
			}else
			{
				this.scaleNum+=addWeight/4000;
			}
			addSpeed(addWeight);
			setScale();
		}
		
		public function setScale():void
		{
			this.radius=initRadius*scaleNum;
			this.size(radius*2,radius*2);
			
			this.scaleX=scaleNum;
			this.scaleY=scaleNum;
		}
		
		public function addSpeed(addWeight:int):void
		{
			if(this.weight<1000)
			{
				this.speed-=this.speed*(addWeight/5000);
				
			}else 
			{
				this.speed-=this.speed*(addWeight/20000);
			}

			trace(this.id,"角色缩放比------",scaleNum,"速度------",this.speed);
		}
	}
}