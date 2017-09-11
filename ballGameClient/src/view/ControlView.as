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
		private var clientLostMsg:ClientLostMsg=new ClientLostMsg();
		
		private var lostDelay:int=1000;
		
		/**
		 * 角色行为控制UI
		 */	
		public function ControlView()
		{
			this.clientLostMsg.clientId=Game.player.clientId;
			
			this.ctr_lostProp.on(Event.MOUSE_DOWN,this,onLostProp);
			this.ctr_lostProp.on(Event.MOUSE_UP,this,onLostUp);
			
			this.ctr_Split.on(Event.MOUSE_DOWN,this,onSplit);
			
		}
		
		
		private function onSplit():void
		{
			
		}
		
		private function onLostProp():void
		{ 
			this.clientLostMsg.lostAngle=Game.player.angle;
			Game.send(clientLostMsg);
			trace("点击了丢道具-----");
			
			Laya.timer.loop(lostDelay,this,onDelayLost);
		}
		
		private function onDelayLost():void
		{
			trace("长按丢道具-----");
			this.clientLostMsg.lostAngle=Game.player.angle;
			Game.send(clientLostMsg);
		}
		private function onLostUp():void
		{
			Laya.timer.clear(lostDelay,this,onDelayLost);
		}
	}
}