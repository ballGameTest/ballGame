package
{
	import laya.utils.Pool;
	
	import msgs.ItemDataMsg;

	public class GameProp extends GameItem
	{
		public var flyDistance:int=200;
		private var isFly:Boolean=false;
		
		public var roleId:int=0;
		
		public function GameProp()
		{
		}
		
		override public function init(msg:ItemDataMsg):void
		{
			this.visible=true;
			this.id=msg.id;
			this.x=msg.x;
			this.y=msg.y;
			this.sourceId=msg.sourceId;
			this.angle=msg.angle;
			
			this.type=this.PROP;
			this.speed=8;
			this.radius=12;
			this.weight=50;
			
			this.setSource(this.sourceId)
				
				
			var radians:Number = Math.PI / 180 *this.angle;
			this.speedX=Math.sin(radians)*speed;  
			this.speedY=Math.cos(radians)*speed;
			Laya.timer.loop(16,this,fly);
		}
		
		private function fly():void
		{
			this.x+=this.speedX;
			this.y+=this.speedY;
			flyDistance-=this.speed;
			if(this.flyDistance<=0)
			{
				stopMove();
			}
		}
		
		/**
		 * 停止移动
		 */	
		public function stopMove():void
		{
			Laya.timer.clearAll(this);
		}
		
		/**
		 * 物品死亡消失
		 */		
		override public function kill():void
		{
			img.removeSelf();
			this.removeSelf();
			flyDistance=200;
			this.offAll();
			this.speed=this.speedX=this.speedY=0;
			Pool.recover("gameProp",this);
		}
	}
}