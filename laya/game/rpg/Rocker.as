package laya.game.rpg {
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.game.rpg.GameObject;
	import laya.game.rpg.IGameComponent;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.net.Loader;
	import laya.resource.Texture;
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	/**
	 * 摇杆组件。<br/>
	 * 使用示例：<br/>
	 * var hero:Hero = new Hero();<br/>
	 * var rockerContain:Sprite = Laya.stage.addChild(new Sprite()) as Sprite;<br/>
	 * var rocker:Rocker = rockerContain.addChild(new Rocker(false, false)) as Rocker;<br/>
	 * rocker.pos(rocker.rockRadius + 50, Laya.stage.height - rocker.rockRadius - 50);<br/>
	 * rocker.setSkin(_bgSkin, _knobSkin);<br/>
	 * rocker.on(Event.LOADED, this, onLoaded);<br/>
	 * rocker.reg(hero);<br/>
	 * <br/>
	 * function onLoaded(url:String, texWidth:Number, texHeight:Number):void {<br/>
	 * 	if (url === _bgSkin) {<br/>
	 * 		rocker.setRockArea(texWidth / 2);<br/>
	 * 		rocker.setTouchArea(texWidth, texHeight);<br/>
	 * 	}<br/>
	 * }
	 */
	public class Rocker extends Sprite implements IGameComponent {
		/**
		 * 触控状态:未触控
		 */
		public static const TouchNone:int = -1;
		/**
		 * 触控状态:按下
		 */
		public static const TouchDown:int = 1;
		/**
		 * 触控状态:移动
		 */
		public static const TouchMove:int = 2;
		/**
		 * 触控状态:取消
		 */
		public static const TouchCancel:int = 3;
		
		/**
		 * 触控进行有效移动的最小偏移量(X轴或Y轴任一轴向上的偏移量)，单位为像素，只在摇杆进入移动激活状态时有效。
		 */
		public var mouseMoveAccuracy:Number = 2;
		/**
		 * 摇杆移动激活半径，单位为像素，默认值为8。<br/>
		 * 此半径以摇杆中心点为圆心，定义了一个圆形区域，当玩家触控开始，且触控点一直在此区域内移动时，摇杆处于TouchDown状态，当触控点超出此区域后，摇杆更新状态为TouchMove，之后触控点再次返回区域内部时，摇杆状态依然为TouchMove。
		 */
		public var activeRadius:Number = 8;
		/**
		 * 摇动区域半径，单位为像素，默认值为100。
		 */
		public var rockRadius:Number = 100;
		/**
		 * 将单位圆按指定角度进行均匀分段，开发者可以指定每段的角度阈值，默认值为5，也就是分为72段。<br/>
		 * 常用于优化与服务器同步对象状态的通讯频率。<br/>
		 * 如果为5，则将单位圆等分为72段，(-2.5, 2.5)区间范围内的角度值对应0度，[2.5, 7.5)对应5度，依此类推。
		 */
		public var anglePerUnit:Number = 5;
		/**
		 * 对注册对象进行移动更新的最小间隔时间，单位为毫秒，默认值为0。<br/>
		 * 常用于优化与服务器同步对象状态的通讯频率。
		 */
		public var moveMinDeltaTime:int = 0;
		
		/**
		 * @private
		 * 弧度到角度的转换系数
		 */
		private static const Factor_R2A:Number = 57.29577951308232;
		/**
		 * @private
		 * 角度到弧度的转换系数
		 */
		private static const Factor_A2R:Number = 0.017453292519943295;
		
		/**
		 * @private
		 * 摇杆组件的唯一子对象，其皮肤为摇杆背景，拖块为其子对象。<br/>
		 * 摇杆跟随模式下，此对象的位置会跟随玩家按下屏幕时的坐标点。
		 */
		private var _baseSpr:Sprite;
		/**
		 * @private
		 * 摇杆背景皮肤路径
		 */
		private var _bgSkin:String;
		/**
		 * @private
		 * 摇杆拖块精灵
		 */
		private var _knobSpr:Sprite;
		/**
		 * @private
		 * 摇杆拖块精灵皮肤路径
		 */
		private var _knobSkin:String;
		/**
		 * @private
		 * 摇杆类型。<br/>
		 * true:摇杆跟随模式，用户按下屏幕时，摇杆更新自身位置到用户按下的位置<br/>
		 * false:摇杆固定位置，用户按下屏幕时，不会自动跟随
		 */
		private var _isFixed:Boolean = true;
		/**
		 * @private
		 * 当前摇杆指示的角度值。<br/>
		 * X轴正方向为0，顺时针增加，取值范围[0,360)或-1(表示摇杆处于未触控状态)。
		 */
		private var _angle:Number = -1;
		/**
		 * @private
		 * 当前摇杆指示的弧度值。<br/>
		 * X轴正方向为0，顺时针增加，取值范围[0,2*PI)或-1(表示摇杆处于未触控状态)。
		 */
		private var _radian:Number = -1;
		/**
		 * @private
		 * 是否在摇杆的激活区域内。<br/>
		 * 当用户触控点与摇杆基准原点的偏移量达到指定值后
		 */
		private var _inActiveArea:Boolean = false;
		/**
		 * @private
		 * 用于触控精度逻辑，记录用户触控每次进行有效移动的舞台坐标
		 */
		private var _moveBeginDeltaX:Number = 0;
		/**
		 * @private
		 * 用于触控精度逻辑，记录用户触控每次进行有效移动的舞台坐标
		 */
		private var _moveBeginDeltaY:Number = 0;
		/**
		 * @private
		 * 用户在“摇杆响应区域”按下时的“触控ID”
		 */
		private var _touchId:int = -1;
		/**
		 * @private
		 * 摇杆组件在屏幕上的触摸响应区域
		 */
		private var _touchSpr:Sprite;
		/**
		 * @private
		 * 触控状态。<br/>
		 * -1:未触控 0:取消 1:点击 2:移动 3:结束
		 */
		private var _touchState:int = TouchNone;
		/**
		 * @private
		 * 用于标记对注册对象进行移动更新的最小间隔时间
		 */
		private var _preTime:Number;
		/**
		 * @private
		 * 控制对象
		 */
		private var _target:*;
		/**
		 * @private
		 * 是否在移动设备，影响多点触控判断
		 */
		private var _onMobile:Boolean = false;
		/**
		 * @private
		 * 摇杆背景纹理
		 */
		private var _bgTex:Texture;
		/**
		 * @private
		 * 摇杆是否启用
		 */
		private var _enable:Boolean = false;
		/**
		 * @private
		 * 摇杆在无触控状态下是否自动隐藏，默认为false
		 * 非操控状态表示无触控状态和触控取消状态，操控状态表示触控按下和触控移动。
		 */
		private var _autoHide:Boolean = false;
		/**
		 * @private
		 * 摇杆触摸区域宽度，仅在固定模式下生效
		 */
		private var _touchWidth:Number = 200;
		/**
		 * @private
		 * 摇杆触摸区域高度，仅在固定模式下生效
		 */
		private var _touchHeight:Number = 200;
		/**
		 * @private
		 * “摇动区域中心点”相对于“摇杆背景图像中心点”在X轴上的偏移量
		 */
		private var _rockAreaOfsX:Number = 0;
		/**
		 * @private
		 * “摇动区域中心点”相对于“摇杆背景图像中心点”在Y轴上的偏移量
		 */
		private var _rockAreaOfsY:Number = 0;
		/**
		 * @private
		 * 触控响应区域相对于摇杆中心点在X轴上的偏移量
		 */
		private var _touchAreaOfsX:Number = 0;
		/**
		 * @private
		 * 触控响应区域相对于摇杆中心点在Y轴上的偏移量
		 */
		private var _touchAreaOfsY:Number = 0;
		
		/**
		 * 创建摇杆组件对象。<br/>
		 * 以下是关于摇杆的几个名词：<br/>
		 * “精灵”：也就是Sprite，基本显示对象节点；<br/>
		 * “摇杆精灵”：是摇杆对象的唯一子对象，包含摇杆的背景图像和拖块精灵；<br/>
		 * “摇杆原点”：摇杆对象坐标原点，跟随模式下，玩家触控取消时，摇杆精灵自动归位，并以此点为归位点；<br/>
		 * “摇杆触控响应区域精灵”：它定义了摇杆在屏幕上的响应区域，跟随模式下，左半屏为摇杆响应区域，固定模式下，可通过setTouchArea设置其区域；<br/>
		 * “摇杆中心点”：由“摇动区域中心点”定义。“触控响应区域”偏移向量、玩家触控偏移向量都以此为参考点。非移动激活区域、移动激活区域、摇动区域的圆心始终与摇杆中心点重合；<br/>
		 * “摇动区域”：摇杆拖块的活动范围，是一个圆形，其圆心就是“摇杆中心点”，其偏移向量的参考点是摇杆背景图像中心点；<br/>
		 * “移动激活区域”：以“摇杆中心点”为中心的，指定半径的圆形范围内，为非移动激活区域，外围为移动激活区域，只有玩家触控点进入摇杆移动激活区域，才能触发调用路径更新回调方法。
		 *
		 * @param isFixed		摇杆是固定模式还是跟随模式。true:固定模式，摇杆固定位置，false:跟随模式，摇杆跟随用户按下时的位置
		 */
		public function Rocker(isFixed:Boolean = false) {
			super();
			createChildren();
			
			_onMobile = Browser.onMobile;
			_isFixed = isFixed;
		}
		
		/**
		 * @private
		 * 被添加到父节点的事件
		 */
		private function onAdded():void {
			if (!_enable) return;
			
			_touchSpr.parent || this.parent.addChild(_touchSpr);
			_touchSpr.on(Event.MOUSE_DOWN, this, onTouchBegin);
			updateTouchArea();
			Laya.stage.on(Event.RESIZE, this, updateFollowedTouchArea);
			this.autoHide = _autoHide;
		}
		
		/**
		 * 注册对象，并启用摇杆，开始响应玩家触控。<br/>
		 * 摇杆状态改变时，会调用注册对象的某些方法：TouchDown时调用target.moveBegin()，TouchMove时调用target.moveUpdate(radian)，TouchEnd时调用target.moveEnd()。<br/>
		 * 如果对应函数不存在，则不调用。
		 * @param target	注册对象
		 */
		public function reg(target:GameObject):void {
			_target = target;
			enable = true;
		}
		
		/**
		 * 反注册对象。清除已注册对象的引用，禁用摇杆触控响应，重置摇杆相关属性。
		 */
		public function unReg():void {
			_target = null;
			enable = false;
			reset();
		}
		
		/**
		 * 反注册对象，并销毁自身。这会导致摇杆从显示列表移除，并且摇杆子对象被销毁，此后这个摇杆对象不能再用。
		 */
		public function kill():void {
			unReg();
			destroy();
		}
		
		/**
		 * @private
		 * 重置状态
		 */
		private function reset():void {
			_angle = -1;
			_radian = -1;
			_touchState = TouchNone;
		}
		
		/**
		 * @private
		 */
		private function createChildren():void {
			_baseSpr = this.addChild(new Sprite()) as Sprite;
			_knobSpr = _baseSpr.addChild(new Sprite()) as Sprite;
			_touchSpr = new Sprite();
		}
		
		/**
		 * 设置摇杆皮肤。也可以单独设置背景皮肤(setter bgSkin)和拖块皮肤(setter knobSkin)。<br/>
		 * 每个资源加载完成后派发Event.LOADED事件，同时返回资源路径和资源宽高。
		 * @param bgSkin	背景皮肤路径
		 * @param knobSkin	拖块皮肤路径
		 */
		public function setSkin(bgSkin:String, knobSkin:String):void {
			this.bgSkin = bgSkin;
			this.knobSkin = knobSkin;
		}
		
		/**
		 * 设置拖块皮肤。<br/>
		 * 加载完成后派发Event.LOADED事件，同时返回资源路径和资源宽高。
		 * @param knobSkin	拖块皮肤路径
		 */
		public function set knobSkin(knobSkin:String):void {
			if (_knobSkin !== knobSkin) {
				_knobSkin = knobSkin;
				if (knobSkin) {
					var img:* = Loader.getRes(_knobSkin);
					if (img) {
						loadKnobTexCmpl(_knobSkin, img);
					} else {
						Laya.loader.load(_knobSkin, Handler.create(this, loadKnobTexCmpl, [_knobSkin]));
					}
				} else {
					_knobSpr.graphics.clear();
				}
			}
		}
		
		public function get knobSkin():String {
			return _knobSkin;
		}
		
		/**
		 * @private
		 */
		private function loadKnobTexCmpl(url:String, img:Texture):void {
			if (url === _knobSkin && img && !destroyed) {
				_knobSpr.graphics.cleanByTexture(img, -img.sourceWidth / 2, -img.sourceHeight / 2);
				event(Event.LOADED, [url, img.sourceWidth, img.sourceHeight]);
			}
		}
		
		/**
		 * 摇杆背景皮肤。<br/>
		 * 加载完成后派发Event.LOADED事件，同时返回资源路径和资源宽高。
		 * @param bgSkin	摇杆背景皮肤路径
		 */
		public function set bgSkin(bgSkin:String):void {
			if (_bgSkin !== bgSkin) {
				_bgSkin = bgSkin;
				if (bgSkin) {
					var img:* = Loader.getRes(_bgSkin);
					if (img) {
						loadBgTexCmpl(_bgSkin, img);
					} else {
						Laya.loader.load(_bgSkin, Handler.create(this, loadBgTexCmpl, [_bgSkin]));
					}
				} else {
					_baseSpr.graphics.clear();
				}
			}
		}
		
		public function get bgSkin():String {
			return _bgSkin;
		}
		
		/**
		 * @private
		 */
		private function loadBgTexCmpl(url:String, img:Texture):void {
			if (url === _bgSkin && img && !destroyed) {
				_bgTex = img;
				_baseSpr.graphics.cleanByTexture(_bgTex, -_bgTex.width / 2 - _rockAreaOfsX, -_bgTex.height / 2 - _rockAreaOfsY);
				event(Event.LOADED, [url, img.sourceWidth, img.sourceHeight]);
			}
		}
		
		/**
		 * @private
		 * 更新路径
		 */
		private function updatePath(touchState:int):void {
			if (!_target) return;
			
			if (TouchMove === touchState) {
				if (moveMinDeltaTime > 0) {
					var tTime:Number = Browser.now();
					if (tTime - _preTime < moveMinDeltaTime) return;
					_preTime = tTime;
				}
				
				var adptRad:Number = Math.round(radian * Factor_R2A / anglePerUnit) * anglePerUnit * Factor_A2R;
				_target.moveUpdate && _target.moveUpdate(adptRad);
			} else if (TouchDown === touchState) {
				_target.moveBegin && _target.moveBegin();
			} else if (TouchCancel === touchState) {
				_target.moveEnd && _target.moveEnd();
			} else {
				trace("Err: Rocker.updatePath: unknown touchState: " + touchState);
			}
		}
		
		/**
		 * @private
		 * 更新摇杆触控响应区域。
		 */
		private function updateTouchArea():void {
			if (!_touchSpr.parent || !_enable) return;
			
			if (_isFixed) {
				updateFixedTouchArea();
			} else {
				updateFollowedTouchArea();
			}
		}
		
		/**
		 * 在跟随模式下，更新摇杆触控响应区域。<br/>
		 * 在跟随模式下，舞台大小会发生变化，此时如果不更新，可能会导致触控区域与预期不一致。
		 */
		private function updateFollowedTouchArea():void {
			if (!_touchSpr.parent || _isFixed || !_enable) return;
			
			var touchAreaPos:Point = (_touchSpr.parent as Sprite).globalToLocal(Point.TEMP.setTo(0, 0));
			_touchSpr.pos(touchAreaPos.x, touchAreaPos.y);
			
			var sizePoi:Point = (_touchSpr.parent as Sprite).globalToLocal(Point.TEMP.setTo(Laya.stage.width / 2, Laya.stage.height));
			_touchSpr.size(sizePoi.x, sizePoi.y);
		}
		
		/**
		 * 在固定模式下，更新摇杆触控响应区域。<br/>
		 * 在固定模式下，对摇杆进行了重定位或缩放操作，此时如果不更新，可能会导致触控区域与预期不一致。
		 */
		private function updateFixedTouchArea():void {
			if (!_touchSpr.parent || !_isFixed || !_enable) return;
			
			_touchSpr.pos(this.x + (_touchAreaOfsX - _touchWidth / 2) * scaleX, this.y + (_touchAreaOfsY - _touchHeight / 2) * scaleY);
			_touchSpr.size(_touchWidth * scaleX, _touchHeight * scaleY);
		}
		
		/**
		 * @private
		 * 用户按下的触控事件
		 */
		private function onTouchBegin(e:Event):void {
			_onMobile && (_touchId = e.touchId);
			_touchState = TouchDown;
			
			//按下的触控事件触发后，注册触控移动和结束事件
			stage.on(Event.MOUSE_MOVE, this, onTouchMove);
			stage.on(Event.MOUSE_UP, this, onTouchEnd);
			stage.on(Event.MOUSE_OUT, this, onTouchCancel);
			
			//默认用户触控点在摇杆的不可移动区域内
			_inActiveArea = false;
			//触控发生时可见
			_baseSpr.visible = true;
			
			var localPos:Point;
			if (!_isFixed) {
				//摇杆跟随模式下，按下触控事件触发后，将摇杆位置置为用户触控位置
				localPos = this.globalToLocal(Point.TEMP.setTo(Laya.stage.mouseX, Laya.stage.mouseY));
				_baseSpr.pos(localPos.x, localPos.y);
				//更新路径
				updatePath(_touchState);
				return;
			}
			
			//判断是否进入移动激活区域
			localPos = _baseSpr.globalToLocal(Point.TEMP.setTo(Laya.stage.mouseX, Laya.stage.mouseY));
			var localDeltaX:Number = localPos.x;
			var localDeltaY:Number = localPos.y;
			//判断用户按下的触控点与摇杆基准原点的偏移量，小于指定值表示摇杆处于未移动激活状态，否则将摇杆置为移动激活状态
			if (Math.abs(localDeltaX) < activeRadius && Math.abs(localDeltaY) < activeRadius) {
				//更新路径
				updatePath(_touchState);
				return;
			}
			
			//跟随模式下，按下触控事件发生后，会将其位置置为用户触控位置，不会执行到这里
			//固定模式下，此时触控点在移动激活区域内
			_inActiveArea = true;
			_touchState = TouchMove;
			
			//进入移动激活状态后，更新用户触控滑动开始偏移坐标
			_moveBeginDeltaX = localDeltaX;
			_moveBeginDeltaY = localDeltaY;
			
			//计算摇杆偏移的弧度和角度
			_radian = Math.atan2(localDeltaY, localDeltaX);
			(_radian < 0) && (_radian += Math.PI * 2);
			_angle = _radian * Factor_R2A;
			
			//重定位拖块位置
			//摇杆鼠标离中心的最远距离
			var _sqx:int = localDeltaX * localDeltaX;
			var _sqy:int = localDeltaY * localDeltaY;
			if (_sqy + _sqx > rockRadius * rockRadius) {
				var x:int = Math.round(Math.cos(_radian) * rockRadius);
				var y:int = Math.round(Math.sin(_radian) * rockRadius);
				_knobSpr.pos(x, y);
			} else {
				_knobSpr.pos(localDeltaX, localDeltaY);
			}
			
			//更新路径
			updatePath(_touchState);
		}
		
		/**
		 * @private
		 * 用户触控移动事件
		 */
		private function onTouchMove(e:Event):void {
			//如果是移动设备(多点触控设备)，需要触控ID一致
			//如果不是移动设备，不需要判断触控ID，直接执行
			if (!_onMobile || (_touchId === e.touchId)) {
				var localPos:Point = _baseSpr.globalToLocal(Point.TEMP.setTo(Laya.stage.mouseX, Laya.stage.mouseY));
				var localDeltaX:Number = localPos.x;
				var localDeltaY:Number = localPos.y;
				
				//判断是否进入移动激活区域
				//判断用户移动后的触控点与摇杆基准原点的偏移量，小于指定值表示摇杆处于未移动激活状态，否则将摇杆置为移动激活状态
				if (!_inActiveArea && Math.abs(localDeltaX) < activeRadius && Math.abs(localDeltaY) < activeRadius) {
					return;
				}
				
				//已经进入移动激活区域
				_inActiveArea = true;
				_touchState = TouchMove;
				
				//判断用户触控连续移动间的偏移量，过小则忽略，一直累计到指定值才进行有效移动
				if (Math.abs(localDeltaX - _moveBeginDeltaX) < mouseMoveAccuracy && Math.abs(localDeltaY - _moveBeginDeltaY) < mouseMoveAccuracy) {
					return;
				}
				
				//更新用户触控滑动开始偏移坐标
				_moveBeginDeltaX = localDeltaX;
				_moveBeginDeltaY = localDeltaY;
				
				//计算摇杆偏移的弧度和角度
				_radian = Math.atan2(localDeltaY, localDeltaX);
				(_radian < 0) && (_radian += Math.PI * 2);
				_angle = _radian * Factor_R2A;
				
				//重定位拖块位置
				//鼠标离摇杆中心的最远距离
				var _sqx:int = localDeltaX * localDeltaX;
				var _sqy:int = localDeltaY * localDeltaY;
				if (_sqy + _sqx > rockRadius * rockRadius) {
					var x:int = Math.floor(Math.cos(_radian) * rockRadius);
					var y:int = Math.floor(Math.sin(_radian) * rockRadius);
					_knobSpr.pos(x, y);
				} else {
					_knobSpr.pos(localDeltaX, localDeltaY);
				}
				
				//更新路径
				updatePath(_touchState);
			}
		}
		
		/**
		 * @private
		 * 用户触控结束事件
		 */
		private function onTouchEnd(e:Event):void {
			//如果是移动设备(多点触控设备)，需要触控ID一致
			//如果不是移动设备，不需要判断触控ID，直接执行
			if (!_onMobile || (_touchId === e.touchId)) {
				_touchId = -1;
				_touchState = TouchCancel;
				
				//触控结束，移除相关事件
				Laya.stage.off(Event.MOUSE_MOVE, this, onTouchMove);
				Laya.stage.off(Event.MOUSE_OUT, this, onTouchCancel);
				Laya.stage.off(Event.MOUSE_UP, this, onTouchEnd);
				
				//重置摇杆拖块和摇杆子精灵坐标为默认值
				_knobSpr.pos(0, 0);
				_baseSpr.pos(0, 0);
				
				_baseSpr.visible = !_autoHide;
				
				//重置弧度和角度为未触控状态值
				_radian = -1;
				_angle = -1;
				
				//更新路径
				updatePath(_touchState);
			}
		}
		
		/**
		 * @private
		 * 用户触控滑出事件
		 */
		private function onTouchCancel(e:Event):void {
			onTouchEnd(e);
		}
		
		/**
		 * 当前摇杆指示的弧度值。<br/>
		 * X轴正方向为0，顺时针增加，取值范围[0,2*PI)或-1(表示摇杆处于未触控状态)。
		 */
		public function get radian():Number {
			return _radian;
		}
		
		/**
		 * 当前摇杆指示的角度值。<br/>
		 * X轴正方向为0，顺时针增加，取值范围[0,360)或-1(表示摇杆处于未触控状态)。
		 */
		public function get angle():Number {
			return _angle == -1 ? -1 : Math.round(_angle / anglePerUnit) * anglePerUnit;
		}
		
		/**
		 * 获取触控状态
		 */
		public function get touchState():int {
			return _touchState;
		}
		
		/**
		 * 定义触控响应区域。
		 * @param width		触控响应区域宽度
		 * @param height	触控响应区域高度
		 * @param ofsX		触控响应区域相对于摇杆中心点在X轴上的偏移量
		 * @param ofsY		触控响应区域相对于摇杆中心点在Y轴上的偏移量
		 *
		 */
		public function setTouchArea(width:Number, height:Number, ofsX:Number = 0, ofsY:Number = 0):void {
			if ((_touchAreaOfsX === ofsX) && (_touchAreaOfsY === ofsY) && (_touchWidth === width) && (_touchHeight === height)) return;
			
			_touchWidth = width;
			_touchHeight = height;
			_touchAreaOfsX = ofsX;
			_touchAreaOfsY = ofsY;
			
			_isFixed && _touchSpr.parent && updateFixedTouchArea();
		}
		
		/**
		 * 触控响应区域宽度
		 */
		public function get touchWidth():int {
			return _touchWidth;
		}
		
		/**
		 * 触控响应区域高度
		 */
		public function get touchHeight():int {
			return _touchHeight;
		}
		
		/**
		 * 触控响应区域相对于摇杆中心点在X轴上的偏移量
		 */
		public function get touchAreaOfsX():int {
			return _touchAreaOfsX;
		}
		
		/**
		 * 触控响应区域相对于摇杆中心点在Y轴上的偏移量
		 */
		public function get touchAreaOfsY():int {
			return _touchAreaOfsY;
		}
		
		/**
		 * “摇动区域中心点”相对于“摇杆背景图像中心点”在X轴上的偏移量
		 */
		public function get rockAreaOfsX():Number {
			return _rockAreaOfsX;
		}
		
		/**
		 * “摇动区域中心点”相对于“摇杆背景图像中心点”在X轴上的偏移量
		 */
		public function get rockAreaOfsY():Number {
			return _rockAreaOfsY;
		}
		
		/**
		 * 定义摇动区域。
		 * @param radius	摇动区域是圆形区域，radius定义此区域的半径
		 * @param ofsX		“摇动区域中心点”相对于“摇杆背景图像中心点”在X轴上的偏移量
		 * @param ofsY		“摇动区域中心点”相对于“摇杆背景图像中心点”在Y轴上的偏移量
		 */
		public function setRockArea(radius:Number, ofsX:Number = 0, ofsY:Number = 0):void {
			rockRadius = radius;
			if ((_rockAreaOfsX === ofsX) && (_rockAreaOfsY === ofsY)) return;
			
			_rockAreaOfsX = ofsX;
			_rockAreaOfsY = ofsY;
			
			_bgTex && _baseSpr.graphics.cleanByTexture(_bgTex, -_bgTex.width / 2 - ofsX, -_bgTex.height / 2 - ofsY);
		}
		
		/**
		 * 设置摇杆是否位置固定。摇杆有两种模式：固定模式和跟随模式。默认值为false，也就是跟随模式。<br/>
		 * 固定模式：玩家在摇杆触控响应区域按下时，摇杆根据玩家按下的位置相对于摇杆中心点的偏移向量更新摇杆状态。<br/>
		 * 固定模式下，可通过方法setTouchArea设置触控响应区域。<br/>
		 * 跟随模式：玩家在摇杆触控响应区域按下时，摇杆更新摇杆精灵位置到玩家按下的位置，触控仍然以摇杆中心点为原点计算偏移量。<br/>
		 * 跟随模式下，触控响应区域固定为左半屏，并且适配舞台大小的变化。
		 */
		public function set isFixed(value:Boolean):void {
			if (_isFixed === value) return;
			_isFixed = value;
			this.autoHide = _autoHide;
			_touchSpr.parent && updateTouchArea();
		}
		
		public function get isFixed():Boolean {
			return _isFixed;
		}
		
		/**
		 * 摇杆在无触控状态下是否自动隐藏，默认为false。<br/>
		 * 非操控状态表示无触控状态和触控取消状态，操控状态表示触控按下和触控移动。
		 */
		public function set autoHide(value:Boolean):void {
			_autoHide = value;
			this.isPress || (_baseSpr.visible = !value);
		}
		
		public function get autoHide():Boolean {
			return _autoHide;
		}
		
		/**
		 * 是否启用摇杆触控响应。默认值为false。<br/>
		 * 如果禁用，摇杆将不能响应玩家触控，但是摇杆仍然可见。
		 * @param value 是否启用摇杆响应
		 */
		public function set enable(value:Boolean):void {
			if (_enable === value) return;
			_enable = value;
			
			if (value) {
				if (this.parent) {
					onAdded();
				} else {
					on(Event.ADDED, this, onAdded);
				}
			} else {
				Laya.stage.off(Event.RESIZE, this, updateFollowedTouchArea);
				Laya.stage.off(Event.MOUSE_MOVE, this, onTouchMove);
				Laya.stage.off(Event.MOUSE_OUT, this, onTouchCancel);
				Laya.stage.off(Event.MOUSE_UP, this, onTouchEnd);
				
				_touchSpr.off(Event.MOUSE_DOWN, this, onTouchBegin);
				_touchSpr.removeSelf();
				
				reset();
				
				_baseSpr.pos(0, 0);
				_baseSpr.visible = !_autoHide;
			}
		}
		
		public function get enable():Boolean {
			return _enable;
		}
		
		/**
		 * 玩家触控是否处于按下状态。按下状态包括：TOUCH_DOWN、TOUCH_MOVE
		 * @return 是否处于按下状态
		 */
		public function get isPress():Boolean {
			return _touchState == TouchDown || _touchState == TouchMove;
		}
		
		/**@inheritDoc */
		override public function set x(value:Number):void {
			super.x = value;
			updateFixedTouchArea();
		}
		
		/**@inheritDoc */
		override public function set y(value:Number):void {
			super.y = value;
			updateFixedTouchArea();
		}
		
		/**@inheritDoc */
		override public function pos(x:Number, y:Number, speedMode:Boolean = false):Sprite {
			super.pos(x, y, speedMode);
			updateFixedTouchArea();
			return this;
		}
		
		/**@inheritDoc */
		override public function set transform(value:Matrix):void {
			super.transform = value;
			updateFixedTouchArea();
		}
		
		/**@inheritDoc */
		override public function set scaleX(value:Number):void {
			super.scaleX = value;
			updateFixedTouchArea();
		}
		
		/**@inheritDoc */
		override public function set scaleY(value:Number):void {
			super.scaleY = value;
			updateFixedTouchArea();
		}
		
		/**@inheritDoc */
		override public function scale(scaleX:Number, scaleY:Number, speedMode:Boolean = false):Sprite {
			super.scale(scaleX, scaleY, speedMode);
			updateFixedTouchArea();
			return this;
		}
	}
}