
class FontPoiretOne extends FontBase {

    function initialize() {
        FontBase.initialize();

        _fontXSmall = WatchUi.loadResource(Rez.Fonts.font_poiretone_xsmall);
        _fontSmall = WatchUi.loadResource(Rez.Fonts.font_poiretone_small);
        _fontMedium = WatchUi.loadResource(Rez.Fonts.font_poiretone_medium);
        _fontLarge = WatchUi.loadResource(Rez.Fonts.font_poiretone_large);

        _id = 2;
    }
}