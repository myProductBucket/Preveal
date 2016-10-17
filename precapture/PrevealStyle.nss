@primaryFontName: Avenir-Book;
@secondaryFontName: Avenir-Light;
@secondaryFontNameBold: HelveticaNeue;
@secondaryFontNameStrong: HelveticaNeue-Medium;
@inputFontName: Avenir-Light;
@primaryFontColor: #1F445F;
@secondaryFontColor: #6C68AC;
@whiteColor: #FFFFFF;
Label {
    font-name: @primaryFontName;
    font-color: @primaryFontColor;
    text-auto-fit: false;
}
Title {
    font-name: @secondaryFontName;
    font-color: @primaryFontColor;
    text-auto-fit: false;
    font-size: 17;
}

TextField {
    height: 37;
    font-name: @inputFontName;
    font-color: @secondaryFontColor;
}

TextField:tray {
    font-size: 32;
    font-name: @inputFontName;
    font-color: @whiteColor;
}
Label:MenuHeading {
    font-size: 45;
    font-name: @secondaryFontName;
}