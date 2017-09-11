package view
{
	import laya.events.Event;
	
	import ui.OverUI;
	
	public class OverView extends OverUI
	{
		private static var instance:OverView;
		
		public function OverView()
		{
			this.btn_back.on(Event.MOUSE_DOWN,this,onBackHome);
		}
		
		/**
		 * 大厅页面单例
		 */		
		public static function I():OverView
		{
			if(!instance) instance=new OverView();
			return instance;
		}
		
		private function onBackHome():void
		{
			this.removeSelf();
		}
	}
}