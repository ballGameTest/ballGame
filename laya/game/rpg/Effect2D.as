package laya.game.rpg {
	import laya.events.Event;
	import laya.net.Loader;
	import laya.utils.Handler;
	
	/**
	 * 2D特效基类，实现2D特效加载，播放及回收功能
	 */
	public class Effect2D extends GameObject {
		/**特效主题*/
		public var body:RenderAnimation;
		/**@private */
		private var _loaded:Boolean = false;
		
		/**
		 * 初始化特效，根据ID创建出特效动画
		 * @param	id 特效ID，根据ID创建出特效动画
		 */
		public function init(id:String):void {
			//TODO:从配置表里面读取
			if (id) {
				_loaded = false;
				load("effect/" + id + ".ani", "atlas/effect/" + id + ".json");
			} else {
				if (body) body.graphics = null;
			}
		}
		
		/**
		 * 根据指定的动画路径和图集路径，加载并显示特效动画
		 * @param	aniPath 	动画路径
		 * @param	atlasPath	图集路径
		 */
		public function load(aniPath:String, atlasPath:String):void {
			if (Laya.loader.getRes(atlasPath)) _onLoaded(aniPath);
			else Laya.loader.load(atlasPath, Handler.create(this, _onLoaded, [aniPath]), null, Loader.ATLAS);
		}
		
		/**@private */
		private function _onLoaded(aniPath:String):void {
			_loaded = true;
			if (!body) addChild(body = new RenderAnimation());
			body.loadAnimation(aniPath);
		}
		
		/**
		 * 播放动画，可以指定播放动画名称以及是否自动回收
		 * @param	loop
		 * @param	action
		 * @param	autoRecover
		 */
		public function play(loop:Boolean = false, action:String = null, autoRecover:Boolean = true):void {
			if (loop === false) {
				if (_loaded) {
					autoRecover && body.once(Event.COMPLETE, this, this._recoverLater);
				} else {
					autoRecover && _recoverLater();
					return;
				}
			}
			if (body) body.play(0, loop, action);
		}
		
		private function _recoverLater():void {
			//TODO:临时
			Laya.timer.frameOnce(1, this, recover);
		}
	}
}