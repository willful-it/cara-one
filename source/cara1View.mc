using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.ActivityMonitor;

class cara1View extends WatchUi.WatchFace {

	var bitmapBattery000; 
	var bitmapBattery025;
	var bitmapBattery050;
	var bitmapBattery075;
	var bitmapBattery100;
	var bitmapFire;
	    
    function initialize() {
        WatchFace.initialize();
        
		bitmapBattery000 = WatchUi.loadResource(Rez.Drawables.battery_000);
		bitmapBattery025 = WatchUi.loadResource(Rez.Drawables.battery_025);
		bitmapBattery050 = WatchUi.loadResource(Rez.Drawables.battery_050);
		bitmapBattery075 = WatchUi.loadResource(Rez.Drawables.battery_075);
		bitmapBattery100 = WatchUi.loadResource(Rez.Drawables.battery_100);		
		bitmapFire = WatchUi.loadResource(Rez.Drawables.fire);
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {        
        var cx = (dc.getWidth() / 2);
        var cy = (dc.getHeight() / 2);                    
        
		var textColor = Application.getApp().getProperty("ForegroundColor");
        
        //
        // Background
        //
		dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
		dc.clear();         
                       
        //           
		// Top circle
        //
		dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_RED);
        dc.fillCircle(cx, cy, 60);

		//
		// Bottom circle
		//                       
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.setPenWidth(2);
     	for( var i = 0; i < 60; i++) {
	     	dc.drawArc(cx, cy, i, Toybox.Graphics.ARC_CLOCKWISE, 0, 180);
    	}
     	
        //
        // Battery
        //
        var myStats = System.getSystemStats();		
        var bitmap;
		if (myStats.battery >= 88.5) {
			bitmap = bitmapBattery100;
		} else if (myStats.battery >= 62.5) {
			bitmap = bitmapBattery075;
		} else if (myStats.battery >= 38.5) {
			bitmap = bitmapBattery050;
		} else if (myStats.battery >= 12.5) {
			bitmap = bitmapBattery025;
		} else {
			bitmap = bitmapBattery000;
		}
        
        var bx = cx - (bitmap.getWidth() / 2) - (cx/4);
        var by = cy - (bitmap.getHeight() / 2) - 35;
        dc.drawBitmap(bx, by, bitmap);
		dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
		var textBat = myStats.battery.format("%02d") + "%";
		var dimsBat = dc.getTextDimensions(textBat, Graphics.FONT_SYSTEM_XTINY);
        dc.drawText(cx - (cx/4), by + dimsBat[1] / 2, Graphics.FONT_SYSTEM_XTINY, textBat, Graphics.TEXT_JUSTIFY_CENTER);
        
        //
        // Calories
        //       
        bx = (dc.getWidth() / 2) - (bitmapFire.getWidth() / 2) + (cx/4);
        by = (dc.getHeight() / 2) - (bitmapFire.getHeight() / 2) - 35;        
        dc.drawBitmap(bx, by, bitmapFire);
        
                
        //
        // Time
        //     
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (Application.getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);  
        var dims = dc.getTextDimensions(timeString, Graphics.FONT_LARGE);
		dc.drawText(cx, 25 + cy - (dims[1] / 2), Graphics.FONT_LARGE, timeString, Graphics.TEXT_JUSTIFY_CENTER);      	
     	
	}

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
