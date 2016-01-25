package com.user{
	import com.me.NoEventBtn;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	public class User extends Sprite{
		private var _swfLoader:Loader;
		private var _windowsWidth:uint;
		private var _windowsHeight:uint;
		private var _myTween:Tween;
		private var _buttonNameList:Array=["航班信息浏览","航班信息查询","订票","机票详情/退票","用户信息/修改"];//按按键的名称列表
		private var _swfArr:Array=["browseAirplane.swf","findAirpalne.swf","bookTicket.swf","returnTicket.swf","changeUserInformation.swf"];//加载的其他模块名称。
		public function User()
		{
			if(stage!=null)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE,init);
			}
			
		}
		private function init(event:Event=null):void{
			_windowsWidth=stage.stageWidth;
			_windowsHeight=stage.stageHeight;
			initButtonList();
		}
		//初始化按键列表
		private function initButtonList():void{
			backBtn.y=_windowsHeight*0.9;
			backBtn.x=_windowsWidth/4;
			backBtn.alpha=0;
			buttonSprite.x=_windowsWidth/4;
			buttonSprite.y=0;
			var n:uint=_buttonNameList.length;
			var hisY:uint=60;
			for(var i:uint=0;i<n;i++)
			{
				var mBtn:NoEventBtn=new NoEventBtn(_buttonNameList[i]);
				mBtn.addEventListener(MouseEvent.CLICK,setSwfLoader);
				mBtn.name="mBtn"+i;
				mBtn.num=i;
				buttonSprite.addChild(mBtn);
				mBtn.y=hisY*i;
			}
			_myTween=new Tween(buttonSprite,"y",Strong.easeInOut,buttonSprite.y,_windowsHeight/3,1,true);
		}
		//设置加载
		private function setSwfLoader(event:MouseEvent):void{
			var num:uint=event.target.parent.num;
			_swfLoader=new Loader();
			_swfLoader.load(new URLRequest(_swfArr[num]));//对应响应的按键加载响应的swf文件，num即对应加载索引。
			_swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderSwf);
			
		}
		//加载对应模块
		private function loaderSwf(event:Event):void{
			removeEl(Sprite(getChildByName("buttonSprite")));
			backBtn.alpha=1;
			backBtn.buttonMode=true;
			backBtn.addEventListener(MouseEvent.CLICK,back);
			swfSprite.x=_windowsWidth;
			swfSprite.y=_windowsHeight/4;
			swfSprite.addChild(_swfLoader);
			_myTween=new Tween(swfSprite,"x",Strong.easeInOut,swfSprite.x,_windowsWidth/4,1,true);
		}
		//返回按键设置
		private function back(event:MouseEvent):void{
			backBtn.buttonMode=false;
			backBtn.alpha=0;
			backBtn.removeEventListener(MouseEvent.CLICK,back);
			Sprite(getChildByName("swfSprite")).removeChildAt(0);
			initButtonList();
			
		}
		private function removeEl(Spr:Sprite):void
		{//用于移除元件中的各个按键元件与事件的监听。
			var num:uint = Spr.numChildren;
			for (var i:uint=0; i<num; i++)
			{
				//Spr.getChildAt(0)=null;
				Spr.removeChildAt(0);
			}
		}
	}
}