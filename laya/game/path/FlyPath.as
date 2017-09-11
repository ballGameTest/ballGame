package laya.game.path {
	import laya.game.path.PathBase;
	import laya.maths.Point;
	
	/**
	 * 抛物飞行路径，实现了基于目标点的抛物线运动，同时可设置运行时是否旋转
	 */
	public class FlyPath extends PathBase {
		/**重力参数*/
		public static var g:Number = 0.005;
		private static const TransRate:Number = 57.29577951308232;
		private static var _pos:Point = new Point();
		
		/**运动过程中，是否同时旋转*/
		public var enableRotation:Boolean = false;
		
		protected var _startV:Point = new Point();
		protected var _startPos:Point = new Point();
		protected var _targetPos:Point = new Point();
		protected var _limitTime:Number;
		protected var _flyTime:Number;
		protected var _target:*;
		
		/**
		 * 根据指定的速度或者时间，抛物线飞行某个点
		 * @param target 目标对象
		 * @param x 距离x
		 * @param y 距离y
		 * @param speed 飞行速度，speed和time参数二选一
		 * @param time 飞行时间，speed和time参数二选一
		 */
		public function moveTo(target:*, x:Number, y:Number, speed:Number, time:int = -1):void {
			_target = target;
			_target.scaleX = 1;
			if (x == 0) x = 1;
			_startV.setTo(x, y);
			//y = target.y + y;
			if (time == -1) time = _startV.distance(0, 0) / speed;
			_startPos.setTo(target.x, target.y);
			_targetPos.setTo(target.x + x, target.y + y);
			//y = 0.5 * g * time * time + startV.y * time + startPos.y;
			_startV.y = (y - 0.5 * g * time * time) / time;
			_startV.x = _startV.x / time;
			_flyTime = 0;
			_limitTime = time;
		}
		
		/**
		 * 根据指定的角度，抛物线飞行一段距离
		 * @param target 目标对象
		 * @param radian 方向弧度
		 * @param speed 飞行速度
		 * @param len 飞行距离
		 */
		public function moveBy(target:*, radian:Number, speed:Number, len:Number):void {
			moveTo(target, len * Math.cos(radian), len * Math.sin(radian), speed, len / speed);
		}
		
		/**
		 * 根据指定初始点和目标点，在指定的时间内，抛物线飞行过去
		 * @param target 目标对象
		 * @param x 起始坐标x
		 * @param y 起始坐标y
		 * @param eX 目标x
		 * @param eY 目标y
		 * @param time 飞行时间
		 * @param offTime 时间偏移
		 */
		public function moveBy2(target:*, x:Number, y:Number, eX:Number, eY:Number, time:Number, offTime:Number = 0):void {
			target.pos(x, y);
			moveTo(target, eX - x, eY - y, 100, time);
			_flyTime = offTime;
		}
		
		private function getPosByTime(time:Number):Point {
			_pos.x = _startV.x * time + _startPos.x;
			_pos.y = 0.5 * g * time * time + _startV.y * time + _startPos.y;
			return _pos;
		}
		
		private function getRadian(time:Number):Number {
			//var dt:Number = 0.0001;
			//dx = dt * startV.x;
			//dy = 0.5 * g * (2 * time + dt) * (dt) + startV.y * dt;
			//dxy = dy / dx = startV.x / (0.5) * g * (2 * time + dt) + startV.y;
			//dxy = (g * time + startV.y) / startV.x
			var dxy:Number = (g * time + _startV.y) / _startV.x;
			var radian:Number = Math.atan(dxy) * TransRate;
			if (_startV.x < 0) radian += 180;
			return radian;
		}
		
		override public function update():void {
			if (!Game.timer) return;
			var delta:Number = Game.timer.delta;
			_flyTime += delta;
			if (_flyTime >= _limitTime) {
				getPosByTime(_limitTime);
				_target.pos(_pos.x, _pos.y);
				if (enableRotation) {
					_target.rotation = getRadian(_limitTime);
				}
				complete();
				return;
			} else {
				getPosByTime(_flyTime);
				if (enableRotation) {
					_target.rotation = getRadian(_flyTime);
				}
				//_target.scaleX = 1 - Math.abs((flyTime / limitTime) - 0.5) * 0.8;
				_target.pos(_pos.x, _pos.y);
			}
		}
	}

}