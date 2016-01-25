package com.me{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	public class NoEventBtn extends MovieClip{
		private var _str:String;
		public  var num:uint;//用于标示按键的索引。
		public function NoEventBtn(str:String="无显示")//构造函数对按键元件进行构造，传入的参数用于txt文本显示，与onClick函数的调用，函数的传递为引用传递。
		{
			_str=str;
			init();
		}
		//按键的显示效果设置
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
		}
		private function over(event:MouseEvent):void{
			this.Bg.alpha=0.5;
		}
		private function out(event:MouseEvent):void{
			this.Bg.alpha=0;
		}
	}
}