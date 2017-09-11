package laya.game.rpg {
	import laya.display.Sprite;
	import laya.game.rpg.IGameComponent;
	import laya.utils.Pool;
	
	/**
	 * 游戏组件基类，实现了基于对象池的封装，实现了基于插件的扩展方式
	 */
	public class GameObject extends Sprite {
		
		protected var _config:Object;
		private var _comps:Array;
		
		/**
		 * 从对象池内创建对象，推荐使用此方法创建对象示例，复用对象，不使用的时候调用recover进行回收。
		 * @param	clas 对象具体类
		 * @param	name 缓存对象的别名(可选)
		 * @return	返回一个实例
		 */
		public static function createFromPool(clas:Class, name:String = null):* {
			if (!name && !clas) clas = GameObject;
			return Pool.getItemByClass(name || _getFunName(clas), clas);
		}
		
		/**
		 * 移除自己，移除身上的组件，如果从对象池创建，请使用recover方法进行回收
		 * @param	destroy 是否销毁，建议除非以后再也不使用，否则不要销毁，调用recover回收到对象池方便下次再用
		 */
		public function kill(destroy:Boolean = false):void {
			removeSelf();
			removeAllComponent();
			if (destroy) this.destroy();
		}
		
		/**
		 * 回收到池里面，如果仅仅移除自己，请使用kill方法
		 * @param	name 缓存对象的别名(可选)
		 */
		public function recover(name:String = null):void {
			kill();
			var comp:* = this;
			Pool.recover(name || _getFunName(comp.constructor), this);
		}
		
		/**
		 * 添加组件。组件实例后，通过组件的reg方法传入母体对象，由组件实现控制母体对象的操作，每类组件只有一个实例
		 * @param	clas 组件类
		 */
		public function addComponent(clas:Class):void {
			if (_getComponent(clas) === -1) {
				var comp:IGameComponent = Pool.getItemByClass(_getFunName(clas), clas);
				comp.reg(this);
				_comps ||= [];
				_comps.push(comp);
			}
		}
		
		protected static function _getFunName(fun:*):String {
			return fun.toString().match(/function\s*([^(]*)\(/)[1]
		}
		
		/**
		 * 移除组件
		 * @param	comp 组件
		 */
		public function removeComponent(clas:Class):void {
			var index:int = _getComponent(clas);
			if (index !== -1) {
				var comp:IGameComponent = _comps.splice(index, 1);
				comp.unReg();
				Pool.recover(_getFunName(clas), comp);
			}
		}
		
		/**
		 * 移除所有组件
		 */
		public function removeAllComponent():void {
			if (!_comps) return;
			for (var i:int = _comps.length - 1; i > -1; i--) {
				var comp:* = _comps[i];
				comp.unReg();
				Pool.recover(_getFunName(comp.constructor), comp);
			}
			_comps.length = 0;
		}
		
		/**
		 * 是否有某个组件
		 * @param	clas 组件名称
		 * @return  返回组件索引位置，如果为-1，则没有这样的组件
		 */
		public function hasComponent(clas:Class):Boolean {
			return _getComponent(clas) !== -1;
		}
		
		private function _getComponent(clas:Class):int {
			if (!_comps) return -1;
			for (var i:int = _comps.length - 1; i > -1; i--) {
				if (_comps[i] is clas) {
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * 获得组件实例，如果没有则返回为null
		 * @param	clas 组建类型
		 * @return	返回组件实例
		 */
		public function getComponent(clas:Class):IGameComponent {
			var index:int = _getComponent(clas);
			if (index !== -1) return _comps[index];
			return null;
		}
		
		/**
		 * 通过配置信息初始化
		 * @param	config
		 */
		public function initialize(config:Object):void {
			_config = config;
		}
	}
}