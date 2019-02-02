import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quotage/widgets/fav_icon.dart';

class QuoteCardView extends StatelessWidget {
  QuoteCardView(this.quote, this.author);

  final String quote, author;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Card(
              color: Theme.of(context).primaryColor,
              elevation: 4.0,
              child: Stack(children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 80.0, left: 10.0, right: 10.0),
                      child: AutoSizeText(
                        "` $quote`",
                        minFontSize: 16.0,
                        maxLines: 14,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontFamily: 'Maven Pro',
                          fontSize: 18.0,
                          wordSpacing: 2.0,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 16.0),
                      child: Divider(
                        height: 20.0,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    Text(
                      "- $author",
                      style: TextStyle(
                          fontFamily: 'Montserrat Light',
                          fontSize: 12.0,
                          color: Theme.of(context).accentColor,
                          letterSpacing: 3.0,
                          fontWeight: FontWeight.w100),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 5.0,
                  left: 5.0,
                  child: IconButton(
                    icon: Icon(Icons.content_copy),
                    iconSize: 25.0,
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      Clipboard.setData(
                          new ClipboardData(text: "`$quote` - $author"));
                      _scaffoldKey.currentState.showSnackBar(new SnackBar(
                        content: new Text("Copied to Clipboard"),
                      ));
                    },
                  ),
                ),
                Positioned(
                  bottom: 5.0,
                  right: 5.0,
                  child: FavIcon(quote, author),
                )
              ])),
        ));
  }
}
