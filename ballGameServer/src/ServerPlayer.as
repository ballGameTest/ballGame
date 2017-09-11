package
{
	
	import game.manager.DataManager;
	import game.net.IMessage;
	import game.net.MessageBase;
	import game.net.MessageUtils;
	
	import laya.events.EventDispatcher;
	import laya.utils.Byte;
	import laya.utils.Utils;
	
	import msgs.ClientDataMsg;
	import msgs.EnterRoomMsg;

	/**
	 * 在线的游戏客户端 
	 * @author CHENZHENG
	 * 
	 */	
	public class ServerPlayer extends ServerItem
	{
		/***服务器事件中心***/
		private var eventServer:EventDispatcher;
		/***服务器分配的socket***/
		private var webSocket:Object;
		/***二进制消息体***/
		private  var byte:Byte = new Byte();
		
		//客户端玩家属性------------------------------
		/**所属房间Id****/
		public var roomId:int=0;
		/**是否在房间****/
		public var isInRoom:Boolean=false;
		/**客户端Id****/
		public var clientId:int=0;
		/**是否是游戏发起人****/
		public var isOriginator:Boolean=false;
		/***昵称***/
		public var nickname:String="";
		/***头像Id***/
		public var headId:int=0;
		
		
		public function ServerPlayer()
		{
		}
		
		/**
		 * 客户端初始化
		 * @param socket  服务器分配的socket
		 * @param eventSer  与服务器通信的消息发送器
		 */		
		public function init(socket:Object,eventSer:EventDispatcher):void
		{
			this.webSocket=socket;
			this.eventServer=eventSer;
			
			//客户端消息监听(需加js原生的作用域绑定bind(this)或如下)
			this.webSocket.on(ServerEvent.CLIENT_MESSAGE,Utils.bind(onMessage,this));
			this.webSocket.on(ServerEvent.CLIENT_CLOSE,Utils.bind(onClose,this));
		}
		
		/**
		 * 收到的信息解析与处理
		 * @param buffer  服务器收到的消息
		 */		
		private function onMessage(buffer:*):void
		{
			// 解码消息
			byte.clear();
			byte.writeArrayBuffer(buffer);
			byte.pos = 0;
			//解析成消息类
			var tMsg:MessageBase = MessageUtils.readMessageFromByte(byte) as MessageBase;
			//由数据管理器统一派发
			if (tMsg.msgKey) DataManager.I.add(tMsg.msgKey, tMsg);
		}
		
		/**
		 * 对应的客户端断开连接
		 */		
		private function onClose():void
		{
			this.eventServer.event(ServerEvent.CLIENT_CLOSE,[this]);
		}
		
		/**
		 * 客户端消息发送，二进制发送
		 * @param msg  消息
		 */		
		public function send(msg:MessageBase):void
		{
			byte.clear();
			MessageUtils.writeMessageToByte(byte,msg);
			this.webSocket.send(byte.buffer);
		}
	}
}