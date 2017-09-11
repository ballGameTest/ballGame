package {#@package#} 
{
    import laya.game.manager.Database;
	public class {#@className#}  
	{
{#@vars#}		
        public static function get(id:int):{#@className#}
		{
			return Database.get("{#@className#}", id);
		}
	}
	
}
