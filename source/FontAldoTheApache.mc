
class FontAldoTheApache extends FontBase {

    function initialize() {
        FontBase.initialize();

        _fontXSmall = WatchUi.loadResource(Rez.Fonts.font_aldotheapache_xsmall);
        _fontSmall = WatchUi.loadResource(Rez.Fonts.font_aldotheapache_small);
        _fontMedium = WatchUi.loadResource(Rez.Fonts.font_aldotheapache_medium);
        _fontLarge = WatchUi.loadResource(Rez.Fonts.font_aldotheapache_large);

        _id = 1;
    }

}