using Toybox.System;

class FontBase {

    protected var _fontXSmall;
    protected var _fontSmall;
    protected var _fontMedium;
    protected var _fontLarge;

    protected var _id;

	function initialize() {
        _id = -1;
	}

    function xsmall() {
        return _fontXSmall;
    }

    function small() {
        return _fontSmall;
    }

    function medium() {
        return _fontMedium;
    }

    function large() {
        return _fontLarge;
    }

    function id() {
        return _id;
    }


    static function defaultId() {
        return 0;
    }

    static function buildFont(fontId) {
        var font = null;
        if (fontId == 0) {
        	System.println("Setting font to nova mono");
            font = new FontNovaMono();
        } else if (fontId == 1) {
        	System.println("Setting font to aldo the apache"); 
            font = new FontAldoTheApache();
        } else if (fontId == 2) {
        	System.println("Setting font to poiret one"); 
            font = new FontPoiretOne();
        }

        return font;
    }

} 