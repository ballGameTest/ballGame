var window = window || global;
var document = document || (window.document = {});
/***********************************/
/*http://www.layabox.com  2017/3/23*/
/***********************************/
var Laya=window.Laya=(function(window,document){
	var Laya={
		__internals:[],
		__packages:{},
		__classmap:{'Object':Object,'Function':Function,'Array':Array,'String':String},
		__sysClass:{'object':'Object','array':'Array','string':'String','dictionary':'Dictionary'},
		__propun:{writable: true,enumerable: false,configurable: true},
		__presubstr:String.prototype.substr,
		__substr:function(ofs,sz){return arguments.length==1?Laya.__presubstr.call(this,ofs):Laya.__presubstr.call(this,ofs,sz>0?sz:(this.length+sz));},
		__init:function(_classs){_classs.forEach(function(o){o.__init$ && o.__init$();});},
		__isClass:function(o){return o && (o.__isclass || o==Object || o==String || o==Array);},
		__newvec:function(sz,value){
			var d=[];
			d.length=sz;
			for(var i=0;i<sz;i++) d[i]=value;
			return d;
		},
		__extend:function(d,b){
			for (var p in b){
				if (!b.hasOwnProperty(p)) continue;
				var gs=Object.getOwnPropertyDescriptor(b, p);
				var g = gs.get, s = gs.set; 
				if ( g || s ) {
					if ( g && s)
						Object.defineProperty(d,p,gs);
					else{
						g && Object.defineProperty(d, p, g);
						s && Object.defineProperty(d, p, s);
					}
				}
				else d[p] = b[p];
			}
			function __() { Laya.un(this,'constructor',d); }__.prototype=b.prototype;d.prototype=new __();Laya.un(d.prototype,'__imps',Laya.__copy({},b.prototype.__imps));
		},
		__copy:function(dec,src){
			if(!src) return null;
			dec=dec||{};
			for(var i in src) dec[i]=src[i];
			return dec;
		},
		__package:function(name,o){
			if(Laya.__packages[name]) return;
			Laya.__packages[name]=true;
			var p=window,strs=name.split('.');
			if(strs.length>1){
				for(var i=0,sz=strs.length-1;i<sz;i++){
					var c=p[strs[i]];
					p=c?c:(p[strs[i]]={});
				}
			}
			p[strs[strs.length-1]] || (p[strs[strs.length-1]]=o||{});
		},
		__hasOwnProperty:function(name,o){
			o=o ||this;
		    function classHas(name,o){
				if(Object.hasOwnProperty.call(o.prototype,name)) return true;
				var s=o.prototype.__super;
				return s==null?null:classHas(name,s);
			}
			return (Object.hasOwnProperty.call(o,name)) || classHas(name,o.__class);
		},
		__typeof:function(o,value){
			if(!o || !value) return false;
			if(value===String) return (typeof o==='string');
			if(value===Number) return (typeof o==='number');
			if(value.__interface__) value=value.__interface__;
			else if(typeof value!='string')  return (o instanceof value);
			return (o.__imps && o.__imps[value]) || (o.__class==value);
		},
		__as:function(value,type){
			return (this.__typeof(value,type))?value:null;
		},		
		interface:function(name,_super){
			Laya.__package(name,{});
			var ins=Laya.__internals;
			var a=ins[name]=ins[name] || {self:name};
			if(_super)
			{
				var supers=_super.split(',');
				a.extend=[];
				for(var i=0;i<supers.length;i++){
					var nm=supers[i];
					ins[nm]=ins[nm] || {self:nm};
					a.extend.push(ins[nm]);
				}
			}
			var o=window,words=name.split('.');
			for(var i=0;i<words.length-1;i++) o=o[words[i]];
			o[words[words.length-1]]={__interface__:name};
		},
		class:function(o,fullName,_super,miniName){
			_super && Laya.__extend(o,_super);
			if(fullName){
				Laya.__package(fullName,o);
				Laya.__classmap[fullName]=o;
				if(fullName.indexOf('.')>0){
					if(fullName.indexOf('laya.')==0){
						var paths=fullName.split('.');
						miniName=miniName || paths[paths.length-1];
						if(Laya[miniName]) console.log("Warning!,this class["+miniName+"] already exist:",Laya[miniName]);
						Laya[miniName]=o;
					}
				}
				else {
					if(fullName=="Main")
						window.Main=o;
					else{
						if(Laya[fullName]){
							console.log("Error!,this class["+fullName+"] already exist:",Laya[fullName]);
						}
						Laya[fullName]=o;
					}
				}
			}
			var un=Laya.un,p=o.prototype;
			un(p,'hasOwnProperty',Laya.__hasOwnProperty);
			un(p,'__class',o);
			un(p,'__super',_super);
			un(p,'__className',fullName);
			un(o,'__super',_super);
			un(o,'__className',fullName);
			un(o,'__isclass',true);
			un(o,'super',function(o){this.__super.call(o);});
		},
		imps:function(dec,src){
			if(!src) return null;
			var d=dec.__imps|| Laya.un(dec,'__imps',{});
			function __(name){
				var c,exs;
				if(! (c=Laya.__internals[name]) ) return;
				d[name]=true;
				if(!(exs=c.extend)) return;
				for(var i=0;i<exs.length;i++){
					__(exs[i].self);
				}
			}
			for(var i in src) __(i);
		},
		getset:function(isStatic,o,name,getfn,setfn){
			if(!isStatic){
				getfn && Laya.un(o,'_$get_'+name,getfn);
				setfn && Laya.un(o,'_$set_'+name,setfn);
			}
			else{
				getfn && (o['_$GET_'+name]=getfn);
				setfn && (o['_$SET_'+name]=setfn);
			}
			if(getfn && setfn) 
				Object.defineProperty(o,name,{get:getfn,set:setfn,enumerable:false});
			else{
				getfn && Object.defineProperty(o,name,{get:getfn,enumerable:false});
				setfn && Object.defineProperty(o,name,{set:setfn,enumerable:false});
			}
		},
		static:function(_class,def){
				for(var i=0,sz=def.length;i<sz;i+=2){
					if(def[i]=='length') 
						_class.length=def[i+1].call(_class);
					else{
						function tmp(){
							var name=def[i];
							var getfn=def[i+1];
							Object.defineProperty(_class,name,{
								get:function(){delete this[name];return this[name]=getfn.call(this);},
								set:function(v){delete this[name];this[name]=v;},enumerable: true,configurable: true});
						}
						tmp();
					}
				}
		},		
		un:function(obj,name,value){
			value || (value=obj[name]);
			Laya.__propun.value=value;
			Object.defineProperty(obj, name, Laya.__propun);
			return value;
		},
		uns:function(obj,names){
			names.forEach(function(o){Laya.un(obj,o)});
		}
	};

	window.console=window.console || ({log:function(){}});
	window.trace=window.console.log;
	Error.prototype.throwError=function(){throw arguments;};
	//String.prototype.substr=Laya.__substr;
	Object.defineProperty(Array.prototype,'fixed',{enumerable: false});

	return Laya;
})(window,document);

