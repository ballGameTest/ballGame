package game.net {
	import laya.utils.Byte;
	import laya.utils.ClassUtils;
	
	/**
	 * @private 数据表解析
	 */
	public class DataDecoder {
		public static var ConfigO:Object = {};
		public static const STRING:String = "string";
		public static const NUMBER:String = "number";
		public static const BOOLEAN:String = "boolean";
		public static const INT8:String = "int8";
		public static const UINT8:String = "uint8";
		public static const INT16:String = "int16";
		public static const UINT16:String = "uint16";
		public static const INT32:String = "int32";
		public static const UINT32:String = "uint32";
		public static const FLOAT32:String = "float32";
		public static const FLOAT64:String = "float64";
		
		public static function init():void {
			//ConfigO[类型] = [代码中的类型,存储类型];
			ConfigO["string"] = ["String", STRING];
			ConfigO["number"] = ["Number", NUMBER];
			ConfigO["int8"] = ["Number", INT8];
			ConfigO["uint8"] = ["Number", UINT8];
			ConfigO["int16"] = ["Number", INT16];
			ConfigO["uint16"] = ["Number", UINT16];
			ConfigO["int32"] = ["Number", INT32];
			ConfigO["uint32"] = ["Number", UINT32];
			ConfigO["float32"] = ["Number", FLOAT32];
			ConfigO["float64"] = ["Number", FLOAT64];
			ConfigO["boolean"] = ["Boolean", BOOLEAN];
			
			ConfigO["s"] = ["String", STRING];
			ConfigO["n"] = ["Number", NUMBER];
			ConfigO["i"] = ["Number", INT32];
			ConfigO["b"] = ["Boolean", BOOLEAN];
		}
		init();
		
		public static function getCodeType(type:String):String {
			if (ConfigO[type]) return ConfigO[type][0];
			return type;
		}
		
		public static function getStoreType(type:String):String {
			if (ConfigO[type]) return ConfigO[type][1];
			return STRING;
		}
		
		public static function readTypeFromByte(byte:Byte, type:String):* {
			var rst:*;
			switch (getStoreType(type)) {
				case STRING: 
					rst = byte.getUTFString();
					break;
				case NUMBER: 
					rst = byte.getFloat32();
					break;
				case INT8: 
					rst = byte.readByte();
					break;
				case UINT8: 
					rst = byte.getUint8();
					break;
				case INT16: 
					rst = byte.getInt16();
					break;
				case UINT16: 
					rst = byte.getUint16();
					break;
				case INT32: 
					rst = byte.getInt32();
					break;
				case UINT32: 
					rst = byte.getUint32();
					break;
				case FLOAT32: 
					rst = byte.getFloat32();
					break;
				case FLOAT64: 
					rst = byte.getFloat64();
					break;
				case BOOLEAN: 
					rst = byte.readByte() == 1;
					break;
			}
			return rst;
		}
		
		public static function decodeData(byte:Byte):* {
			var className:String;
			className = byte.readUTFString();
			var typeLen:int;
			typeLen = byte.getInt32();
			var i:int, len:int;
			len = typeLen;
			var keys:Array;
			keys = [];
			for (i = 0; i < len; i++) {
				keys.push(byte.readUTFString());
			}
			var hasIDKey:Boolean;
			hasIDKey = keys.indexOf("id") >= 0;
			var types:Array;
			types = [];
			for (i = 0; i < len; i++) {
				types.push(byte.readUTFString());
			}
			var dataLen:int;
			dataLen = byte.getInt32();
			len = dataLen;
			var datas:*;
			if (hasIDKey) {
				datas = {};
			} else {
				datas = [];
			}
			
			var tData:Object;
			var j:int, jLen:int;
			jLen = typeLen;
			
			var classZ:Class;
			classZ = ClassUtils.getClass(className);
			
			for (i = 0; i < len; i++) {
				if (classZ) {
					tData = new classZ();
				} else {
					tData = {};
				}
				
				for (j = 0; j < jLen; j++) {
					tData[keys[j]] = readTypeFromByte(byte, types[j]);
				}
				
				if (hasIDKey) {
					datas[tData.id] = tData;
				} else {
					datas.push(tData);
				}
			}
			return datas;
		}
	}
}