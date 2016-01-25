package 
{
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	public class Lines extends MovieClip
	{
		private var pt:PhysicalPoint;
		private var time:Timer;
		public function Lines()
		{
			init();
		}
		private function init():void
		{
			pt = new PhysicalPoint(this.stage.stageWidth / 2,this.stage.stageHeight / 2,0.9);
			time = new Timer(33);
			time.addEventListener(TimerEvent.TIMER, inTime);
			time.start();
		}
		private function inTime(event:TimerEvent):void
		{
			pt.setKasoKudo((this.mouseX - pt.x) * 10, (this.mouseY - pt.y) * 10);
			this.graphics.clear();
			var div:Number = 64;
			var hankei:Number = 100;
			this.graphics.lineStyle(6,0xFF0000);
			for (var i:Number = 0; i<div; ++i)
			{
				var colorNum:uint = Math.random() * 0xffffff;
				var px:Number = this.stage.stageWidth / 2 + hankei * Math.cos(Math.PI * 2.0 * i / div);
				var py:Number = this.stage.stageHeight / 2 + hankei * Math.sin(Math.PI * 2.0 * i / div);
				this.graphics.moveTo(px, py);
				this.graphics.beginFill(colorNum);
				this.graphics.lineStyle(1, colorNum, 0);
				this.graphics.drawCircle(px, py, 2);
				this.graphics.endFill();
				this.graphics.moveTo(px, py);
				this.graphics.lineStyle(1,colorNum);
				this.graphics.lineTo(pt.x,pt.y);
			}
		}
	}
}