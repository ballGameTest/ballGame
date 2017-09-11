package laya.game.path {
	import laya.game.path.PathBase;
	
	/**
	 * 回旋路径，实现了飞到目标位置又飞回来的路径
	 */
	public class GoAndBackPath extends PathBase {
		protected var _target:*;
		protected var _limitTime:Number;
		protected var _flyTime:Number;
		protected var _startX:Number;
		protected var _startY:Number;
		protected var _halfTime:Number;
		protected var _speedX:Number;
		protected var _speedY:Number;
		protected var _backRad:Number;
		protected var _speedRad:Number;
		
		/**
		 * 根据指定的开始坐标，方向，速度和来回时间，实现来回运动
		 * @param target 目标对象
		 * @param startX 起始x
		 * @param startY 起始y
		 * @param rad 飞行方向
		 * @param speed 飞行速度
		 * @param time 飞行时间
		 * @param offTime 开始时间偏移
		 */
		public function moveTo(target:*, startX:Number, startY:Number, rad:Number, speed:Number, time:Number, offTime:Number = 0):void {
			this._startX = startX;
			this._startY = startY;
			this._limitTime = time;
			_flyTime = offTime;
			_halfTime = time * 0.5;
			_target = target;
			_target.scaleX = 1;
			target.rotation = rad * 180 / Math.PI;
			_speedX = speed * Math.cos(rad);
			_speedY = speed * Math.sin(rad);
			_speedRad = rad;
			_backRad = rad + Math.PI;
		}
		
		override public function update():void {
			if (!Game.timer) return;
			var delta:Number = Game.timer.delta;
			_flyTime += delta;
			if (_flyTime > _limitTime) {
				complete();
				return;
			}
			if (_flyTime > _halfTime) {
				//_taget.x = startX + _halfTime * _speedX - (flyTime-_halfTime) * _speedX;
				_target.x = _startX + (_limitTime - _flyTime) * _speedX;
				_target.y = _startY + (_limitTime - _flyTime) * _speedY;
				_target.scaleX = -1;
				_speedRad = _backRad;
			} else {
				_target.x = _startX + _flyTime * _speedX;
				_target.y = _startY + _flyTime * _speedY;
			}
		}
	}
}