package 
{
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.MovieClip;
	public class PhysicalPoint extends Point
	{
		private var vx:Number;
		private var vy:Number;
		private var ax:Number;
		private var ay:Number;
		private var f:Number;
		private var sakkiTime:Number;
		private var time:Timer;
		public function PhysicalPoint(xx:Number,yy:Number,ff:Number)
		{
			x = xx;
			y = yy;
			f = ff;
			init();
		}
		private function init():void
		{
			vx = 0;
			vy = 0;
			ax = 0;
			ay = 0;
			sakkiTime = new Date().getTime();
			time = new Timer(33);
			time.addEventListener(TimerEvent.TIMER, loop);
			time.start();
		}
		private function loop(event:TimerEvent):void
		{
			var nowTime:Number = new Date().getTime();
			var t:Number = (nowTime - sakkiTime) / 1000;
			x +=  vx * t + 0.5 * ax * t * t;
			y +=  vy * t + 0.5 * ay * t * t;
			vx +=  ax * t;
			vy +=  ay * t;
			vx *=  f;
			vy *=  f;
			ax = 0;
			ay = 0;
			sakkiTime = nowTime;
		}
		public function setKasoKudo(aax:Number, aay:Number):void
		{
			ax +=  aax;
			ay +=  aay;
		}
	}
}