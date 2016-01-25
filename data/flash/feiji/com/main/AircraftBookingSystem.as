package com.main
{
	import com.me.Btn;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;//Btn类味按键的类对按键的各种属性进行设置和事件监听。
	public class AircraftBookingSystem extends Sprite
	{
		private var _windowsWidth:Number = stage.stageWidth;//获取舞台的宽与高；
		private var _windowsHeight:Number = stage.stageHeight;
		private var _myTween:Tween;//缓动类，用于设置缓动效果；
		private var _curId:int = 0;//对使用者的身份进行标记0表用户，1表管理员。
		private var _adminData:SharedObject;//管理员信息对象。
		private var _userData:SharedObject;//用户信息对象。
		private var _adminId:String;//管理员账号。
		private var _adminKey:String;//管理员密码。
		private var _loader:Loader=new Loader();//用于加载其他swf文件（模块）；
		private var _xml:XML;//用于加载用户数据。
		private var _xmlLoader:URLLoader;//用于加载用户数据。
		private var _userNumber:uint;//用于记录用户在文件文件中的索引位置；
		public function AircraftBookingSystem()
		{
			init();//构造函数初始化；
		}
		private function init():void
		{
			mTitle.x = _windowsWidth / 2 - mTitle.width / 2;//界面标题。
			mTitle.alpha = 1;
			mPrompt.y = 0;
			mPrompt.x = _windowsWidth / 2 - mPrompt.width / 2;//其实窗口用于提示操作的信息。
			mPrompt.alpha = 0;
			initInlet();//初始化身份入口；
			initEnter();//初始化登入界面；
			initAdminData();//初始化管理员身份信息。
			initUserData();//初始化用户的身份信息。
		}
		private function initUserData():void
		{
			_userData = SharedObject.getLocal("UserData","/");
			if (_userData.data.userXmlData != null)
			{//如果储存的数据元件不为空，则加载存储的数据。
				_xml = XML(_userData.data.userXmlData);//对xml文件进行初始化赋值；
				//trace(_xml);
			}
			else
			{
				_xml=
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
				_userData.data.userXmlData=_xml;
				
			}
			_userData.data.userNum=null;
		}
		//加载本地管理员数据
		private function initAdminData():void
		{
			_adminData = SharedObject.getLocal("AdminData", "/");
			//如果本地管理员数据为空则加载默认的管理员信息
			if (_adminData.data.adminData != null)
			{
				_adminId = _adminData.data.adminData.Id;
				_adminKey = _adminData.data.adminData.Key;
			}
			else
			{
				var adminData:Object=new Object();
				adminData.Id = _adminId = "admin";
				adminData.Key = _adminKey = "123456";
				_adminData.data.adminData = adminData;

			}
		}
		private function initEnter():void
		{
			backBtn.alpha = 0;
			var Enter_bt:Btn = new Btn("登录",Enter);
			var Return_bt:Btn = new Btn("返回",ReturnInlet);//对按键进行构建；
			var Login_bt:Btn = new Btn("注册",Login);
			Login_bt.name = "Login_bt";//为按键命名，方便移除。
			var _w:int = Enter_bt.width;
			mEnterSprite.BtnSprite.addChild(Login_bt);
			mEnterSprite.BtnSprite.addChild(Enter_bt);
			mEnterSprite.BtnSprite.addChild(Return_bt);
			Login_bt.x = 0;
			Enter_bt.x = _w;
			Return_bt.x = 2 * _w;
			mEnterSprite.x = _windowsWidth/2-mEnterSprite.width/2;
			mEnterSprite.y = _windowsHeight / 4;//在舞台容器中添加按键，并对其位置进行设置。
			mEnterSprite.alpha = 0;//初始状态为隐藏；
		}
		private function initInlet():void
		{//初始化身份入口；
			var User_bt:Btn = new Btn("用户入口",User);
			var Admin_bt:Btn = new Btn("管理员入口",Admin);//对按键进行构建；
			Admin_bt.y = 60;
			mSpriteIdentity.addChild(User_bt);
			mSpriteIdentity.addChild(Admin_bt);
			mSpriteIdentity.x = _windowsWidth / 2 - mSpriteIdentity.width / 2;//在舞台容器中添加按键，并对其位置进行设置。
			mSpriteIdentity.y = _windowsHeight;
			_myTween = new Tween(mSpriteIdentity,"y",Strong.easeInOut,mSpriteIdentity.y,_windowsHeight / 4,1,true);
		}
		//用户与管理员身份设置
		private function User():void
		{
			_curId = 0;
			inEnter();
		}
		private function Admin():void
		{
			_curId = 1;
			inEnter();
		}
		private function inEnter():void
		{
			if (_curId)
			{
				mEnterSprite.BtnSprite.removeChild(mEnterSprite.BtnSprite.getChildByName("Login_bt"));
			}
			_myTween = new Tween(mSpriteIdentity,"x",Strong.easeInOut,mSpriteIdentity.x,0,1,true);
			_myTween = new Tween(mEnterSprite,"x",Strong.easeInOut,_windowsWidth,_windowsWidth / 2 - mEnterSprite.width / 2,1,true);
			_myTween = new Tween(mEnterSprite,"alpha",Strong.easeInOut,0,1,1,true);
			removeEl(mSpriteIdentity);//移除入口处的按键。
		}
		//返回
		private function ReturnInlet():void
		{
			_myTween = new Tween(mEnterSprite,"x",Strong.easeInOut,mEnterSprite.x,_windowsWidth,1,true);
			_myTween = new Tween(mEnterSprite,"alpha",Strong.easeInOut,1,0,1,true);
			removeEl(mEnterSprite.BtnSprite);//移除登入界面的按键元件防止按键监听事件对其他函数的影响。
			init();

		}
		//注册
		private function Login():void
		{
			_loader.load(new URLRequest("login.swf"));
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,inNterface);
			_myTween = new Tween(mEnterSprite,"y",Strong.easeInOut,mEnterSprite.y,_windowsHeight,1,true);
			_myTween = new Tween(mEnterSprite,"alpha",Strong.easeInOut,1,0,1,true);
		}
		//登入
		private function Enter():void
		{
			mPrompt.alpha = 1;
			_myTween = new Tween(mPrompt,"y",Strong.easeInOut,mPrompt.y,_windowsHeight / 10 * 9,1,true);
			if (_curId)
			{//管理员登入。
				if (_adminId==String(mEnterSprite.Idtxt.text)&&_adminKey==String(mEnterSprite.keytxt.text))
				{
					mTitle.alpha = 0;
					mPrompt.txt.text = "登入成功！";
					_myTween = new Tween(mEnterSprite,"y",Strong.easeInOut,mEnterSprite.y,_windowsHeight,1,true);
					_myTween = new Tween(mEnterSprite,"alpha",Strong.easeInOut,1,0,1,true);
					loaderNterface();
				}
				else
				{
					mPrompt.txt.text = "密码或账号错误！请从新登入！";
				}

			}
			else
			{
				if (affirmUserIdentity())
				{
					_userData = SharedObject.getLocal("UserData","/");
					_userData.data.userNum=null;
					_userData.data.userNum=_userNumber;
					trace("索引为："+_userNumber);
					mPrompt.txt.text = "登入成功！";
					_myTween = new Tween(mEnterSprite,"y",Strong.easeInOut,mEnterSprite.y,_windowsHeight,1,true);
					_myTween = new Tween(mEnterSprite,"alpha",Strong.easeInOut,1,0,1,true);
					loaderNterface();
				}
				else
				{
					mPrompt.txt.text = "无对应账号信息，账号信息错误，或未注册，请从从新确认！";
				}
			}

		}
		//确认用户信息
		private function affirmUserIdentity():Boolean
		{
			var bool:Boolean = false;
			var num:uint=0;
			for each (var _user:XML in _xml.user)
			{
				num=_user.childIndex();
				if (_user.Id == String(mEnterSprite.Idtxt.text) && _user.key == String(mEnterSprite.keytxt.text))
				{
					_userNumber=num;
					bool = true;
					break;
				}
			}
			return bool;
		}
		//加载不同模块
		private function loaderNterface():void
		{
			if (_curId)
			{
				_loader.load(new URLRequest("Admin.swf"));
			}
			else
			{
				_loader.load(new URLRequest("User.swf"));
			}
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,inNterface);
		}
		private function inNterface(event:Event):void
		{
			mPrompt.alpha=0;
			backBtn.alpha = 1;
			backBtn.buttonMode = true;
			backBtn.x=_windowsWidth/4;
			backBtn.y=_windowsHeight*0.95;
			backBtn.addEventListener(MouseEvent.CLICK,back);
			mTitle.alpha = 0;
			this.mSprite.addChild(_loader);
		}
		//返回键
		private function back(event:MouseEvent):void{
			backBtn.removeEventListener(MouseEvent.CLICK,back);
			backBtn.buttonMode=false;
			mSprite.removeChildAt(0);
			mTitle.alpha=1;
			_myTween = new Tween(mEnterSprite,"y",Strong.easeInOut,mEnterSprite.y,_windowsHeight / 4,1,true);
			_myTween = new Tween(mEnterSprite,"alpha",Strong.easeInOut,0,1,1,true);
			initEnter();
			if(_curId)
			{
				Admin();
			}
			else
			{
				User();
			}
			
		}
		/*用于移除元件中的各个按键元件与事件的监听。*/
		private function removeEl(Spr:Sprite):void
		{
			var num:uint = Spr.numChildren;
			for (var i:uint=0; i<num; i++)
			{
				//Spr.getChildAt(0)=null;
				Spr.removeChildAt(0);
			}
		}
	}
}