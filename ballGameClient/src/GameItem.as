package 
{
	import laya.display.Sprite;
	import laya.ui.Image;
	import laya.utils.Pool;
	
	import msgs.ItemDataMsg;

	/**
	 * 游戏物品，可以是角色、星星、刺球等类型
	 * @author CHENZHENG
	 */	
	public class GameItem extends Sprite
	{
		public var clientId:int=-1;
		public var id :Number=0;
		public var type :int=0;
		public var sourceId :int=0;
		public var weight :Number=100;
		public var radius :Number=-1;
		public var speed :Number=0;
		
		public var scaleNum:Number=1;
		public var initRadius:int=30;
		
		public var speedX:Number=0;
		public var speedY:Number=0;
		public var angle:int=0;
		
		protected var img:Image;
		
		
		public const STAR:int=0;
		public const THORN:int=1;
		public const ROLE:int=2;
		public const PROP:int=3;
		
		/**
		 * 游戏物品，可以是角色、星星、刺球等类型
		 * @author CHENZHENG
		 */	
		public function GameItem()
		{
		}
		
		/**
		 * 根据消息初始化游戏物品
		 * @param itemMsg 创建物品的消息
		 */		
		public function init(itemMsg:ItemDataMsg):void
		{
			id=itemMsg.id;
			type=itemMsg.type;
			sourceId=itemMsg.sourceId;
			weight=itemMsg.weight;
			radius=itemMsg.radius;
			speed=itemMsg.speed;
			angle=itemMsg.angle;
			
			this.x=itemMsg.x;
			this.y=itemMsg.y;
			this.setSource(sourceId,radius);
			this.visible=true;
			itemMsg=null;
		}
		
		/**
		 * 设置物品资源
		 * @param sourceId 物品美术资源Id
		 * @param radius   物品半径
		 */		
		public function setSource(sourceId:int,radius:int):void
		{	
			this.initRadius=this.radius=radius;
			this.sourceId=sourceId;
			img=new Image()
				
			var itemName:String;
			if(type==STAR)  itemName="star";
			else if(type==THORN) itemName="thorn";
			else if(type==ROLE) itemName="role";
			else if(type==PROP) itemName="role";
			
			img.loadImage("element/"+itemName+sourceId+".png",-radius,-radius,radius*2,radius*2);
			this.addChild(img);
//			img.x=img.y=-radius;
			this.size(radius*2,radius*2);
		}

		/**
		 * 物品死亡消失
		 */		
		public function kill():void
		{
			img.removeSelf();
			img=null;
			this.removeSelf();
			this.offAll();
			this.speed=this.speedX=this.speedY=0;
			Pool.recover("gameItem",this);
		}
	}
}