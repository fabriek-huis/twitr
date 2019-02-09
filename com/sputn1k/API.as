
/*
	all code copyright SPUTN1K - kurt grüng - kurtgrung@gmail.com	
*/

package com.sputn1k {
	
    import flash.display.*;
    import flash.net.*;
    import flash.events.*;
    import flash.text.*;
    import com.adobe.serialization.json.*; 

    public class API extends Sprite {

    	public function API(screenname) {
		Twitr.instance.output("/////// Twitr - API init ///////");
    		init(Twitr.instance.loc()+"https://api.twitter.com/1/users/show.json?screen_name="+screenname+"&include_entities=true");			
    	}

    	public function init(resource:String):void {
			
    		var loader:URLLoader = new URLLoader();
    		var request:URLRequest = new URLRequest(resource);
			
    		loader.addEventListener(Event.COMPLETE, complete);
		
			loader.addEventListener(IOErrorEvent.IO_ERROR, error);
    		
			loader.load(request);
			
			function error(event:IOErrorEvent){
				Twitr.instance.output("error= "+ event);
				Twitr.instance.error("Error Connecting to Twitter API.");
			}
			
			function complete(event:Event):void {			
				
				var jsonDatax:Object = JSON.decode(loader.data);
				
				for (var i:String in jsonDatax){
					Twitr.instance.output(i + ": " + jsonDatax[i]);
					Twitr.instance.data(i,jsonDatax[i]);
				}
			}
		}
    }
}
