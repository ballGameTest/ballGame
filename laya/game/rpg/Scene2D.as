package laya.game.rpg {
	import laya.display.Sprite;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.ui.View;
	import laya.utils.Tween;
	
	/**
	 * 2D场景基类，实现场景切换，滚动，裁剪，缩放，震屏，层级管理等功能
	 */
	public class Scene2D extends View {
		/**显示视口区域*/
		protected var _viewport:Rectangle;
		/**场景最小滚动位置x*/
		private var _xMin:Number;
		/**场景最小滚动位置y*/
		private var _yMin:Number;
		/**当前x未修正坐标*/
		private var _tx:Number = 0;
		/**当前y未修正坐标*/
		private var _ty:Number = 0;
		
		/**
		 * 切换场景
		 * @param	scene 当前场景
		 * @param	disposeBefore 是否销毁之前场景
		 */
		public static function change(scene:Scene2D, destroyBefore:Boolean = true):void {
			if (Game.scene) Game.scene.kill(destroyBefore);			
			var viewport:Rectangle = new Rectangle(0, 0, Laya.stage.width, Laya.stage.height);
			scene.setViewport(viewport);
			Game.scene = scene;
			Laya.stage.addChildAt(scene, 0);
			scene._updateMapLimit();
			Laya.stage.on("resize", scene, scene._onResize);
		}
		
		private function _onResize():void {
			_viewport.width = Laya.stage.width;
			_viewport.height = Laya.stage.height;
			_updateMapLimit();
			//重置hero到中心位置
			Game.hero && setHero(Game.hero);
		}
		
		/**
		 * 设置主角，地图会跟随主角移动
		 * @param	hero 主角
		 */
		public function setHero(hero:Sprite2D):void {
			if (Game.hero && Game.hero != hero) Game.hero.isHero = false;
			Game.hero = hero;
			hero.isHero = true;
			hero.parent || addToLayer(hero, "spriteLayer");
			
			//移动地图，使得主角居中
			pos(0, 0);
			var point:Point = localToGlobal(Point.TEMP.setTo(hero.x, hero.y));
			//pos(Math.round(Laya.stage.width * 0.5 - point.x), Math.round(Laya.stage.height * 0.5 - point.y));
			super.x = _tx = Math.round(Laya.stage.width * 0.5 - point.x);
			super.y = _ty = Math.round(Laya.stage.height * 0.5 - point.y);
			this.x = this.x;
			this.y = this.y;
		}
		
		/**
		 * 根据名称获取层
		 * @param	name 层名称
		 * @return	返回层
		 */
		public function getLayerByName(name:String):Sprite {
			return getChildByName(name) as Sprite
		}
		
		/**
		 * 添加对象到场景中某一层里面，如果没有这个层，则不进行添加
		 * @param	target 	显示对象
		 * @param	layer 	层名字
		 */
		public function addToLayer(target:Sprite, layer:String):void {
			var box:Sprite = getChildByName(layer) as Sprite;
			if (box) box.addChild(target);
			else console.log("Can't add to layer "+layer);
		}
		
		/**
		 * 设置场景渲染区域，区域外的子对象将不渲染
		 * @param	value	矩形区域
		 */
		public function setViewport(value:Rectangle):void {
			_viewport = value;
			for (var i:int = 0, n:int = numChildren; i < n; i++) {
				var sprite:Sprite = getChildAt(i) as Sprite;
				sprite.viewport = value;
			}
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			_xMin = Laya.stage.width - _width;
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			_yMin = Laya.stage.height - _height;
		}
		
		/**
		 * 更新地图移动区域限制
		 */
		private function _updateMapLimit():void {
			_xMin = Laya.stage.width - _width;
			_yMin = Laya.stage.height - _height;
		}
		
		override public function set x(value:Number):void {
			if (!_width > 0) {
				super.x = value;
				return;
			}
			
			value = value - super.x;
			var newValue:Number = _tx = _tx + value;
			
			if (newValue > 0) newValue = 0;
			else if (newValue < _xMin) newValue = _xMin;
			super.x = newValue;
			_viewport.x = -newValue;
		}
		
		override public function set y(value:Number):void {
			if (!_height > 0) {
				super.y = value;
				return;
			}
			
			value = value - super.y;
			var newValue:Number = _ty = _ty + value;
			
			if (newValue > 0) newValue = 0;
			else if (newValue < _yMin) newValue = _yMin;
			super.y = newValue;
			_viewport.y = -newValue;
		}
		
		/**
		 * 根据场景内的坐标为中心点进行场景缩放
		 * @param	x 场景内的x坐标
		 * @param	y 场景内的y坐标
		 * @param	scale 缩放值
		 * @param	time 缓动时间
		 */
		public function scaleScene(x:Number, y:Number, scale:Number, time:Number):void {
			var point:Point = Sprite(parent).localToGlobal(Point.TEMP.setTo(x, y));
			this.x = Laya.stage.width * 0.5 - point.x + x;
			this.y = Laya.stage.height * 0.5 - point.y + y;
			this.pivot(x, y);
			Tween.to(this, {scaleX: scale, scaleY: scale}, time);
		}
		
		/**
		 * 震动屏幕
		 * @param	x	X轴震幅
		 * @param	y	Y轴震幅
		 * @param	time	持续时间
		 */
		public function shakeScene(x:Number, y:Number, time:Number):void {
			//TODO:
		}
		
		/**
		 * 移除场景，如果有资源，记得销毁
		 */
		public function kill(destroy:Boolean = false):void {
			removeSelf();
			if (destroy) this.destroy();
			Laya.stage.off("resize", this, _onResize);
		}
	}
}