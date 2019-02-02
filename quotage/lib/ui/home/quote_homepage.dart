import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:quotage/ui/home/quote_imageselection.dart';
import 'package:quotage/ui/home/quote_saved.dart';




class QuoteHomePage extends StatefulWidget{

  QuoteHomePage({Key key}): super(key: key);
  @override
  State<StatefulWidget> createState() => _QuoteHomePageState();
}

class _QuoteHomePageState extends State<QuoteHomePage> {

  static int _selectedIndex = 0;
 

  static final Color _darkPurple = const Color(0xFF555683);
  static final _lightPurple = const Color(0xFFF3EBEE);


  final PageStorageBucket bucket = PageStorageBucket();


  

  _updateIndex(int index) {

    setState(() {
      _selectedIndex = index;
    });

  }

  Future<Map> getJsonPaper() async{

    String apiUrl = "http://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en";


    http.Response response = await http.get(
        Uri.encodeFull(apiUrl));

    if(response.statusCode == 200)
    {
      Map data = json.decode(response.body);
      print(data);
      return data;
      //return QuotationPaper.fromJson(fromList);
    }

    else {
      print('Error Fetiching Quote.');
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');

    }
  }



  final Widget _columnExpanded = Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Expanded(
        flex: 1,
        child: Stack(
           children: <Widget>[
             Container(
               color: _lightPurple,
               margin: EdgeInsets.only(bottom: 26.0),
                 ),
             Container(
               width: 150.0,
               height: 200.0,
               alignment: Alignment.bottomCenter,
               child: Card(
                 elevation: 5.0,
                 color: Colors.white,
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text('#Quoteoftheday', textAlign: TextAlign.center, style: TextStyle(
                         color: _darkPurple,
                         fontFamily: 'Montserrat Light',
                         shadows: <Shadow>[
                     Shadow(
                       offset: Offset(1.0, 0.5),
                       blurRadius: 2.0,
                       color: Colors.black45.withOpacity(0.5),
                     ),]),),
                   )),
             )
           ],
        )),
      Expanded(
        flex: 2,
        child: Container(
        ),
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      backgroundColor: _selectedIndex == 0 ? Theme.of(context).primaryColor: Theme.of(context).accentColor,
      body: _selectedIndex == 0 ?Stack(
        key: PageStorageKey('Stack'),
        fit: StackFit.expand,
        children: <Widget>[
          _columnExpanded,
          SafeArea(child: Material(
            color: Colors.transparent,
            child: Text('QUOTAGE',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline),
          ),),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 220),
            child: _buildFutureBuilder(),
          )

        ],
      ) : SavedQuotes(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed:_onPressed,
        child: Icon(Icons.filter_center_focus, color: _darkPurple,size: 30.0,),
        tooltip: 'Analyze',
        backgroundColor: _lightPurple,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: const Color(0xFFF3EBEE),
        notchMargin: 4.0,
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(icon: Icon(Icons.home, color: _selectedIndex == 0 ? _darkPurple : Colors.black12,), onPressed: () => _updateIndex(0),tooltip: 'Home',),
            SizedBox(
              width: 8.0),
            IconButton(icon: Icon(Icons.favorite, color: _selectedIndex == 1 ? _darkPurple : Colors.black12,), onPressed: () {_updateIndex(1);},),
          ],
        ),
      ),
    );
  }

  void _onPressed() {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => ImageSelection()));
  }

  
  _buildFutureBuilder() {
    return FutureBuilder<Map>(
      key: PageStorageKey('Future'),
      future: getJsonPaper(),
      builder: (BuildContext context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.active:
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container(width: 0.0, height: 0.0,);
          case ConnectionState.done:
            {
              if (snapshot.hasData) {
                return SizedBox.fromSize(
                  size: Size.fromHeight(400.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: AutoSizeText(
                            "` ${snapshot.data['quoteText']}`",
                            maxLines: 10,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 22.0,
                              color: _lightPurple),),
                        ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                        child: Divider(
                          height: 20.0,
                          color: _lightPurple,),
                      ),
                      Text("- ${snapshot.data['quoteAuthor']}", style: TextStyle(fontFamily: 'Montserrat Light', fontSize: 12.0, color: _lightPurple,letterSpacing: 3.0, fontWeight: FontWeight.w100 ),),
                    ],
                  ),
                );
              }else if(snapshot.hasError)
              {
                return Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Text("` Quotation Error.`", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Maven Pro',
                      fontSize: 24.0,
                      color: _lightPurple),),
                );}
            }

        }
      },
    );
  }


}




