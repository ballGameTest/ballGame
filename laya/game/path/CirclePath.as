package laya.game.path {
	import laya.game.path.PathBase;
	
	/**
	 * 圆形路径，实现了围绕圆形路径运动的效果
	 */
	public class CirclePath extends PathBase {
		private static const RadToRot:Number = 180 / Math.PI;
		private static const Pi2:Number = Math.PI * 2;
		
		protected var _target:*;
		protected var _limitTime:Number;
		protected var _flyTime:Number;
		protected var _radius:Number;
		protected var _centerX:Number;
		protected var _centerY:Number;
		protected var _startRotation:Number;
		protected var _startRad:Number;
		protected var _speed:Number;
		protected var _speedRad:Number;
		
		/**
		 * 根据设定的圆心，半径，在指定时间内运动一圈
		 * @param target 目标对象
		 * @param x 中心点x
		 * @param y 中心点y
		 * @param r 圆形半径
		 * @param time 时间
		 * @param offTime 偏移时间
		 */
		public function moveTo(target:*, x:Number, y:Number, radius:Number, time:Number, offTime:Number):void {
			_target = target;
			_startRotation = target.rotation;
			_limitTime = time;
			_flyTime = offTime;
			_startRad = 0;
			_speed = Pi2 / time;
			_centerX = x;
			_centerY = y;
			this._radius = radius;
		}
		
		/**
		 * 根据设定的圆心，半径，开始角度位置，速度，运行指定时间结束（不保证一圈）
		 * @param target 目标对象
		 * @param x 中心点x
		 * @param y 中心点y
		 * @param startRad 开始弧度
		 * @param r 圆形半径
		 * @param speed 运动速度(弧度)
		 * @param time 运动时间
		 * @param offTime 偏移时间
		 */
		public function moveTo2(target:*, x:Number, y:Number, startRad:Number, radius:Number, speed:Number, time:Number, offTime:Number):void {
			_target = target;
			_startRotation = speed > 0 ? 90 : -90;
			//startRotation=startRotation
			_limitTime = time;
			_flyTime = offTime;
			this._startRad = startRad;
			_startRotation += startRad * RadToRot;
			this._speed = speed;
			_centerX = x;
			_centerY = y;
			this._radius = radius;
			var chanageRad:Number;
			chanageRad = speed * _flyTime;
			var rot:Number = startRad + chanageRad;
			_speedRad = rot;
			_target.pos(_centerX + radius * Math.cos(rot), _centerY + radius * Math.sin(rot));
			_target.rotation = _startRotation + chanageRad * RadToRot;
		}
		
		override public function update():void {
			if (!Game.timer) return;
			var delta:Number = Game.timer.delta;
			_flyTime += delta;
			if (_flyTime > _limitTime) {
				complete();
				return;
			}
			var chanageRad:Number;
			chanageRad = _speed * _flyTime;
			var rot:Number = _startRad + chanageRad;
			_speedRad = rot;
			_target.pos(_centerX + _radius * Math.cos(rot), _centerY + _radius * Math.sin(rot));
			_target.rotation = _startRotation + chanageRad * RadToRot;
		}
	}
}