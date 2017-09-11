package  
{
    import laya.game.manager.Database;
	public class UserInfo  
	{
        public var id :int;
        public var username :String;
        public var isVip :Boolean;
        public var gold :Number;
        public var speed :int;		
        public static function get(id:int):UserInfo
		{
			return Database.get("UserInfo", id);
		}
	}
	
}
