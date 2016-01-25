package com.user{
	import com.me.Btn;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	public class ChangeUserInformation extends Sprite{
		private var _windowsWidth:Number;
		private var _windowsHeight:Number;
		private var _userData:SharedObject;//用户信息对象。
		private var _userXml:XML;
		private var _xmlLoader:URLLoader;
		private var _myTween:Tween;
		private var _userNum:uint;//标记当前用户在文件的位置索引
		public function ChangeUserInformation()
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
		private function init(event:Event=null):void
		{
			_windowsWidth=stage.stageWidth=860;
			_windowsHeight=stage.stageHeight=430;
			initUserData();
			initChangeUser();
		}
		//初始界面与按键
		private function initChangeUser():void{
			Promit.x=0;
			Promit.y=_windowsHeight/9;
			Promit.txt.text="用户信息详情为:";
			setUserInformation.x=_windowsWidth;
			setUserInformation.y=_windowsHeight/4;
			setUserInformation.alpha=0;
			userInformation.x=0;
			userInformation.y=_windowsHeight/6;
			userInformation.alpha=1;
			var tempXml:XML=XML(_userXml.user[_userNum]);
			//trace(tempXml);
			userInformation.idtxt.text=tempXml.Id;
			userInformation.nametxt.text=tempXml.name;
			userInformation.sextxt.text=tempXml.sex;
			userInformation.pIdtxt.text=tempXml.pId;
			userInformation.telltxt.text=tempXml.tell;
			userInformation.Emailtxt.text=tempXml.Email;
			var changeBtn:Btn=new Btn("修改",change);
			changeBtn.name="changeBtn";
			addChild(changeBtn);
			changeBtn.y=userInformation.y+userInformation.height+10;
		}
		//设置按键事件监听
		private function change():void{
			Promit.txt.text="请进行新用户信息的填写！";
			userInformation.alpha=0;
			removeChild(getChildByName("changeBtn"));
			setUserInformation.alpha=1;
			_myTween=new Tween(setUserInformation,"x",Strong.easeInOut,setUserInformation.x,0,1,true);
			var affirmBtn:Btn=new Btn("确认",affirm);
			affirmBtn.name="affirmBtn";
			var backBtn:Btn=new Btn("取消",back);
			backBtn.name="backBtn";
			addChild(affirmBtn);
			addChild(backBtn);
			backBtn.x=affirmBtn.width+10;
			backBtn.y=affirmBtn.y=setUserInformation.y+setUserInformation.height+10;
			
		}
		//返回
		private function back():void{
			removeChild(getChildByName("backBtn"));
			removeChild(getChildByName("affirmBtn"));
			init();
			//setUserInformation.alpha=0;
		}
		//确认修改
		private function affirm():void{
			var id:String=setUserInformation.idtxt.text;
			var key:String=setUserInformation.keytxt.text;
			var mkey:String=setUserInformation.mkeytxt.text;
			var tell:String=setUserInformation.telltxt.text;
			var Email:String=setUserInformation.Emailtxt.text;
			var arr:Array=[id,key,mkey,tell,Email];
			if(!(testNull(arr)||testID_key(id,key)||testKeys(key,mkey)))
			{
				_userXml.user[_userNum].id=id;
				_userXml.user[_userNum].key=key;
				_userXml.user[_userNum].tell=tell;
				_userXml.user[_userNum].Email=Email;
				_userData = SharedObject.getLocal("UserData","/");
				_userData.data.userXmlData=_userXml;
				Promit.txt.text="修改成功!";
				MovieClip(getChildByName("affirmBtn")).alpha=0.3;
			}
		}
		private function testNull(arr:Array):Boolean//验证是否所有的信息都有填写完整；
		{
			var bool:Boolean=false;
			var n:uint=arr.length;
			for(var i:uint;i<n;i++)
			{
				if(arr[i]=="")
				{
					bool=true;
					Promit.txt.text="账号信息填写不完整，请从新确认修改！";
					break;
				}
			}
			return bool;
			
		}
		private function testID_key(id:String,key:String):Boolean//验证账号是否已经存在
		{
			var bool:Boolean=false;
			for each(var _user:XML in _userXml.user)
			{
				var i:uint=_user.childIndex();
				if((id==String(_user.Id))&&(key==String(_user.key))&&(_userNum!=i))
				{
					bool=true;
					Promit.txt.text="账号已存在,请从新确认修改！";
					break;
				}
			}
			return bool;
		}
		private function testKeys(key:String,mkey:String):Boolean{//验证两次输入的密码是否一致；
			var bool:Boolean=false;
			if(key!=mkey)
			{
				Promit.txt.text="两次密码不相同，请从新确认修改！";
				bool=true;
			}
			return bool;
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