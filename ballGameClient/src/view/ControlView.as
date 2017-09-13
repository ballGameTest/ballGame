package view
{
	import laya.events.Event;
	
	import msgs.ClientLostMsg;
	
	import ui.ControlUI;
	
	/**
	 * 角色行为控制UI
	 * @author CHENZHENG
	 */	
	public class ControlView extends ControlUI
	{
		
		private var lostDelay:int=300;
		
		/**
		 * 角色行为控制UI
		 */	
		public function ControlView()
		{
			this.ctr_lostProp.on(Event.MOUSE_DOWN,this,onLostProp);
			Laya.stage.on(Event.MOUSE_UP,this,onUp);
			
			this.ctr_Split.on(Event.MOUSE_DOWN,this,onSplit);
			
		}
		
		
		private function onSplit():void
		{
			this.event(GameEvent.PLAYER_SPLIT);
		}
		
		private function onLostProp():void
		{ 
			this.event(GameEvent.PLAYER_LOST);
//			trace("点击了丢道具-----");
			
			Laya.timer.loop(lostDelay,this,onDelayLost);
		}
		
		private function onDelayLost():void
		{
//			trace("长按丢道具-----");
			this.event(GameEvent.PLAYER_LOST);
		}
		private function onUp():void
		{
			Laya.timer.clear(this,onDelayLost);
		}
	}
}