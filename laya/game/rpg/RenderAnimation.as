package laya.game.rpg {
	import laya.display.Animation;
	import laya.renders.RenderContext;
	import laya.utils.Browser;
	
	/**
	 * 基于render运行的动画，功能同Animation，但是渲染更改为基于render渲染，节点不显示的时候，动画会自动停止播放
	 */
	public class RenderAnimation extends Animation
	{
		private var _lastTime:Number;
		
		override public function play(start:* = 0, loop:Boolean = true, name:String = ""):void {
			if (loop) {
				if (name) _setFramesFromCache(name);
				this._isPlaying = true;
				this.index = (start is String) ? _getFrameByLabel(start) : start;
				this.loop = loop;
				this._actionName = name;
				_isReverse = wrapMode == 1;
				_lastTime = Browser.now();
			} else {
				super.play(start, loop, name);
			}
		}
		
		override public function render(context:RenderContext, x:Number, y:Number):void {
			if (loop) {
				var timeOut:Boolean = (Laya.timer.currTimer - _lastTime) >= _interval;
				if (timeOut) {
					_lastTime = Laya.timer.currTimer;
					_frameLoop();
				}
			}
			super.render(context, x, y);
		}
	}
}