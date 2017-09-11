package laya.game.rpg {
	import laya.game.rpg.GameObject;
	
	/**
	 * 组件接口
	 */
	public interface IGameComponent {
		function reg(target:GameObject):void;
		function unReg():void;
	}
}