package laya.game.path {
	import laya.game.path.PathBase;
	
	/**
	 * 带运动补偿的直线路径，实现带补偿功能的，基于点或者方向的直线运动
	 * 用途：当服务器和客户端位移有偏差的时候（网络迟钝时），客户端进行补充运动，弥补这种差异
	 */
	public class CatchUpLinePath extends PathBase 
	{
		/**设置补偿到目标值所花费的帧数，默认为60帧补偿完毕*/
		public static var cacthFrameCount:int = 60;
		
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
		
		private var _startX:Number;
		private var _startY:Number;
		private var _offX:Number;
		private var _offY:Number;
		private var _curDx:Number = 0;
		private var _curDy:Number = 0;
		private var _curCatchCount:int = 0;
		
		/**
		 * 移动到某个点，速度和时间可二选一
		 * @param	target	目标对象
		 * @param	x		目标位置
		 * @param	y		目标位置
		 * @param	speed	速度，每毫秒移动的距离（速度和时间2选一）
		 * @param	time	时间（速度和时间2选一）
		 * @param	offX	偏移x
		 * @param	offY	偏移y
		 */
		public function moveTo(target:*, x:Number, y:Number, speed:Number, time:int = -1, offX:Number = 0, offY:Number = 0):void 
		{
			_target = target;
			_targetX = x;
			_targetY = y;
			
			this._offX = offX;
			this._offY = offY;
			
			_startX = _target.x + offX;
			_startY = _target.y + offY;
			
			var dx:Number = x - target.x;
			var dy:Number = y - target.y;
			
			if (time === -1) time = Math.sqrt(dx * dx + dy * dy) / speed;
			
			_speedX = dx / time;
			_speedY = dy / time;
			spendTime = 0;
			_durationTime = time;
			
			_curCatchCount = cacthFrameCount;
			_curDx = _offX / cacthFrameCount;
			_curDy = _offY / cacthFrameCount;
		}
		
		/**
		 * 朝着某个角度移动，速度和时间可二选一
		 * @param	target	目标对象
		 * @param	radian	弧度值
		 * @param	speed	速度
		 * @param	time	时间（速度和时间2选一）
		 * @param	offX	偏移x
		 * @param	offY	偏移y
		 */
		public function moveBy(target:*, radian:Number, speed:Number, time:int = -1, offX:Number = 0, offY:Number = 0):void
		{
			_target = target;
			
			this._offX = offX;
			this._offY = offY;
			
			_startX = _target.x + offX;
			_startY = _target.y + offY;
			
			_speedX = speed * Math.cos(radian);
			_speedY = speed * Math.sin(radian);
			
			_targetX = _targetY = NaN;
			spendTime = 0;
			_durationTime = time;
			
			_curCatchCount = cacthFrameCount;
			_curDx = _offX / cacthFrameCount;
			_curDy = _offY / cacthFrameCount;
		}
		
		override public function update():void 
		{
			if (!Game.scene) return;
			var delta:Number = Game.scene.timer.delta;
			
			if (_curCatchCount >= 0) 
			{
				_offX = _curDx * _curCatchCount;
				_offY = _curDy * _curCatchCount;
				_curCatchCount--;
			}
			spendTime += delta;
			if (_durationTime != -1) 
			{
				if (spendTime >= _durationTime) 
				{
					stop();
					spendTime = _durationTime;
					_target.x = _startX + spendTime * _speedX - _offX;
					_target.y = _startY + spendTime * _speedY - _offY;
					complete();
					return;
				}
			}
			_target.x = _startX + spendTime * _speedX - _offX;
			_target.y = _startY + spendTime * _speedY - _offY;
		}
	}
}