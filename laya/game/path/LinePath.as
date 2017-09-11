package laya.game.path {
	import laya.game.path.PathBase;
	
	/**
	 * 直线路径，匀速运动，实现基于点或者方向的直线运动
	 */
	public class LinePath extends PathBase {
		/**消耗的时间，设置此值可以让路径快进到某一个位置*/
		public var spendTime:Number;
		
		/**目标对象*/
		protected var _target:*;
		/**目标位置*/
		protected var _targetX:Number;
		/**目标位置*/
		protected var _targetY:Number;
		/**持续总时间*/
		protected var _durationTime:Number;
		/**每一步的移动速度*/
		protected var _speedX:Number;
		/**每一步的移动速度*/
		protected var _speedY:Number;
		
		/**
		 * 移动到某个点，速度和时间可二选一
		 * @param	target	目标对象
		 * @param	x		目标位置
		 * @param	y		目标位置
		 * @param	speed	速度，每毫秒移动的距离，单位为像素（速度和时间2选一）
		 * @param	time	时间（速度和时间2选一）
		 */
		public function moveTo(target:*, x:Number, y:Number, speed:Number, time:int = -1):void {
			_target = target;
			_targetX = x;
			_targetY = y;
			var dx:Number = x - target.x;
			var dy:Number = y - target.y;
			
			if (time === -1) time = Math.sqrt(dx * dx + dy * dy) / speed;
			
			_speedX = dx / time;
			_speedY = dy / time;
			spendTime = 0;
			_durationTime = time;
		}
		
		/**
		 * 朝着某个角度移动，可以设定速度和时间二选一
		 * @param	target	目标对象
		 * @param	radian	弧度值
		 * @param	speed	速度
		 */
		public function moveBy(target:*, radian:Number, speed:Number, time:int = -1):void {
			_target = target;
			_speedX = speed * Math.cos(radian);
			_speedY = speed * Math.sin(radian);
			_targetX = _targetY = NaN;
			spendTime = 0;
			_durationTime = time;
		}
		
		override public function update():void {
			var delta:Number = Game.timer.delta;
			
			if (_durationTime != -1) {
				spendTime += delta;
				if (spendTime >= _durationTime) {
					spendTime = _durationTime;
					if (_targetX) _target.x = _targetX;
					if (_targetY) _target.y = _targetY;
					complete();
					return;
				}
			}
			_target.x += _speedX * delta;
			_target.y += _speedY * delta;
		}
	}
}