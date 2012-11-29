
/*
	all code copyright SPUTN1K - kurt grüng - kurtgrung@gmail.com
*/

package com.sputn1k {

	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;

	public class Scroller extends MovieClip {

		private var min:Number;
		private var max:Number;
		public var per:uint;
		private var cony:Number;

		public function Scroller() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		public function init(event:Event = null):void {

			reset();
			
			this.con.mask = this.maskmc;
			
			this.min = background.y;
			this.max = background.y + background.height - ruler.height;
			
			this.ruler.buttonMode = true;
			
			this.cony = con.y;
			
			this.min = 0;
			this.max = this.background.height - this.ruler.height;

			ruler.addEventListener(MouseEvent.MOUSE_DOWN, click);
			stage.addEventListener(MouseEvent.MOUSE_UP, release);
			this.addEventListener(Event.ENTER_FRAME, enter);
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, wheel);
		}
		
		private function wheel(event:MouseEvent):void {				
			if ((event.delta > 0 && ruler.y < background.height - ruler.height) || (event.delta < 0 && ruler.y > 0)) {
				ruler.y = ruler.y + (event.delta * 8);
			}
		}

		private function click(event:MouseEvent) {
			var rect:Rectangle = new Rectangle(background.x-(ruler.width/2)+1, min, 0, max);
			ruler.startDrag(false, rect);
		}

		private function release(event:MouseEvent) {
			ruler.stopDrag();
		}

		private function enter(event:Event) {
			positionContent();
		}

		public function positionContent():void {

			var downy:Number = con.height - (maskmc.height / 2) + 20;
			per = (100 / max) * ruler.y;
			
			checklen();

			var sum:Number = cony - (((downy - (maskmc.height/2)) / 100) * per);
			var pos:int = con.y;
			var finalpos:Number = sum;

			if (pos != finalpos) {
				var diff:Number = finalpos - pos;
				pos += diff / 4;
			}
			
			con.y = pos;
		}

		public function checklen():void {
			if (con.height < maskmc.height) {
				ruler.visible = false;
			} else {
				ruler.visible = true;
			}
		}

		public function reset():void {
			con.y = 0;
			ruler.y = 0;
		}
	}
}