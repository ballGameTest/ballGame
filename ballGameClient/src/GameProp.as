package
{
	import laya.utils.Pool;
	
	import msgs.ItemDataMsg;

	public class GameProp extends GameItem
	{
		public var flyDistance:int=300;
		private var isFly:Boolean=false;
		public var radius:int=10;
		
		public var roleId:int=0;
		
		public function GameProp()
		{
		}
		
		public function init(msg:ItemDataMsg):void
		{
			this.id=msg.id;
			this.x=msg.x;
			this.y=msg.y;
			this.sourceId=msg.sourceId;
			this.angle=msg.angle;
			
			this.type=this.PROP;
			this.speed=6;
			this.flyDistance=100;
			this.initRadius=this.radius=10;
			this.weight=50;
			
			this.setSource(this.sourceId,this.radius)
				
				
			var radians:Number = Math.PI / 180 *this.angle;
			this.speedX=Math.sin(radians)*speed;  
			this.speedY=Math.cos(radians)*speed;
			Laya.timer.loop(16,this,onLoop);
		}
		
		private function onLoop():void
		{
			this.x+=this.speedX;
			this.y+=this.speedY;
			flyDistance-=this.speed;
			if(this.flyDistance<=0)
			{
				Laya.timer.clearAll(this);
			}
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
			Pool.recover("gameProp",this);
		}
	}
}