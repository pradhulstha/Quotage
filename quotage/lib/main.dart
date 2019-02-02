import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quotage/ui/home/quote_homepage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Color(0xFFF3EBEE), //or set color with: Color(0xFF0000FF)
      statusBarIconBrightness: Brightness.dark
    ));
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Montserrat',
        canvasColor: const Color(0xFF444569),
        primaryColor: const Color(0xFF444569),
        accentColor: const Color(0xFFF3EBEE),
        textTheme: TextTheme(
          headline: TextStyle(fontFamily: 'Josefin Sans',
                color: const Color(0xFF444569),
                fontWeight: FontWeight.w600,
                fontSize: 24.0,
                letterSpacing: 4.0,
                shadows:<Shadow>[
                  Shadow(
                    offset: Offset(2.5, 1.6),
                    blurRadius: 5.0,
                    color: Colors.black12.withOpacity(0.1),
                  ),
                  Shadow(
                    offset: Offset(2.2, 0.5),
                    blurRadius: 6.0,
                    color: Colors.black45.withOpacity(0.4),
                  ),
                ],),
          
        )
      ),
      home: new QuoteHomePage(),
    );
  }
}
