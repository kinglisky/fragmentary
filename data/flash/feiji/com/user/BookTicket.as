package com.user{
	import com.airplane.ui.AirplaneInformation;
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
	public class BookTicket extends Sprite{
		private var _windowsWidth:Number;
		private var _windowsHeight:Number;
		private var _airplaneXml:XML;
		private var _userXml:XML;
		private var _xmlLoader;
		private var _airplaneData:SharedObject;//储存对象；
		private var _userData:SharedObject;//用户信息对象。
		private var _myTween:Tween;
		private var _numAirplane:int;//用于记录目的航班的检索位置。
		private var _userNum:uint;//用于记录用户检索位置。
		public function BookTicket()
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
			initSetBook();
		}
		//设置订票
		private function initSetBook():void{
			Promit.alpha=0;
			Promit.x=0;
			Promit.y=0;
			setSprite.x=0;
			setSprite.y=0;
			setSprite.alpha=0;
			if(_userXml.user[_userNum].airplane!=null)
			{
				Promit.txt.text="您已经订购机票，如还需订票,请先退票！";
				Promit.alpha=1;
				_myTween=new Tween(Promit,"y",Strong.easeInOut,Promit.y,_windowsHeight/5,1,true);
				
			}
			else{
				setSprite.alpha=1;
				var mBtn:Btn=new Btn("订票",book);
				mBtn.name="mBtn";
				setSprite.addChild(mBtn);
				mBtn.x=setSprite.findAirplane.width+10;
				mBtn.y=0;
				_myTween=new Tween(setSprite,"y",Strong.easeInOut,setSprite.y,_windowsHeight/2,1,true);
			}
		}
		//订票信息判断
		private function book():void{
			Promit.alpha=1;
			var bool:Boolean;
			_myTween=new Tween(Promit,"y",Strong.easeInOut,Promit.y,_windowsHeight/5,1,true);
			var Id:String=String(setSprite.findAirplane.idtxt.text);
			_numAirplane=testId(Id);
			if(_numAirplane==-1)
			{
				bool=false;
			}
			else
			{
				bool=testAmount(_numAirplane);
			}
			if(_numAirplane!=-1&&bool)
			{
				findedAirplane();
			}
			else
			{
				if((!bool)&&_numAirplane!=-1)
				{
					Promit.txt.text="所查找航班已无机票，请查询其他航班！";
					var recommendBtn:Btn=new Btn("推荐航班",recommend);
					addChild(recommendBtn);
					recommendBtn.name="recommendBtn";
					recommendBtn.y=_windowsHeight/2;
					recommendBtn.x=setSprite.width+10;
				}
				else
				{
					Promit.txt.text="未找到对应航班，请从新确认航班信息！";
				}
			}
		}
		//推荐航班设置
		private function recommend():void{
			var id:String=String(_airplaneXml.airplane[_numAirplane].id);
			var be:String=String(_airplaneXml.airplane[_numAirplane].be);
			var ed:String=String(_airplaneXml.airplane[_numAirplane].ed);
			_numAirplane=findNewAirplane(id,be,ed);//找到与原索引起始终点站且有票的航班。
			if(_numAirplane!=-1)
			{
				findedAirplane();
			}
			else
			{
				Promit.txt.text="未找到推荐航班，请从新确认航班信息！";
			}
		}
		//设置查找目标航班
		private function findedAirplane():void{
			var tempXml:XML =XML(_airplaneXml.airplane[_numAirplane]);
			Promit.txt.text="请确认航班的详情！";
			setSprite.removeChild(setSprite.getChildByName("mBtn"));
			setSprite.alpha=0;
			if(getChildByName("recommendBtn")!=null)
			{
				removeChild(getChildByName("recommendBtn"));
			}
			var airplane:AirplaneInformation = new AirplaneInformation(tempXml.id,tempXml.be,tempXml.ed,tempXml.date,tempXml.amount,tempXml.price,tempXml.rebate);
			airplane.name="airplane";
			var affirmBtn:Btn=new Btn("确认",affirm);
			affirmBtn.name="affirmBtn";
			var cancelBtn:Btn=new Btn("取消",back);
			cancelBtn.name="cancelBtn";
			addChild(airplane);
			addChild(affirmBtn);
			addChild(cancelBtn);
			airplane.x=_windowsWidth;
			airplane.y=_windowsHeight/4;
			affirmBtn.y=airplane.y+airplane.height+10;
			cancelBtn.y=affirmBtn.y;
			cancelBtn.x=affirmBtn.width+10;
			_myTween=new Tween(airplane,"x",Strong.easeInOut,airplane.x,0,1,true);
		}
		//返回
		private function back():void{
			removeChild(getChildByName("airplane"));
			removeChild(getChildByName("affirmBtn"));
			removeChild(getChildByName("cancelBtn"));
			init();
		}
		//确认订票
		private function affirm():void{
			var amount:uint;
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
				</data>;
			
			tempXml.airplane=XML(_airplaneXml.airplane[_numAirplane]);
			amount=uint(_airplaneXml.airplane[_numAirplane].amount)-1;
			_userXml.user[_userNum].airplane=XML(tempXml.airplane);
			_airplaneXml.airplane[_numAirplane].amount=amount;
			_userData = SharedObject.getLocal("UserData","/");
			_userData.data.userXmlData=_userXml;
			_airplaneData = SharedObject.getLocal("Airplane","/");
			_airplaneData.data.airplaneXmlData=_airplaneXml;
			//trace(_userXml);
			MovieClip(getChildByName("affirmBtn")).alpha=0.3;
			
		}
		//当前航班无票时推荐航班，传入原查找航班的起始站、终点站、还有航班号
		private function findNewAirplane(id:String,be:String,ed:String):int
		{
			var i:int = 0;
			//遍历文件顺序表，生成每个航班的信息
			for each (var _tempXml:XML in _airplaneXml.airplane)
			{
				i = _tempXml.childIndex();
				//当查找的航班满足起始与终点站与原查找航班相同且航班号不同查找成功！
				if ((be==String(_tempXml.be))&&(ed==String(_tempXml.ed))&&(id!=String(_tempXml.id))&&(uint(_tempXml.amount)!=0))
				{
					return i;
					break;
				}
			}
			i=-1;
			return i;
		}
		//用于寻找目标航班那的文件索引
		private function testId(Id:String):int{
			var i:int = 0;
			//遍历顺序表，生成每条航班的信息
			for each (var _tempXml:XML in _airplaneXml.airplane)
			{
				i = _tempXml.childIndex();
				if (Id==String( _tempXml.id))
				{
					return i;
					break;
				}
			}
			i=-1;
			return i;
		}
		//判断查找的航班的票数是否为零
		private function testAmount(num:int):Boolean{
			var bool:Boolean=true;
			if(int(_airplaneXml.airplane[num].amount)<=0)
			{
				bool=false;
			}
			return bool;
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