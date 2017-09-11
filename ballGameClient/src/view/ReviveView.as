package view
{
	import laya.events.Event;
	
	import ui.ReviveUI;
	
	public class ReviveView extends ReviveUI
	{
		public function ReviveView()
		{
			this.btn_revive.on(Event.MOUSE_DOWN,this,onRevive);
		}
		
		private function onRevive():void
		{
			this.event(GameEvent.PLAYER_REVIVE);
		}
	}
}