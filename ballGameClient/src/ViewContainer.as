package
{
	import laya.display.Sprite;
	import laya.ui.View;
	
	import view.LoginView;
	
	
	/**
	 *游戏界面UI管理类 ，界面层
	 * @author CHENZHENG
	 * 
	 */	
	public class ViewContainer extends Sprite
	{
		private static var instance:ViewContainer;
		
		private static var uiArray:Array=[];
		
		public function ViewContainer()
		{
			this.size(1334,750);
			Laya.stage.addChild(this);
		}
		
		public static function I():ViewContainer
		{
			if(!instance) instance=new ViewContainer();
			return instance;
		}
		
		public static function addUI(view:View):void
		{
			instance.addChild(view);
//			instance.removeChildAt(uiArray[uiArray.length-1]);
//			uiArray.push(view);
		}
	}
}