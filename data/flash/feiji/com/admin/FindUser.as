package com.admin
{
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
	public class FindUser extends Sprite
	{
		private var _windowsWidth:Number;
		private var _windowsHeight:Number;
		private var _userData:SharedObject;//用户信息对象。
		private var _userXml:XML;
		private var _xmlLoader:URLLoader;
		private var _myTween:Tween;
		private var _userNum:uint;//标记当前用户在文件的位置索引
		public function FindUser()
		{
			if (stage!=null)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE,init);
			}
		}
		private function init(event:Event=null):void
		{
			_windowsWidth = stage.stageWidth = 860;
			_windowsHeight = stage.stageHeight = 430;
			initUserData();
			initFindUser();
		}
		//初始化按键设置
		private function initFindUser():void
		{
			Promit.x = 0;
			Promit.y = 0;
			setFind.x = 0;
			setFind.y = _windowsHeight * 0.4;
			setFind.alpha = 1;
			var findBtn:Btn = new Btn("查找",find);
			findBtn.name = "findBtn";
			addChild(findBtn);
			findBtn.y = setFind.y + setFind.height + 10;
		}
		//设置查找
		private function find():void
		{
			removeChild(getChildByName("findBtn"));
			setFind.alpha = 0;
			var pId:String = setFind.pIdtxt.text;
			var num:int = findUserNum(pId);
			Promit.alpha = 1;
			if (num!=-1)
			{
				Promit.txt.text = "用户信息详情为：";
				_userNum = num;
				var tempXml:XML = XML(_userXml.user[_userNum]);
				var userInformation:UserInformation=new UserInformation();
				addChild(userInformation);
				userInformation.name = "userInformation";
				userInformation.x = _windowsWidth;
				userInformation.y = Promit.height + 10;
				userInformation.idtxt.text = tempXml.Id;
				userInformation.nametxt.text = tempXml.name;
				userInformation.sextxt.text = tempXml.sex;
				userInformation.pIdtxt.text = tempXml.pId;
				userInformation.telltxt.text = tempXml.tell;
				userInformation.Emailtxt.text = tempXml.Email;
				var backBtn:Btn = new Btn("返回",back);
				backBtn.name = "backBtn";
				addChild(backBtn);
				backBtn.y = userInformation.y;
				backBtn.x = userInformation.width + 10;
				//trace(tempXml);
				//如果用户有订票的话讲航班信息页显示出来
				if (XML(tempXml.airplane)!= null)
				{
					var tempAirplaneXml:XML = new XML(tempXml.airplane);
					var userTicketInformation:UserTicketInformation = new UserTicketInformation(tempAirplaneXml.id,tempAirplaneXml.be,tempAirplaneXml.ed,tempAirplaneXml.date,tempAirplaneXml.amount,Number(tempAirplaneXml.price) * Number(tempAirplaneXml.rebate));
					userTicketInformation.name = "userTicketInformation";
					addChild(userTicketInformation);
					userTicketInformation.x = _windowsWidth;
					userTicketInformation.y = userInformation.y + userInformation.height + 10;
					_myTween = new Tween(userTicketInformation,"x",Strong.easeInOut,userTicketInformation.x,0,1,true);
				}
				_myTween = new Tween(userInformation,"x",Strong.easeInOut,userInformation.x,0,1,true);
			}
			else
			{
				Promit.txt.text = "未找到对应的用户信息，请从新确认信息！";
				_myTween=new Tween(Promit,"y",Strong.easeInOut,Promit.y,_windowsHeight/5,1,true);
			}

		}
		//返回
		private function back():void
		{
			if (getChildByName("userTicketInformation")!=null)
			{
				removeChild(getChildByName("userTicketInformation"));
			}
			removeChild(getChildByName("backBtn"));
			removeChild(getChildByName("userInformation"));
			init();

		}
		//放回当前用户在文件中位置索引
		private function findUserNum(pId:String):int
		{
			var i:int = 0;
			for each (var _user:XML in _userXml.user)
			{
				i = _user.childIndex();
				if (pId==String(_user.pId))
				{
					return i;
					break;
				}
			}
			return -1;
		}
		private function initUserData():void
		{
			_userData = SharedObject.getLocal("UserData","/");
			if (_userData.data.userXmlData != null)
			{//如果储存的数据元件不为空，则加载存储的数据。
				trace("不是空的！");
				_userXml = XML(_userData.data.userXmlData);//对xml文件进行初始化赋值；
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
				_userData.data.userXmlData = _userXml;
			}
		}
	}
}