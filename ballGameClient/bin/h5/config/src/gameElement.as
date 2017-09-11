package  
{
    import laya.game.manager.Database;
	public class gameElement  
	{
        public var id :Number;
        public var type :String;
        public var class :String;
        public var userId :Number;
        public var sourceId :Number;
        public var weight :Number;
        public var radius :Number;
        public var speed :Number;		
        public static function get(id:int):gameElement
		{
			return Database.get("gameElement", id);
		}
	}
	
}
