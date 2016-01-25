package com.me{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	public class Btn extends MovieClip{
		private var _str:String;
		private var _fun:Function;
		public var num:uint;
		public function Btn(str:String="无显示",fun:Function=noEvent())//构造函数对按键元件进行构造，传入的参数用于txt文本显示，与onClick函数的调用，函数的传递为引用传递。
		{
			_str=str;
			_fun=fun;
			init();
		}
		//按键显示效果的设置
		private function init():void{
			this.Bg.alpha=0;
			this.buttonMode=true;
			this.txt.mouseEnabled=false;
			this.txt.autoSize=TextFieldAutoSize.LEFT;
			this.txt.text=_str;
			this.txt.x=4;
			this.Bg.width=8+this.txt.width;
			this.addEventListener(MouseEvent.MOUSE_OVER,over);
			this.addEventListener(MouseEvent.MOUSE_OUT,out);
			this.addEventListener(MouseEvent.CLICK,onClick);
		}
		private function over(event:MouseEvent):void{
			this.Bg.alpha=0.5;
		}
		private function out(event:MouseEvent):void{
			this.Bg.alpha=0;
		}
		//接受事件传递的函数对象，即事件响应
		private function onClick(event:MouseEvent):void{
			_fun();
		}
		private function noEvent():void{
			trace("没有事件传递，所以什么都没发生哦！");
		}
	}
}