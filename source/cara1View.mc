using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.ActivityMonitor;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Sensor;

class cara1View extends WatchUi.WatchFace {

    var bitmapBattery000; 
    var bitmapBattery025;
    var bitmapBattery050;
    var bitmapBattery075;
    var bitmapBattery100;
    var bitmapFire;
    var bitmapHeart;
    var bitmapNotifcation;
    var bitmapSteps;

    var fontXSmall;
    var fontSmall;
    var fontMedium;
    var fontLarge;
    
    var showHeartBeat;

    function initialize() {
        WatchFace.initialize();
        
        bitmapBattery000 = WatchUi.loadResource(Rez.Drawables.battery_000);
        bitmapBattery025 = WatchUi.loadResource(Rez.Drawables.battery_025);
        bitmapBattery050 = WatchUi.loadResource(Rez.Drawables.battery_050);
        bitmapBattery075 = WatchUi.loadResource(Rez.Drawables.battery_075);
        bitmapBattery100 = WatchUi.loadResource(Rez.Drawables.battery_100);
        bitmapFire = WatchUi.loadResource(Rez.Drawables.fire);
        bitmapHeart = WatchUi.loadResource(Rez.Drawables.heart);
        bitmapNotifcation = WatchUi.loadResource(Rez.Drawables.notifcation);
        bitmapSteps = WatchUi.loadResource(Rez.Drawables.steps);
        
        fontXSmall = WatchUi.loadResource(Rez.Fonts.font_xsmall);
        fontSmall = WatchUi.loadResource(Rez.Fonts.font_small);
        fontMedium = WatchUi.loadResource(Rez.Fonts.font_medium);
        fontLarge = WatchUi.loadResource(Rez.Fonts.font_large);
        
        showHeartBeat = true;
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
        var circleRadius = 50;
        var centralSize = 12;
        
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
        drawSemiCircle(dc, cx, cy, circleRadius, Graphics.COLOR_DK_GREEN, Toybox.Graphics.ARC_COUNTER_CLOCKWISE);
        drawSemiCircle(dc, cx, cy, circleRadius, Graphics.COLOR_RED, Toybox.Graphics.ARC_CLOCKWISE);
        
         var w = (circleRadius * 2) + 1;
         var h = centralSize;
         dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
         dc.fillRectangle(cx - (w/2), cy - (h/2), w, h);
         
         drawCircle(dc, cx, cy, 4, Graphics.COLOR_BLACK);
         
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
        
        var bx = cx - 28 - (bitmap.getWidth() / 2);
        var by = cy - (bitmap.getHeight() / 2);
        dc.drawBitmap(bx, by, bitmap);
        
        //
        // Calories
        //
        var cals = ActivityMonitor.getInfo().calories;
        if (cals != null) {
            var calsString = cals.format("%d");
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            var dims = dc.getTextDimensions(calsString, fontMedium);
            dc.drawText(cx, cy + (dims[1] / 2), fontMedium, calsString, Graphics.TEXT_JUSTIFY_CENTER);            
            dc.drawText(cx, cy + dims[1] + 5, fontXSmall, "kcal", Graphics.TEXT_JUSTIFY_CENTER);
        }
        
        //
        // Date
        //
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dateString = Lang.format(
            "$1$-$2$",
            [
                today.day,
                today.month
            ]
        );
        
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        var dimsDate = dc.getTextDimensions(dateString, fontXSmall);
        dc.drawText(cx + (dimsDate[0] / 2) + 15, cy - (dimsDate[1] / 2) - 1, fontXSmall, dateString, Graphics.TEXT_JUSTIFY_CENTER);

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
        var dims = dc.getTextDimensions(timeString, fontLarge);
        dc.drawText(cx, cy - (circleRadius / 2) - (dims[1] / 2 ), fontLarge, timeString, Graphics.TEXT_JUSTIFY_CENTER);

        //
        // Show heart beat
        //
        if (showHeartBeat) {
             if (ActivityMonitor has :getHeartRateHistory) {
                bx = ((cx - circleRadius) / 2) - (bitmapHeart.getWidth() / 2); 
                by = cy - bitmapHeart.getHeight() - 1;
                dc.drawBitmap(bx, by, bitmapHeart);
             
                var heartRate = Activity.getActivityInfo().currentHeartRate;
                if (heartRate == null) {
                    var HRH = ActivityMonitor.getHeartRateHistory(1, true);
                    var HRS = HRH.next();

                    if (HRS != null && HRS.heartRate != ActivityMonitor.INVALID_HR_SAMPLE) {
                        heartRate = HRS.heartRate.toString();
                    }
                } else {
                    heartRate = heartRate.toString();
                }
                
                if (heartRate == null) {
                    heartRate = "--";
                }
                
                dims = dc.getTextDimensions(heartRate, fontSmall);
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                dc.drawText(
                    ((cx - circleRadius) / 2),
                    cy + 1,
                    fontSmall,
                    heartRate,
                    Graphics.TEXT_JUSTIFY_CENTER);
            }
        }
        
        //
        // Show notifications
        //
        if (showHeartBeat) {
            bx = dc.getWidth() - ((dc.getWidth() - (cx + circleRadius)) / 2) - (bitmapNotifcation.getWidth() / 2); 
            by = cy - bitmapNotifcation.getHeight() - 1;
            dc.drawBitmap(bx, by, bitmapNotifcation);

            var msgCount = displayMsgCount()[0];
            dims = dc.getTextDimensions(msgCount, fontSmall);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                dc.getWidth() - ((dc.getWidth() - (cx + circleRadius)) / 2),
                cy + 1,
                fontSmall,
                msgCount,
                Graphics.TEXT_JUSTIFY_CENTER);
        }
        
        //
        // Steps
        //
        if (showHeartBeat) {
           	var ySpace = (dc.getHeight() - (circleRadius * 2)) / 2;

            var stepCount = ActivityMonitor.getInfo().steps.toString();
            dims = dc.getTextDimensions(stepCount, fontSmall);

            var spaceSpace = (ySpace - (dims[1] + bitmapSteps.getHeight()));

            bx = cx - (bitmapNotifcation.getWidth() / 2); 
            by = spaceSpace / 2;
            dc.drawBitmap(bx, by, bitmapSteps);

            bx = cx;
            by = by + dims[1]; 
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                bx,
                by,
                fontSmall,
                stepCount,
                Graphics.TEXT_JUSTIFY_CENTER);

        }
        
    }


    function displayMsgCount()
    {
        var ds = System.getDeviceSettings();
        return (ds != null && ds.notificationCount != null)
            ? [ds.notificationCount.format("%d"), "msg"]
            : ["0", "msg"];
    }
/*
    function displayPulse() {
        var isUpdate = false;
        var info = Activity.getActivityInfo();

        if (info != null && info has :currentHeartRate && info.currentHeartRate != null && _heartRate != info.currentHeartRate)
        {
            _heartRate = info.currentHeartRate;
            _heartRateText = (_heartRate < 100) ? _heartRate.toString() + "  " : _heartRate.toString();
            isUpdate = true;
        }

        return [_heartRateText, "bpm", isUpdate];
    }
*/
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
        showHeartBeat = true;
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
        showHeartBeat = false;
    }

}
