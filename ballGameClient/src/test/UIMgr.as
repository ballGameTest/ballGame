package view 
{
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.events.MouseManager;
	import laya.ui.Box;
	import laya.utils.ClassUtils;
	import log.Log_Test;
	
	import view.page.BGPage;
	import view.page.LoadingPage;
	import view.page.MenuList;
	/**
	 * 游戏界面管理
	 * @author 贾艳昭
	 */
	public class UIMgr 
	{
		
		public static const LAYER_FIGHT:String = "layer_fight";//战斗界面UI
		public static const LAYER_BG:String = "layer_bg";//UI背景
		public static const LAYER_POP1:String = "layer_pop1";//战斗UI弹窗 - 暂时和大厅弹窗使用一个
		public static const LAYER_POP2:String = "layer_pop2";//大厅UI弹窗
		public static const LAYER_POP3:String = "layer_pop3";
		public static const LAYER_POP4:String = "layer_pop4";//打开大厅的时候放ui背景，关闭后还原到LAYER_BG
		public static const LAYER_POP5:String = "layer_pop5";//放了公告
		public static const LAYER_TIPS:String = "layer_tips";
		public static const LAYER_GUIDE:String = "layer_guide";
		public static const LAYER_LOADING:String = "layer_loading";
		public static const LAYER_WARNING:String = "layer_warning";
		public static const LAYER_WAITING:String = "layer_waiting";
		static private var _layerNames:Array;
		static private var _layers:Object;
		/**
		 * 正处于打开状态的UI界面数组（按层分组）
		 */
		static private var openingUIArray:Object;
		/**
		 * 已经创建的ui缓存对象集合
		 */
		static private var uiMap:Object;
		
		public function UIMgr() 
		{
			
		}
		
		public static function init(target:Sprite = null):void{
			if (!target) target = Laya.stage ;
			_layerNames = [LAYER_FIGHT, LAYER_BG, LAYER_POP1, LAYER_POP2, LAYER_POP3, LAYER_POP4, LAYER_POP5, LAYER_TIPS, LAYER_GUIDE, LAYER_LOADING, LAYER_WARNING, LAYER_WAITING];
			_layers = new Object();
			uiMap = new Object();
			openingUIArray = new Object();
			
			var __layer:Box;
			for (var i:int = 0; i < _layerNames.length; i++) 
			{
				__layer = new Box();
				__layer.name = _layerNames[i];
				__layer.mouseThrough = true;
				__layer.mouseEnabled = true;
				__layer.left = __layer.top = __layer.right = __layer.bottom = 0;
				target.addChild(__layer);
				_layers[_layerNames[i]] = __layer;
				openingUIArray[_layerNames[i]] = [];
			}
			target.on(Event.RESIZE, null, onStageResize);
		}
		
		static private function onStageResize():void 
		{
			var scale:Number = Math.min(Laya.stage.width / Laya.stage.desginWidth, Laya.stage.height / Laya.stage.desginHeight);
			for (var key:String in _layers) {
				//这里不缩放 战斗界面UI 避免控制器位置计算错误
				if (key == LAYER_FIGHT) continue ;
				var _layer:Box = Box(_layers[key]);
				_layer.scale(scale, scale);
			}
			
			//console.log('box 缩放比例:' + scale);
		}
		
		//返回被关闭自动关闭的界面的 uiname
		public static function openUIFight(uiname:*, layerName:String = LAYER_POP2):String{
			return openUI(uiname, layerName);
		}

		public static var uiNum:int = 0
		
		//返回被关闭自动关闭的界面的 uiname
		public static function openUI(uiname:*, layerName:String = LAYER_POP2):String{
			
			// 防止重复点击
			MouseManager.enabled = false;
			LoadingPage.getInstance().show();
			
			// 适配缩放
			onStageResize();
			
			uiname = getUIStringName(uiname);
			
			uiNum ++ ;
			Log_Test.debug(1, "openUI " + uiname+"    uiNum:" + uiNum);
			
			var layer:Box = getLayer(layerName);
			var _ui:UIBase0;
			var isOpen:Boolean = false ;
			if (isOpening(uiname, layerName)) {
				_ui = uiMap[uiname];
				_ui.isOpen = isOpen = false ;
				//layer.addChild(_ui);
				//return autoCloseUI(layerName);
				//_ui.onOpen();
			}
			var closeUIName:String = autoCloseUI(layerName);
			//if (_ui && !_checkRes(_ui.resList)) {
				//Laya.loader.load(dicRes[uiname], new Handler(null, _createUI, [uiname, layerName]));				
			//}else {
				_createUI(uiname, layerName, isOpen);
			//}
			return closeUIName;

		}
		
		//private static function _checkRes(resArr:Array):Boolean{
			//if (!resArr || !resArr.length) return true ;
			//var obj:Object, url:String , cont:int = 0;
			//for (var i:int = 0, j:int = resArr.length; i < j; i++){
				//var obj:Object = resArr[i];
				//if (!obj) continue ;
				//url = obj.url;
				//if (!url || !url.length) continue ;
				//if (Laya.loader.getRes(url)) cont ++; 
			//}
			//if (cont == i) return true;
			//
			//return false ;
		//}
		
		static private function _createUI(uiname:String, layerName:String, isOpen:Boolean = false):void 
		{
			var _ui:UIBase0 = uiMap[uiname];
			var hasResToLoad:Boolean = false;
			if (_ui == null) {				
				_ui = __cr(uiname);
				_ui.uiNum = uiNum;
				_ui.isCrOpen = true ;
				hasResToLoad = _ui.loadRes();
			}
			_ui.uiNum = uiNum;
			var layer:Box = getLayer(layerName);
			layer.addChild(_ui);
			//reposUI(_ui);
			layer['maxcount'] = layer.numChildren ;
			(!isOpen) && openingUIArray[layerName].push(_ui);
			if (!hasResToLoad)
			{
				_ui.isOpen = isOpen ;
				_ui.onOpen();
			}
		}
		
		/**返回一个类对象，但还没有被实例（creatView 函数尚未被调用）*/
		private static function __cr(uiname:String):UIBase0{
			var _ui:UIBase0;
			_ui = uiMap[uiname] = ClassUtils.getInstance("view.page." + uiname);
			_ui.name = uiname;
			return _ui ;
		}
		
		static private function onUIResLoaded(_ui:UIBase0, layerName:String):void{
			var layer:Box = getLayer(layerName);
			layer.addChild(_ui);
			//reposUI(_ui);
			openingUIArray[layerName].push(_ui);
			//if (!remote) {
				_ui.onOpen();
			//}
		}
		
		
		private static function getLayer(layerName:String):Box 
		{
			return _layers[layerName];
		}
		
		/**
		 * 判断界面是否已经在指定的层处于打开状态
		 * @param	uiname
		 * @param	layerName
		 */
		static private function isOpening(uiname:String, layerName:String):Boolean 
		{
			var arr:Array = openingUIArray[layerName];
			if ( arr == null )
				return false;
			for (var i:int = 0; i < arr.length;i++) {
				if (arr[i].name==uiname)
					return true;
			}
			return false;
		}
		
		/**
		 * 自动关闭层级中最后打开的界面
		 * @param	layerName  层级名字
		 * @return
		 */
		static private function autoCloseUI(layerName:String):String 
		{
			var layer:Box = getLayer(layerName);
			var maxCount :int = parseInt(layer['maxcount']);
			if (isNaN(maxCount) || maxCount < 1) maxCount = 1;
			if (openingUIArray[layerName].length >= maxCount) {
				var _ui :UIBase0 = openingUIArray[layerName][maxCount-1];
				var uiName :String = _ui.name;
				closeUI(uiName);
				return uiName;
			}
			return '';
		}
		
		static public function closeUI(uiName:*):UIBase0 
		{
			uiName = getUIStringName(uiName);
			var _ui:UIBase0 = uiMap[uiName];
			if (_ui == null) return null;
			if (_ui.parent == null) return _ui;
			var layer:Box = _ui.parent as Box;
			var layerName:String = layer.name;
			var array:Array = openingUIArray[layerName];
			var uiIndex:int = array.indexOf(_ui);
			if (uiIndex > -1) {
				array.splice(uiIndex, 1);
				_ui.onClose();
			}
			layer["maxcount"] = layer.numChildren ;
			return _ui;
		}
		
		private static function getUIStringName(uiclass:*):String{
			if (!(uiclass is String)) {
				var arr:Array = uiclass.prototype.__className.split('.');
				return arr[arr.length - 1];
			}else{
				return uiclass;
			}
		}
		/**
		 * 获取UI实例
		 * @param	uiName
		 */
		public static function getUI(uiName:*):UIBase0{
			uiName = getUIStringName(uiName);
			var _ui:UIBase0 = uiMap[uiName];
			if (_ui == null){
				//return _ui;
				_ui = __cr(uiName);
				_ui.isCrOpen = false ;
				_ui.loadRes();
			}
			return _ui ;
		}
		
		public static function closeAllByLayer(layerName:String):void{
			var arr:Array = openingUIArray[layerName];
			if (!arr || !arr.length) return ;
			for (var i:int = 0, j:int = arr.length; i < j; i++ ){
				arr[i] && closeUI(arr[i].name);
			}
		}
		
		public static function destroyUI(uiName:*):void{
			var _ui:UIBase0 = closeUI(uiName);
			if (!_ui) return ;
			delete uiMap[_ui.name] ;
			_ui.destroy();
			_ui = null;
		}
	}

}