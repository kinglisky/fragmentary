package com.user{
	import com.me.Btn;
	import com.user.ui.UserTicketInformation;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	public class ReturnTicket extends Sprite{
		private var _windowsWidth:Number;
		private var _windowsHeight:Number;
		private var _airplaneData:SharedObject;//储存对象；
		private var _userData:SharedObject;//用户信息对象。
		private var _airplaneXml:XML;//航班数据文件
		private var _userXml:XML;//用户数据文件
		private var _xmlLoader:URLLoader;
		private var _myTween:Tween;
		private var _userNum:uint;//标记当前用户在文件的位置索引
		private var _airplaneNum:uint;//标记用户所定航班位于文件中的位置索引；
		//private var NULL:String="NULL";
		public function ReturnTicket()
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
			_windowsWidth=stage.stageWidth=860;
			_windowsHeight=stage.stageHeight=430;
			initUserData();
			initAirplaneData();
			initSetReturnTicket();
		}
		//初始化入口
		private function initSetReturnTicket():void{
			Promit.x=0;
			Promit.y=0;
			_myTween=new Tween(Promit,"y",Strong.easeInOut,Promit.y,_windowsHeight/5,1,true);
			trace(_userXml.user[_userNum]);
			//如用户机票不为空，显示机票详情
			if(XML(_userXml.user[_userNum].airplane)!=null)
			{
				var tempXml:XML=XML(_userXml.user[_userNum].airplane);
				var Id:String=String(tempXml.id);
				_airplaneNum=findAirplaneNum(Id);
				if(_airplaneNum!=-1)
				{
					Promit.txt.text="您的机票详情为:";
					var userTicket:UserTicketInformation=new UserTicketInformation(tempXml.id,tempXml.be,tempXml.ed,tempXml.date,tempXml.amount,Number(tempXml.price)*Number(tempXml.rebate));
					userTicket.name="userTicket";
					var affirmBtn:Btn=new Btn("退票",affirm);
					affirmBtn.name="affirmBtn";
					addChild(userTicket);
					addChild(affirmBtn);
					userTicket.x=_windowsWidth;
					userTicket.y=_windowsHeight/4;
					affirmBtn.y=userTicket.y+userTicket.height+10;
					affirmBtn.width+10;
					_myTween=new Tween(userTicket,"x",Strong.easeInOut,userTicket.x,0,1,true);
				}
				else
				{
					Promit.txt.text="未找到相应的航班对象！！";
				}
			}
			else
			{
				Promit.txt.text="您尚未订购机票！";
			}
		}
		//确认退票
		private function affirm():void{
			var amount:uint=uint(_airplaneXml.airplane[_airplaneNum].amount)+1;
			_airplaneXml.airplane[_airplaneNum].amount=amount;
			_userXml.user[_userNum].airplane=null;
			_airplaneData = SharedObject.getLocal("Airplane","/");
			_airplaneData.data.airplaneXmlData=_airplaneXml;
			_userData = SharedObject.getLocal("UserData","/");
			_userData.data.userXmlData=_userXml;
			Promit.txt.text="退票成功！";
			MovieClip(getChildByName("affirmBtn")).alpha=0.3;
		}
		//寻找目标航班的文件位置索引
		private function findAirplaneNum(Id:String):int{
			var i:int = 0;
			for each (var _tempXml:XML in _airplaneXml.airplane)
			{
				i = _tempXml.childIndex();
				if (Id==String(_tempXml.id))
				{
					return i;
					break;
				}
			}
			i=-1;
			return i;
		}
		private function initAirplaneData():void{
			_airplaneData = SharedObject.getLocal("Airplane","/");
			if (_airplaneData.data.airplaneXmlData != null)
			{//如果储存的数据元件不为空，则加载存储的数据。
				trace("不是空的！");
				_airplaneXml = XML(_airplaneData.data.airplaneXmlData);//对xml文件进行初始化赋值；
			}
			else
			{//否则加载默认的数据元件。
				_xmlLoader = new URLLoader(new URLRequest("com/airplane/data/airplaneData.xml"));
				_xmlLoader.addEventListener(Event.COMPLETE,xmlLoader);
				
			}
		}
		private function xmlLoader(event:Event):void{
			_airplaneData.data.airplaneXmlData=_airplaneXml=XML(_xmlLoader.data);
		}
		private function initUserData():void{
			_userData = SharedObject.getLocal("UserData","/");
			if(_userData.data.userNum!=null)
			{
				_userNum=_userData.data.userNum;
			}
			else
			{
				_userNum=0;//默认的索引为0
				trace("索引为空！！！")
			}
			if (_userData.data.userXmlData != null)
			{//如果储存的数据元件不为空，则加载存储的数据。
				trace("不是空的！");
				_userXml= XML(_userData.data.userXmlData);//对xml文件进行初始化赋值；
			}
			else
			{
				_userXml=
					<data>
					<user>
					<Id>admin</Id>
					<key>123456</key>
					<name>null</name>
					<sex>null</sex>
					<pId>null</pId>
					<tell>null</tell>
					<Email>null</Email>
					<airplane>null</airplane>
					</user>
					</data>;
				_userData.data.userXmlData=_userXml;
			}
		}
	}
	
}