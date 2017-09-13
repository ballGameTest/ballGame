package
{
	import laya.display.Sprite;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.ui.View;
	import laya.utils.ClassUtils;
	import laya.utils.Pool;
	
	import ui.scene.Map01UI;
	import ui.scene.Map02UI;
	
	/**
	 * 游戏场景
	 * @author CHENZHENG
	 */	
	public class GameScene extends Sprite
	{
		/****场景地图底层*****/
		public var mapLayer:View;
		/****场景角色层*****/
		public var roleLayer:Sprite;
		/****场景星星层*****/
		public var starLayer:Sprite;
		/****角色名字框层*****/
		public var nameLayer:Sprite;
		/****场景显示视口矩形*****/
		private var viewportRect:Rectangle;
		
		
		public var player:GamePlayer;
		public var roles:Object={};
		public var items:Object={};
		public var props:Object={};
		
		/****当前的地图Id*****/
		public var currentMapId:int=-1;
		
		/**
		 * 游戏场景
		 * @author CHENZHENG
		 */
		public function GameScene()
		{
			starLayer=new Sprite();
//			starLayer.cacheAs="normal";
			this.addChild(starLayer);
			
			roleLayer=new Sprite();
			this.addChild(roleLayer);
			
			this.nameLayer=new Sprite();
			this.addChild(this.nameLayer);
		}
		
		/**
		 * 场景更新 
		 */		
		public function update():void
		{
			setViewport();
			//角色边界检测
			for(var id:String in roles)
			{
				this.roleBlock(roles[id]);
			}
			//道具边界检测
			for(var pp:String in props)
			{
				this.roleBlock(props[pp]);
			}
		}
		
		/**
		 * 创建地图底层 
		 * @param mapId 地图Id
		 */		
		public function createMap(mapId:int):void
		{
			this.currentMapId=mapId;
			ClassUtils.getClass("ui.scene.Map0"+mapId+"UI");
			mapLayer=ClassUtils.getInstance("ui.scene.Map0"+mapId+"UI");
			this.addChild(mapLayer);
			this.setChildIndex(mapLayer,0);
			
			this.size(2560,2560);
		}
		
		/**
		 * 创建场景物品
		 * @param msgArr  创建物品的消息列表
		 * @return 返回物品实例列表
		 * 
		 */		
		public function createItems(msgArr:Array):Object
		{
			var len:int=msgArr.length
			for(var i:int=0;i<len;i++)
			{
				var item:GameItem=Pool.getItemByClass("gameItem",GameItem);
				item.init(msgArr[i]);
				this.starLayer.addChild(item);
				items[item.id]=item;
			}
			trace("场景物品被创建了------------场景中星星数：",this.starLayer.numChildren,i);
			return items;
		}
		
		
		/*****设置游戏观察视口******/
		public function setViewport():void
		{
			var viewX:int=player.x-Laya.stage.width/2;
			//视口X边界检查,不超左右
			if(player.x<Laya.stage.width/2) viewX=0;
			if(player.x>this.width-Laya.stage.width/2) viewX=this.width-Laya.stage.width;
			
			var viewY:int=player.y-Laya.stage.height/2;
			//视口Y边界检查，不超上下
			if(player.y<Laya.stage.height/2) viewY=0;
			if(player.y>this.height-Laya.stage.height/2) viewY=this.height-Laya.stage.height;
			
			//游戏视图窗口更新
			viewportRect=new Rectangle(viewX,viewY,Laya.stage.width,Laya.stage.height);
			//设置地图滚动
			this.scrollRect=viewportRect;
			this.starLayer.viewport=viewportRect;
		}
		
		/**
		 * 角色与地图边界检测
		 * @param player
		 */		
		public function roleBlock(item:GameItem):void
		{
			//角色X边界检查
			if(item.x>this.width-item.width/2) 
			{
				item.x=this.width-item.width/2;
			}
			else if(item.x<item.width/2)
			{
				item.x=item.width/2;
			}
			//角色Y边界检查
			if(item.y>this.height-item.height/2) 
			{
				item.y=this.height-item.height/2;
			}
			else if(item.y<item.height/2)
			{
				item.y=item.height/2;
			}
//			if(item.type==item.PROP) (item as GameProp).stopMove();
		}
		
		/**
		 * 游戏结束，场景关闭清空
		 */		
		public function close():void
		{
			roles={};
			items={};
			mapLayer.removeChildren();
			roleLayer.removeChildren();
			nameLayer.removeChildren();
			starLayer.removeChildren();
		}
	}
}