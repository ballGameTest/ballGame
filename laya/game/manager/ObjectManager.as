package laya.game.manager {
	import laya.game.rpg.GameObject;
	import laya.utils.ClassUtils;
	
	/**
	 * ObjectManager为对象管理器，实现基于配置表的对象创建管理
	 * 对象创建是根据配置表里面的描述来创建实例
	 * 对象创建是基于对象池方式创建，尽量减少对象创建，减少垃圾回收
	 * 对象使用完毕后，记得手动回收到对象池中，方便下次再用
	 */
	public class ObjectManager {
		
		private static var _config:Object;
		
		/**
		 * 使用数据表初始化对象管理器，config为一个json表
		 * @param	config 配置信息
		 */
		public static function init(config:Object):void {
			_config = config;
		}
		
		/**
		 * 根据ID创建对象（根据配置表的className创建，并创建后调用对象的initialize方法初始化实例，如果有layer属性，则会调用Game.scene.addToLayer添加到指定层中）
		 * 对象创建是基于对象池方式创建，使用完毕后要手动回收到池里面
		 * @param	id 资源表ID
		 * @return	返回对象实例
		 */
		public static function create(id:*):* 
		{
			if (_config[id]) {
				var info:Object = _config[id];
				var className:String = info.className || info.clas;
				var instance:GameObject = GameObject.createFromPool(ClassUtils.getClass(className));
				instance.initialize(info);
				if (info.layer) Game.scene.addToLayer(instance, info.layer);
				return instance;
			}
			console.warn("Cannot create resource by ID " + id);
			return null; 
		}
	}
}