package com.airplane
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;//SharedObject类用于文件的信息的储存，文件储存于falsh的cookie空间中。
	import flash.ui.Mouse;//滚轮响应事件的响应包。
	import flash.filters.BitmapFilter;//对滚动栏模糊效果的设置用的包。
	import flash.filters.BitmapFilterQuality;//对滚动栏模糊效果的设置用的包。
	import flash.filters.BlurFilter;//对滚动栏模糊效果的设置用的包。
	import com.airplane.ui.AirplaneInformation;//用于生成航班的类
	public class BrowseAirplane extends Sprite
	{
		private var _xml:XML;
		private var _xmlLoader:URLLoader;
		private var _airplaneData:SharedObject;
		private var _scroll_rect:Rectangle;
		private var _speedfactor:Number = 2;
		private var _ty:Number = 0;
		public function BrowseAirplane()
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
		//选择加载默认文件或本地文件
		private function init(e:Event = null):void
		{
			_airplaneData= SharedObject.getLocal("Airplane","/");
			if (_airplaneData.data.airplaneXmlData != null)
			{
				trace("不是空的！");
				_xml=XML(_airplaneData.data.airplaneXmlData);
				loaded();
				
			}
			else
			{
				_xmlLoader = new URLLoader(new URLRequest("com/airplane/data/airplaneData.xml"));
				_xmlLoader.addEventListener(Event.COMPLETE,xmlLoader);
			}
		}
		//加载默认xml文件
		private function xmlLoader(event:Event):void
		{
			_xml = XML(_xmlLoader.data);
			loaded();
		}
		private function loaded():void{
			initAirplaneList();
			airplaneSprite.mask = mMasker;
			initScrollBar();//航班信息滚动效果的设置
			
		}
		private function initAirplaneList():void
		{
			for each (var _airplaneXml:XML in _xml.airplane)
			{/*遍历xml文件的的每个airplane节点，生成每个节点对应的航班信息xml文件*/
				var _airplane:AirplaneInformation = new AirplaneInformation(_airplaneXml.id,_airplaneXml.be,_airplaneXml.ed,_airplaneXml.date,_airplaneXml.amount,_airplaneXml.price,_airplaneXml.rebate);
				var i:uint = _airplaneXml.childIndex();
				/*i表示航班在每条航班在xml文件的索引*/
				_airplane.name = "p" + i;
				airplaneSprite.addChild(_airplane);
				_airplane.y = 80 * (i + 0.5);
			}
		}
		/*以下是对航班信息窗口滚动效果的设置*/
		private function initScrollBar():void
		{
			_scroll_rect = new Rectangle(mScrollHandler.mScrollArea.x,mScrollHandler.mScrollArea.y,0,mScrollHandler.mScrollArea.height);
			mScrollHandler.mThumb.buttonMode = true;
			mScrollHandler.mThumb.mouseChildren = false;
			mScrollHandler.mThumb.addEventListener(MouseEvent.MOUSE_DOWN,press_drag);
			mScrollHandler.mThumb.stage.addEventListener(MouseEvent.MOUSE_UP,release_drag);
			mScrollHandler.mThumb.addEventListener(MouseEvent.MOUSE_OVER,over_drag);
			mScrollHandler.mThumb.addEventListener(MouseEvent.MOUSE_OUT,out_drag);
			airplaneSprite.stage.addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheel);
			addEventListener(Event.ENTER_FRAME,contentEnterFrame);
		}
		private function mouseWheel(event:MouseEvent):void
		{
			mScrollHandler.mThumb.y -=  event.delta * 3;
			if (mScrollHandler.mThumb.y > mScrollHandler.mScrollArea.height)
			{
				mScrollHandler.mThumb.y = mScrollHandler.mScrollArea.height;
			}
			else if (mScrollHandler.mThumb.y < 0)
			{
				mScrollHandler.mThumb.y = 0;
			}
			_ty = mMasker.height - airplaneSprite.height * mScrollHandler.mThumb.y / mScrollHandler.mScrollArea.height - mScrollHandler.mThumb.height;
		}
		private function over_drag(event:MouseEvent):void
		{
			event.target.mBlue.visible = false;
		}
		private function out_drag(event:MouseEvent):void
		{
			event.target.mBlue.visible = true;
		}
		private function press_drag(event:MouseEvent):void
		{
			mScrollHandler.mThumb.startDrag(false,_scroll_rect);
			mScrollHandler.mThumb.addEventListener(Event.ENTER_FRAME,drag);
		}
		private function release_drag(event:MouseEvent):void
		{
			mScrollHandler.mThumb.alpha = 1;
			mScrollHandler.mThumb.removeEventListener(Event.ENTER_FRAME,drag);
			mScrollHandler.mThumb.stopDrag();
		}
		private function drag(event:Event):void
		{
			mScrollHandler.mThumb.alpha = .8;
			_ty = mMasker.height - airplaneSprite.height * mScrollHandler.mThumb.y / mScrollHandler.mScrollArea.height - mScrollHandler.mThumb.height;
		}
		private function contentEnterFrame(event:Event):void
		{
			var _move:Number = ((_ty - airplaneSprite.y) / _speedfactor);
			airplaneSprite.y +=  _move;
			airplaneSprite.filters = [new BlurFilter(0,Math.abs(_move),BitmapFilterQuality.HIGH)];
			if (Math.abs((_ty - airplaneSprite.y)) < 0.1)
			{
				airplaneSprite.y = _ty;
			}
		}
	}
}