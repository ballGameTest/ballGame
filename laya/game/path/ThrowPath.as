package laya.game.path {
	import laya.display.Sprite;
	import laya.game.path.PathBase;
	import laya.maths.Point;
	
	/**
	 * 抛物线路径，实现了模拟重力效果的抛物线运动，可用于掉血，物品掉落等效果
	 */
	public class ThrowPath extends PathBase {
		/**重力参数*/
		public static var g:Number = 0.0015;
		
		protected var _startPos:Point = new Point();
		protected var _startSpeed:Point = new Point();
		protected var _minY:Number;
		protected var _spendTime:Number;
		protected var _target:Sprite;
		
		/**
		 * 初始化抛物线数据
		 * @param target 目标对象
		 * @param speedX x起始速度
		 * @param speedY y起始速度
		 * @param minY 当Y落到某个值时结束
		 */
		public function init(target:Sprite, speedX:Number, speedY:Number, minY:Number):void {
			this._target = target;
			_startPos.setTo(target.x, target.y);
			_startSpeed.setTo(speedX, speedY);
			this._minY = minY;
			_spendTime = 0;
		}
		
		override public function update():void {
			if (!Game.scene) return;
			_spendTime += Game.scene.timer.delta;
			
			var x:Number = _startSpeed.x * _spendTime + _startPos.x;
			var y:Number = 0.5 * g * _spendTime * _spendTime + _startSpeed.y * _spendTime + _startPos.y;
			
			if (y < _minY) _target.pos(x, y);
			else complete();
		}
	}
}