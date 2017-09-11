package game.manager {
	import game.net.DataDecoder;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.utils.Byte;
	import laya.utils.Handler;
	
	/**
	 *  数据表管理类，主要负责数据表读取，获取等操作。
	 *  数据表数据为二进制格式，数据来源于策划填写的Excel，经由工具自动导出为二进制格式。
	 */
	public class Database 
	{
		private static var _data:Object = {};
		
		/**
		 * 加载数据表，可以加载单独的地址或者地址数组
		 * @param	url 表url路径或者路径集合，加载完成后，将使用文件名作为表名索引存储
		 * @param	complete 加载完成回调
		 */
		public static function load(url:*, complete:Handler = null):void 
		{
			var loads:Array = [];
			if (url is Array) {
				var i:int, len:int;
				len = url.length;
				for (i = 0; i < len; i++) {
					loads.push({url: url[i], type: Loader.BUFFER});
				}
			} else if (url is String) {
				loads.push({url: url, type: Loader.BUFFER});
			}
			Laya.loader.load(loads, Handler.create(null, _dataLoaded, [url, complete]));
		}
		
		private static function _dataLoaded(url:*, complete:Handler):void 
		{
			if (url is Array) {
				var i:int, len:int;
				len = url.length;
				for (i = 0; i < len; i++) {
					_dealLoadedData(url[i]);
				}
			} else if (url is String) {
				_dealLoadedData(url);
			}
			if (complete) complete.run();
		}
		
		private static function _dealLoadedData(url:String):void {
			var fileName:String;
			fileName = URL.getFileName(url).split(".")[0];
			if (_data[fileName]) return;
			var buffer:* = Loader.getRes(url);
			var byte:Byte = new Byte(buffer);
			var datas:* = DataDecoder.decodeData(byte);
			_data[fileName] = datas;
		}
		
		/**
		 * 获取整张表集合，数据表中如果有id字段，则返回用id索引的object，否则为数组
		 * @param	sheetName 表名
		 * @return	返回数据表集合
		 */
		public static function getSheet(sheetName:String):* {
			return _data[sheetName];
		}
		
		/**
		 * 获取表中某条数据
		 * @param	sheetName	表名
		 * @param	id	id索引或者数组索引
		 * @return	返回具体的模型数据
		 */
		public static function get(sheetName:String, id:int):* {
			if (!_data[sheetName]) return null;
			return _data[sheetName][id];
		}
		
		/**
		 * 是否存在某表（表是否加载）
		 * @param	sheetName 表名
		 * @return	返回是否存在
		 */
		public static function hasSheet(sheetName:String):Boolean {
			return _data[sheetName] != null;
		}
	}
}