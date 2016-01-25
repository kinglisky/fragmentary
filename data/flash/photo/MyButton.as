package 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	public class MyButton extends Sprite
	{
		private var _label:String;
		private var _buttonColor:uint;
		private var _num:uint;
		private var _colorT:ColorTransform;
		private var _winterval:uint = 8;
		private var _hinterval:uint = 4;
		private var _name:String;
		public function MyButton(str:String="NoName",bColor:uint=0XCCCCCC,n:uint=0)
		{
			_label = str;
			_buttonColor = bColor;
			_num = n;
			_colorT = new ColorTransform();
			if (stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		private function init(event:Event=null):void
		{
			_colorT.color = _buttonColor;
			this.Bg.transform.colorTransform = _colorT;
			this.Bg.alpha = 0;
			this.buttonMode = true;
			this.Label.mouseEnabled = false;
			this.Label.autoSize = TextFieldAutoSize.LEFT;
			this.Label.text = _label;
			this.Bg.width = _winterval + this.Label.width;
			this.Bg.height = _hinterval + this.Label.height;
			this.Label.x = _winterval / 2;
			this.Label.y = _hinterval / 2;
			this.addEventListener(MouseEvent.MOUSE_OVER,over);
			this.addEventListener(MouseEvent.MOUSE_OUT,out);
		}
		private function over(event:MouseEvent):void
		{
			this.Bg.alpha = 0.5;
		}
		private function out(event:MouseEvent):void
		{
			this.Bg.alpha = 0;
		}
		public function get Num():uint
		{
			return _num;
		}
	}
}