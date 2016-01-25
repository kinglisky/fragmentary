package com.user{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	public class Login extends Sprite{
		private var _windowsWidth:Number;
		private var _windowsHeight:Number;
		private var _userData:SharedObject;//用户信息对象。
		private var _myTween:Tween;
		private var _xml:XML;
		public function Login()
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
		//各元件的设置
		private function init(event:Event=null):void{
			_windowsWidth=stage.stageWidth;
			_windowsHeight=stage.stageHeight;
			Title.x=_windowsWidth/2-Title.width/2;
			Title.y=_windowsHeight/6;
			affirmBtn.x=_windowsWidth/4+60;
			affirmBtn.y=_windowsHeight*0.95;
			Promit.x=_windowsWidth/3;
			Promit.y=_windowsHeight/5;
			Promit.alpha=0;
			affirmBtn.alpha=0;
			initUserData();
			initLoginSprite();
		}
		//加载用户信息
		private function initUserData():void{
			_userData = SharedObject.getLocal("UserData","/");
			if (_userData.data.userXmlData != null)
			{//如果储存的数据元件不为空，则加载存储的数据。
				_xml = XML(_userData.data.userXmlData);//对xml文件进行初始化赋值；
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
		}
		//加载注册板块
		private function initLoginSprite():void{
			loginSprite.alpha=0;
			loginSprite.x=_windowsWidth/4;
			loginSprite.y=0;
			_myTween=new Tween(loginSprite,"alpha",Strong.easeInOut,0,1,1,true);
			_myTween=new Tween(loginSprite,"y",Strong.easeInOut,loginSprite.y,_windowsHeight/4,1,true);
			initAffirm();
		}
		//确定按键的效果设置
		private function initAffirm():void{
			affirmBtn.alpha=1;
			affirmBtn.buttonMode=true;
			affirmBtn.addEventListener(MouseEvent.CLICK,affirm);
		}
		private function affirm(event:MouseEvent):void{
			Promit.alpha=1;
			/*有输入文本框获取相应的属性赋值*/
			var xmlLength:uint=_xml.user.length();
			var _id:String=String(loginSprite.Idtxt.text);
			var _key:String=String(loginSprite.keytxt.text);
			var _mkey:String=String(loginSprite.mkeytxt.text);
			var _name:String=String(loginSprite.nametxt.text);
			var _sex:String=String(loginSprite.sextxt.text);
			var _pId:String=String(loginSprite.pIdtxt.text);
			var _tell:String=String(loginSprite.telltxt.text);
			var _Email:String=String(loginSprite.Emailtxt.text);
			/*生成新的用户信息的xml文件*/
			var tempXml:XML=
			<data>
					<user>
					<Id>{_id}</Id>
					<key>{_key}</key>
					<name>{_name}</name>
					<sex>{_sex}</sex>
					<pId>{_pId}</pId>
					<tell>{_tell}</tell>
					<Email>{_Email}</Email>
					<airplane>null</airplane>
					</user>
			</data>;
			var arrUser:Array=[_id,_key,_mkey,_name,_sex,_pId,_tell,_Email];
			/*如果新注册的用户满足1.账号与密码不与已有的账号密码相同、2.填写项目完整、3.两次密码相同、才能注册*/
			if(!(testID_key(_id,_key)||testNull(arrUser)||testKeys(_key,_mkey)))
			{
				_xml.user[xmlLength]=tempXml.user;
				_userData = SharedObject.getLocal("UserData","/");//打开存储空间
				_userData.data.userXmlData=null;
				_userData.data.userXmlData=_xml;//添加新注册的用户信息
				Promit.txt.text="注册成功！！";
				affirmBtn.alpha=0.3;
				affirmBtn.buttonMode=false;
				affirmBtn.removeEventListener(MouseEvent.CLICK,affirm);
			}
			_myTween=new Tween(Promit,"y",Strong.easeInOut,Promit.y,_windowsHeight/2,1,true);
			
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
			/*遍历顺序 表，找出满足与否*/
			for each(var _user:XML in _xml.user)
			{
				if(id==String(_user.Id)&&key==String(_user.key))
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
	}
}