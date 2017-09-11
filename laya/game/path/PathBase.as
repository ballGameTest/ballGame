package laya.game.path {
	import laya.events.EventDispatcher;
	import laya.utils.Pool;
	
	/**
	 * 路径基类，实现了路径播放，更新，回收接口
	 * 路径播放完毕会派发"complete"事件
	 * 实现具体路径只需继承此类，重写update方法即可
	 * 引擎本身提供了几个通用路径的实现，比如直线路径，抛物线路径等，可以哪来直接使用
	 */
	public class PathBase extends EventDispatcher {
		/**是否在播放*/
		public var isPlaying:Boolean = false;
		
		/**更新路径，此函数在start被调用后，每帧都会执行。重写此方法，实现路径运动逻辑*/
		public function update():void {
		
		}
		
		/**开始播放路径*/
		public function start():void {
			if (isPlaying) return;
			isPlaying = true;
			Game.timer.frameLoop(1, this, update);
		}
		
		/**停止播放路径*/
		public function stop():void {
			isPlaying = false;
			Game.timer.clear(this, update);
		}
		
		/**立即停止并派发结束事件*/
		public function complete():void {
			stop();
			event("complete");
		}
		
		/**回收到对象池，回收名称为类名*/
		public function recover():void {
			offAll();
			stop();
			Pool.recover(this["constructor"].name, this);
		}
	}
}