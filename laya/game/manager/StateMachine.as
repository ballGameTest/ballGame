package laya.game.manager {
	import laya.utils.Handler;
	
	/**
	 * 状态机
	 * reference Javascript State Machine Library
	 * https://github.com/jakesgordon/javascript-state-machine
	 */
	public class StateMachine {
		public static var Result:Object = {SUCCEEDED: 1, // the event transitioned successfully from one state to another
			NOTRANSITION: 2, // the event was successfull but no state transition was necessary
			CANCELLED: 3, // the event was cancelled by the caller in a beforeEvent callback
			PENDING: 4  // the event is asynchronous and the caller is in control of when the transition occurs
		}
		
		public static var traceEnabled:Boolean=false;
		public static var WILDCARD:String = '*';
		public static var ASYNC:String = "async";
		
		public var current:String = 'none';
		public var terminal:String;
		public var transition:Function;
		public var event:String;
		public var from:String;
		public var to:String;
		
		protected var _callMap:Object = {};
		protected var _eventMap:Object = {};
		protected var _stateMap:Object = {};
		
		/**
		 * 创建一个状态机
		 * @param	initState 初始状态
		 * @param	events	事件集合
		 * @param	terminal 全局结束状态
		 * @return	返回状态机实例
		 */
		public static function create(initState:String, events:Array = null, callbacks:Array = null, terminal:String = null):StateMachine {
			var fsm:StateMachine = new StateMachine();
			fsm.terminal = terminal;
			
			if (initState) fsm.add('startup', 'none', initState);
			if (events) {
				for (var i:int = 0, n:int = events.length; i < n; i++) {
					fsm.add(events[i].event || events[i].name, events[i].from, events[i].to);
				}
			}
			if (callbacks) {
				for (var name:String in callbacks) {
					if (callbacks.hasOwnProperty(name))
						fsm.callback(name, callbacks[name]);
				}
			}
			if (initState) fsm.run('startup');
			
			return fsm;
		}
		
		/**
		 * 当前状态是否是制定参数的状态
		 * @param	state 字符串或者数组
		 */
		public function contain(state:*):Boolean {
			return (state is Array) ? (state.indexOf(this.current) >= 0) : (this.current === state);
		}
		
		/**
		 * 当前状态下，是否能执行指定行为
		 * @param	event 行为
		 */
		public function can(event:String):Boolean {
			return !(this.transition!=null) && (_eventMap[event][current] || _eventMap[event][WILDCARD]);
		}
		
		/**
		 * 当前状态下，是否不能执行指定行为
		 * @param	event 行为
		 */
		public function cannot(event:String):Boolean {
			return !can(event);
		}
		
		/**
		 * 返回当前状态下，所有关联的事件
		 */
		public function transitions():Array {
			return _stateMap[this.current];
		}
		
		/**
		 * 返回当前状态是否结束
		 */
		public function isFinished():Boolean {
			return contain(terminal);
		}
		
		/**
		 * 添加行为状态对应表
		 * @param	event 行为
		 * @param	from 开始状态
		 * @param	to	 结束状态
		 */
		public function add(event:String, from:*, to:String):void {
			var arr:Array = from is Array ? from : [from];
			_eventMap[event] || (_eventMap[event] = {});
			for (var i:int = 0, n:int = arr.length; i < n; i++) {
				var state:String = arr[i];
				_stateMap[state] || (_stateMap[state] = []);
				_stateMap[state].push(event);
				_eventMap[event][state] = to || state;
			}
		}
		
		/**
		 * 注册回调事件
		 * @param	event 回调事件名称
		 * @param	handler	 回调函数
		 */
		public function callback(event:String, handler:Handler):void {
			_callMap[event] = handler;
		}
		
		/**
		 * 执行预先定义好的行为
		 * @param	event 行为名称
		 * @return  返回执行行为的结果 0:失败，1:成功 100:在beforeEvent内被取消 101.异步等待
		 */
		public function run(event:String):Number {
			var map:Object = this._eventMap[event];
			if (!map) return 0;
			var from:String = current;
			var to:String = map[from] || map[WILDCARD] || from;
			
			if (this.transition!=null) {
				return _error(event, from, to, "event " + event + " inappropriate because previous transition did not complete");
			}
			
			if (cannot(event)) {
				return _error(event, from, to, "event " + event + " inappropriate in current state " + this.current);
			}
			
			this.event = event;
			this.from = from;
			this.to = to;
			
			if (false === _callEvent("before", event)) {
				return 1;
			}
			
			if (from === to) {
				_callEvent("after", event);
				return 1;
			}
			
			this.transition = this._doTransition;
			var leave:* = _callEvent("leave", from);
			if (leave === false) {
				this.transition = null;
				return 100;
			} else if (ASYNC === leave) {
				return 101;
			} else {
				if (this.transition!=null) return this.transition();
				else return 1;
			}
		}
		
		private function _doTransition():Number {
			this.transition = null;
			current = to;
			_callEvent("enter", to);
			_callEvent("change", from);
			_callEvent("after", event);
			return 1;
		}
		
		private function _callEvent(type:String, name:String):* {
			if (_callMap[type + name]) return _callMap[type + name].runWith(this);
			if (_callMap[type]) return _callMap[type].runWith(this);
			return true;
		}
		
		protected function _error(event:String, from:String, to:String, msg:String):Number {
			traceEnabled && trace("state:", msg);
			return 0;
		}
	}
}