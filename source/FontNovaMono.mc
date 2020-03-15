
class FontNovaMono extends FontBase {

    function initialize() {
        FontBase.initialize();

        _fontXSmall = WatchUi.loadResource(Rez.Fonts.font_novamono_xsmall);
        _fontSmall = WatchUi.loadResource(Rez.Fonts.font_novamono_small);
        _fontMedium = WatchUi.loadResource(Rez.Fonts.font_novamono_medium);
        _fontLarge = WatchUi.loadResource(Rez.Fonts.font_novamono_large);

        _id = 0;
    }
}