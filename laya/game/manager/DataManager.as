package game.manager {
	
	import laya.events.EventDispatcher;
	import game.net.MessageUtils;
	
	/**
	 * 数据管理器，集成数据存储，更新，事件派发等功能
	 * 数据中心实现了均衡负载功能，防止一瞬间大量数据处理导致帧率不稳定
	 * 所有的逻辑都应该以数据为中心进行驱动，数据发生变化时做相应的处理
	 */
	public class DataManager extends EventDispatcher {
		/**数据管理器单例*/
		public static var I:DataManager = new DataManager();
		/**单帧消息派发超时时间*/
		public var timeout:int = 40;
		
		protected var _msgs:Array = [];
		protected var _isBlock:Boolean;
		protected var _map:Object = {};
		
		/**
		 * 增加一条数据，同时派发相应事件
		 * @param	key 索引
		 * @param	data 数据
		 * @param	save 是否存储
		 */
		public function add(key:String, data:*, save:Boolean = true):void {
			_msgs.push(key, data);
			if (save) _map[key] = data;
			if (!_isBlock) _dispatch();
		}
		
		/**
		 * 增加一条数据
		 * @param	key 索引
		 * @param	data 数据
		 * @param	save 是否存储
		 */
		public function set(key:String, data:*, save:Boolean = true):void {
			_msgs.push(key, data);
			if (save) _map[key] = data;
		}
		
		/**
		 * 直接派发数据更新事件，功能同event
		 * @param	type 事件类型
		 * @param	data 数据
		 */
		public function notify(type:String, data:* = null):void {
			event(type, data);
		}
		
		/**
		 * 监听消息
		 * @param clz 消息类
		 * @param caller 执行域
		 * @param fun 回调函数
		 * @param params 参数
		 */
		public static function listen(clz:Class, caller:Object, fun:Function, params:Array = null):void 
		{
			I.on(MessageUtils.getClassKey(clz), caller, fun, params);
		}
		
		/**
		 * 取消监听
		 * @param clz 消息类
		 * @param caller 执行域
		 * @param fun 回调函数
		 */
		public static function cancel(clz:Class, caller:Object, fun:Function):void {
			I.off(MessageUtils.getClassKey(clz), caller, fun);
		}
		
		/**
		 * 获取数据
		 * @param clz 消息类
		 * @return
		 */
		public static function getData(clz:Class):* {
			return I.get(MessageUtils.getClassKey(clz));
		}
		
		private function _dispatch():void {
			_isBlock = true;
			while (_msgs.length) 
			{
				var key:String = _msgs.shift();
				var msg:* = _msgs.shift();
				event(key, msg);
//				if (Laya.stage.getTimeFromFrameStart() > timeout) {
//					Laya.timer.frameOnce(1, this, _dispatch);
//					return;
//				}
			}
			_isBlock = false;
		}
		
		/**
		 * 移除数据缓存
		 * @param	key 索引
		 */
		public function remove(key:String):void {
			delete _map[key];
		}
		
		/**
		 * 从缓存中获得数据
		 * @param	key 索引
		 */
		public function get(key:String):* {
			return _map[key];
		}
		
		/**
		 * 缓存中是否有索引为key的数据
		 * @param	key 索引
		 */
		public function has(key:String):Boolean {
			return _map[key] != null;
		}
	}
}