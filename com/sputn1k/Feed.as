
/*
	all code copyright SPUTN1K - kurt grüng - kurtgrung@gmail.com	
*/

package com.sputn1k {
	
    import flash.display.*;
    import flash.net.*;
    import flash.events.*;
    import flash.text.*;

    public class Feed extends Sprite {

    	public function Feed(screenname) {
			Twitr.instance.output("/////// Twitr - Feed init ///////");
			init(Twitr.instance.loc()+"http://api.twitter.com/1/statuses/user_timeline.rss?screen_name="+screenname);
		}

    	public function init(resource:String):void {
			
			var date:Date = new Date();
			var cache:String = "?nocache="+date.getSeconds()+date.getMilliseconds();
			
			var xml:XML;
			var loader:URLLoader = new URLLoader();
			
    		var request:URLRequest = new URLRequest(resource);
			
			var offset:Number = 50;
			var spacer:Number = 2;
			
			loader.addEventListener(Event.COMPLETE, complete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, error);
			
			loader.load(request);
			
			function error(event:IOErrorEvent){
				Twitr.instance.output("error= "+ event);
				Twitr.instance.error("Error Loading Twitter Data.");
			}
			
			function complete(event:Event):void {
				
				xml = new XML(event.target.data);
				xml = Twitr.instance.ns(xml);
				Twitr.instance.output("xml= "+xml);
				
				for (var i:int = 0; i<xml.channel.item.length(); i++){
					
					Twitr.instance.output("#"+i+
						  "\ndescription: "+xml.channel.item[i].description+
						  "\nlink: http:"+xml.channel.item[i].link+
						  "\ndate: "+xml.channel.item[i].pubDate
						  );
					
					Twitr.instance.tweet(i, xml.channel.item[i].title, xml.channel.item[i].pubDate, xml.channel.item[i].link);
				}
			}
		}
    }
}
