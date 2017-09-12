package
{
	import laya.utils.Pool;

	public class GameRole extends GameItem
	{
		public var propWeight:int=200;
		
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
				var dx:Number=Math.sin(radians)*(this.radius+10);  
				var dy:Number=Math.cos(radians)*(this.radius+10);
				

				trace(11111,dx,dy,radius)
				prop.x=this.x+dx;
				prop.y=this.y+dx;
				
				trace(this.x,this.y);
				trace(prop.x,prop.y);
				
				prop.clientId=this.clientId;
				prop.roleId=this.id;
				prop.sourceId=this.sourceId;
				prop.type=this.PROP;
			}
			
			return prop;
		}
		
		
		/**
		 * 游戏物品增加重量，扩大半径
		 * @param addWeight 增加的重量
		 */		
		public function addWeight(addWeight:int):void
		{
			this.event(GameEvent.EAT_ITEM);
			this.weight+=addWeight;
			
			if(this.weight<5000)
			{
				this.scaleNum+=addWeight/3000
				
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