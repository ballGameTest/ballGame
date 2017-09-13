package
{
	import laya.utils.Pool;

	public class GameRole extends GameItem
	{
		public var propWeight:int=200;
		public var initRadius:int=0;
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
		
		private function splitFly():void
		{
			if(!isFly) return;
			var radians:Number = Math.PI / 180 *this.angle;
			this.speedX=Math.sin(radians)*5;  
			this.speedY=Math.cos(radians)*5;
			
			this.x+=this.speedX;
			this.y+=this.speedY;
			flyDistance-=5;
			if(this.flyDistance<=0)
			{
				isFly=false;
			}
		}
		/**
		 * 游戏物品增加或减少重量，扩大减小半径
		 * @param addWeight 增加的重量
		 */		
		public function addWeight(addWeight:int):void
		{
			this.weight+=addWeight;
			this.event(GameEvent.EAT_ITEM);
			
			if(this.weight<5000)
			{
				this.scaleNum+=addWeight/3000;
				this.speed-=addWeight/3000/10;
				
			}else if(this.weight>5000&&this.weight<1000000)
			{
				this.scaleNum+=addWeight/10000
			}
			this.radius=initRadius*scaleNum;
			this.size(radius*2,radius*2);
			
			this.scaleX=scaleNum;
			this.scaleY=scaleNum;
			
		}
	}
}