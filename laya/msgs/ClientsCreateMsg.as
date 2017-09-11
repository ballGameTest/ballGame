package msgs
{
	import game.net.MessageBase;
	
	/**
	 * 客户端列表消息
	 * @author CHENZHENG
	 */	
	public class ClientsCreateMsg extends MessageBase
	{
		public var clients:Array;
		
		public function ClientsCreateMsg()
		{
		}
		
		public static const DES:Array = [
			["clients", MessageBase.ARRAY, [MessageBase.CLASS,ClientDataMsg]]
		];
	}
}