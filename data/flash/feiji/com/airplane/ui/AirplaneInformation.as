package com.airplane.ui
{
	import flash.display.MovieClip;
	public class AirplaneInformation extends MovieClip
	{
		private var _id:String;//航班号
		private var _be:String;//起始站
		private var _ed:String;//终点站
		private var _date:String;//时间
		private var _amount:uint;//票数
		private var _price:Number;//价格
		private var _rebate:Number;//折扣
		public function AirplaneInformation(id:String="NUll",be:String="NULL",ed:String="Null",date:String="NULL",amount:uint=0,price:Number=0,rebate:Number=0)
		{//构造函数构造航班对象的内部属性
			_id=id;
			_be=be;      
			_ed=ed;
			_date=date;
			_amount=amount;
			_price=price;
			_rebate=rebate;
			init();
		}
		private function init():void{//可视化界面显示
			idtxt.text=_id;
			betxt.text=_be;
			edtxt.text=_ed;
			datetxt.text=_date;
			amounttxt.text=String(_amount);
			pricetxt.text=String(_price);
			rebatetxt.text=String(_rebate);
		}
	}
}