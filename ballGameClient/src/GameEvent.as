package
{
	public class GameEvent
	{
		/***创建游戏***/
		public static var GAME_CREATE:String="game_create";
		/***游戏开始***/		
		public static var GAME_START:String="game_start";
		/***游戏结束***/
		public static var GAME_OVER:String="game_over";
		/***资源加载完成***/
		public static var ASSETS_LOADED:String="assets_loaded";
		/***返回大厅***/
		public static var BACK_HOME:String="back_home";
		
		/***角度变化消息***/
		public static var ANGLE_CHANGE:String="angle_change";
		/***吃物品消息***/
		public static var EAT_ITEM:String="eat_item";
		/***玩家重量变化事件***/
		public static var PLAYER_WEIGHT:String="player_weight";
		/***玩家复活事件***/
		public static var PLAYER_REVIVE:String="player_revive";
		/***玩家丢道具事件***/
		public static var PLAYER_LOST:String="player_lost";
		/***玩家分裂事件***/
		public static var PLAYER_SPLIT:String="player_split";

		
		public function GameEvent()
		{
		}
	}
}