(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;
	Laya.interface('game.net.IMessage');
	/**
	*游戏服务器
	*@author CHENZHENG
	*/
	//class BallGameServer
	var BallGameServer=(function(){
		function BallGameServer(){
			this.socketServer=null;
			this.eventServer=null;
			this.roomManager=null;
			this.clients={};
			this.clientId=0;
			this.clientCount=0;
			this.clientDataMsg=null;
			this.config=[];
			this.serverConfig={};
			MessageInit.init();
			this.socketServer=new SocketServer();
			this.eventServer=new EventDispatcher();
			this.initClientEvent();
			this.roomManager=RoomManager.I();
			this.roomManager.init(this.eventServer,this.clients);
		}

		__class(BallGameServer,'BallGameServer');
		var __proto=BallGameServer.prototype;
		/**
		*初始化客户端连接、断开监听
		*/
		__proto.initClientEvent=function(){
			this.socketServer.on("client_connect",this,this.onConnect);
			this.eventServer.on(ServerEvent.CLIENT_CLOSE,this,this.onClose);
		}

		/**
		*玩家上线消息，创建客户端
		*@param webSocket 服务器为客户端分配的对应webSocket
		*/
		__proto.onConnect=function(webSocket){
			this.clientId++;
			this.clientCount++;
			var serverClient=new ServerPlayer();
			serverClient.init(webSocket,this.eventServer);
			serverClient.nickname="测试昵称"+Math.round(Math.random()*100);
			serverClient.headId=Math.round(Math.random()*7);
			serverClient.sourceId=Math.round(Math.random()*3);
			serverClient.clientId=this.clientId;
			this.clients[this.clientId]=serverClient;
			this.clientDataMsg=new ClientDataMsg(serverClient);
			serverClient.send(this.clientDataMsg);
			var num=0;
			for(var p in this.clients)num++;
			console.log("玩家----"+serverClient.nickname+"----上线了！在线人数为："+num);
		}

		/**
		*玩家离开游戏
		*@param serverClient 离线的客户端
		*/
		__proto.onClose=function(client){
			this.roomManager.clientRemove(client);
			delete this.clients[client.clientId];
			this.clientCount--;
			if(this.clientCount==0)this.clientId=0;
			console.log("有客户端离线了！在线人数为："+this.clientCount);
			client=null;
		}

		return BallGameServer;
	})()


	//class RoomManager
	var RoomManager=(function(){
		function RoomManager(){
			this.eventServer=null;
			this.clients={};
			this.rooms={};
			this.roomId=0;
			this.roomCount=0;
			DataManager.listen(EnterRoomMsg,this,this.onEnterRoom);
			DataManager.listen(GameStartMsg,this,this.onRoomStart);
		}

		__class(RoomManager,'RoomManager');
		var __proto=RoomManager.prototype;
		/**
		*初始化房间管理全局信息
		*/
		__proto.init=function(eventSer,clients){
			this.eventServer=eventSer;
			this.clients=clients;
			this.eventServer.on("game_room",this,this.onRoomOver);
		}

		/**
		*房间游戏开始
		*/
		__proto.onRoomStart=function(msg){
			console.log("---------玩家请求开始游戏，房间Id为："+msg.roomId)
			if(this.rooms[msg.roomId])this.rooms[msg.roomId].gameStart();
		}

		/**
		*房间游戏结束，移除房间
		*/
		__proto.onRoomOver=function(room){
			delete this.rooms[room.roomId];
			this.roomCount--;
			if(this.roomCount==0||this.roomCount<0){
				this.roomCount=0;
				this.roomId=0;
			}
			Pool.recover("serverRoom",room);
			console.log("房间"+room.roomId+"----游戏结束！ 目前房间数为："+this.roomCount);
		}

		/**
		*玩家进入房间消息，进入现有房间或创建新房间
		*/
		__proto.onEnterRoom=function(msg){
			var client=this.clients[msg.clientDataMsg.clientId];
			var serverRoom;
			for(var i in this.rooms){
				serverRoom=this.rooms[i];
				if(serverRoom.clientsCount<serverRoom.roomMaxCount&&!serverRoom.roomStart){
					client.isOriginator=false;
					serverRoom.clientToRoom(client,serverRoom.roomId);
					console.log("玩家----"+client.nickname+"----加入了房间"+serverRoom.roomId,"----目前房间人数:"+serverRoom.clientsCount);
					break ;
				}
			}
			if(!client.isInRoom){
				this.roomCount++;
				serverRoom=Pool.getItemByClass("serverRoom",ServerRoom);
				serverRoom.init(this.roomId,this.eventServer);
				this.rooms[this.roomId]=serverRoom;
				client.isOriginator=true;
				serverRoom.clientToRoom(client,this.roomId);
				this.roomId++;
				console.log("玩家----"+client.nickname+"----创建了房间"+serverRoom.roomId);
			}
		}

		/**
		*移除房间中离开游戏的玩家
		*@param client
		*/
		__proto.clientRemove=function(client){
			if(client.isInRoom){
				var room=this.rooms[client.roomId];
				room.clientRemove(client);
				console.log("玩家----"+client.nickname+"----离开了游戏房间Id:"+room.roomId,"----目前房间人数:"+room.clientsCount);
				if(room.clientsCount==0){
					this.onRoomOver(room);
					console.log("游戏房间中无人了，取消房间！   目前房间数为："+this.roomCount)
				}
			}
		}

		RoomManager.I=function(){
			if(!RoomManager.instance)RoomManager.instance=new RoomManager();
			return RoomManager.instance;
		}

		RoomManager.instance=null
		return RoomManager;
	})()


	//class ServerEvent
	var ServerEvent=(function(){
		function ServerEvent(){}
		__class(ServerEvent,'ServerEvent');
		ServerEvent.CONFIG_COMPLETE="gameConfig_complete";
		ServerEvent.CLIENT_CONNECT="client_connect";
		ServerEvent.GAME_OVER="game_room";
		ServerEvent.GAME_START="game_start";
		ServerEvent.CLIENT_MESSAGE="message";
		ServerEvent.CLIENT_CLOSE="close";
		return ServerEvent;
	})()


	//class ServerItem
	var ServerItem=(function(){
		function ServerItem(){
			this.id=0;
			this.type=0;
			this.sourceId=0;
			this.weight=0;
			this.radius=-1;
			this.speed=0;
			this.angle=0;
			this.x=0;
			this.y=0;
			this.isFly=false;
		}

		__class(ServerItem,'ServerItem');
		return ServerItem;
	})()


	//class ServerRoom
	var ServerRoom=(function(){
		function ServerRoom(){
			this.eventServer=null;
			this.timer={};
			this.roomId=0;
			this.clientsCount=0;
			this.clients={};
			this.roomMaxCount=4;
			this.roomStart=false;
			this.roomTime=360000;
			this.mapId=0;
			this.starCount=100;
			this.thornCount=10;
			this.items={};
			this.STAR=0;
			this.THORN=1;
			this.ROLE=2;
			this.PROP=3;
			this.itemId=0;
			this.roomClientsMsg=null;
			this.gameStartMsg=null;
			this.gameOverMsg=null;
			this.itemDataMsg=null;
			this.gameCreateMsg=null;
			this.clientLeaveMsg=null;
			this.clientReviveMsg=null;
			DataManager.listen(ClientAngleMsg,this,this.onPlayerAngle);
			DataManager.listen(ClientLostMsg,this,this.onClientLost);
			DataManager.listen(EatItemMsg,this,this.onItemEaten);
			DataManager.listen(ClientReviveMsg,this,this.onClientRevive);
		}

		__class(ServerRoom,'ServerRoom');
		var __proto=ServerRoom.prototype;
		/***转发玩家角度变化消息***/
		__proto.onPlayerAngle=function(msg){
			this.broadcastToRoom(msg);
		}

		/***转发玩家吐道具消息***/
		__proto.onClientLost=function(msg){
			var len=msg.itemDataArray.length;
			for(var i=0;i<len;i++){
				msg.itemDataArray[i].id=this.itemId++;
			}
			this.broadcastToRoom(msg);
		}

		/***道具被吃消息处理***/
		__proto.onItemEaten=function(msg){
			if(msg.eatClientId==-1){
				if(this.items[msg.eatId].type===this.STAR){
					this.starCount--;
					delete this.items[msg.eatId];
				}
				else if(this.items[msg.eatId].type===this.THORN){
					this.thornCount--;
					delete this.items[msg.eatId];
				}
			}
			this.broadcastToRoom(msg,this.clients[msg.roleClientId]);
			if(this.starCount<=80){
				console.log("------星星数："+this.starCount,"创建20个！！");
				this.createItems(this.STAR,20);
				this.broadcastToRoom(this.gameCreateMsg);
				this.starCount+=20;
			}
		}

		/***转发玩家复活消息***/
		__proto.onClientRevive=function(msg){
			this.clientReviveMsg=msg;
			this.clientReviveMsg.x=Math.ceil(Math.random()*2450+100);
			this.clientReviveMsg.y=Math.ceil(Math.random()*2450+100);
			this.broadcastToRoom(this.clientReviveMsg);
		}

		/**
		*游戏房间初始化
		*@param roomId 房间Id
		*@param eventSer 服务器事件中心
		*
		*/
		__proto.init=function(roomId,eventSer){
			this.roomId=roomId;
			this.eventServer=eventSer;
			this.mapId=Math.ceil(Math.random()*2);
			this.createItems(this.STAR,this.starCount);
		}

		/**
		*房间时间循环
		*/
		__proto.onFrame=function(){
			this.roomTime-=16;
			if(this.roomTime<=0)this.gameOver();
		}

		/**
		*房间游戏结束，游戏对象还原并回收
		*/
		__proto.gameOver=function(){
			this.gameOverMsg=new GameOverMsg();
			this.broadcastToRoom(this.gameOverMsg);
			this.eventServer.event("game_room",[this]);
			this.timer=clearInterval(this.timer);;
			this.roomId=0;
			this.clientsCount=0;
			this.starCount=100;
			this.itemId=0;
			this.roomStart=false;
			this.roomTime=360000;
			for(var m in this.clients){
				this.clients[m].isInRoom=false;
			}
			this.clients={};
		}

		/**房间游戏开始****/
		__proto.gameStart=function(){
			this.roomStart=true;
			this.gameStartMsg=new GameStartMsg();
			this.broadcastToRoom(this.gameStartMsg);
			console.log("房间"+this.roomId+"----开始游戏,游戏总时间为："+this.roomTime)
			this.timer=setInterval(this.onFrame.bind(this),16);;
		}

		/**
		*根据类型创建游戏物品与相关消息。星星、刺球
		*@param type 类型
		*@param count 数量
		*/
		__proto.createItems=function(type,count){
			var msgArray=[];
			for(var i=0;i<count;i++){
				var item=Pool.getItemByClass("serverItem",ServerItem);
				if(type===this.THORN){
					item.type=this.THORN;
					item.weight=Math.ceil(Math.random()*1000+300);
					item.radius=128;
					}else{
					item.type=this.STAR;
					item.weight=Math.ceil(Math.random()*50+20);
					item.radius=16;
				}
				item.id=this.itemId;
				item.sourceId=Math.ceil(Math.random()*6);
				item.x=Math.ceil(Math.random()*2520+20);
				item.y=Math.ceil(Math.random()*2520+20);
				this.items[this.itemId]=item;
				this.itemId++;
				var itemDataMsg=new ItemDataMsg(item);
				msgArray.push(itemDataMsg);
			}
			this.gameCreateMsg=new GameCreateMsg();
			this.gameCreateMsg.itemDataArray=msgArray;
			this.gameCreateMsg.gameTime=this.roomTime;
			this.gameCreateMsg.roomId=this.roomId;
			this.gameCreateMsg.mapId=this.mapId;
		}

		/***玩家加入房间****/
		__proto.clientToRoom=function(client,roomId){
			client.type=this.ROLE;
			this.clients[client.clientId]=client;
			client.isInRoom=true;
			client.roomId=roomId;
			client.x=Math.ceil(Math.random()*2560);
			client.y=Math.ceil(Math.random()*2560);
			client.speed=2;
			client.angle=Math.ceil(Math.random()*360);
			this.clientsCount++;
			client.send(this.gameCreateMsg);
			var arr=[];
			for(var m in this.clients){
				var clientDataMsg=new ClientDataMsg(this.clients[m]);
				arr.push(clientDataMsg);
			}
			this.roomClientsMsg=new ClientsCreateMsg();
			this.roomClientsMsg.clients=arr;
			this.broadcastToRoom(this.roomClientsMsg);
		}

		/**
		*玩家移除房间
		*/
		__proto.clientRemove=function(client){
			this.clientLeaveMsg=new ClientLeaveMsg();
			this.clientLeaveMsg.id=client.clientId;
			this.broadcastToRoom(this.clientLeaveMsg,client);
			delete this.clients[client.clientId];
			client.isInRoom=false;
			this.clientsCount--;
			if(this.clientsCount<=1){
				this.gameOver();
			}
		}

		/**
		*广播消息(房间)
		*@param msg 发送的消息
		*@param exclude 排除的消息接收者
		*/
		__proto.broadcastToRoom=function(msg,exclude){
			for(var i in this.clients){
				if(exclude!=null&&i==exclude.clientId)continue ;
				this.clients[i].send(msg);
			}
		}

		return ServerRoom;
	})()


	//class laya.events.EventDispatcher
	var EventDispatcher=(function(){
		var EventHandler;
		function EventDispatcher(){
			this._events=null;
		}

		__class(EventDispatcher,'laya.events.EventDispatcher');
		var __proto=EventDispatcher.prototype;
		/**
		*检查 EventDispatcher 对象是否为特定事件类型注册了任何侦听器。
		*@param type 事件的类型。
		*@return 如果指定类型的侦听器已注册，则值为 true；否则，值为 false。
		*/
		__proto.hasListener=function(type){
			var listener=this._events && this._events[type];
			return !!listener;
		}

		/**
		*派发事件。
		*@param type 事件类型。
		*@param data （可选）回调数据。<b>注意：</b>如果是需要传递多个参数 p1,p2,p3,...可以使用数组结构如：[p1,p2,p3,...] ；如果需要回调单个参数 p ，且 p 是一个数组，则需要使用结构如：[p]，其他的单个参数 p ，可以直接传入参数 p。
		*@return 此事件类型是否有侦听者，如果有侦听者则值为 true，否则值为 false。
		*/
		__proto.event=function(type,data){
			if (!this._events || !this._events[type])return false;
			var listeners=this._events[type];
			if (listeners.run){
				if (listeners.once)delete this._events[type];
				data !=null ? listeners.runWith(data):listeners.run();
				}else {
				for (var i=0,n=listeners.length;i < n;i++){
					var listener=listeners[i];
					if (listener){
						(data !=null)? listener.runWith(data):listener.run();
					}
					if (!listener || listener.once){
						listeners.splice(i,1);
						i--;
						n--;
					}
				}
				if (listeners.length===0 && this._events)delete this._events[type];
			}
			return true;
		}

		/**
		*使用 EventDispatcher 对象注册指定类型的事件侦听器对象，以使侦听器能够接收事件通知。
		*@param type 事件的类型。
		*@param caller 事件侦听函数的执行域。
		*@param listener 事件侦听函数。
		*@param args （可选）事件侦听函数的回调参数。
		*@return 此 EventDispatcher 对象。
		*/
		__proto.on=function(type,caller,listener,args){
			return this._createListener(type,caller,listener,args,false);
		}

		/**
		*使用 EventDispatcher 对象注册指定类型的事件侦听器对象，以使侦听器能够接收事件通知，此侦听事件响应一次后自动移除。
		*@param type 事件的类型。
		*@param caller 事件侦听函数的执行域。
		*@param listener 事件侦听函数。
		*@param args （可选）事件侦听函数的回调参数。
		*@return 此 EventDispatcher 对象。
		*/
		__proto.once=function(type,caller,listener,args){
			return this._createListener(type,caller,listener,args,true);
		}

		/**@private */
		__proto._createListener=function(type,caller,listener,args,once,offBefore){
			(offBefore===void 0)&& (offBefore=true);
			offBefore && this.off(type,caller,listener,once);
			var handler=EventHandler.create(caller || this,listener,args,once);
			this._events || (this._events={});
			var events=this._events;
			if (!events[type])events[type]=handler;
			else {
				if (!events[type].run)events[type].push(handler);
				else events[type]=[events[type],handler];
			}
			return this;
		}

		/**
		*从 EventDispatcher 对象中删除侦听器。
		*@param type 事件的类型。
		*@param caller 事件侦听函数的执行域。
		*@param listener 事件侦听函数。
		*@param onceOnly （可选）如果值为 true ,则只移除通过 once 方法添加的侦听器。
		*@return 此 EventDispatcher 对象。
		*/
		__proto.off=function(type,caller,listener,onceOnly){
			(onceOnly===void 0)&& (onceOnly=false);
			if (!this._events || !this._events[type])return this;
			var listeners=this._events[type];
			if (listener !=null){
				if (listeners.run){
					if ((!caller || listeners.caller===caller)&& listeners.method===listener && (!onceOnly || listeners.once)){
						delete this._events[type];
						listeners.recover();
					}
					}else {
					var count=0;
					for (var i=0,n=listeners.length;i < n;i++){
						var item=listeners[i];
						if (item && (!caller || item.caller===caller)&& item.method===listener && (!onceOnly || item.once)){
							count++;
							listeners[i]=null;
							item.recover();
						}
					}
					if (count===n)delete this._events[type];
				}
			}
			return this;
		}

		/**
		*从 EventDispatcher 对象中删除指定事件类型的所有侦听器。
		*@param type （可选）事件类型，如果值为 null，则移除本对象所有类型的侦听器。
		*@return 此 EventDispatcher 对象。
		*/
		__proto.offAll=function(type){
			var events=this._events;
			if (!events)return this;
			if (type){
				this._recoverHandlers(events[type]);
				delete events[type];
				}else {
				for (var name in events){
					this._recoverHandlers(events[name]);
				}
				this._events=null;
			}
			return this;
		}

		__proto._recoverHandlers=function(arr){
			if (!arr)return;
			if (arr.run){
				arr.recover();
				}else {
				for (var i=arr.length-1;i >-1;i--){
					if (arr[i]){
						arr[i].recover();
						arr[i]=null;
					}
				}
			}
		}

		EventDispatcher.__init$=function(){
			Object.defineProperty(laya.events.EventDispatcher.prototype,"_events",{enumerable:false,writable:true});
			/**@private */
			//class EventHandler extends laya.utils.Handler
			EventHandler=(function(_super){
				function EventHandler(caller,method,args,once){
					EventHandler.__super.call(this,caller,method,args,once);
				}
				__class(EventHandler,'',_super);
				var __proto=EventHandler.prototype;
				__proto.recover=function(){
					if (this._id > 0){
						this._id=0;
						EventHandler._pool.push(this.clear());
					}
				}
				EventHandler.create=function(caller,method,args,once){
					(once===void 0)&& (once=true);
					if (EventHandler._pool.length)return EventHandler._pool.pop().setTo(caller,method,args,once);
					return new EventHandler(caller,method,args,once);
				}
				EventHandler._pool=[];
				return EventHandler;
			})(Handler)
		}

		return EventDispatcher;
	})()


	//class laya.maths.Matrix
	var Matrix=(function(){
		function Matrix(a,b,c,d,tx,ty){
			//this.a=NaN;
			//this.b=NaN;
			//this.c=NaN;
			//this.d=NaN;
			//this.tx=NaN;
			//this.ty=NaN;
			this.inPool=false;
			this.bTransform=false;
			(a===void 0)&& (a=1);
			(b===void 0)&& (b=0);
			(c===void 0)&& (c=0);
			(d===void 0)&& (d=1);
			(tx===void 0)&& (tx=0);
			(ty===void 0)&& (ty=0);
			this.a=a;
			this.b=b;
			this.c=c;
			this.d=d;
			this.tx=tx;
			this.ty=ty;
			this._checkTransform();
		}

		__class(Matrix,'laya.maths.Matrix');
		var __proto=Matrix.prototype;
		/**
		*将本矩阵设置为单位矩阵。
		*@return 返回当前矩形。
		*/
		__proto.identity=function(){
			this.a=this.d=1;
			this.b=this.tx=this.ty=this.c=0;
			this.bTransform=false;
			return this;
		}

		/**@private*/
		__proto._checkTransform=function(){
			return this.bTransform=(this.a!==1 || this.b!==0 || this.c!==0 || this.d!==1);
		}

		/**
		*设置沿 x 、y 轴平移每个点的距离。
		*@param x 沿 x 轴平移每个点的距离。
		*@param y 沿 y 轴平移每个点的距离。
		*@return 返回对象本身
		*/
		__proto.setTranslate=function(x,y){
			this.tx=x;
			this.ty=y;
			return this;
		}

		/**
		*沿 x 和 y 轴平移矩阵，平移的变化量由 x 和 y 参数指定。
		*@param x 沿 x 轴向右移动的量（以像素为单位）。
		*@param y 沿 y 轴向下移动的量（以像素为单位）。
		*@return 返回此矩形对象。
		*/
		__proto.translate=function(x,y){
			this.tx+=x;
			this.ty+=y;
			return this;
		}

		/**
		*对矩阵应用缩放转换。
		*@param x 用于沿 x 轴缩放对象的乘数。
		*@param y 用于沿 y 轴缩放对象的乘数。
		*/
		__proto.scale=function(x,y){
			this.a *=x;
			this.d *=y;
			this.c *=x;
			this.b *=y;
			this.tx *=x;
			this.ty *=y;
			this.bTransform=true;
		}

		/**
		*对 Matrix 对象应用旋转转换。
		*@param angle 以弧度为单位的旋转角度。
		*/
		__proto.rotate=function(angle){
			var cos=Math.cos(angle);
			var sin=Math.sin(angle);
			var a1=this.a;
			var c1=this.c;
			var tx1=this.tx;
			this.a=a1 *cos-this.b *sin;
			this.b=a1 *sin+this.b *cos;
			this.c=c1 *cos-this.d *sin;
			this.d=c1 *sin+this.d *cos;
			this.tx=tx1 *cos-this.ty *sin;
			this.ty=tx1 *sin+this.ty *cos;
			this.bTransform=true;
		}

		/**
		*对 Matrix 对象应用倾斜转换。
		*@param x 沿着 X 轴的 2D 倾斜弧度。
		*@param y 沿着 Y 轴的 2D 倾斜弧度。
		*@return 当前 Matrix 对象。
		*/
		__proto.skew=function(x,y){
			var tanX=Math.tan(x);
			var tanY=Math.tan(y);
			var a1=this.a;
			var b1=this.b;
			this.a+=tanY *this.c;
			this.b+=tanY *this.d;
			this.c+=tanX *a1;
			this.d+=tanX *b1;
			return this;
		}

		/**
		*对指定的点应用当前矩阵的逆转化并返回此点。
		*@param out 待转化的点 Point 对象。
		*@return 返回out
		*/
		__proto.invertTransformPoint=function(out){
			var a1=this.a;
			var b1=this.b;
			var c1=this.c;
			var d1=this.d;
			var tx1=this.tx;
			var n=a1 *d1-b1 *c1;
			var a2=d1 / n;
			var b2=-b1 / n;
			var c2=-c1 / n;
			var d2=a1 / n;
			var tx2=(c1 *this.ty-d1 *tx1)/ n;
			var ty2=-(a1 *this.ty-b1 *tx1)/ n;
			return out.setTo(a2 *out.x+c2 *out.y+tx2,b2 *out.x+d2 *out.y+ty2);
		}

		/**
		*将 Matrix 对象表示的几何转换应用于指定点。
		*@param out 用来设定输出结果的点。
		*@return 返回out
		*/
		__proto.transformPoint=function(out){
			return out.setTo(this.a *out.x+this.c *out.y+this.tx,this.b *out.x+this.d *out.y+this.ty);
		}

		/**
		*将 Matrix 对象表示的几何转换应用于指定点，忽略tx、ty。
		*@param out 用来设定输出结果的点。
		*@return 返回out
		*/
		__proto.transformPointN=function(out){
			return out.setTo(this.a *out.x+this.c *out.y ,this.b *out.x+this.d *out.y);
		}

		/**
		*@private
		*将 Matrix 对象表示的几何转换应用于指定点。
		*@param data 点集合。
		*@param out 存储应用转化的点的列表。
		*@return 返回out数组
		*/
		__proto.transformPointArray=function(data,out){
			var len=data.length;
			for (var i=0;i < len;i+=2){
				var x=data[i],y=data[i+1];
				out[i]=this.a *x+this.c *y+this.tx;
				out[i+1]=this.b *x+this.d *y+this.ty;
			}
			return out;
		}

		/**
		*@private
		*将 Matrix 对象表示的几何缩放转换应用于指定点。
		*@param data 点集合。
		*@param out 存储应用转化的点的列表。
		*@return 返回out数组
		*/
		__proto.transformPointArrayScale=function(data,out){
			var len=data.length;
			for (var i=0;i < len;i+=2){
				var x=data[i],y=data[i+1];
				out[i]=this.a *x+this.c *y;
				out[i+1]=this.b *x+this.d *y;
			}
			return out;
		}

		/**
		*获取 X 轴缩放值。
		*@return X 轴缩放值。
		*/
		__proto.getScaleX=function(){
			return this.b===0 ? this.a :Math.sqrt(this.a *this.a+this.b *this.b);
		}

		/**
		*获取 Y 轴缩放值。
		*@return Y 轴缩放值。
		*/
		__proto.getScaleY=function(){
			return this.c===0 ? this.d :Math.sqrt(this.c *this.c+this.d *this.d);
		}

		/**
		*执行原始矩阵的逆转换。
		*@return 当前矩阵对象。
		*/
		__proto.invert=function(){
			var a1=this.a;
			var b1=this.b;
			var c1=this.c;
			var d1=this.d;
			var tx1=this.tx;
			var n=a1 *d1-b1 *c1;
			this.a=d1 / n;
			this.b=-b1 / n;
			this.c=-c1 / n;
			this.d=a1 / n;
			this.tx=(c1 *this.ty-d1 *tx1)/ n;
			this.ty=-(a1 *this.ty-b1 *tx1)/ n;
			return this;
		}

		/**
		*将 Matrix 的成员设置为指定值。
		*@param a 缩放或旋转图像时影响像素沿 x 轴定位的值。
		*@param b 旋转或倾斜图像时影响像素沿 y 轴定位的值。
		*@param c 旋转或倾斜图像时影响像素沿 x 轴定位的值。
		*@param d 缩放或旋转图像时影响像素沿 y 轴定位的值。
		*@param tx 沿 x 轴平移每个点的距离。
		*@param ty 沿 y 轴平移每个点的距离。
		*@return 当前矩阵对象。
		*/
		__proto.setTo=function(a,b,c,d,tx,ty){
			this.a=a,this.b=b,this.c=c,this.d=d,this.tx=tx,this.ty=ty;
			return this;
		}

		/**
		*将指定矩阵与当前矩阵连接，从而将这两个矩阵的几何效果有效地结合在一起。
		*@param matrix 要连接到源矩阵的矩阵。
		*@return 当前矩阵。
		*/
		__proto.concat=function(matrix){
			var a=this.a;
			var c=this.c;
			var tx=this.tx;
			this.a=a *matrix.a+this.b *matrix.c;
			this.b=a *matrix.b+this.b *matrix.d;
			this.c=c *matrix.a+this.d *matrix.c;
			this.d=c *matrix.b+this.d *matrix.d;
			this.tx=tx *matrix.a+this.ty *matrix.c+matrix.tx;
			this.ty=tx *matrix.b+this.ty *matrix.d+matrix.ty;
			return this;
		}

		/**
		*@private
		*对矩阵应用缩放转换。反向相乘
		*@param x 用于沿 x 轴缩放对象的乘数。
		*@param y 用于沿 y 轴缩放对象的乘数。
		*/
		__proto.scaleEx=function(x,y){
			var ba=this.a,bb=this.b,bc=this.c,bd=this.d;
			if (bb!==0 || bc!==0){
				this.a=x *ba;
				this.b=x *bb;
				this.c=y *bc;
				this.d=y *bd;
				}else {
				this.a=x *ba;
				this.b=0 *bd;
				this.c=0 *ba;
				this.d=y *bd;
			}
			this.bTransform=true;
		}

		/**
		*@private
		*对 Matrix 对象应用旋转转换。反向相乘
		*@param angle 以弧度为单位的旋转角度。
		*/
		__proto.rotateEx=function(angle){
			var cos=Math.cos(angle);
			var sin=Math.sin(angle);
			var ba=this.a,bb=this.b,bc=this.c,bd=this.d;
			if (bb!==0 || bc!==0){
				this.a=cos *ba+sin *bc;
				this.b=cos *bb+sin *bd;
				this.c=-sin *ba+cos *bc;
				this.d=-sin *bb+cos *bd;
				}else {
				this.a=cos *ba;
				this.b=sin *bd;
				this.c=-sin *ba;
				this.d=cos *bd;
			}
			this.bTransform=true;
		}

		/**
		*返回此 Matrix 对象的副本。
		*@return 与原始实例具有完全相同的属性的新 Matrix 实例。
		*/
		__proto.clone=function(){
			var dec=Matrix.create();
			dec.a=this.a;
			dec.b=this.b;
			dec.c=this.c;
			dec.d=this.d;
			dec.tx=this.tx;
			dec.ty=this.ty;
			dec.bTransform=this.bTransform;
			return dec;
		}

		/**
		*将当前 Matrix 对象中的所有矩阵数据复制到指定的 Matrix 对象中。
		*@param dec 要复制当前矩阵数据的 Matrix 对象。
		*@return 已复制当前矩阵数据的 Matrix 对象。
		*/
		__proto.copyTo=function(dec){
			dec.a=this.a;
			dec.b=this.b;
			dec.c=this.c;
			dec.d=this.d;
			dec.tx=this.tx;
			dec.ty=this.ty;
			dec.bTransform=this.bTransform;
			return dec;
		}

		/**
		*返回列出该 Matrix 对象属性的文本值。
		*@return 一个字符串，它包含 Matrix 对象的属性值：a、b、c、d、tx 和 ty。
		*/
		__proto.toString=function(){
			return this.a+","+this.b+","+this.c+","+this.d+","+this.tx+","+this.ty;
		}

		/**
		*销毁此对象。
		*/
		__proto.destroy=function(){
			if (this.inPool)return;
			var cache=Matrix._cache;
			this.inPool=true;
			cache._length || (cache._length=0);
			cache[cache._length++]=this;
			this.a=this.d=1;
			this.b=this.c=this.tx=this.ty=0;
			this.bTransform=false;
		}

		Matrix.mul=function(m1,m2,out){
			var aa=m1.a,ab=m1.b,ac=m1.c,ad=m1.d,atx=m1.tx,aty=m1.ty;
			var ba=m2.a,bb=m2.b,bc=m2.c,bd=m2.d,btx=m2.tx,bty=m2.ty;
			if (bb!==0 || bc!==0){
				out.a=aa *ba+ab *bc;
				out.b=aa *bb+ab *bd;
				out.c=ac *ba+ad *bc;
				out.d=ac *bb+ad *bd;
				out.tx=ba *atx+bc *aty+btx;
				out.ty=bb *atx+bd *aty+bty;
				}else {
				out.a=aa *ba;
				out.b=ab *bd;
				out.c=ac *ba;
				out.d=ad *bd;
				out.tx=ba *atx+btx;
				out.ty=bd *aty+bty;
			}
			return out;
		}

		Matrix.mul16=function(m1,m2,out){
			var aa=m1.a,ab=m1.b,ac=m1.c,ad=m1.d,atx=m1.tx,aty=m1.ty;
			var ba=m2.a,bb=m2.b,bc=m2.c,bd=m2.d,btx=m2.tx,bty=m2.ty;
			if (bb!==0 || bc!==0){
				out[0]=aa *ba+ab *bc;
				out[1]=aa *bb+ab *bd;
				out[4]=ac *ba+ad *bc;
				out[5]=ac *bb+ad *bd;
				out[12]=ba *atx+bc *aty+btx;
				out[13]=bb *atx+bd *aty+bty;
				}else {
				out[0]=aa *ba;
				out[1]=ab *bd;
				out[4]=ac *ba;
				out[5]=ad *bd;
				out[12]=ba *atx+btx;
				out[13]=bd *aty+bty;
			}
			return out;
		}

		Matrix.mulPre=function(m1,ba,bb,bc,bd,btx,bty,out){
			var aa=m1.a,ab=m1.b,ac=m1.c,ad=m1.d,atx=m1.tx,aty=m1.ty;
			if (bb!==0 || bc!==0){
				out.a=aa *ba+ab *bc;
				out.b=aa *bb+ab *bd;
				out.c=ac *ba+ad *bc;
				out.d=ac *bb+ad *bd;
				out.tx=ba *atx+bc *aty+btx;
				out.ty=bb *atx+bd *aty+bty;
				}else {
				out.a=aa *ba;
				out.b=ab *bd;
				out.c=ac *ba;
				out.d=ad *bd;
				out.tx=ba *atx+btx;
				out.ty=bd *aty+bty;
			}
			return out;
		}

		Matrix.mulPos=function(m1,aa,ab,ac,ad,atx,aty,out){
			var ba=m1.a,bb=m1.b,bc=m1.c,bd=m1.d,btx=m1.tx,bty=m1.ty;
			if (bb!==0 || bc!==0){
				out.a=aa *ba+ab *bc;
				out.b=aa *bb+ab *bd;
				out.c=ac *ba+ad *bc;
				out.d=ac *bb+ad *bd;
				out.tx=ba *atx+bc *aty+btx;
				out.ty=bb *atx+bd *aty+bty;
				}else {
				out.a=aa *ba;
				out.b=ab *bd;
				out.c=ac *ba;
				out.d=ad *bd;
				out.tx=ba *atx+btx;
				out.ty=bd *aty+bty;
			}
			return out;
		}

		Matrix.preMul=function(parent,self,out){
			var pa=parent.a,pb=parent.b,pc=parent.c,pd=parent.d;
			var na=self.a,nb=self.b,nc=self.c,nd=self.d,ntx=self.tx,nty=self.ty;
			out.a=na *pa;
			out.b=out.c=0;
			out.d=nd *pd;
			out.tx=ntx *pa+parent.tx;
			out.ty=nty *pd+parent.ty;
			if (nb!==0 || nc!==0 || pb!==0 || pc!==0){
				out.a+=nb *pc;
				out.d+=nc *pb;
				out.b+=na *pb+nb *pd;
				out.c+=nc *pa+nd *pc;
				out.tx+=nty *pc;
				out.ty+=ntx *pb;
			}
			return out;
		}

		Matrix.preMulXY=function(parent,x,y,out){
			var pa=parent.a,pb=parent.b,pc=parent.c,pd=parent.d;
			out.a=pa;
			out.b=pb;
			out.c=pc;
			out.d=pd;
			out.tx=x *pa+parent.tx+y *pc;
			out.ty=y *pd+parent.ty+x *pb;
			return out;
		}

		Matrix.create=function(){
			var cache=Matrix._cache;
			var mat=!cache._length ? (new Matrix()):cache[--cache._length];
			mat.inPool=false;
			return mat;
		}

		Matrix.EMPTY=new Matrix();
		Matrix.TEMP=new Matrix();
		Matrix._cache=[];
		return Matrix;
	})()


	//class laya.maths.Point
	var Point=(function(){
		function Point(x,y){
			//this.x=NaN;
			//this.y=NaN;
			(x===void 0)&& (x=0);
			(y===void 0)&& (y=0);
			this.x=x;
			this.y=y;
		}

		__class(Point,'laya.maths.Point');
		var __proto=Point.prototype;
		/**
		*将 <code>Point</code> 的成员设置为指定值。
		*@param x 水平坐标。
		*@param y 垂直坐标。
		*@return 当前 Point 对象。
		*/
		__proto.setTo=function(x,y){
			this.x=x;
			this.y=y;
			return this;
		}

		/**
		*计算当前点和目标点(x，y)的距离。
		*@param x 水平坐标。
		*@param y 垂直坐标。
		*@return 返回当前点和目标点之间的距离。
		*/
		__proto.distance=function(x,y){
			return Math.sqrt((this.x-x)*(this.x-x)+(this.y-y)*(this.y-y));
		}

		/**返回包含 x 和 y 坐标的值的字符串。*/
		__proto.toString=function(){
			return this.x+","+this.y;
		}

		/**
		*标准化向量。
		*/
		__proto.normalize=function(){
			var d=Math.sqrt(this.x *this.x+this.y *this.y);
			if (d > 0){
				var id=1.0 / d;
				this.x *=id;
				this.y *=id;
			}
		}

		Point.TEMP=new Point();
		Point.EMPTY=new Point();
		return Point;
	})()


	//class laya.maths.Rectangle
	var Rectangle=(function(){
		function Rectangle(x,y,width,height){
			//this.x=NaN;
			//this.y=NaN;
			//this.width=NaN;
			//this.height=NaN;
			(x===void 0)&& (x=0);
			(y===void 0)&& (y=0);
			(width===void 0)&& (width=0);
			(height===void 0)&& (height=0);
			this.x=x;
			this.y=y;
			this.width=width;
			this.height=height;
		}

		__class(Rectangle,'laya.maths.Rectangle');
		var __proto=Rectangle.prototype;
		/**
		*将 Rectangle 的属性设置为指定值。
		*@param x x 矩形左上角的 X 轴坐标。
		*@param y x 矩形左上角的 Y 轴坐标。
		*@param width 矩形的宽度。
		*@param height 矩形的高。
		*@return 返回属性值修改后的矩形对象本身。
		*/
		__proto.setTo=function(x,y,width,height){
			this.x=x;
			this.y=y;
			this.width=width;
			this.height=height;
			return this;
		}

		/**
		*复制 source 对象的属性值到此矩形对象中。
		*@param sourceRect 源 Rectangle 对象。
		*@return 返回属性值修改后的矩形对象本身。
		*/
		__proto.copyFrom=function(source){
			this.x=source.x;
			this.y=source.y;
			this.width=source.width;
			this.height=source.height;
			return this;
		}

		/**
		*确定由此 Rectangle 对象定义的矩形区域内是否包含指定的点。
		*@param x 点的 X 轴坐标值（水平位置）。
		*@param y 点的 Y 轴坐标值（垂直位置）。
		*@return 如果 Rectangle 对象包含指定的点，则值为 true；否则为 false。
		*/
		__proto.contains=function(x,y){
			if (this.width <=0 || this.height <=0)return false;
			if (x >=this.x && x < this.right){
				if (y >=this.y && y < this.bottom){
					return true;
				}
			}
			return false;
		}

		/**
		*确定在 rect 参数中指定的对象是否与此 Rectangle 对象相交。此方法检查指定的 Rectangle 对象的 x、y、width 和 height 属性，以查看它是否与此 Rectangle 对象相交。
		*@param rect Rectangle 对象。
		*@return 如果传入的矩形对象与此对象相交，则返回 true 值，否则返回 false。
		*/
		__proto.intersects=function(rect){
			return !(rect.x > (this.x+this.width)|| (rect.x+rect.width)< this.x || rect.y > (this.y+this.height)|| (rect.y+rect.height)< this.y);
		}

		/**
		*如果在 rect 参数中指定的 Rectangle 对象与此 Rectangle 对象相交，则返回交集区域作为 Rectangle 对象。如果矩形不相交，则此方法返回null。
		*@param rect 待比较的矩形区域。
		*@param out （可选）待输出的矩形区域。如果为空则创建一个新的。建议：尽量复用对象，减少对象创建消耗。
		*@return 返回相交的矩形区域对象。
		*/
		__proto.intersection=function(rect,out){
			if (!this.intersects(rect))return null;
			out || (out=new Rectangle());
			out.x=Math.max(this.x,rect.x);
			out.y=Math.max(this.y,rect.y);
			out.width=Math.min(this.right,rect.right)-out.x;
			out.height=Math.min(this.bottom,rect.bottom)-out.y;
			return out;
		}

		/**
		*<p>矩形联合，通过填充两个矩形之间的水平和垂直空间，将这两个矩形组合在一起以创建一个新的 Rectangle 对象。</p>
		*<p>注意：union()方法忽略高度或宽度值为 0 的矩形，如：var rect2:Rectangle=new Rectangle(300,300,50,0);</p>
		*@param 要添加到此 Rectangle 对象的 Rectangle 对象。
		*@param out 用于存储输出结果的矩形对象。如果为空，则创建一个新的。建议：尽量复用对象，减少对象创建消耗。Rectangle.TEMP对象用于对象复用。
		*@return 充当两个矩形的联合的新 Rectangle 对象。
		*/
		__proto.union=function(source,out){
			out || (out=new Rectangle());
			this.clone(out);
			if (source.width <=0 || source.height <=0)return out;
			out.addPoint(source.x,source.y);
			out.addPoint(source.right,source.bottom);
			return this;
		}

		/**
		*返回一个 Rectangle 对象，其 x、y、width 和 height 属性的值与当前 Rectangle 对象的对应值相同。
		*@param out （可选）用于存储结果的矩形对象。如果为空，则创建一个新的。建议：尽量复用对象，减少对象创建消耗。。Rectangle.TEMP对象用于对象复用。
		*@return Rectangle 对象，其 x、y、width 和 height 属性的值与当前 Rectangle 对象的对应值相同。
		*/
		__proto.clone=function(out){
			out || (out=new Rectangle());
			out.x=this.x;
			out.y=this.y;
			out.width=this.width;
			out.height=this.height;
			return out;
		}

		/**
		*当前 Rectangle 对象的水平位置 x 和垂直位置 y 以及高度 width 和宽度 height 以逗号连接成的字符串。
		*/
		__proto.toString=function(){
			return this.x+","+this.y+","+this.width+","+this.height;
		}

		/**
		*检测传入的 Rectangle 对象的属性是否与当前 Rectangle 对象的属性 x、y、width、height 属性值都相等。
		*@param rect 待比较的 Rectangle 对象。
		*@return 如果判断的属性都相等，则返回 true ,否则返回 false。
		*/
		__proto.equals=function(rect){
			if (!rect || rect.x!==this.x || rect.y!==this.y || rect.width!==this.width || rect.height!==this.height)return false;
			return true;
		}

		/**
		*<p>为当前矩形对象加一个点，以使当前矩形扩展为包含当前矩形和此点的最小矩形。</p>
		*<p>此方法会修改本对象。</p>
		*@param x 点的 X 坐标。
		*@param y 点的 Y 坐标。
		*@return 返回此 Rectangle 对象。
		*/
		__proto.addPoint=function(x,y){
			this.x > x && (this.width+=this.x-x,this.x=x);
			this.y > y && (this.height+=this.y-y,this.y=y);
			if (this.width < x-this.x)this.width=x-this.x;
			if (this.height < y-this.y)this.height=y-this.y;
			return this;
		}

		/**
		*@private
		*返回代表当前矩形的顶点数据。
		*@return 顶点数据。
		*/
		__proto._getBoundPoints=function(){
			var rst=Rectangle._temB;
			rst.length=0;
			if (this.width==0 || this.height==0)return rst;
			rst.push(this.x,this.y,this.x+this.width,this.y,this.x,this.y+this.height,this.x+this.width,this.y+this.height);
			return rst;
		}

		/**
		*确定此 Rectangle 对象是否为空。
		*@return 如果 Rectangle 对象的宽度或高度小于等于 0，则返回 true 值，否则返回 false。
		*/
		__proto.isEmpty=function(){
			if (this.width <=0 || this.height <=0)return true;
			return false;
		}

		/**此矩形右侧的 X 轴坐标。 x 和 width 属性的和。*/
		__getset(0,__proto,'right',function(){
			return this.x+this.width;
		});

		/**此矩形底端的 Y 轴坐标。y 和 height 属性的和。*/
		__getset(0,__proto,'bottom',function(){
			return this.y+this.height;
		});

		Rectangle._getBoundPointS=function(x,y,width,height){
			var rst=Rectangle._temA;
			rst.length=0;
			if (width==0 || height==0)return rst;
			rst.push(x,y,x+width,y,x,y+height,x+width,y+height);
			return rst;
		}

		Rectangle._getWrapRec=function(pointList,rst){
			if (!pointList || pointList.length < 1)return rst ? rst.setTo(0,0,0,0):Rectangle.TEMP.setTo(0,0,0,0);
			rst=rst ? rst :new Rectangle();
			var i,len=pointList.length,minX,maxX,minY,maxY,tPoint=Point.TEMP;
			minX=minY=99999;
			maxX=maxY=-minX;
			for (i=0;i < len;i+=2){
				tPoint.x=pointList[i];
				tPoint.y=pointList[i+1];
				minX=minX < tPoint.x ? minX :tPoint.x;
				minY=minY < tPoint.y ? minY :tPoint.y;
				maxX=maxX > tPoint.x ? maxX :tPoint.x;
				maxY=maxY > tPoint.y ? maxY :tPoint.y;
			}
			return rst.setTo(minX,minY,maxX-minX,maxY-minY);
		}

		Rectangle.EMPTY=new Rectangle();
		Rectangle.TEMP=new Rectangle();
		Rectangle._temB=[];
		Rectangle._temA=[];
		return Rectangle;
	})()


	//class laya.utils.Byte
	var Byte=(function(){
		function Byte(data){
			this._xd_=true;
			this._allocated_=8;
			//this._d_=null;
			//this._u8d_=null;
			this._pos_=0;
			this._length=0;
			if (data){
				this._u8d_=new Uint8Array(data);
				this._d_=new DataView(this._u8d_.buffer);
				this._length=this._d_.byteLength;
				}else {
				this.___resizeBuffer(this._allocated_);
			}
		}

		__class(Byte,'laya.utils.Byte');
		var __proto=Byte.prototype;
		/**@private */
		__proto.___resizeBuffer=function(len){
			try {
				var newByteView=new Uint8Array(len);
				if (this._u8d_ !=null){
					if (this._u8d_.length <=len)newByteView.set(this._u8d_);
					else newByteView.set(this._u8d_.subarray(0,len));
				}
				this._u8d_=newByteView;
				this._d_=new DataView(newByteView.buffer);
				}catch (err){
				throw "___resizeBuffer err:"+len;
			}
		}

		/**
		*<p>常用于解析固定格式的字节流。</p>
		*<p>先从字节流的当前字节偏移位置处读取一个 <code>Uint16</code> 值，然后以此值为长度，读取此长度的字符串。</p>
		*@return 读取的字符串。
		*/
		__proto.getString=function(){
			return this.rUTF(this.getUint16());
		}

		/**
		*从字节流中 <code>start</code> 参数指定的位置开始，读取 <code>len</code> 参数指定的字节数的数据，用于创建一个 <code>Float32Array</code> 对象并返回此对象。
		*@param start 开始位置。
		*@param len 需要读取的字节长度。如果要读取的长度超过可读取范围，则只返回可读范围内的值。
		*@return 读取的 Float32Array 对象。
		*/
		__proto.getFloat32Array=function(start,len){
			var end=start+len;
			end=(end > this._length)? this._length :end;
			var v=new Float32Array(this._d_.buffer.slice(start,end));
			this._pos_=end;
			return v;
		}

		/**
		*从字节流中 <code>start</code> 参数指定的位置开始，读取 <code>len</code> 参数指定的字节数的数据，用于创建一个 <code>Uint8Array</code> 对象并返回此对象。
		*@param start 开始位置。
		*@param len 需要读取的字节长度。如果要读取的长度超过可读取范围，则只返回可读范围内的值。
		*@return 读取的 Uint8Array 对象。
		*/
		__proto.getUint8Array=function(start,len){
			var end=start+len;
			end=(end > this._length)? this._length :end;
			var v=new Uint8Array(this._d_.buffer.slice(start,end));
			this._pos_=end;
			return v;
		}

		/**
		*从字节流中 <code>start</code> 参数指定的位置开始，读取 <code>len</code> 参数指定的字节数的数据，用于创建一个 <code>Int16Array</code> 对象并返回此对象。
		*@param start 开始读取的字节偏移量位置。
		*@param len 需要读取的字节长度。如果要读取的长度超过可读取范围，则只返回可读范围内的值。
		*@return 读取的 Uint8Array 对象。
		*/
		__proto.getInt16Array=function(start,len){
			var end=start+len;
			end=(end > this._length)? this._length :end;
			var v=new Int16Array(this._d_.buffer.slice(start,end));
			this._pos_=end;
			return v;
		}

		/**
		*从字节流的当前字节偏移位置处读取一个 IEEE 754 单精度（32 位）浮点数。
		*@return 单精度（32 位）浮点数。
		*/
		__proto.getFloat32=function(){
			if (this._pos_+4 > this._length)throw "getFloat32 error - Out of bounds";
			var v=this._d_.getFloat32(this._pos_,this._xd_);
			this._pos_+=4;
			return v;
		}

		/**
		*从字节流的当前字节偏移量位置处读取一个 IEEE 754 双精度（64 位）浮点数。
		*@return 双精度（64 位）浮点数。
		*/
		__proto.getFloat64=function(){
			if (this._pos_+8 > this._length)throw "getFloat64 error - Out of bounds";
			var v=this._d_.getFloat64(this._pos_,this._xd_);
			this._pos_+=8;
			return v;
		}

		/**
		*在字节流的当前字节偏移量位置处写入一个 IEEE 754 单精度（32 位）浮点数。
		*@param value 单精度（32 位）浮点数。
		*/
		__proto.writeFloat32=function(value){
			this.ensureWrite(this._pos_+4);
			this._d_.setFloat32(this._pos_,value,this._xd_);
			this._pos_+=4;
		}

		/**
		*在字节流的当前字节偏移量位置处写入一个 IEEE 754 双精度（64 位）浮点数。
		*@param value 双精度（64 位）浮点数。
		*/
		__proto.writeFloat64=function(value){
			this.ensureWrite(this._pos_+8);
			this._d_.setFloat64(this._pos_,value,this._xd_);
			this._pos_+=8;
		}

		/**
		*从字节流的当前字节偏移量位置处读取一个 Int32 值。
		*@return Int32 值。
		*/
		__proto.getInt32=function(){
			if (this._pos_+4 > this._length)throw "getInt32 error - Out of bounds";
			var float=this._d_.getInt32(this._pos_,this._xd_);
			this._pos_+=4;
			return float;
		}

		/**
		*从字节流的当前字节偏移量位置处读取一个 Uint32 值。
		*@return Uint32 值。
		*/
		__proto.getUint32=function(){
			if (this._pos_+4 > this._length)throw "getUint32 error - Out of bounds";
			var v=this._d_.getUint32(this._pos_,this._xd_);
			this._pos_+=4;
			return v;
		}

		/**
		*在字节流的当前字节偏移量位置处写入指定的 Int32 值。
		*@param value 需要写入的 Int32 值。
		*/
		__proto.writeInt32=function(value){
			this.ensureWrite(this._pos_+4);
			this._d_.setInt32(this._pos_,value,this._xd_);
			this._pos_+=4;
		}

		/**
		*在字节流的当前字节偏移量位置处写入 Uint32 值。
		*@param value 需要写入的 Uint32 值。
		*/
		__proto.writeUint32=function(value){
			this.ensureWrite(this._pos_+4);
			this._d_.setUint32(this._pos_,value,this._xd_);
			this._pos_+=4;
		}

		/**
		*从字节流的当前字节偏移量位置处读取一个 Int16 值。
		*@return Int16 值。
		*/
		__proto.getInt16=function(){
			if (this._pos_+2 > this._length)throw "getInt16 error - Out of bounds";
			var us=this._d_.getInt16(this._pos_,this._xd_);
			this._pos_+=2;
			return us;
		}

		/**
		*从字节流的当前字节偏移量位置处读取一个 Uint16 值。
		*@return Uint16 值。
		*/
		__proto.getUint16=function(){
			if (this._pos_+2 > this._length)throw "getUint16 error - Out of bounds";
			var us=this._d_.getUint16(this._pos_,this._xd_);
			this._pos_+=2;
			return us;
		}

		/**
		*在字节流的当前字节偏移量位置处写入指定的 Uint16 值。
		*@param value 需要写入的Uint16 值。
		*/
		__proto.writeUint16=function(value){
			this.ensureWrite(this._pos_+2);
			this._d_.setUint16(this._pos_,value,this._xd_);
			this._pos_+=2;
		}

		/**
		*在字节流的当前字节偏移量位置处写入指定的 Int16 值。
		*@param value 需要写入的 Int16 值。
		*/
		__proto.writeInt16=function(value){
			this.ensureWrite(this._pos_+2);
			this._d_.setInt16(this._pos_,value,this._xd_);
			this._pos_+=2;
		}

		/**
		*从字节流的当前字节偏移量位置处读取一个 Uint8 值。
		*@return Uint8 值。
		*/
		__proto.getUint8=function(){
			if (this._pos_+1 > this._length)throw "getUint8 error - Out of bounds";
			return this._d_.getUint8(this._pos_++);
		}

		/**
		*在字节流的当前字节偏移量位置处写入指定的 Uint8 值。
		*@param value 需要写入的 Uint8 值。
		*/
		__proto.writeUint8=function(value){
			this.ensureWrite(this._pos_+1);
			this._d_.setUint8(this._pos_,value);
			this._pos_++;
		}

		/**
		*@private
		*从字节流的指定字节偏移量位置处读取一个 Uint8 值。
		*@param pos 字节读取位置。
		*@return Uint8 值。
		*/
		__proto._getUInt8=function(pos){
			return this._d_.getUint8(pos);
		}

		/**
		*@private
		*从字节流的指定字节偏移量位置处读取一个 Uint16 值。
		*@param pos 字节读取位置。
		*@return Uint16 值。
		*/
		__proto._getUint16=function(pos){
			return this._d_.getUint16(pos,this._xd_);
		}

		/**
		*@private
		*使用 getFloat32()读取6个值，用于创建并返回一个 Matrix 对象。
		*@return Matrix 对象。
		*/
		__proto._getMatrix=function(){
			var rst=new Matrix(this.getFloat32(),this.getFloat32(),this.getFloat32(),this.getFloat32(),this.getFloat32(),this.getFloat32());
			return rst;
		}

		/**
		*@private
		*读取指定长度的 UTF 型字符串。
		*@param len 需要读取的长度。
		*@return 读取的字符串。
		*/
		__proto.rUTF=function(len){
			var v="",max=this._pos_+len,c=0,c2=0,c3=0,f=String.fromCharCode;
			var u=this._u8d_,i=0;
			while (this._pos_ < max){
				c=u[this._pos_++];
				if (c < 0x80){
					if (c !=0){
						v+=f(c);
					}
					}else if (c < 0xE0){
					v+=f(((c & 0x3F)<< 6)| (u[this._pos_++] & 0x7F));
					}else if (c < 0xF0){
					c2=u[this._pos_++];
					v+=f(((c & 0x1F)<< 12)| ((c2 & 0x7F)<< 6)| (u[this._pos_++] & 0x7F));
					}else {
					c2=u[this._pos_++];
					c3=u[this._pos_++];
					v+=f(((c & 0x0F)<< 18)| ((c2 & 0x7F)<< 12)| ((c3 << 6)& 0x7F)| (u[this._pos_++] & 0x7F));
				}
				i++;
			}
			return v;
		}

		/**
		*@private
		*读取 <code>len</code> 参数指定的长度的字符串。
		*@param len 要读取的字符串的长度。
		*@return 指定长度的字符串。
		*/
		__proto.getCustomString=function(len){
			var v="",ulen=0,c=0,c2=0,f=String.fromCharCode;
			var u=this._u8d_,i=0;
			while (len > 0){
				c=u[this._pos_];
				if (c < 0x80){
					v+=f(c);
					this._pos_++;
					len--;
					}else {
					ulen=c-0x80;
					this._pos_++;
					len-=ulen;
					while (ulen > 0){
						c=u[this._pos_++];
						c2=u[this._pos_++];
						v+=f((c2 << 8)| c);
						ulen--;
					}
				}
			}
			return v;
		}

		/**
		*清除字节数组的内容，并将 length 和 pos 属性重置为 0。调用此方法将释放 Byte 实例占用的内存。
		*/
		__proto.clear=function(){
			this._pos_=0;
			this.length=0;
		}

		/**
		*@private
		*获取此对象的 ArrayBuffer 引用。
		*@return
		*/
		__proto.__getBuffer=function(){
			return this._d_.buffer;
		}

		/**
		*<p>将 UTF-8 字符串写入字节流。类似于 writeUTF()方法，但 writeUTFBytes()不使用 16 位长度的字为字符串添加前缀。</p>
		*<p>对应的读取方法为： getUTFBytes 。</p>
		*@param value 要写入的字符串。
		*/
		__proto.writeUTFBytes=function(value){
			value=value+"";
			for (var i=0,sz=value.length;i < sz;i++){
				var c=value.charCodeAt(i);
				if (c <=0x7F){
					this.writeByte(c);
					}else if (c <=0x7FF){
					this.ensureWrite(this._pos_+2);
					this._u8d_.set([0xC0 | (c >> 6),0x80 | (c & 0x3F)],this._pos_);
					this._pos_+=2;
					}else if (c <=0xFFFF){
					this.ensureWrite(this._pos_+3);
					this._u8d_.set([0xE0 | (c >> 12),0x80 | ((c >> 6)& 0x3F),0x80 | (c & 0x3F)],this._pos_);
					this._pos_+=3;
					}else {
					this.ensureWrite(this._pos_+4);
					this._u8d_.set([0xF0 | (c >> 18),0x80 | ((c >> 12)& 0x3F),0x80 | ((c >> 6)& 0x3F),0x80 | (c & 0x3F)],this._pos_);
					this._pos_+=4;
				}
			}
		}

		/**
		*<p>将 UTF-8 字符串写入字节流。先写入以字节表示的 UTF-8 字符串长度（作为 16 位整数），然后写入表示字符串字符的字节。</p>
		*<p>对应的读取方法为： getUTFString 。</p>
		*@param value 要写入的字符串值。
		*/
		__proto.writeUTFString=function(value){
			var tPos=this.pos;
			this.writeUint16(1);
			this.writeUTFBytes(value);
			var dPos=this.pos-tPos-2;
			if (dPos >=65536){
				throw "writeUTFString byte len more than 65536";
			}
			this._d_.setUint16(tPos,dPos,this._xd_);
		}

		/**
		*@private
		*读取 UTF-8 字符串。
		*@return 读取的字符串。
		*/
		__proto.readUTFString=function(){
			return this.readUTFBytes(this.getUint16());
		}

		/**
		*<p>从字节流中读取一个 UTF-8 字符串。假定字符串的前缀是一个无符号的短整型（以此字节表示要读取的长度）。</p>
		*<p>对应的写入方法为： writeUTFString 。</p>
		*@return 读取的字符串。
		*/
		__proto.getUTFString=function(){
			return this.readUTFString();
		}

		/**
		*@private
		*读字符串，必须是 writeUTFBytes 方法写入的字符串。
		*@param len 要读的buffer长度，默认将读取缓冲区全部数据。
		*@return 读取的字符串。
		*/
		__proto.readUTFBytes=function(len){
			(len===void 0)&& (len=-1);
			if (len==0)return "";
			var lastBytes=this.bytesAvailable;
			if (len > lastBytes)throw "readUTFBytes error - Out of bounds";
			len=len > 0 ? len :lastBytes;
			return this.rUTF(len);
		}

		/**
		*<p>从字节流中读取一个由 length 参数指定的长度的 UTF-8 字节序列，并返回一个字符串。</p>
		*<p>一般读取的是由 writeUTFBytes 方法写入的字符串。</p>
		*@param len 要读的buffer长度，默认将读取缓冲区全部数据。
		*@return 读取的字符串。
		*/
		__proto.getUTFBytes=function(len){
			(len===void 0)&& (len=-1);
			return this.readUTFBytes(len);
		}

		/**
		*<p>在字节流中写入一个字节。</p>
		*<p>使用参数的低 8 位。忽略高 24 位。</p>
		*@param value
		*/
		__proto.writeByte=function(value){
			this.ensureWrite(this._pos_+1);
			this._d_.setInt8(this._pos_,value);
			this._pos_+=1;
		}

		/**
		*@private
		*从字节流中读取带符号的字节。
		*/
		__proto.readByte=function(){
			if (this._pos_+1 > this._length)throw "readByte error - Out of bounds";
			return this._d_.getInt8(this._pos_++);
		}

		/**
		*<p>从字节流中读取带符号的字节。</p>
		*<p>返回值的范围是从-128 到 127。</p>
		*@return 介于-128 和 127 之间的整数。
		*/
		__proto.getByte=function(){
			return this.readByte();
		}

		/**
		*<p>保证该字节流的可用长度不小于 <code>lengthToEnsure</code> 参数指定的值。</p>
		*@param lengthToEnsure 指定的长度。
		*/
		__proto.ensureWrite=function(lengthToEnsure){
			if (this._length < lengthToEnsure)this._length=lengthToEnsure;
			if (this._allocated_ < lengthToEnsure)this.length=lengthToEnsure;
		}

		/**
		*<p>将指定 arraybuffer 对象中的以 offset 为起始偏移量， length 为长度的字节序列写入字节流。</p>
		*<p>如果省略 length 参数，则使用默认长度 0，该方法将从 offset 开始写入整个缓冲区；如果还省略了 offset 参数，则写入整个缓冲区。</p>
		*<p>如果 offset 或 length 小于0，本函数将抛出异常。</p>
		*$NEXTBIG 由于没有判断length和arraybuffer的合法性，当开发者填写了错误的length值时，会导致写入多余的空白数据甚至内存溢出，为了避免影响开发者正在使用此方法的功能，下个重大版本会修复这些问题。
		*@param arraybuffer 需要写入的 Arraybuffer 对象。
		*@param offset Arraybuffer 对象的索引的偏移量（以字节为单位）
		*@param length 从 Arraybuffer 对象写入到 Byte 对象的长度（以字节为单位）
		*/
		__proto.writeArrayBuffer=function(arraybuffer,offset,length){
			(offset===void 0)&& (offset=0);
			(length===void 0)&& (length=0);
			if (offset < 0 || length < 0)throw "writeArrayBuffer error - Out of bounds";
			if (length==0)length=arraybuffer.byteLength-offset;
			this.ensureWrite(this._pos_+length);
			var uint8array=new Uint8Array(arraybuffer);
			this._u8d_.set(uint8array.subarray(offset,offset+length),this._pos_);
			this._pos_+=length;
		}

		/**
		*获取此对象的 ArrayBuffer 数据，数据只包含有效数据部分。
		*/
		__getset(0,__proto,'buffer',function(){
			var rstBuffer=this._d_.buffer;
			if (rstBuffer.byteLength==this.length)return rstBuffer;
			return rstBuffer.slice(0,this.length);
		});

		/**
		*<p> <code>Byte</code> 实例的字节序。取值为：<code>BIG_ENDIAN</code> 或 <code>BIG_ENDIAN</code> 。</p>
		*<p>主机字节序，是 CPU 存放数据的两种不同顺序，包括小端字节序和大端字节序。通过 <code>getSystemEndian</code> 可以获取当前系统的字节序。</p>
		*<p> <code>BIG_ENDIAN</code> ：大端字节序，地址低位存储值的高位，地址高位存储值的低位。有时也称之为网络字节序。<br/>
		*<code>LITTLE_ENDIAN</code> ：小端字节序，地址低位存储值的低位，地址高位存储值的高位。</p>
		*/
		__getset(0,__proto,'endian',function(){
			return this._xd_ ? "littleEndian" :"bigEndian";
			},function(endianStr){
			this._xd_=(endianStr=="littleEndian");
		});

		/**
		*<p> <code>Byte</code> 对象的长度（以字节为单位）。</p>
		*<p>如果将长度设置为大于当前长度的值，则用零填充字节数组的右侧；如果将长度设置为小于当前长度的值，将会截断该字节数组。</p>
		*<p>如果要设置的长度大于当前已分配的内存空间的字节长度，则重新分配内存空间，大小为以下两者较大者：要设置的长度、当前已分配的长度的2倍，并将原有数据拷贝到新的内存空间中；如果要设置的长度小于当前已分配的内存空间的字节长度，也会重新分配内存空间，大小为要设置的长度，并将原有数据从头截断为要设置的长度存入新的内存空间中。</p>
		*/
		__getset(0,__proto,'length',function(){
			return this._length;
			},function(value){
			if (this._allocated_ < value)
				this.___resizeBuffer(this._allocated_=Math.floor(Math.max(value,this._allocated_ *2)));
			else if (this._allocated_ > value)
			this.___resizeBuffer(this._allocated_=value);
			this._length=value;
		});

		/**
		*移动或返回 Byte 对象的读写指针的当前位置（以字节为单位）。下一次调用读取方法时将在此位置开始读取，或者下一次调用写入方法时将在此位置开始写入。
		*/
		__getset(0,__proto,'pos',function(){
			return this._pos_;
			},function(value){
			this._pos_=value;
		});

		/**
		*可从字节流的当前位置到末尾读取的数据的字节数。
		*/
		__getset(0,__proto,'bytesAvailable',function(){
			return this._length-this._pos_;
		});

		Byte.getSystemEndian=function(){
			if (!Byte._sysEndian){
				var buffer=new ArrayBuffer(2);
				new DataView(buffer).setInt16(0,256,true);
				Byte._sysEndian=(new Int16Array(buffer))[0]===256 ? "littleEndian" :"bigEndian";
			}
			return Byte._sysEndian;
		}

		Byte.BIG_ENDIAN="bigEndian";
		Byte.LITTLE_ENDIAN="littleEndian";
		Byte._sysEndian=null;
		return Byte;
	})()


	//class laya.utils.Handler
	var Handler=(function(){
		function Handler(caller,method,args,once){
			//this.caller=null;
			//this.method=null;
			//this.args=null;
			this.once=false;
			this._id=0;
			(once===void 0)&& (once=false);
			this.setTo(caller,method,args,once);
		}

		__class(Handler,'laya.utils.Handler');
		var __proto=Handler.prototype;
		/**
		*设置此对象的指定属性值。
		*@param caller 执行域(this)。
		*@param method 回调方法。
		*@param args 携带的参数。
		*@param once 是否只执行一次，如果为true，执行后执行recover()进行回收。
		*@return 返回 handler 本身。
		*/
		__proto.setTo=function(caller,method,args,once){
			this._id=Handler._gid++;
			this.caller=caller;
			this.method=method;
			this.args=args;
			this.once=once;
			return this;
		}

		/**
		*执行处理器。
		*/
		__proto.run=function(){
			if (this.method==null)return null;
			var id=this._id;
			var result=this.method.apply(this.caller,this.args);
			this._id===id && this.once && this.recover();
			return result;
		}

		/**
		*执行处理器，携带额外数据。
		*@param data 附加的回调数据，可以是单数据或者Array(作为多参)。
		*/
		__proto.runWith=function(data){
			if (this.method==null)return null;
			var id=this._id;
			if (data==null)
				var result=this.method.apply(this.caller,this.args);
			else if (!this.args && !data.unshift)result=this.method.call(this.caller,data);
			else if (this.args)result=this.method.apply(this.caller,this.args.concat(data));
			else result=this.method.apply(this.caller,data);
			this._id===id && this.once && this.recover();
			return result;
		}

		/**
		*清理对象引用。
		*/
		__proto.clear=function(){
			this.caller=null;
			this.method=null;
			this.args=null;
			return this;
		}

		/**
		*清理并回收到 Handler 对象池内。
		*/
		__proto.recover=function(){
			if (this._id > 0){
				this._id=0;
				Handler._pool.push(this.clear());
			}
		}

		Handler.create=function(caller,method,args,once){
			(once===void 0)&& (once=true);
			if (Handler._pool.length)return Handler._pool.pop().setTo(caller,method,args,once);
			return new Handler(caller,method,args,once);
		}

		Handler._pool=[];
		Handler._gid=1;
		return Handler;
	})()


	//class laya.utils.Pool
	var Pool=(function(){
		function Pool(){};
		__class(Pool,'laya.utils.Pool');
		Pool.getPoolBySign=function(sign){
			return Pool._poolDic[sign] || (Pool._poolDic[sign]=[]);
		}

		Pool.clearBySign=function(sign){
			if (Pool._poolDic[sign])Pool._poolDic[sign].length=0;
		}

		Pool.recover=function(sign,item){
			if (item["__InPool"])return;
			item["__InPool"]=true;
			Pool.getPoolBySign(sign).push(item);
		}

		Pool.getItemByClass=function(sign,cls){
			var pool=Pool.getPoolBySign(sign);
			var rst=pool.length ? pool.pop():new cls();
			rst["__InPool"]=false;
			return rst;
		}

		Pool.getItemByCreateFun=function(sign,createFun){
			var pool=Pool.getPoolBySign(sign);
			var rst=pool.length ? pool.pop():createFun();
			rst["__InPool"]=false;
			return rst;
		}

		Pool.getItem=function(sign){
			var pool=Pool.getPoolBySign(sign);
			var rst=pool.length ? pool.pop():null;
			if (rst){
				rst["__InPool"]=false;
			}
			return rst;
		}

		Pool._poolDic={};
		Pool.InPoolSign="__InPool";
		return Pool;
	})()


	//class laya.utils.Utils
	var Utils=(function(){
		function Utils(){};
		__class(Utils,'laya.utils.Utils');
		Utils.toRadian=function(angle){
			return angle *Utils._pi2;
		}

		Utils.toAngle=function(radian){
			return radian *Utils._pi;
		}

		Utils.getGID=function(){
			return Utils._gid++;
		}

		Utils.concatArray=function(source,array){
			if (!array)return source;
			if (!source)return array;
			var i=0,len=array.length;
			for (i=0;i < len;i++){
				source.push(array[i]);
			}
			return source;
		}

		Utils.clearArray=function(array){
			if (!array)return array;
			array.length=0;
			return array;
		}

		Utils.copyArray=function(source,array){
			source || (source=[]);
			if (!array)return source;
			source.length=array.length;
			var i=0,len=array.length;
			for (i=0;i < len;i++){
				source[i]=array[i];
			}
			return source;
		}

		Utils.bind=function(fun,scope){
			var rst=fun;
			rst=fun.bind(scope);;
			return rst;
		}

		Utils._gid=1;
		Utils._pi=180 / Math.PI;
		Utils._pi2=Math.PI / 180;
		return Utils;
	})()


	//class game.net.MessageBase
	var MessageBase=(function(){
		function MessageBase(){};
		__class(MessageBase,'game.net.MessageBase');
		var __proto=MessageBase.prototype;
		Laya.imps(__proto,{"game.net.IMessage":true})
		/**
		*@private
		*/
		__proto.read=function(byte){
			var des=MessageUtils.getDesByObject(this);
			var i=0,len=0;
			len=des.length;
			var tArr;
			for (i=0;i < len;i++){
				tArr=des[i];
				this[tArr[0]]=this._readObj(byte,tArr[1],tArr[2]);
			}
			return true;
		}

		/**
		*@private
		*/
		__proto.write=function(byte){
			this.writeByDes(this,byte,MessageUtils.getDesByObject(this));
			return true;
		}

		/**
		*@private
		*/
		__proto.clear=function(){}
		/**
		*@private
		*/
		__proto._readObj=function(byte,type,des){
			var v;
			switch (type){
				case 0:
					v=byte.getUint8()!=0;
					break ;
				case 1:
					v=byte.readByte();
					break ;
				case 2:
					v=byte.getUint8();
					break ;
				case 3:
					v=byte.getInt16();
					break ;
				case 4:
					v=byte.getUint16();
					break ;
				case 5:
					v=byte.getInt32();
					break ;
				case 6:
					v=byte.getUint32();
					break ;
				case 7:
					v=byte.getFloat32();
					break ;
				case 8:
					v=byte.getFloat64();
					break ;
				case 9:
					v=byte.readUTFString();
					break ;
				case 11:
					v=this.readClass(byte,des);
					break ;
				case 10:
					v=this.readArray(byte,des);
					break ;
				}
			return v;
		}

		/**
		*@private
		*/
		__proto.readClass=function(byte,Clz){
			Clz=MessageUtils.getClassByID(MessageUtils.getClassID(Clz));
			var rst=new Clz();
			rst.read(byte);
			return rst;
		}

		/**
		*@private
		*/
		__proto.readArray=function(byte,des){
			var rst=[];
			var i=0,len=0;
			rst.length=len=byte.getInt32();
			for (i=0;i < len;i++){
				rst[i]=this._readObj(byte,des[0],des[1]);
			}
			return rst;
		}

		/**
		*@private
		*/
		__proto.writeByDes=function(data,byte,des){
			var i=0,len=0;
			len=des.length;
			var tArr;
			for (i=0;i < len;i++){
				tArr=des[i];
				var v=data[tArr[0]];
				this._writeObj(v,byte,tArr[1],tArr[2]);
			}
		}

		__proto._writeObj=function(v,byte,type,des){
			switch (type){
				case 0:
					byte.writeUint8(v ? 1 :0);
					break ;
				case 1:
					byte.writeByte(v);
					break ;
				case 2:
					byte.writeUint8(v);
					break ;
				case 3:
					byte.writeInt16(v);
					break ;
				case 4:
					byte.writeUint16(v);
					break ;
				case 5:
					byte.writeInt32(v);
					break ;
				case 6:
					byte.writeUint32(v);
					break ;
				case 7:
					byte.writeFloat32(v);
					break ;
				case 8:
					byte.writeFloat64(v);
					break ;
				case 9:
					byte.writeUTFString(v);
					break ;
				case 11:
					this.writeClass(v,byte,des);
					break ;
				case 10:
					this.writeArray(v,byte,des);
					break ;
				}
		}

		/**
		*@private
		*/
		__proto.writeClass=function(data,byte,clz){
			data.writeByDes(data,byte,clz["DES"]);
		}

		/**
		*@private
		*/
		__proto.writeArray=function(arr,byte,des){
			var i=0,len=arr.length;
			byte.writeInt32(len);
			for (i=0;i < len;i++){
				this._writeObj(arr[i],byte,des[0],des[1]);
			}
		}

		/**@private */
		__getset(0,__proto,'msgKey',function(){
			return MessageUtils.getObjectClass(this)["KEY"];
		});

		MessageBase.DES_SIGN="DES";
		MessageBase.BOOLEAN=0;
		MessageBase.INT8=1;
		MessageBase.UINT8=2;
		MessageBase.INT16=3;
		MessageBase.UINT16=4;
		MessageBase.INT32=5;
		MessageBase.UINT32=6;
		MessageBase.FLOAT32=7;
		MessageBase.FLOAT64=8;
		MessageBase.STRING=9;
		MessageBase.ARRAY=10;
		MessageBase.CLASS=11;
		return MessageBase;
	})()


	//class game.net.MessageUtils
	var MessageUtils=(function(){
		function MessageUtils(){};
		__class(MessageUtils,'game.net.MessageUtils');
		MessageUtils.regMessage=function(clz){
			if (!clz["__MID"]){
				clz["__MID"]=MessageUtils.msgID;
				MessageUtils._msgDic[MessageUtils.msgID]=clz;
				MessageUtils._desDic[MessageUtils.msgID]=clz["DES"];
				MessageUtils.msgID++;
			}
		}

		MessageUtils.regMessageList=function(msgList){
			var i=0,len=msgList.length;
			for (i=0;i < len;i++){
				game.net.MessageUtils.regMessage(msgList[i]);
			}
		}

		MessageUtils.setMessagesKey=function(msgList){
			var i=0,len=msgList.length;
			for (i=0;i < len;i++){
				MessageUtils.setMessageKey(msgList[i]);
			}
		}

		MessageUtils.setMessageKey=function(msg,key){
			if (!key)key=msg["name"];
			msg["KEY"]=key;
		}

		MessageUtils.replaceClass=function(newClz,oldClz){
			var id=0;
			id=MessageUtils.getClassID(oldClz);
			newClz["__MID"]=id;
			MessageUtils._msgDic[id]=newClz;
		}

		MessageUtils.getDesByObject=function(obj){
			return MessageUtils._desDic[MessageUtils.getObjectClassID(obj)];
		}

		MessageUtils.getClassByID=function(id){
			return MessageUtils._msgDic[id];
		}

		MessageUtils.getClassID=function(clz){
			return clz["__MID"];
		}

		MessageUtils.getClassKey=function(clz){
			return clz["KEY"];
		}

		MessageUtils.getObjectClassID=function(obj){
			return MessageUtils.getClassID(obj["__proto__"]["constructor"]);
		}

		MessageUtils.getObjectClass=function(obj){
			return obj["__proto__"]["constructor"];
		}

		MessageUtils.readMessageFromByte=function(byte){
			var clz=MessageUtils.getClassByID(byte.getInt32());
			var rst=new clz();
			rst.read(byte);
			return rst;
		}

		MessageUtils.writeMessageToByte=function(byte,message){
			byte.endian="littleEndian";
			byte.writeInt32(MessageUtils.getObjectClassID(message));
			message.write(byte);
		}

		MessageUtils._msgDic={};
		MessageUtils._desDic={};
		MessageUtils.msgID=1;
		MessageUtils.IDSign="__MID";
		MessageUtils.KEYSign="KEY";
		return MessageUtils;
	})()


	//class msgs.MessageInit
	var MessageInit=(function(){
		function MessageInit(){};
		__class(MessageInit,'msgs.MessageInit');
		MessageInit.init=function(){
			var regMsgs;
			regMsgs=[ClientDataMsg,EnterRoomMsg,ClientsCreateMsg,GameStartMsg,GameOverMsg,ItemDataMsg,GameCreateMsg,ClientAngleMsg,ClientLeaveMsg,
			EatItemMsg,ClientReviveMsg,ClientLostMsg];
			MessageUtils.regMessageList(regMsgs);
			MessageUtils.setMessagesKey(regMsgs);
		}

		return MessageInit;
	})()


	//class ServerPlayer extends ServerItem
	var ServerPlayer=(function(_super){
		function ServerPlayer(){
			this.eventServer=null;
			this.webSocket=null;
			this.roomId=0;
			this.isInRoom=false;
			this.clientId=0;
			this.isOriginator=false;
			this.nickname="";
			this.headId=0;
			ServerPlayer.__super.call(this);
			this.byte=new Byte();
		}

		__class(ServerPlayer,'ServerPlayer',_super);
		var __proto=ServerPlayer.prototype;
		/**
		*客户端初始化
		*@param socket 服务器分配的socket
		*@param eventSer 与服务器通信的消息发送器
		*/
		__proto.init=function(socket,eventSer){
			this.webSocket=socket;
			this.eventServer=eventSer;
			this.webSocket.on(ServerEvent.CLIENT_MESSAGE,Utils.bind(this.onMessage,this));
			this.webSocket.on(ServerEvent.CLIENT_CLOSE,Utils.bind(this.onClose,this));
		}

		/**
		*收到的信息解析与处理
		*@param buffer 服务器收到的消息
		*/
		__proto.onMessage=function(buffer){
			this.byte.clear();
			this.byte.writeArrayBuffer(buffer);
			this.byte.pos=0;
			var tMsg=MessageUtils.readMessageFromByte(this.byte);
			if (tMsg.msgKey)DataManager.I.add(tMsg.msgKey,tMsg);
		}

		/**
		*对应的客户端断开连接
		*/
		__proto.onClose=function(){
			this.eventServer.event(ServerEvent.CLIENT_CLOSE,[this]);
		}

		/**
		*客户端消息发送，二进制发送
		*@param msg 消息
		*/
		__proto.send=function(msg){
			this.byte.clear();
			MessageUtils.writeMessageToByte(this.byte,msg);
			this.webSocket.send(this.byte.buffer);
		}

		return ServerPlayer;
	})(ServerItem)


	//class SocketServer extends laya.events.EventDispatcher
	var SocketServer=(function(_super){
		function SocketServer(){
			this.server=null;
			SocketServer.__super.call(this);
			this.WebSocketServer=require('ws').Server;
			this.server=new this.WebSocketServer({port:8999 });
			console.log("启动服务器,端口号:"+8999);
			console.log("服务器IP地址为:"+this.IP);
			this.server.on("connection",Utils.bind(this.connectionHandler,this));
		}

		__class(SocketServer,'SocketServer',_super);
		var __proto=SocketServer.prototype;
		/**
		*有客户端连接成功
		*@param webSocket 连接时会分配一个客户端的webSocket镜像
		*/
		__proto.connectionHandler=function(webSocket){
			this.event("client_connect",webSocket);
		}

		/**
		*获取本机的ip地址
		*/
		__getset(0,__proto,'IP',function(){
			var os=require('os')
			var ifaces=os.networkInterfaces();
			var ip='';
			for (var dev in ifaces){
				var info=ifaces[dev];
				for(var i in info){
					if (ip==='' && info[i].family==='IPv4' && !info[i]["internal"]){
						ip=info[i].address;
						return ip;
					}
				}
			}
			return ip;
		});

		return SocketServer;
	})(EventDispatcher)


	//class game.manager.DataManager extends laya.events.EventDispatcher
	var DataManager=(function(_super){
		function DataManager(){
			this.timeout=40;
			this._msgs=[];
			this._isBlock=false;
			this._map={};
			DataManager.__super.call(this);
		}

		__class(DataManager,'game.manager.DataManager',_super);
		var __proto=DataManager.prototype;
		/**
		*增加一条数据，同时派发相应事件
		*@param key 索引
		*@param data 数据
		*@param save 是否存储
		*/
		__proto.add=function(key,data,save){
			(save===void 0)&& (save=true);
			this._msgs.push(key,data);
			if (save)this._map[key]=data;
			if (!this._isBlock)this._dispatch();
		}

		/**
		*增加一条数据
		*@param key 索引
		*@param data 数据
		*@param save 是否存储
		*/
		__proto.set=function(key,data,save){
			(save===void 0)&& (save=true);
			this._msgs.push(key,data);
			if (save)this._map[key]=data;
		}

		/**
		*直接派发数据更新事件，功能同event
		*@param type 事件类型
		*@param data 数据
		*/
		__proto.notify=function(type,data){
			this.event(type,data);
		}

		__proto._dispatch=function(){
			this._isBlock=true;
			while (this._msgs.length){
				var key=this._msgs.shift();
				var msg=this._msgs.shift();
				this.event(key,msg);
			}
			this._isBlock=false;
		}

		/**
		*移除数据缓存
		*@param key 索引
		*/
		__proto.remove=function(key){
			delete this._map[key];
		}

		/**
		*从缓存中获得数据
		*@param key 索引
		*/
		__proto.get=function(key){
			return this._map[key];
		}

		/**
		*缓存中是否有索引为key的数据
		*@param key 索引
		*/
		__proto.has=function(key){
			return this._map[key] !=null;
		}

		DataManager.listen=function(clz,caller,fun,params){
			DataManager.I.on(MessageUtils.getClassKey(clz),caller,fun,params);
		}

		DataManager.cancel=function(clz,caller,fun){
			DataManager.I.off(MessageUtils.getClassKey(clz),caller,fun);
		}

		DataManager.getData=function(clz){
			return DataManager.I.get(MessageUtils.getClassKey(clz));
		}

		__static(DataManager,
		['I',function(){return this.I=new DataManager();}
		]);
		return DataManager;
	})(EventDispatcher)


	//class msgs.ClientAngleMsg extends game.net.MessageBase
	var ClientAngleMsg=(function(_super){
		function ClientAngleMsg(){
			this.clientId=0;
			this.angle=0;
			ClientAngleMsg.__super.call(this);
		}

		__class(ClientAngleMsg,'msgs.ClientAngleMsg',_super);
		__static(ClientAngleMsg,
		['DES',function(){return this.DES=[
			["clientId",4],
			["angle",4]];}
		]);
		return ClientAngleMsg;
	})(MessageBase)


	//class msgs.ClientDataMsg extends game.net.MessageBase
	var ClientDataMsg=(function(_super){
		function ClientDataMsg(client){
			this.roomId=0;
			this.isInRoom=false;
			this.clientId=0;
			this.isOriginator=false;
			this.nickname="";
			this.headId=0;
			this.sourceId=0;
			this.x=0;
			this.y=0;
			this.speed=0;
			this.angle=0;
			ClientDataMsg.__super.call(this);
			if(client){
				this.roomId=client.roomId;
				this.isInRoom=client.isInRoom;
				this.clientId=client.clientId;
				this.isOriginator=client.isOriginator;
				this.nickname=client.nickname;
				this.headId=client.headId;
				this.sourceId=client.sourceId;
				this.x=client.x;
				this.y=client.y;
				this.speed=client.speed;
				this.angle=client.angle;
			}
		}

		__class(ClientDataMsg,'msgs.ClientDataMsg',_super);
		__static(ClientDataMsg,
		['DES',function(){return this.DES=[
			["roomId",4],
			["clientId",4],
			["isOriginator",0],
			["isInRoom",0],
			["nickname",9],
			["headId",2],
			["sourceId",2],
			["x",3],
			["y",3],
			["speed",3],
			["angle",3]];}
		]);
		return ClientDataMsg;
	})(MessageBase)


	//class msgs.ClientLeaveMsg extends game.net.MessageBase
	var ClientLeaveMsg=(function(_super){
		function ClientLeaveMsg(){
			this.id=0;
			ClientLeaveMsg.__super.call(this);
		}

		__class(ClientLeaveMsg,'msgs.ClientLeaveMsg',_super);
		__static(ClientLeaveMsg,
		['DES',function(){return this.DES=[
			["id",4]];}
		]);
		return ClientLeaveMsg;
	})(MessageBase)


	//class msgs.ClientLostMsg extends game.net.MessageBase
	var ClientLostMsg=(function(_super){
		function ClientLostMsg(){
			this.clientId=0;
			this.itemDataArray=[];
			ClientLostMsg.__super.call(this);
		}

		__class(ClientLostMsg,'msgs.ClientLostMsg',_super);
		__static(ClientLostMsg,
		['DES',function(){return this.DES=[
			["clientId",4],
			["itemDataArray",10,[11,ItemDataMsg]]];}
		]);
		return ClientLostMsg;
	})(MessageBase)


	//class msgs.ClientReviveMsg extends game.net.MessageBase
	var ClientReviveMsg=(function(_super){
		function ClientReviveMsg(){
			this.roleClientId=0;
			this.roleId=0;
			this.x=0;
			this.y=0;
			ClientReviveMsg.__super.call(this);
		}

		__class(ClientReviveMsg,'msgs.ClientReviveMsg',_super);
		__static(ClientReviveMsg,
		['DES',function(){return this.DES=[
			["roleClientId",4],
			["roleId",4],
			["x",4],
			["y",4]];}
		]);
		return ClientReviveMsg;
	})(MessageBase)


	//class msgs.ClientsCreateMsg extends game.net.MessageBase
	var ClientsCreateMsg=(function(_super){
		function ClientsCreateMsg(){
			this.clients=null;
			ClientsCreateMsg.__super.call(this);
		}

		__class(ClientsCreateMsg,'msgs.ClientsCreateMsg',_super);
		__static(ClientsCreateMsg,
		['DES',function(){return this.DES=[
			["clients",10,[11,ClientDataMsg]]];}
		]);
		return ClientsCreateMsg;
	})(MessageBase)


	//class msgs.EatItemMsg extends game.net.MessageBase
	var EatItemMsg=(function(_super){
		function EatItemMsg(){
			this.roleId=0;
			this.roleClientId=0;
			this.eatId=0;
			this.eatClientId=-1;
			this.eatWeight=0;
			EatItemMsg.__super.call(this);
		}

		__class(EatItemMsg,'msgs.EatItemMsg',_super);
		__static(EatItemMsg,
		['DES',function(){return this.DES=[
			["roleId",4],
			["roleClientId",3],
			["eatId",4],
			["eatClientId",3],
			["eatWeight",4]];}
		]);
		return EatItemMsg;
	})(MessageBase)


	//class msgs.EnterRoomMsg extends game.net.MessageBase
	var EnterRoomMsg=(function(_super){
		function EnterRoomMsg(){
			this.clientDataMsg=null;
			EnterRoomMsg.__super.call(this);
		}

		__class(EnterRoomMsg,'msgs.EnterRoomMsg',_super);
		__static(EnterRoomMsg,
		['DES',function(){return this.DES=[
			["clientDataMsg",11,ClientDataMsg]];}
		]);
		return EnterRoomMsg;
	})(MessageBase)


	//class msgs.GameCreateMsg extends game.net.MessageBase
	var GameCreateMsg=(function(_super){
		function GameCreateMsg(){
			this.roomId=0;
			this.gameTime=0;
			this.mapId=-1;
			this.itemDataArray=[];
			GameCreateMsg.__super.call(this);
		}

		__class(GameCreateMsg,'msgs.GameCreateMsg',_super);
		__static(GameCreateMsg,
		['DES',function(){return this.DES=[
			["roomId",2],
			["gameTime",6],
			["mapId",1],
			["itemDataArray",10,[11,ItemDataMsg]]];}
		]);
		return GameCreateMsg;
	})(MessageBase)


	//class msgs.GameOverMsg extends game.net.MessageBase
	var GameOverMsg=(function(_super){
		function GameOverMsg(){
			this.gameOver=true;
			GameOverMsg.__super.call(this);
		}

		__class(GameOverMsg,'msgs.GameOverMsg',_super);
		__static(GameOverMsg,
		['DES',function(){return this.DES=[
			["gameOver",0]];}
		]);
		return GameOverMsg;
	})(MessageBase)


	//class msgs.GameStartMsg extends game.net.MessageBase
	var GameStartMsg=(function(_super){
		function GameStartMsg(){
			this.roomId=0;
			GameStartMsg.__super.call(this);
		}

		__class(GameStartMsg,'msgs.GameStartMsg',_super);
		__static(GameStartMsg,
		['DES',function(){return this.DES=[
			["roomId",4]];}
		]);
		return GameStartMsg;
	})(MessageBase)


	//class msgs.ItemDataMsg extends game.net.MessageBase
	var ItemDataMsg=(function(_super){
		function ItemDataMsg(item){
			this.id=0;
			this.type=0;
			this.sourceId=0;
			this.weight=0;
			this.radius=0;
			this.speed=0;
			this.x=0;
			this.y=0;
			this.angle=0;
			ItemDataMsg.__super.call(this);
			if(item){
				this.id=item.id;
				this.type=item.type;
				this.sourceId=item.sourceId;
				this.weight=item.weight;
				this.radius=item.radius;
				this.speed=item.speed;
				this.x=item.x;
				this.y=item.y;
			}
		}

		__class(ItemDataMsg,'msgs.ItemDataMsg',_super);
		__static(ItemDataMsg,
		['DES',function(){return this.DES=[
			["id",4],
			["type",2],
			["sourceId",2],
			["weight",6],
			["radius",4],
			["speed",2],
			["x",4],
			["y",4],
			["angle",3],];}
		]);
		return ItemDataMsg;
	})(MessageBase)


	Laya.__init([EventDispatcher]);
	new BallGameServer();

})(window,document,Laya);
