package com.airplane
{
	import com.airplane.ui.AirplaneInformation;
	import com.me.Btn;
	import com.me.NoEventBtn;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	public class ModificationAirplane extends Sprite
	{
		private var _windowsWidth:Number = 860;//舞台宽.
		private var _windowsHeight:Number = 430;//舞台高.
		private var _xml:XML;//用于加载航班的数据文件。
		private var _tempXml:XML;//用于储存临时xml文件，便于保存。
		private var _xmlLoader:URLLoader;//加载方法。
		private var _airplaneData:SharedObject;//储存对象；
		private var _buttonList:Array = ["航班信息修改","航班信息删除","航班信息增添","航班信息录入"];//航班的名称列表。
		private var _myTween:Tween;//用于设置元件缓动效果。
		private var _id:*;
		private var _count:uint;
		private var _num:int;
		public function ModificationAirplane()
		{
			init();
		}
		private function init():void
		{
			initXmlLoader();//用于加载储存用的数据元件。
			initButtonList();//生成按键列表。
		}
		private function initXmlLoader():void
		{
			_airplaneData = SharedObject.getLocal("Airplane","/");
			if (_airplaneData.data.airplaneXmlData != null)
			{//如果储存的数据元件不为空，则加载存储的数据。
				trace("不是空的！");
				_xml = XML(_airplaneData.data.airplaneXmlData);//对xml文件进行初始化赋值；
			}
			else
			{//否则加载默认的数据元件。
				_xmlLoader = new URLLoader(new URLRequest("com/airplane/data/airplaneData.xml"));
				_xmlLoader.addEventListener(Event.COMPLETE,xmlLoader);

			}
		}
		private function xmlLoader(event:Event):void
		{
			_xml = XML(_xmlLoader.data);
			_airplaneData.data.airplaneXmlData = _xml;
		}
		private function initButtonList():void
		{
			backBtn.alpha = 0;//返回键的状态初始为透明。
			setSprite.alpha = 0;
			buttonSprite.y = _windowsHeight / 6;
			var n:uint = _buttonList.length;
			var hisY:uint = 80;
			for (var i:uint; i<n; i++)
			{
				var mBtn:NoEventBtn = new NoEventBtn(_buttonList[i]);
				mBtn.name = "mBtn" + i;
				mBtn.num = i;
				mBtn.addEventListener(MouseEvent.CLICK,setOperate);
				buttonSprite.addChild(mBtn);
				mBtn.y = hisY * i;
			}
		}//遍历按键名称数组生成按键列表。
		//不同修改方式的按键设置
		private function setOperate(event:MouseEvent):void
		{
			if (setSprite.numChildren > 1)
			{
				setSprite.removeChildAt(1);
			}
			setSprite.x = _windowsWidth / 4;
			setSprite.y = 0;
			var num:uint = event.target.parent.num;
			if (num==0)
			{
				setSprite.setChange.promit.text = "请输入要修改的航班号:";
				var newBtn:Btn = new Btn("修改",changeAirplane);
				setSprite.addChild(newBtn);
				newBtn.x = setSprite.setChange.width + 10;
			}
			else if (num==1)
			{
				setSprite.setChange.promit.text = "请输入要删除的航班号:";
				var newBtn1:Btn = new Btn("删除",deleteAirplane);
				setSprite.addChild(newBtn1);
				newBtn1.x = setSprite.setChange.width + 10;
			}
			else if (num==2)
			{
				setSprite.setChange.promit.text = "请输入增添的航班号:";
				var newBtn2:Btn = new Btn("增添",addAirplane);
				setSprite.addChild(newBtn2);
				newBtn2.x = setSprite.setChange.width + 10;
			}
			else
			{
				setSprite.setChange.promit.text = "请输入录入的航班数量:";
				var newBtn3:Btn = new Btn("录入",loggingAirplane);
				setSprite.addChild(newBtn3);
				newBtn3.x = setSprite.setChange.width + 10;
			}
			setSprite.alpha = 1;
			_myTween = new Tween(setSprite,"y",Strong.easeInOut,setSprite.y,_windowsHeight / 2,1,true);

		}
		//录入
		private function loggingAirplane():void
		{
			removeEl(changeSprite);
			resultOrBack();
			_num=_id = int(setSprite.setChange.inputtxt.text);
			var hisY:uint = 70;
			if (_id>0&&_id<4)
			{
				for (var i:uint; i<_id; i++)
				{
					var airplaneInput:AirplaneInput=new AirplaneInput();
					changeSprite.addChild(airplaneInput);
					airplaneInput.y = i * hisY;
				}
				var mBtn1:Btn = new Btn("清空录入",newTypeIn);
				var mBtn2:Btn=new Btn("增添录入",addTypeIn);
				changeSprite.addChild(mBtn1);
				changeSprite.addChild(mBtn2);
				mBtn1.name = "mBtn1";
				mBtn2.name="mBtn2";
				mBtn2.y=mBtn1.y = airplaneInput.y + hisY;
				mBtn2.x=mBtn1.x+100;
			}
			else
			{
				var promit:Promit=new Promit();
				promit.txt.text = "数量不合法，或超额（一次最多录入3架航班信息）";
				changeSprite.addChild(promit);
			}
		}
		/*清空原有信息后录入*/
		private function newTypeIn():void{
			var n:uint = _xml.airplane.length();
			var tempXml:XML=
				<data>
					<airplane>
						<id></id>
						<be></be>
						<ed></ed>
						<date></date>
						<price></price>
						<rebate></rebate>
						<amount></amount>
					</airplane>
				</data>
			_xml=null;
			_xml=tempXml;
			for(var i:uint=0;i<_num;i++)
			{
				_tempXml = new XML(_xml.airplane[0]);
				_tempXml.airplane.id = MovieClip(changeSprite.getChildAt(i)).idtxt.text;
				_tempXml.airplane.be = MovieClip(changeSprite.getChildAt(i)).betxt.text;
				_tempXml.airplane.ed = MovieClip(changeSprite.getChildAt(i)).edtxt.text;
				_tempXml.airplane.date = MovieClip(changeSprite.getChildAt(i)).datetxt.text;
				_tempXml.airplane.price = MovieClip(changeSprite.getChildAt(i)).pricetxt.text;
				_tempXml.airplane.rebate = MovieClip(changeSprite.getChildAt(i)).rebatetxt.text;
				_tempXml.airplane.amount = MovieClip(changeSprite.getChildAt(i)).amounttxt.text;
				_xml.airplane[i] = _tempXml.airplane;
			}
			_airplaneData = SharedObject.getLocal("Airplane","/");
			_airplaneData.data.airplaneXmlData = _xml;
			MovieClip(changeSprite.getChildByName("mBtn1")).alpha = 0.3;
		}
		/*航班信息的增添录入*/
		private function addTypeIn():void{
			var n:uint = _xml.airplane.length();
			for(var i:uint=0;i<_num;i++)
			{
				_tempXml = new XML(_xml.airplane[0]);
				_tempXml.airplane.id = MovieClip(changeSprite.getChildAt(i)).idtxt.text;
				_tempXml.airplane.be = MovieClip(changeSprite.getChildAt(i)).betxt.text;
				_tempXml.airplane.ed = MovieClip(changeSprite.getChildAt(i)).edtxt.text;
				_tempXml.airplane.date = MovieClip(changeSprite.getChildAt(i)).datetxt.text;
				_tempXml.airplane.price = MovieClip(changeSprite.getChildAt(i)).pricetxt.text;
				_tempXml.airplane.rebate = MovieClip(changeSprite.getChildAt(i)).rebatetxt.text;
				_tempXml.airplane.amount = MovieClip(changeSprite.getChildAt(i)).amounttxt.text;
				_xml.airplane[n+i] = _tempXml.airplane;
			}
			_airplaneData = SharedObject.getLocal("Airplane","/");
			_airplaneData.data.airplaneXmlData = _xml;
			MovieClip(changeSprite.getChildByName("mBtn2")).alpha = 0.3;
		}
		//增加航班
		private function addAirplane():void
		{
			removeEl(changeSprite);
			resultOrBack();
			_id = String(setSprite.setChange.inputtxt.text);
			_num = findSite(_id);
			if (_num==-1)
			{
				var airplaneInput:AirplaneInput=new AirplaneInput();
				airplaneInput.name = "airplaneInput";
				var promit1:Promit=new Promit();
				var mBtn:Btn = new Btn("确认添加",affirmAdd);
				mBtn.name = "mBtn";
				promit1.txt.text = "请输入添加的航班信息:";
				changeSprite.addChild(promit1);
				changeSprite.addChild(airplaneInput);
				changeSprite.addChild(mBtn);
				airplaneInput.y = promit1.y + 30;
				mBtn.y = airplaneInput.y + 70;
			}
			else
			{
				var promit:Promit=new Promit();
				promit.txt.text = "此航班已存在,请确认添加的航班信息";
				changeSprite.addChild(promit);
			}
		}
		/*增添航班信息*/
		private function affirmAdd():void
		{
			var num:uint = _xml.airplane.length();
			_tempXml = new XML(_xml.airplane[0]);
			_tempXml.airplane.id = MovieClip(changeSprite.getChildByName("airplaneInput")).idtxt.text;
			_tempXml.airplane.be = MovieClip(changeSprite.getChildByName("airplaneInput")).betxt.text;
			_tempXml.airplane.ed = MovieClip(changeSprite.getChildByName("airplaneInput")).edtxt.text;
			_tempXml.airplane.date = MovieClip(changeSprite.getChildByName("airplaneInput")).datetxt.text;
			_tempXml.airplane.price = MovieClip(changeSprite.getChildByName("airplaneInput")).pricetxt.text;
			_tempXml.airplane.rebate = MovieClip(changeSprite.getChildByName("airplaneInput")).rebatetxt.text;
			_tempXml.airplane.amount = MovieClip(changeSprite.getChildByName("airplaneInput")).amounttxt.text;
			_xml.airplane[num] = _tempXml.airplane;
			_airplaneData = SharedObject.getLocal("Airplane","/");
			_airplaneData.data.airplaneXmlData = _xml;
			MovieClip(changeSprite.getChildByName("mBtn")).alpha = 0.3;

		}
		//删除航班
		private function deleteAirplane():void
		{
			removeEl(changeSprite);
			resultOrBack();
			_id = String(setSprite.setChange.inputtxt.text);
			_num = findSite(_id);
			if (_num!=-1)
			{
				var _airplaneXml:XML = _xml.airplane[_num];
				var airplane:AirplaneInformation = new AirplaneInformation(_airplaneXml.id,_airplaneXml.be,_airplaneXml.ed,_airplaneXml.date,_airplaneXml.amount,_airplaneXml.price,_airplaneXml.rebate);
				var promit1:Promit=new Promit();
				var mBtn:Btn = new Btn("确认删除",ConfirmDeletions);
				mBtn.name = "mBtn";
				promit1.txt.text = "要删除的航班详情为:";
				changeSprite.addChild(promit1);
				changeSprite.addChild(airplane);
				changeSprite.addChild(mBtn);
				airplane.y = promit1.y + 30;
				mBtn.y = airplane.y + 70;
			}
			else
			{
				var promit:Promit=new Promit();
				promit.txt.text = "查无此航班，请确认后再修改！";
				changeSprite.addChild(promit);
			}
		}
		/*删除航班信息*/
		private function ConfirmDeletions():void
		{
			delete _xml.airplane[_num];
			_airplaneData = SharedObject.getLocal("Airplane","/");
			_airplaneData.data.airplaneXmlData = _xml;
			MovieClip(changeSprite.getChildByName("mBtn")).alpha = 0.3;
		}
		//修改航班
		private function changeAirplane():void
		{
			removeEl(changeSprite);
			resultOrBack();
			_id = String(setSprite.setChange.inputtxt.text);
			_num = findSite(_id);
			if (_num!=-1)
			{
				var _airplaneXml:XML = _xml.airplane[_num];
				var airplane:AirplaneInformation = new AirplaneInformation(_airplaneXml.id,_airplaneXml.be,_airplaneXml.ed,_airplaneXml.date,_airplaneXml.amount,_airplaneXml.price,_airplaneXml.rebate);
				var airplaneInput:AirplaneInput=new AirplaneInput();
				airplaneInput.name = "airplaneInput";
				var promit1:Promit=new Promit();
				var promit2:Promit=new Promit();
				var mBtn:Btn = new Btn("确认修改",UpdateAcknowledge);
				mBtn.name = "mBtn";
				promit1.txt.text = "要修改的航班详情为:";
				promit2.txt.text = "请输入修改后的航班信息:";
				changeSprite.addChild(promit1);
				changeSprite.addChild(promit2);
				changeSprite.addChild(airplane);
				changeSprite.addChild(airplaneInput);
				changeSprite.addChild(mBtn);
				airplane.y = promit1.y + 30;
				promit2.y = airplane.y + 70;
				airplaneInput.y = promit2.y + 30;
				mBtn.y = airplaneInput.y + 70;
			}
			else
			{
				var promit:Promit=new Promit();
				promit.txt.text = "查无此航班，请确认后再修改！";
				changeSprite.addChild(promit);
			}
		}
		/*修改航班信息*/
		private function UpdateAcknowledge():void
		{
			_tempXml = new XML(_xml.airplane[_num]);
			_tempXml.airplane.id = MovieClip(changeSprite.getChildByName("airplaneInput")).idtxt.text;
			_tempXml.airplane.be = MovieClip(changeSprite.getChildByName("airplaneInput")).betxt.text;
			_tempXml.airplane.ed = MovieClip(changeSprite.getChildByName("airplaneInput")).edtxt.text;
			_tempXml.airplane.date = MovieClip(changeSprite.getChildByName("airplaneInput")).datetxt.text;
			_tempXml.airplane.price = MovieClip(changeSprite.getChildByName("airplaneInput")).pricetxt.text;
			_tempXml.airplane.rebate = MovieClip(changeSprite.getChildByName("airplaneInput")).rebatetxt.text;
			_tempXml.airplane.amount = MovieClip(changeSprite.getChildByName("airplaneInput")).amounttxt.text;
			_xml.airplane[_num] = _tempXml.airplane;
			_airplaneData = SharedObject.getLocal("Airplane","/");
			_airplaneData.data.airplaneXmlData = _xml;
			MovieClip(changeSprite.getChildByName("mBtn")).alpha = 0.3;
		}
		private function resultOrBack():void
		{
			backBtn.alpha = 1;
			backBtn.buttonMode = true;
			backBtn.addEventListener(MouseEvent.CLICK,back);
			changeSprite.x = _windowsWidth;
			changeSprite.y = _windowsHeight / 4;
			setSprite.removeChildAt(1);
			setSprite.alpha = 0;
			removeEl(buttonSprite);
			_myTween = new Tween(changeSprite,"x",Strong.easeInOut,changeSprite.x,0,1,true);
		}
		private function back(event:MouseEvent):void
		{
			backBtn.buttonMode = false;
			backBtn.removeEventListener(MouseEvent.CLICK,back);
			_myTween = new Tween(changeSprite,"x",Strong.easeInOut,changeSprite.x,_windowsWidth,1,true);
			initButtonList();
			removeEl(changeSprite);
		}
		private function findSite(str:String):int
		{
			var i:int = 0;
			/*遍历整个xml文件顺序表，获取符合条件航班信息在顺序表中的索引，若不满足则返回-1*/
			for each (var _airplaneXml:XML in _xml.airplane)
			{
				/*i表顺序表中每条航班的顺序索引*/
				i = _airplaneXml.childIndex();
				if (str==String(_airplaneXml.id))
				{
					/*满足条件之则返回索引值*/
					return i;
					break;
				}
			}
			i=-1;
			return i;//否则返回-1;
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