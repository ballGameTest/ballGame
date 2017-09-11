package  
{
    import laya.game.manager.Database;
	public class gameElement  
	{
        public var id :int;
        public var type :String;
        public var class :String;
        public var userId :int;
        public var sourceId :int;
        public var weight :int;
        public var radius :Number;
        public var speed :Number;		
        public static function get(id:int):gameElement
		{
			return Database.get("gameElement", id);
		}
	}
	
}
