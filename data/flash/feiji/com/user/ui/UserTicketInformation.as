package com.user.ui
{
	import flash.display.MovieClip;
	public class UserTicketInformation extends MovieClip
	{
		private var _id:String;//航班号
		private var _be:String;//起始站
		private var _ed:String;//终点站
		private var _date:String;//日期
		private var _amount:uint;//座位号
		private var _price:Number;//价格
		public function UserTicketInformation(id:String="NUll",be:String="NULL",ed:String="Null",date:String="NULL",amount:uint=0,price:Number=0)
		{//初始构造对象内部属性
			_id=id;
			_be=be;
			_ed=ed;
			_date=date;
			_amount=amount;
			_price=price;
			init();
		}
		private function init():void{
			idtxt.text=_id;
			betxt.text=_be;
			edtxt.text=_ed;
			datetxt.text=_date;
			amounttxt.text=String(_amount);
			pricetxt.text=String(_price);
		}
	}
}