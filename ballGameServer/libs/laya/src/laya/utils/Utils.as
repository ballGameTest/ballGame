package laya.utils {
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	
	/**
	 * <code>Utils</code> 是工具类。
	 */
	public class Utils {
		/**@private */
		private static var _gid:int = 1;
		/**@private */
		private static var _pi:Number = /*[STATIC SAFE]*/ 180 / Math.PI;
		/**@private */
		private static var _pi2:Number = /*[STATIC SAFE]*/ Math.PI / 180;
		
		/**
		 * 角度转弧度。
		 * @param	angle 角度值。
		 * @return	返回弧度值。
		 */
		public static function toRadian(angle:Number):Number {
			return angle * _pi2;
		}
		
		/**
		 * 弧度转换为角度。
		 * @param	radian 弧度值。
		 * @return	返回角度值。
		 */
		public static function toAngle(radian:Number):Number {
			return radian * _pi;
		}
		
		
		/**获取一个全局唯一ID。*/
		public static function getGID():int {
			return _gid++;
		}
		
		
		/**
		 * @private
		 * <p>连接数组。和array的concat相比，此方法不创建新对象</p>
		 * <b>注意：</b>若 参数 a 不为空，则会改变参数 source 的值为连接后的数组。
		 * @param	source 待连接的数组目标对象。
		 * @param	array 待连接的数组对象。
		 * @return 连接后的数组。
		 */
		public static function concatArray(source:Array, array:Array):Array {
			if (!array) return source;
			if (!source) return array;
			var i:int, len:int = array.length;
			for (i = 0; i < len; i++) {
				source.push(array[i]);
			}
			return source;
		}
		
		/**
		 * @private
		 * 清空数组对象。
		 * @param	array 数组。
		 * @return	清空后的 array 对象。
		 */
		public static function clearArray(array:Array):Array {
			if (!array) return array;
			array.length = 0;
			return array;
		}
		
		/**
		 * @private
		 * 清空source数组，复制array数组的值。
		 * @param	source 需要赋值的数组。
		 * @param	array 新的数组值。
		 * @return 	复制后的数据 source 。
		 */
		public static function copyArray(source:Array, array:Array):Array {
			source || (source = []);
			if (!array) return source;
			source.length = array.length;
			var i:int, len:int = array.length;
			for (i = 0; i < len; i++) {
				source[i] = array[i];
			}
			return source;
		}
		
		/**
		 * 给传入的函数绑定作用域，返回绑定后的函数。
		 * @param	fun 函数对象。
		 * @param	scope 函数作用域。
		 * @return 绑定后的函数。
		 */
		public static function bind(fun:Function, scope:*):Function {
			var rst:Function = fun;
			__JS__("rst=fun.bind(scope);");
			return rst;
		}
		
	}
}