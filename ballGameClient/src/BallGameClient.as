package 
{
	import game.manager.DataManager;
	import game.net.GameSocket;
	import msgs.MessageInit;
	
	import laya.display.Stage;
	import laya.ui.View;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	
	import msgs.EnterRoomMsg;
	import msgs.GameStartMsg;
	
	import view.GameView;
	import view.HomeView;
	import view.LoginView;
	import view.OverView;
	import view.RoomView;

	/**
	 * 游戏客户端入口类 
	 * @author CHENZHENG
	 * 
	 */	
	public class BallGameClient 
	{
		/**游戏启动页面****/
		private var login:LoginView;
		/**游戏大厅页面****/
		private var homeView:HomeView;
		/**游戏房间页面****/ 
		private var room:RoomView;
		/**游戏进行中****/ 
		private var myGame:Game;
		/**游戏房间页面****/ 
		private var gameOver:OverView;
		
		/**游戏美术资源表****/
		public static var gameSource:Object={};		
		/**客户端socket****/
		public static var gameSocket:GameSocket;
		
		
		public function BallGameClient() 
		{
			//初始化引擎
			Laya.init(1334,750,WebGL);
			//画布垂直居中对齐
			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			//画布水平居中对齐
			Laya.stage.alignH = Stage.ALIGN_CENTER;
			//等比缩放
			Laya.stage.scaleMode = Stage.SCALE_FIXED_AUTO;
			
			Stat.show();
			//加载启动页资源
			Laya.loader.load("res/atlas/ui.atlas",Handler.create(this,onLoginView));
			Laya.loader.load(["res/atlas/element.atlas","res/atlas/role.atlas","res/atlas/controller.atlas"]);
			//初始化页面容器
			ViewContainer.I();
			//注册所有消息
			MessageInit.init();
		}		
		
		/**游戏开始启动****/
		private function onLoginView():void
		{
			//游戏启动页，加载资源
			login=new LoginView();
			login.on(GameEvent.ASSETS_LOADED,this,onAssetsLoaded); 
			ViewContainer.addUI(login);
		}
		
		
		/**游戏资源加载结束，进入大厅****/
		private function onAssetsLoaded():void
		{
			//大厅主UI页面
			homeView=HomeView.I();
			homeView.on(GameEvent.GAME_CREATE,this,onGameCreate);
			ViewContainer.addUI(homeView);
			
			//初始化socket，连接服务器
			gameSocket=new GameSocket();
			gameSocket.connect("10.10.20.56",8999);
			
			//获取游戏配置文件
			gameSource=Laya.loader.getRes("config/gameSource.json"); 

		}
		
		/**游戏创建（在服务器房间创建时）****/
		private function onGameCreate():void
		{
			//游戏初始化
			myGame=Game.I();
			myGame.on(GameEvent.GAME_START,this,onGameStart);
			myGame.on(GameEvent.GAME_OVER,this,onGameOver);
			//游戏房间UI 
			room=RoomView.I();
			ViewContainer.addUI(room);
			trace("游戏创建了！--------")
		}
		
		/**
		 * 游戏正式开始
		 */		
		private function onGameStart():void
		{
			trace("游戏开始了！--------");
			Laya.stage.addChild(myGame);
			room.close();
		}
		
		/**
		 * 游戏结束，排行UI
		 */		
		private function onGameOver():void
		{
			gameOver=OverView.I();
			ViewContainer.addUI(gameOver);
			myGame.close();
		}
	}
}