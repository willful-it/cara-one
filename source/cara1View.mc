using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.ActivityMonitor;
using Toybox.Time;
using Toybox.Time.Gregorian;

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
		// Circle
		//                       
		drawCircle(dc, cx, cy, 61, Graphics.COLOR_WHITE);
		drawCircle(dc, cx, cy, 5, Graphics.COLOR_BLACK);
		drawSemiCircle(dc, cx, cy - 6, 60, Graphics.COLOR_DK_GREEN, Toybox.Graphics.ARC_COUNTER_CLOCKWISE);
    	drawSemiCircle(dc, cx, cy + 6, 60, Graphics.COLOR_RED, Toybox.Graphics.ARC_CLOCKWISE);
     	
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
        
        var bx = cx - (bitmap.getWidth() / 2) - (cx/2) + 5;
        var by = cy - (bitmap.getHeight() / 2);
        dc.drawBitmap(bx, by, bitmap);
        
        //
        // Calories
        //       
        var cals = ActivityMonitor.getInfo().calories;        
        if (cals != null) {
        	var calsString = cals.format("%d");
        	dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        	var dims = dc.getTextDimensions(calsString, Graphics.FONT_SYSTEM_XTINY);
        	dc.drawText(cx, cy + (dims[1] / 2) + 5, Graphics.FONT_SYSTEM_XTINY, calsString, Graphics.TEXT_JUSTIFY_CENTER);
        	dc.drawText(cx, cy + (dims[1] * 1.2) + 5, Graphics.FONT_SYSTEM_XTINY, "kcal", Graphics.TEXT_JUSTIFY_CENTER);
        }
        
        //
        // Date
        //
		var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
		var dateString = Lang.format(
		    "$1$ $2$",
		    [
		        today.day,
		        today.month
		    ]
		);        
        var customFont = WatchUi.loadResource(Rez.Fonts.custom_font_16);
    	dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    	var dimsDate = dc.getTextDimensions(dateString, customFont);
    	dc.drawText(cx + (cx/4) + (dimsDate[0] / 2), cy - (dimsDate[1] / 2) - 2, customFont, dateString, Graphics.TEXT_JUSTIFY_CENTER);
                
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

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);  
        var dims = dc.getTextDimensions(timeString, Graphics.FONT_LARGE);
		dc.drawText(cx, cy - 30 - (dims[1] / 2), Graphics.FONT_LARGE, timeString, Graphics.TEXT_JUSTIFY_CENTER);      	
     	
	}

	function drawSemiCircle(dc, x, y, radius, color, attr) {
        dc.setColor(color, color);
        dc.setPenWidth(2);
     	for( var i = 0; i < radius; i++) {
	     	dc.drawArc(x, y, i, attr, 0, 180);
    	}
	}
	
	function drawCircle(dc, x, y, radius, color) {
		dc.setColor(color, color);
        dc.fillCircle(x, y, radius);
	
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
