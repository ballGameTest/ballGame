package msgs {	
	
	import game.net.MessageUtils;

	/**
	 * 初始化消息列表
	 */
	public class MessageInit 
	{
		/**
		 * 初始化并注册消息列表
		 */
		public static function init():void 
		{
			var regMsgs:Array;
			regMsgs = [ClientDataMsg,EnterRoomMsg,ClientsCreateMsg,GameStartMsg,GameOverMsg,ItemDataMsg,GameCreateMsg,ClientAngleMsg,ClientLeaveMsg,
					   EatItemMsg,ClientReviveMsg,ClientLostMsg];

			MessageUtils.regMessageList(regMsgs);
			MessageUtils.setMessagesKey(regMsgs);
		}
	}
}