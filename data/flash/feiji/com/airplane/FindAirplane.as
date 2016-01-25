package com.airplane
{
	import com.airplane.ui.AirplaneInformation;
	import com.me.NoEventBtn;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import fl.transitions.easing.*;
	import fl.transitions.Tween;
	public class FindAirplane extends Sprite
	{
		private var _windowsWidth:Number = 860;
		private var _windowsHeight:Number = 430;
		private var _xml:XML;//用于加载航班文件；
		private var _xmlLoader:URLLoader;
		private var _airplaneData:SharedObject;
		private var _buttonList:Array = ["按航班号查找","按起始—终点站查找","精细查找"];
		private var _arrLength:uint;
		private var _idString:String;
		private var _beString:String;
		private var _edString:String;
		private var _dateString:String;
		private var _myTween:Tween;
		private var _bool:Boolean ;
		public function FindAirplane()
		{
			init();
		}
		private function init():void
		{
			initButtonList();
			initXmlLoader();
		}
		//设置航班信息的加载
		private function initXmlLoader():void
		{
			_airplaneData = SharedObject.getLocal("Airplane","/");
			if (_airplaneData.data.airplaneXmlData != null)
			{
				trace("不是空的！");
				_xml = XML(_airplaneData.data.airplaneXmlData);

			}
			else
			{
				_xmlLoader = new URLLoader(new URLRequest("com/airplane/data/airplaneData.xml"));
				_xmlLoader.addEventListener(Event.COMPLETE,xmlLoader);

			}
		}
		private function xmlLoader(event:Event):void
		{
			_xml = XML(_xmlLoader.data);
		}
		//初始化按键列表与按键对应的事件
		private function initButtonList():void
		{
			backBtn.alpha = 0;
			promittxt.alpha=0;
			promittxt.y = _windowsHeight / 6;
			promittxt.x = _windowsWidth;
			airplaneSprite.y = promittxt.y + 30;
			airplaneSprite.x = _windowsWidth;
			chooseSprite.x = _windowsWidth / 4;
			chooseSprite.y = 0;
			buttonSprite.x = 0;
			buttonSprite.y = _windowsHeight / 4;
			_bool=false;
			_arrLength = _buttonList.length;
			var hisY:uint = 100;
			/*遍历按键名数组生成按键实例，添加至按键列表元件中*/
			for (var i:uint=0; i<_arrLength; i++)
			{
				var mBtn:NoEventBtn = new NoEventBtn(_buttonList[i]);
				mBtn.name = "Btn" + i;
				mBtn.num = i;
				mBtn.addEventListener(MouseEvent.CLICK,chooseFind);
				buttonSprite.addChild(mBtn);
				mBtn.y = hisY * i;

			}
		}
		private function chooseFind(event:MouseEvent):void
		{
			chooseSprite.y = 0;
			removeEl(chooseSprite);
			if (event.target.parent.num == 0)
			{
				var findIdBtn:NoEventBtn = new NoEventBtn("查找");
				findIdBtn.addEventListener(MouseEvent.CLICK,findWithSet);
				var mfindId:findId=new findId();
				mfindId.name = "mfindId";
				chooseSprite.addChild(mfindId);
				chooseSprite.addChild(findIdBtn);
				findIdBtn.x = mfindId.width + 10;
			}
			else if (event.target.parent.num==1)
			{
				var findBeEdBtn:NoEventBtn = new NoEventBtn("查找");
				findBeEdBtn.addEventListener(MouseEvent.CLICK,findWithSet);
				findBeEdBtn.num = 1;
				var mfindBeEd:findBeEd=new findBeEd();
				chooseSprite.addChild(mfindBeEd);
				chooseSprite.addChild(findBeEdBtn);
				findBeEdBtn.x = mfindBeEd.width + 10;
			}
			else
			{
				var findCarefulBtn:NoEventBtn = new NoEventBtn("查找");
				findCarefulBtn.addEventListener(MouseEvent.CLICK, findWithSet);
				findCarefulBtn.num = 2;
				var mfindCareful:findCareful=new findCareful();
				chooseSprite.addChild(mfindCareful);
				chooseSprite.addChild(findCarefulBtn);
				findCarefulBtn.x = mfindCareful.width + 10;
			}
			_myTween = new Tween(chooseSprite,"y",Strong.easeInOut,chooseSprite.y,_windowsHeight / 2,1,true);
		}
		private function findWithSet(event:MouseEvent):void
		{
			/*从输入文本获取相应的属性赋值*/
			_idString = MovieClip(chooseSprite.getChildAt(0)).idtxt.text;//航班号
			_beString = MovieClip(chooseSprite.getChildAt(0)).betxt.text;//起始站
			_edString = MovieClip(chooseSprite.getChildAt(0)).edtxt.text;//终点站
			_dateString = MovieClip(chooseSprite.getChildAt(0)).datetxt.text;//日期
			var n:uint = 0;
			/*遍历xml文件,生成每个航班信息对应xml信息文件，在顺序表中查找相应的项*/
			for each (var _airplaneXml:XML in _xml.airplane)
			{
				/*设置匹配三种键值查找*/
				var num:uint = event.target.parent.num;//num标记三种查找方式
				/*第一种匹配的键值为id（航班号）*/
				if ((num==0)&&_idString==String(_airplaneXml.id))
				{/*如果输入的航班号与顺序表中的航班号相匹配则为查找成功*/
					var _airplane0:AirplaneInformation = new AirplaneInformation(_airplaneXml.id,_airplaneXml.be,_airplaneXml.ed,_airplaneXml.date,_airplaneXml.amount,_airplaneXml.price,_airplaneXml.rebate);
					_airplane0.name = "p" + n;
					airplaneSprite.addChild(_airplane0);
					_airplane0.y = 80 * n;
					n++;
					_bool = true;
				}
				/*第二种匹配键值为：be（起始站）与ed（终点站）*/
				else if ((num==1)&&_beString==String(_airplaneXml.be)&&_edString==String(_airplaneXml.ed))
				{/*如果顺序表中某节点与be、ed想匹配则为查找成功*/
					var _airplane1:AirplaneInformation = new AirplaneInformation(_airplaneXml.id,_airplaneXml.be,_airplaneXml.ed,_airplaneXml.date,_airplaneXml.amount,_airplaneXml.price,_airplaneXml.rebate);
					_airplane1.name = "p" + n;
					airplaneSprite.addChild(_airplane1);
					_airplane1.y = 80 * n;
					n++;
					_bool = true;
				}
				/*第三种匹配键值为：be（起始站）与ed（终点站）、date（日期）*/
				else if ((num==2)&&(_beString==String(_airplaneXml.be))&&(_edString==String(_airplaneXml.ed))&&(_dateString==String(_airplaneXml.date)))
				{/*同上三项相匹配则查找成功*/
					var _airplane2:AirplaneInformation = new AirplaneInformation(_airplaneXml.id,_airplaneXml.be,_airplaneXml.ed,_airplaneXml.date,_airplaneXml.amount,_airplaneXml.price,_airplaneXml.rebate);
					_airplane2.name = "p" + n;
					airplaneSprite.addChild(_airplane2);
					_airplane2.y = 80 * n;
					n++;
					_bool = true;
				}
			}
			resultOrBack();
		}
		//返回按键设置
		private function resultOrBack():void
		{
			promittxt.alpha=1;
			removeEl(buttonSprite);
			removeEl(chooseSprite);
			if (! _bool)
			{
				promittxt.text = "无对应的查找结果，请确认航班信息后再查找！";
			}
			else
			{
				promittxt.text = "查找结果为：";
			}
			_myTween = new Tween(promittxt,"x",Strong.easeInOut,chooseSprite.x,0,1,true);
			_myTween = new Tween(airplaneSprite,"x",Strong.easeInOut,chooseSprite.x,0,1,true);
			initBackBtn();
		}
		private function initBackBtn():void
		{
			backBtn.alpha = 1;
			backBtn.buttonMode = true;
			backBtn.addEventListener(MouseEvent.CLICK,back);

		}
		private function back(event:MouseEvent):void
		{
			promittxt.alpha=0;
			backBtn.alpha = 0;
			backBtn.removeEventListener(MouseEvent.CLICK,back);
			promittxt.x=airplaneSprite.x=_windowsWidth;
			removeEl(airplaneSprite);
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