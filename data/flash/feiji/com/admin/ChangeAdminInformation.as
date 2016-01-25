package com.admin
{
	import com.me.Btn;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	public class ChangeAdminInformation extends Sprite
	{
		private var _windowsWidth:uint;
		private var _windowsHeight:uint;
		private var _adminId:String;
		private var _adminKey:String;
		private var _adminData:SharedObject;
		private var _myTween:Tween;
		public function ChangeAdminInformation()
		{
			if (stage!=null)
			{
				init();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,init);
			}
		}
		private function init(event:Event=null):void
		{
			_windowsWidth = stage.stageWidth = 550;
			_windowsHeight = stage.stageHeight = 430;
			initAdminData();//初始化管理员的登入信息。
			initEnter();//初始化旧信息验证。
			initSetAdmin();//初始新信息的设置模块。
		}
		//选择加载管理员信息
		private function initAdminData():void
		{
			_adminData = SharedObject.getLocal("AdminData","/");
			if (_adminData.data.adminData != null)
			{
				_adminId = _adminData.data.adminData.Id;
				_adminKey = _adminData.data.adminData.Key;
			}
			else
			{
				var adminData:Object = new Object  ;
				adminData.Id = _adminId = "admin";
				adminData.Key = _adminKey = "123456";
				_adminData.data.adminData = adminData;

			}

		}
		//设置按键
		private function initSetAdmin():void
		{
			setAdminSprite.x = _windowsWidth;
			setAdminSprite.y = _windowsHeight / 4;
			setAdminSprite.alpha = 0;
			var mBtn1:Btn = new Btn("确认",setAdmin);
			var mBtn2:Btn = new Btn("取消",back);
			mBtn1.name = "mBtn1";
			mBtn2.name = "mBtn2";
			setAdminSprite.addChild(mBtn1);
			setAdminSprite.addChild(mBtn2);
			mBtn1.y = mBtn2.y = setAdminSprite.mkeytxt.y + 40;
			mBtn2.x = mBtn1.x + 60;
		}
		//返回键
		private function back():void{
			_myTween = new Tween(setAdminSprite,"alpha",Strong.easeInOut,1,0,1,true);
			_myTween = new Tween(setAdminSprite,"x",Strong.easeInOut,setAdminSprite.x,_windowsWidth,1,true);
			setAdminSprite.removeChild(setAdminSprite.getChildByName("mBtn1"));
			setAdminSprite.removeChild(setAdminSprite.getChildByName("mBtn2"));
			removeChild(getChildByName("promit"));
			init();
		}
		//设置修改保存
		private function setAdmin():void{
			if(setAdminSprite.keytxt.text==setAdminSprite.mkeytxt.text)
			{
				var adminData:Object=new Object();
				adminData.Id =String(setAdminSprite.Idtxt.text);
				adminData.Key =String(setAdminSprite.keytxt.text);
				_adminData = SharedObject.getLocal("AdminData","/");
				_adminData.data.adminData =null;
				_adminData.data.adminData = adminData;
				MovieClip(setAdminSprite.getChildByName("mBtn1")).alpha=0.3;
				MovieClip(getChildByName("promit")).txt.text="修改成功！";
			}
			else
			{
				MovieClip(getChildByName("promit")).txt.text="两次的密码不一致请从新输入！";
			}
		}
		//设置确认修改键
		private function initEnter():void
		{
			mEnterSprite.x = 0;
			mEnterSprite.y = _windowsWidth / 4;
			mEnterSprite.alpha=1;
			var promit:Promit=new Promit();
			this.addChild(promit);
			promit.name = "promit";
			promit.x = 0;
			promit.y = 0;
			promit.alpha = 0;
			var mBtn:Btn = new Btn("确认",enterAdmin);
			mBtn.name = "mBtn";
			mEnterSprite.addChild(mBtn);
			mBtn.y = mEnterSprite.keytxt.y + 30;
		}
		//原身份验证
		private function enterAdmin():void
		{
			MovieClip(getChildByName("promit")).alpha = 1;
			_myTween = new Tween(MovieClip(getChildByName("promit")),"y",Strong.easeInOut,MovieClip(getChildByName("promit")).y,mEnterSprite.y + 250,1,true);
			if (_adminId==String(mEnterSprite.Idtxt.text)&&_adminKey==String(mEnterSprite.keytxt.text))
			{
				MovieClip(getChildByName("promit")).txt.text = "登入成功！";
				mEnterSprite.x=_windowsWidth;
				mEnterSprite.removeChild(MovieClip(mEnterSprite.getChildByName("mBtn")));
				mEnterSprite.alpha = 0;
				_myTween = new Tween(setAdminSprite,"alpha",Strong.easeInOut,0,1,1,true);
				_myTween = new Tween(setAdminSprite,"x",Strong.easeInOut,setAdminSprite.x,0,1,true);
			}
			else
			{
				MovieClip(getChildByName("promit")).txt.text = "登入失败！账号或密码错误，请从新确认登入信息！";
			}
		}
	}
}