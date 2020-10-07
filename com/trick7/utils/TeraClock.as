package com.trick7.utils {
	import flash.display.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;	

	/**
	* @author tera
	* サンプルコード（ドキュメントクラスとして設定すれば動きます）：
		package  {
			import flash.events.Event;
			import flash.display.Sprite;
			import com.trick7.utils.TeraClock;
			public class Main extends Sprite{
				public var clock:TeraClock;
				public function Main() {
					clock = new TeraClock();
					clock.addEventListener(TeraClock.SECONDS_CHANGED, secondsListener);
					clock.addEventListener(TeraClock.MINUTES_CHANGED, minutesListener);
					clock.addEventListener(TeraClock.HOURS_CHANGED, hoursListener);
				}
				private function secondsListener(e:Event):void {
					trace(clock.seconds + "秒です。現在：" +clock.hours+":"+clock.minutes+":"+clock.seconds+" です。" );
				}
				private function minutesListener(e:Event):void {
					trace(clock.minutes +"分になったよ。");
				}
				private function hoursListener(e:Event):void {
					trace(clock.hours+"時になったよ。");
				}
			}
		}
	*/
	public class TeraClock extends Sprite {
		public static const HOURS_CHANGED:String = "hoursChanged";
		public static const MINUTES_CHANGED:String = "minutesChanged";
		public static const SECONDS_CHANGED:String = "secondsChanged";
		private var _hours:int;
		private var _minutes:int;
		private var _seconds:int;
		private var _preSeconds:int;
		private var _gmt:int;
		// コンストラクタ関数。引数でタイムゾーンを設定できる。デフォルトは+9:00（日本）
		public function TeraClock(GMT:int = 9) {
			_gmt = GMT%24;
			this.enterFrameListener(null);
			addEventListener(Event.ENTER_FRAME, enterFrameListener);
		}
		
		private function enterFrameListener(e:Event):void {
			var date:Date = new Date();
			if(_gmt>=0){
				_hours = (date.getUTCHours() + _gmt) % 24;
			}else {
				_hours = (24+(date.getUTCHours() + _gmt)) % 24;
			}
			_minutes = date.getUTCMinutes();
			_seconds = date.getUTCSeconds();
			if (_seconds != _preSeconds) {
				//trace(_hours + ":" + _minutes + ":" + _seconds);
				dispatchEvent(new Event(SECONDS_CHANGED));
				if (_seconds == 0) {
					dispatchEvent(new Event(MINUTES_CHANGED));
					if (_minutes == 0) {
						dispatchEvent(new Event(HOURS_CHANGED));
					}
				}
			}
			_preSeconds = _seconds;
		}
		// 外部から値を取得するためのゲッター。セッターはとりあえずいらないや。
		public function get hours():int { return _hours; }
		public function get minutes():int { return _minutes; }
		public function get seconds():int { return _seconds; }
		public function get milliseconds():int { return (new Date()).getUTCMilliseconds(); }
		// 上位1桁返す
		public function get hoursUpper():int { return _hours / 10; }
		public function get minutesUpper():int { return _minutes / 10; }
		public function get secondsUpper():int { return _seconds / 10; }
		// 下位1桁返す
		public function get hoursLower():int { return _hours % 10; }
		public function get minutesLower():int  { return _minutes % 10; }
		public function get secondsLower():int { return _seconds % 10; }
		// 1桁の数の時を2桁にする。返り値は String 型になる。
		public function get hours2():String { return niketa(_hours); }
		public function get minutes2():String { return niketa(_minutes); }
		public function get seconds2():String { return niketa(_seconds); }
		// 1の位を切り捨てて2桁にする。返り値は String 型になる。
		public function get milliseconds2():String { return niketa((new Date()).getUTCMilliseconds() / 10); }
		// 3桁になるように接頭に0を付けくわえる。返り値は String 型になる。
		public function get milliseconds3():String { return keta((new Date()).getUTCMilliseconds(), 3); }
		// 2桁にして返す関数
		private function niketa(num:int):String {
			if (num < 10) {
				return String("0"+num);
			}else {
				return String(num);
			}
		}
		// 指定桁数にして返す関数
		private function keta(num:int, keta:int):String {
			var str:String = String(num);
			while(str.length < keta) str = "0" + str;
			return str;
		}
		//アナログ時計にした時の針の角度を返す。
		public function get hoursDegree():Number {
			return ((_hours % 12) * 30) + (_minutes / 2) + (_seconds/120);
		}
		public function get minutesDegree():Number {
			return (_minutes * 6) + (_seconds / 10);
		}
		public function get secondsDegree():Number {
			return _seconds * 6;
		}
		//現時刻からh時m分s秒だけずらした時間を取得する(戻り値のdateは元の時刻を0日としたときの差分)
		public function getDifferenceTime(s:int, m:int, h:int):Object {
			var time:Array = [_seconds, _minutes, _hours, 0];
			var dt:Array   = [s, m, h];
			var cap:Array  = [60, 60, 24];
			for(var i:int = 0; i < 3; ++i) {
				time[i] += dt[i];
				if(time[i] < 0) {
					time[i + 1] += Math.floor(time[i] / cap[i]);
					time[i] = time[i] % cap[i] + cap[i];
					continue;
				}
				if(time[i] >= cap[i]) {
					time[i + 1] += Math.floor(time[i] / cap[i]);
					time[i] = time[i] % cap[i];
					continue;
				}
			}
			return {seconds:time[0], minutes:time[1], hours:time[2], date:time[3]};
		}
	}
}