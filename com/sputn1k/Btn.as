
/*
	all code copyright SPUTN1K - kurt grüng - kurtgrung@gmail.com
*/

package com.sputn1k {

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;

	public class Btn extends Sprite {

		private var bg:Shape;
		private var labelField:TextField;
		private var _url:String;

		public function Btn() {
			
			bg = new Shape();
			bg.graphics.beginFill(0x999999, 1);
			bg.graphics.drawRect(0, 0, 10, 10);
			bg.alpha = 0;
			addChild(bg);

			labelField = new TextField();
			labelField.width = 200;
			labelField.height = 30;
			labelField.y = 15;
			
			var format:TextFormat = new TextFormat();
			format.align = "center";
			format.size = 14;
			format.font = "Verdana";
			
			labelField.defaultTextFormat = format;
			addChild(labelField);

			addEventListener(MouseEvent.ROLL_OVER, over);
			addEventListener(MouseEvent.ROLL_OUT, out);

			mouseChildren = false;
			buttonMode = true;
		}
		public function set label(text:String):void {
			labelField.text = text;
			var autoWidth:Number = Math.max(200,labelField.textWidth + 40);
			this.width = autoWidth;
		}
		public function get label():String {
			return labelField.text;
		}
		private function over(e:MouseEvent):void {
			//bg.alpha = 0.8;
		}
		private function out(e:MouseEvent):void {
			//bg.alpha = 1;
		}

		public function set url(theUrl:String):void {
			if (theUrl.indexOf("http://") == -1) {
				theUrl = "http://" + theUrl;
			}
			_url = theUrl;
		}

		public function get url():String {
			return _url;
		}

		override public function set width(w:Number):void {
			labelField.width = w;
			bg.width = w;
		}
		override public function set height(h:Number):void {
			labelField.height = h;
			labelField.y = (h - labelField.textHeight) / 2 - 3;
			bg.height = h;
		}
	}
}