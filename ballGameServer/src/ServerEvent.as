package 
{
	public class ServerEvent
	{
		/***配置加载完成事件***/
		public static const CONFIG_COMPLETE:String="gameConfig_complete";
		
		/***客户端连接事件***/
		public static const CLIENT_CONNECT:String="client_connect";
		/***游戏结束事件***/
		public static const GAME_OVER:String="game_room";
		/***游戏开始事件***/
		public static const GAME_START:String="game_start";
		/***客户端消息事件***/
		public static var CLIENT_MESSAGE:String="message";
		/***客户端断开事件***/
		public static var CLIENT_CLOSE:String="close";
		
		public function ServerEvent()
		{
		}
	}
}