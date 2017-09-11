package laya.game.rpg {
	import laya.display.Animation;
	import laya.game.path.CatchUpLinePath;
	import laya.game.path.LinePath;
	import laya.game.path.PathBase;
	import laya.game.rpg.RenderAnimation;
	import laya.net.Loader;
	import laya.utils.Handler;
	import laya.utils.Pool;
	
	/**
	 * 2D精灵基类，基于GameObject类，实现了基于8方向动画展示，动作切换，方向切换，行走等基础功能
	 */
	public class Sprite2D extends GameObject {
		
		protected static const DIR_MAP:Object = {7: 9, 4: 6, 1: 3};
		protected static const DIR_KEY:Array = [3, 2, 1, 4, 7, 8, 9, 6];
		
		/**角色身体*/
		public var body:Animation;
		/**移动速度，每毫秒移动的距离*/
		public var speed:Number = 0.2;
		/**朝向弧度*/
		public var orientation:Number = 0;
		/**是否在移动*/
		public var isMoveing:Boolean;
		
		protected var _isHero:Boolean;
		protected var _action:String = "idle";
		protected var _direction:int = 2;
		protected var _path:PathBase;
		private var _tx:Number = 0;
		private var _ty:Number = 0;
		
		public function Sprite2D() {
			this.size(10, 10);
		}
		
		/**
		 * 初始化精灵，根据ID创建出精灵的形象及动画
		 * @param	id 精灵ID，根据ID获取精灵的形象及动画信息
		 */
		public function init(id:String):void {
			//TODO:根据配置信息，获取aniPath和atlasPath初始化
			load("battle/role/role" + id + ".ani", "atlas/battle/role/role" + id + ".json");
		}
		
		/**@private 编辑器专用*/
		public function set source(value:String):void {
			var arr:Array = value.split("\/");
			var name:String = arr[arr.length - 1].replace(".ani", "");
			init(name);
		}
		
		/**
		 * 根据指定的动画路径和图集路径，加载并显示角色动画
		 * @param	aniPath 	动画路径
		 * @param	atlasPath	图集路径
		 */
		public function load(aniPath:String, atlasPath:String):void {
			if (Laya.loader.getRes(atlasPath)) _onLoaded(aniPath);
			else Laya.loader.load(atlasPath, Handler.create(this, _onLoaded, [aniPath]), null, Loader.ATLAS);
		}
		
		protected function _onLoaded(aniPath:String):void {
			if (!body) addChild(body = new RenderAnimation());
			body.loadAnimation(aniPath);
			play();
		}
		
		/**获取设置角色动作，可以由IDE内预制出各种动画，然后通过action切换不同的动作*/
		public function get action():String {
			return _action;
		}
		
		public function set action(value:String):void {
			if (_action != value) {
				_action = value;
				play();
			}
		}
		
		/**
		 * 获取设置角色的方向，角色动画由角色动作+角色方向共同决定，角色方向请参考小键盘朝向
		 * 7  8  9
		 * 4     6
		 * 1  2  3
		 */
		public function get direction():int {
			return _direction;
		}
		
		public function set direction(value:int):void {
			if (_direction != value) {
				_direction = value;
				play();
			}
		}
		
		private function get _actionName():String {
			return _action + (DIR_MAP[_direction] || _direction);
		}
		
		/**播放角色动画，动画效果由角色动作+角色方向共同决定*/
		public function play():void {
			if (body) {
				body.scaleX = DIR_MAP[_direction] ? -1 : 1;
				body.play(0, true, _actionName);
			}
		}
		
		override public function get x():Number {
			return _tx;
		}
		
		override public function set x(value:Number):void {
			if (_isHero) {
				if (value < 0) value = 0;
				else if (value > Game.scene.width) value = Game.scene.width;
			}
			_tx = value;
			value = Math.round(value);
			if (value != _x) {
				if (_isHero) Game.scene.x -= value - _x;
				_x = value;
				conchModel && conchModel.pos(value, _y);
			}
		}
		
		override public function get y():Number {
			return _ty;
		}
		
		override public function set y(value:Number):void {
			if (_isHero) {
				if (value < 0) value = 0;
				else if (value > Game.scene.height) value = Game.scene.height;
			}
			_ty = value;
			value = Math.round(value);
			if (value != _y) {
				if (_isHero) Game.scene.y -= value - _y;
				_y = value;
				_zOrder = value;
				conchModel && conchModel.pos(_x, value);
			}
		}
		
		/**[只读]是否是主角，地图会始终跟随主角进行移动，可以通过Game.scene.setHero设置某个角色为主角*/
		public function get isHero():Boolean {
			return _isHero;
		}
		
		public function set isHero(value:Boolean):void {
			_isHero = value;
		}
		
		/**路径控制器*/
		public function get path():PathBase {
			return _path;
		}
		
		public function set path(value:PathBase):void {
			if (_path != value) {
				if (_path) _path.recover();
				_path = value;
			}
		}
		
		/**
		 * 角色朝向某个位置，根据坐标计算出角色应该朝向方向然后显示
		 * @param	x	X轴坐标
		 * @param	y	Y轴坐标
		 */
		public function faceTo(x:Number, y:Number):void {
			faceBy(Math.atan2(y - this.y, x - this.x));
		}
		
		/**
		 * 角色按照指定的弧度朝向显示
		 * @param	radian 弧度
		 */
		public function faceBy(radian:Number):void {
			if (radian < 0) radian += 2 * Math.PI;
			var index:int = Math.floor(radian / Math.PI * 8) - 1;
			index = index % 16;
			if (index == -1) index = 15;
			this.direction = DIR_KEY[Math.floor(index / 2)];
			orientation = radian;
		}
		
		/**
		 * 移动到某点，可以指定速度或者时间来走到某个位置，还可以设置移动结束后的朝向
		 * @param	x	目标X坐标
		 * @param	y	目标Y坐标
		 * @param	time	(可选)花费的时间，如果为-1，则根据速度计算出时间
		 * @param	endFaceRadian	(可选)移动结束后的朝向，单位为弧度
		 */
		public function moveTo(x:Number, y:Number, time:int = -1, endFaceRadian:Number = -1):void {
			if (!path) path = Pool.getItemByClass("LinePath", LinePath);
			LinePath(path).moveTo(this, x, y, speed, time);
			isMoveing = true;
			action = "run";
			faceTo(x, y);
			path.once("complete", this, _onMoveComplete, endFaceRadian != -1 ? [endFaceRadian] : null);
			path.start();
		}
		
		/**
		 * 根据指定的方向一直往前走，可以指定速度或者时间来走到某个位置，还可以设置移动结束后的朝向
		 * @param	radian	方向弧度值
		 * @param	time	(可选)花费的时间，如果为-1，则根据速度计算出时间
		 * @param	endFaceRadian	(可选)移动结束后的朝向，单位为弧度
		 * @return	是否能行走
		 */
		public function moveBy(radian:Number, time:int = -1, endFaceRadian:Number = -1):Boolean {
			if (!path) path = Pool.getItemByClass("LinePath", LinePath);
			LinePath(path).moveBy(this, radian, speed, time);
			isMoveing = true;
			action = "run";
			faceBy(radian);
			path.once("complete", this, _onMoveComplete, endFaceRadian != -1 ? [endFaceRadian] : null);
			path.start();
			return true;
		}
		
		protected function _onMoveComplete(endFaceRadian:Number):void {
			stopMove();
			if (endFaceRadian) faceBy(endFaceRadian);
		}
		
		/**
		 * 带位置补偿的位移，会自动补偿位置偏差（一般为网络延迟导致的位置偏差）
		 * @param	radian	方向弧度值
		 * @param	time	(可选)花费的时间，如果为-1，则根据速度计算出时间
		 * @param	offX	(可选)X位置偏差
		 * @param	offY	(可选)Y位置偏差
		 * @param	endFaceRadian	(可选)移动结束后的朝向，单位为弧度
		 * @return	是否能行走
		 */
		public function moveByWithOffset(radian:Number, time:int = -1, offX:Number = 0, offY:Number = 0, endFaceRadian:Number = -1):Boolean {
			if (!path) path = Pool.getItemByClass("CatchUpLinePath", CatchUpLinePath);
			CatchUpLinePath(path).moveBy(this, radian, speed, time, offX, offY);
			isMoveing = true;
			action = "run";
			faceBy(radian);
			path.once("complete", this, _onMoveComplete);
			path.start();
			return true;
		}
		
		/**
		 * 停止移动，并且切换到某个动作（默认为idle）
		 * @param	changeAction 切换到某个动作
		 */
		public function stopMove(changeAction:String = "idle"):void {
			if (path) path.stop();
			isMoveing = false;
			action = changeAction;  
		}
		
		/**
		 * 移除自己，停止移动，停止动画播放，移除扩展组件
		 * @param	destory 是否销毁，建议除非以后再也不使用，否则不要销毁，调用recover回收到对象池方便下次再用
		 */
		override public function kill(destory:Boolean = false):void {
			stopMove();
			if (body) {
				body.offAll();
				this.body.stop();
			}
			if (_isHero) isHero = false;
			super.kill(destory);
		}
	}
}