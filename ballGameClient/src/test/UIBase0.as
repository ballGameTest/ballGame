package view 
{
	import laya.events.MouseManager;
	import laya.ui.View;
	import laya.utils.Handler;
	import laya.utils.Tween;
	import log.Log_Test;
	
	import view.page.LoadingPage;
	/**
	 * ...
	 * @author 贾艳昭
	 */
	public class UIBase0 extends View
	{
		private var uiView:Object;
		public var resList:Array = [];
		/**是否在 onCreated 函数内调用 onOpen*/
		public var isCrOpen:Boolean = true ;
		/**界面是否是打开的*/
		public var isOpen:Boolean = true;
		
		public var uiNum:int ;
		
		
		public function UIBase0() 
		{
			
		}
		
		override protected function createView(uiView:Object):void 
		{
			this.uiView = uiView;
		}
		
		public function onOpen():void 
		{
			super.onCompResize();
			
			LoadingPage.getInstance().hide();
			
			isOpen ? onCompleteOpen() : openingAction();
			
			Log_Test.debug(1, "onOpen    uiNum:" + uiNum);
		}
		
		// 淡入效果
		public function openingAction():void
		{
			this.alpha = 0;
			Tween.to(this, {alpha:1}, 500, null, Handler.create(this, onCompleteOpen));
		}
		
		private function onCompleteOpen():void
		{
			MouseManager.enabled = true;
		}
		
		public function onClose():void 
		{
			//closingAction();
			this.removeSelf();
		}
		
		// 淡出效果
		private function closingAction():void
		{
			this.alpha = 1;
			Tween.to(this, {alpha:0}, 500, null, Handler.create(this, onCompleteClose));
		}
		
		private function onCompleteClose():void
		{
			this.removeSelf();
		}
		
		public function onCreated():void{
			
			Log_Test.debug(1, "onCreated    uiNum:" + uiNum);
			super.createView(uiView);
			isOpen = false ;
			isCrOpen && Laya.timer.callLater(this, onOpen);
		}
		
		public function loadRes():Boolean 
		{
			Log_Test.debug(1, "loadRes    uiNum:" + uiNum);
			if (resList.length > 0) {
				Laya.loader.load(resList, Handler.create(this, onCreated), null, null, 0);
				return true;
			}else{
				onCreated();
			}
			return false;
		}
	}

}