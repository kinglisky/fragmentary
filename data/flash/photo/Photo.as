package {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import flash.geom.ColorTransform;
	import flash.ui.Mouse;
	import flash.system.Capabilities;
	public class Photo extends Sprite
	{
		private var n:uint = 6;
		private var nameArr:Array = ["原图","锐化","浮雕","模糊","正片","黑白"];
		public function Photo()
		{
			stage.stageWidth=Capabilities.screenResolutionX;
			stage.stageHeight=Capabilities.screenResolutionY;
			init();
		}
		private function init():void
		{
			trace(Capabilities.screenResolutionX);
			trace(Capabilities.screenResolutionY);
			trace(stage.stageWidth);
			trace(stage.stageHeight);
			var interval:uint = 60;
			var btnSprite:Sprite = new Sprite();
			btnSprite.x = 50;
			btnSprite.y = 50;
			for (var i:uint=0; i < n; i++ )
			{
				var myBtn:MyButton = new MyButton(nameArr[i], 0XFFF6CB, i);
				myBtn.addEventListener(MouseEvent.CLICK, photoChange);
				myBtn.x = interval * i;
				btnSprite.addChild(myBtn);
			}
			addChild(btnSprite);
		}
		private function photoChange(event:MouseEvent):void 
		{
			var num:uint = event.currentTarget.Num;
			trace(num);
			switch(num)
			{
				case 0:toOriginal(); break;
				case 1:toSharpen(); break;
				case 2:toEmboss(); break;
				case 3:toBlur(); break;
				case 4:toNegative(); break;
				case 5:toGrayscale(); break;
			}	
		}
		private function toOriginal():void
		{
			var original:Array = [0, 0, 0, 0, 1, 0, 0, 0, 0];
			CF(photo,original,0);
		}
		private function toPositive():void
		{
			var posi:ColorTransform = new ColorTransform();
			posi.redMultiplier = 1;
			posi.greenMultiplier = 1;
			posi.blueMultiplier = 1;
			posi.alphaMultiplier = 1;
			posi.redOffset = 0;
			posi.greenOffset = 0;
			posi.blueOffset = 0;
			photo.transform.colorTransform = posi;
			
		}
		private function toNegative():void
		{
			toOriginal();
			toPositive();
			var posi:ColorTransform = new ColorTransform();
			posi.redMultiplier = -1;
			posi.greenMultiplier = -1;
			posi.blueMultiplier = -1;
			posi.alphaMultiplier = 1;
			posi.redOffset = 255;
			posi.greenOffset = 255;
			posi.blueOffset = 255;
			photo.transform.colorTransform = posi;	
		}
		private function toGrayscale():void
		{
			toOriginal();
			toPositive();
			var Rd:Number = 0.2127;
			var Gr:Number = 0.7152;
			var Bl:Number = 0.0722;
			var gray:ColorMatrixFilter = new ColorMatrixFilter([Rd, Gr, Bl, 0, 0, Rd, Gr, Bl, 0, 0, Rd, Gr, Bl, 0, 0, 0, 0, 0, 1, 0]);
			photo.filters = [gray];
		}
		private function toSharpen():void
		{
			toOriginal();
			toPositive();
			var sharpen:Array = [0, -1, 0, -1, 5, -1, 0, -1, 0];
			CF(photo,sharpen,0);
		}
		private function toEmboss():void
		{
			toOriginal();
			toPositive();
			var emboss:Array = [ -2, -2, 0, -2, 1, 2, 0, 2, 2];
			CF(photo,emboss,0);
		}
		private function toBlur():void
		{
			toOriginal();
			toPositive();
			var blur:Array = [0, 1.5, 0, 1.5, 1.5, 1.5, 0, 1.5, 0];
			CF(photo, blur, 7);
		}
		private function CF(displayObj:DisplayObject, matrix:Array, divisor:int):void
		{
			var cf:ConvolutionFilter = new ConvolutionFilter(3, 3, matrix, divisor);
			displayObj.filters = [cf];
		}
	}
}