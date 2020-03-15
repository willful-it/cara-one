

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

} 