
/*
	all code copyright SPUTN1K - kurt grüng - kurtgrung@gmail.com
*/

package  com.sputn1k {
		
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.external.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	import fl.transitions.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.geom.*;
	import flash.external.*;
	import flash.system.*;
	
	public class Twitr extends MovieClip {
		
		//// settings ////
		
		var screenname = "sputn1k";
		var domain = "http://sputn1k.com/twitr/";
		
		//////////////////
		
		Security.allowDomain("*");
		
		private static var _instance:Twitr;
		
		public static function get instance():Twitr { 
			return _instance;
		}
		
		private var api:API;
		private var feed:Feed;
		private var ui:UI = new UI();
		private var header:Btn = new Btn();
		private var scroller:Scroller = new Scroller();
		
		private var tf:TextField = new TextField();
		private var format:TextFormat = new TextFormat();
		
		private var debug:Boolean = true;
		private var offset:Number = 55;
		private var spacer:Number = 2;
		private var date:Date = new Date();
		private var cache:String = "?nocache="+date.getSeconds()+date.getMilliseconds();
		
		public function Twitr() {
			
			_instance = this;
			
			format.font = "Verdana";
			format.color = 0x000000;
			format.size = 10;
			
			tf.width = 200;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.wordWrap = true;
			tf.htmlText = "true";
			tf.multiline = true;
			tf.selectable = false;
			tf.defaultTextFormat = format;
			tf.text = "Loading Data..";
			
			scroller.x = 19.3;
			scroller.y = 104;
			scroller.background.alpha = 0.20;
			
			header.x = 0;
			header.y = 0;
			header.label = "";
			header.width = stage.stageWidth;
			header.height = 100;
			header.url = "http://twitter.com/"+screenname;
			header.addEventListener(MouseEvent.CLICK, click);
			
			ui.follow.addEventListener(MouseEvent.CLICK, down);
			
			api = new API(screenname);
			feed = new Feed(screenname);
			
			scroller.con.addChild(tf);
			addChild(ui);
			addChild(header);
			addChild(scroller);
		}
		
		function error(data){
			tf.text = data;
		}
		
		function tweet(num, copy, date, link){
			
			if(num == 0){
				tf.text = "";
			}
				
			var box:twitrBox = new twitrBox();			
			scroller.con.addChild(box);
			
			box.buttonMode = true;
			box.useHandCursor = true;
			box.hit.addEventListener(MouseEvent.CLICK, down);
		
			function down(event:MouseEvent):void {
				var url:URLRequest = new URLRequest("http:"+link);
				navigateToURL(url, "_blank");
			}
			
			box.retweet.addEventListener(MouseEvent.CLICK, retweetDown);
		
			function retweetDown(event:MouseEvent):void {
				navigateToURL(new URLRequest("https://twitter.com/intent/tweet?original_referer="+escape("http:"+link)+"%2F&source="+escape("http:"+link)+"&text="+escape("RT "+copy)+""));
			}
			
			box.reply.addEventListener(MouseEvent.CLICK, replyDown);
		
			function replyDown(event:MouseEvent):void {
				navigateToURL(new URLRequest("https://twitter.com/intent/tweet?original_referer="+escape("http:"+link)+"%2F&source="+escape("http:"+link)+"&text="+escape("@"+screenname)+" "));			
			}
			
			if(num == 0){
				//
			} else {
				box.y = offset+spacer;
				offset = offset+55+spacer;
			}
			
			copy = copy.split("&apos;").join("'");
			copy = copy.split("&quot;").join("''");
			copy = copy.split("&gt;").join(">");
			copy = copy.split("&lt;").join("<");
			copy = copy.split("&amp;").join("&");
			box.msg.text = copy;
							
			date = date.split("+0000").join("");
			date = date.slice(0, date.length-3);
			box.date.text = date;
		}
		
		public function output(data) {
			if(debug == true){
				trace(data);
			}
		}
		
		public function data(name,data) {
						
			if(name == "description"){
				
				function measure(str:String, format:TextFormat):Rectangle {
					var textField:TextField = new TextField();
					textField.defaultTextFormat = format;
					textField.text = str;					
					return new Rectangle(0, 0, textField.textWidth, textField.textHeight);
				}
				
				var format:TextFormat = new TextFormat();
				format.font = "Market Deco";
				format.size = 13;
				
				var sum:Number = measure(data, format).width;
				var calculated:Number = sum;
				var len:Number = 208.6;
				
				ui.d.autoSize = TextFieldAutoSize.LEFT;
				ui.d.text = data;
				
				var interval:uint = setInterval (init, 500);
							
				function init(){
					clearInterval(interval);
					var tween:Tween = new Tween(ui.d, "x", None.easeNone, ui.d.x, ui.d.x-calculated+len, 20, true);
				}				
			}
			
			if(name == "name"){
				ui.n.text = "@"+data;
			}
			
			if(name == "followers_count"){
				ui.f.text = "followers "+data;
			}
			
			if(name == "profile_image_url_https"){
				
				data = data.split("_normal").join("_bigger");
				
				var loader:Loader = new Loader();
				loader.load(new URLRequest(loc()+data));
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
				
				function loaded(event:Event):void{
					
					var bit:Bitmap;
					bit = Bitmap(loader.content);
					bit.smoothing = true;
					ui.photo.addChild(bit);
				}
			}
		}
		
		public function loc(){
			
			var loc = ExternalInterface.call("window.location.href.toString");
			
			if(loc == null){
				loc = "";
			} else {
				loc = domain+"proxy.php?url=";
			}
			
			return loc;
		}
		
		public function ns( value:XML ):XML {
			return new XML( value.toXMLString().replace(/(xmlns(:\w*)?=\".*?\")/gim, "").replace(  /\w+:/gim, "" ));
		}
		
		private function click(event:MouseEvent):void {
			navigateToURL(new URLRequest(event.target.url));
		}
		
		private function down(event:MouseEvent):void {
			navigateToURL(new URLRequest("http://twitter.com/"+screenname));
		}
	}
}