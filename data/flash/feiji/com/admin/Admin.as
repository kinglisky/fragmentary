package com.admin
{
	import com.me.NoEventBtn;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import fl.transitions.easing.*;
	import fl.transitions.Tween;
	public class Admin extends Sprite
	{
		private var _windowsWidth:Number;
		private var _windowsHeight:Number ;
		private var _airplaneXml:XML;//加载航班的默认信息文件。
		private var _xmlLoader:URLLoader;//用于加载xml文件。
		private var _swfLoader:Loader=new Loader();//用于加载其他模块的swf文件。
		private var _swfArr:Array=["browseAirplane.swf","findAirpalne.swf","modificationAirplane.swf","findUser.swf","changeAdminInformation.swf"];
		private var _buttonList:Array = ["航班信息浏览","航班信息查询","航班信息修改","用户信息查询","管理员信息修改"];
		private var _arrLength:uint;
		private var _myTween:Tween;//缓动对象。
		private var _myTweenNew:Tween;//缓动对象。
		//private var _curId:uint=0;//表示数组的索引位置。
		public function Admin()
		{
			if(stage!=null)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		private function init(event:Event=null):void
		{
			_windowsWidth=stage.stageWidth;
			_windowsHeight=stage.stageHeight;
			moduleSprite.x=_windowsWidth;//初始化模块容器的位置。
			mBackButton.alpha=0;//初始返回按键的可见度为0;
			mBackButton.x=_windowsWidth/4;//初始化返回按键的位置。
			initBtnList();//初始化按键菜单。
		}
		//初始化按键列表
		private function initBtnList():void
		{
			ButtonList.y = 0;
			ButtonList.x=_windowsWidth/4;
			ButtonList.alpha = 0;//设置按键菜单的初始位置。
			var _hisY:uint = 60;//按键间的间隔。
			_arrLength = _buttonList.length;//按键名称数组的长度。
			for (var i:uint=0; i<_arrLength; i++)//遍历数组对应生成按键，并添加进舞台中的按键容器ButtonList。
			{
				var adminBtn:NoEventBtn = new NoEventBtn(_buttonList[i]);//初始化生成按键。
				adminBtn.addEventListener(MouseEvent.CLICK,loaderModule);//添加按键事件响应。
				adminBtn.name = "adminBtn" + i;
				adminBtn.num=i;//用于标示按键的索引，以便于在事件响应时，设定加载的swf文件。
				ButtonList.addChild(adminBtn);
				adminBtn.x = 0;
				adminBtn.y = _hisY * i;
			}
			_myTween = new Tween(ButtonList,"alpha",Strong.easeInOut,0,1,1,true);
			_myTween = new Tween(ButtonList,"y",Strong.easeInOut,ButtonList.y,_windowsHeight / 3,1,true);
		}
		//设置加载模块
		private function loaderModule(event:MouseEvent):void{
			mBackButton.addEventListener(MouseEvent.CLICK,backBtnList);//化返回键添加事件监听函数。
			mBackButton.alpha=1;
			mBackButton.buttonMode=true;
			mBackButton.x=_windowsWidth/4;
			mBackButton.y=_windowsHeight*0.9;
			_swfLoader.load(new URLRequest(_swfArr[event.target.parent.num]));//对应响应的按键加载响应的swf文件，num即对应加载索引。
			_swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderSwf);
		}
		//加载对应模块
		private function loaderSwf(event:Event):void{
			moduleSprite.addChild(_swfLoader);
			_myTweenNew = new Tween(ButtonList,"x",Strong.easeInOut,ButtonList.x,-ButtonList.width,1,true);
			_myTweenNew=new Tween(moduleSprite,"x",Strong.easeInOut,moduleSprite.x,_windowsWidth/4,1,true);
			_myTween=new Tween(moduleSprite,"alpha",Strong.easeInOut,0,1,1,true);
			removeEl(ButtonList);
		}
		//返回按键设置
		private function backBtnList(event:MouseEvent):void{
			_myTweenNew=new Tween(moduleSprite,"x",Strong.easeInOut,moduleSprite.x,_windowsWidth,1,true);
			mBackButton.removeEventListener(MouseEvent.CLICK,backBtnList);
			mBackButton.alpha=0;
			mBackButton.buttonMode=false;
			removeEl(moduleSprite);
			initBtnList();
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
		private function test():void
		{
			trace("有用么？");
		}
	}
}