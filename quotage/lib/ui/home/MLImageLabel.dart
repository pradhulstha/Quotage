import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:quotage/model/Quote.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:quotage/model/counterstorage.dart';
import 'package:quotage/widgets/fav_icon.dart';
import 'package:quotage/widgets/quote_list.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:flutter/cupertino.dart';

const List<String> _defaultTools = <String>[
  'Success',
  'Motivation',
  'Love',
  'Empower',
  'Women',
  'Art',
  'Romance',
  'Spirit',
  'inspirational',
  'uprising',
  'cute',
  'people',
  'night',
  'romantic',
  'self',
  'imporvement',
  'anger',
  'courage',
  'failure'
];

const List<String> _suggestions = [
  'Age',
  'Alone',
  'Amazing',
  'Anger',
  'Anniversary',
  'Architecture',
  'Art',
  'Favorite',
  'Attitude',
  'Beauty',
  'Birthday',
  'Brainy',
  'Business',
  'Car',
  'Chance',
  'Change',
  'Christmas',
  'Communication',
  'Cool',
  'Courage',
  'Dad',
  'Dating',
  'Death',
  'Design',
  'Diet',
  'Dreams',
  'Easter',
  'Education',
  'Environmental',
  'Equality',
  'Experience',
  'Failure',
  'Faith',
  'Family',
  'Famous',
  'Father\'s Day',
  'Fear',
  'Finance',
  'Fitness',
  'Food',
  'Forgiveness',
  'Freedom'
];

class ImageLabel extends StatefulWidget {
  final File imageFile;
  final List<String> labels;

  final Color _darkPurple = const Color(0xFF555683);
  final Color _lightPurple = const Color(0xFFF3EBEE);

  ImageLabel(this.imageFile, this.labels);

  @override
  _ImageLabelState createState() => _ImageLabelState();
}

class _ImageLabelState extends State<ImageLabel> {
  CounterStorage storage;
  int pressed = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map> strResult = new List<Map>();
  Map data;

  final Set<String> _selectedTools = Set<String>();

  @override
  void initState() {
    super.initState();
    if (widget.labels != null) {
      getQuotes();
    }
  }

  String _capitalize(String name) {
    assert(name != null && name.isNotEmpty);
    return name.substring(0, 1).toUpperCase() + name.substring(1);
  }

  void _showBottomSheet() {
    _scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
      final ThemeData themeData = Theme.of(context);
      return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
//            border: Border(top: BorderSide(color: themeData.disabledColor)),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0))),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 4.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                      color: widget._darkPurple,
                      borderRadius: BorderRadius.circular(14.0)),
                ),
              ),
              new Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: new Text(
                    'Select Category',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: widget._darkPurple),
                  )),
              Wrap(
                alignment: WrapAlignment.start,
                direction: Axis.horizontal,
                spacing: 4.0,
                children: _defaultTools.map<Widget>((String name) {
                  return FilterChip(
                    key: ValueKey<String>(name),
                    label: Text(_capitalize(name)),
                    selected: _selectedTools.contains(name),
                    onSelected: (bool value) {
                      setState(() {
                        if (!value) {
                          _selectedTools.remove(name);
                          Navigator.pop(context);
                        } else {
                          _selectedTools.add(name);
                          Navigator.pop(context);
                        }
                      });
                    },
                  );
                }).map<Widget>((Widget chip) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: chip,
                  );
                }).toList(),
              ),
            ],
          ));
    });
  }

  Future<Quotation> getJson(String category) async {
    String apiUrl =
        "https://theysaidso.p.mashape.com/quote?category=" + category;

    Map mapData;

    http.Response response = await http.get(Uri.encodeFull(apiUrl), headers: {
      "X-Mashape-Key": "QSbm8bXAztmshABHOfCS3hxPiGXEp17lqwijsno8WGtPBu7PZc",
      "X-Mashape-Host": "theysaidso.p.mashape.com",
      "Accept": "application/json"
    });

    if (response.statusCode == 200) {
      Map data = json.decode(response.body);
      mapData = data['contents'];
      return Quotation.fromJson(mapData);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  void getQuotes() {
    for (int i = 0; i < widget.labels.length; i++) getJsonPaper();
  }

  Future<void> getJsonPaper() async {
    int rag = new Random().nextInt(widget.labels.length);
    String cat = widget.labels[rag];

    String apiUrl =
        "http://api.paperquotes.com/apiv1/quotes\?tags\=" + cat + "\&limit\=5";
    String TOKEN = "e2eeb1aa9f32eb07fa04595a0c457ecb6fadb772";

    http.Response response = await http.get(Uri.encodeFull(apiUrl),
        headers: {'Authorization': 'TOKEN $TOKEN'});

    if (response.statusCode == 200) {
      data = json.decode(response.body);
      final List mapData = data['results'];
      if (mapData != null) {
        for (Map mapValue in mapData) {
          strResult.add(mapValue);
        }
      }
    } else {
      print(response.statusCode);
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Widget _buildPageList() {
    return SizedBox.fromSize(
      size: Size.fromHeight(500.0),
      child: PageView.builder(
          itemCount: widget.labels.length,
          controller: PageController(viewportFraction: 0.9),
          itemBuilder: (context, index) {
            String text = widget.labels[index];
            return Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Card(
                        color: widget._darkPurple,
                        elevation: 4.0,
                        child: FutureBuilder<Quotation>(
                            future: getJson(text),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.active:
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return Align(
                                      alignment: Alignment.center,
                                      child: CupertinoActivityIndicator());
                                case ConnectionState.done:
                                  {
                                    if (snapshot.hasError) {
                                      String quotation =
                                          strResult[index]['quote'];
                                      String author =
                                          strResult[index]['author'];
                                      List<String> splitQuote =
                                          quotation.split('\n');
                                      return Stack(
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 80.0,
                                                    left: 10.0,
                                                    right: 10.0),
                                                child: AutoSizeText(
                                                  "` ${splitQuote[0]}`",
                                                  maxLines: 12,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      fontFamily: 'Maven Pro',
                                                      fontSize: 18.0,
                                                      wordSpacing: 2.0,
                                                      color:
                                                          widget._lightPurple),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 40.0,
                                                        vertical: 16.0),
                                                child: Divider(
                                                  height: 20.0,
                                                  color: widget._lightPurple,
                                                ),
                                              ),
                                              Text(
                                                "- $author",
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Montserrat Light',
                                                    fontSize: 12.0,
                                                    color: widget._lightPurple,
                                                    letterSpacing: 3.0,
                                                    fontWeight:
                                                        FontWeight.w100),
                                              ),
                                            ],
                                          ),
                                          Positioned(
                                            bottom: 5.0,
                                            left: 5.0,
                                            child: IconButton(
                                              icon: Icon(Icons.content_copy),
                                              iconSize: 25.0,
                                              color: widget._lightPurple,
                                              onPressed: () {
                                                Clipboard.setData(new ClipboardData(
                                                    text:
                                                        "` ${splitQuote[0]}` - $author"));
                                                _scaffoldKey.currentState
                                                    .showSnackBar(new SnackBar(
                                                  content: new Text(
                                                      "Copied to Clipboard"),
                                                ));
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 5.0,
                                            right: 5.0,
                                            child:
                                                FavIcon(author, splitQuote[0]),
                                          )
                                        ],
                                      );
                                    } else {
                                      return Stack(
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 80.0,
                                                    left: 10.0,
                                                    right: 10.0),
                                                child: AutoSizeText(
                                                  "` ${snapshot.data.getQuote()}`",
                                                  minFontSize: 16.0,
                                                  maxLines: 14,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      fontFamily: 'Maven Pro',
                                                      fontSize: 18.0,
                                                      wordSpacing: 2.0,
                                                      color:
                                                          widget._lightPurple),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 40.0,
                                                        vertical: 16.0),
                                                child: Divider(
                                                  height: 20.0,
                                                  color: widget._lightPurple,
                                                ),
                                              ),
                                              Text(
                                                "- ${snapshot.data.author}",
                                                style: TextStyle(
                                                    fontFamily:
                                                        'Montserrat Light',
                                                    fontSize: 12.0,
                                                    color: widget._lightPurple,
                                                    letterSpacing: 3.0,
                                                    fontWeight:
                                                        FontWeight.w100),
                                              ),
                                            ],
                                          ),
                                          Positioned(
                                            bottom: 5.0,
                                            left: 5.0,
                                            child: IconButton(
                                              icon: Icon(Icons.content_copy),
                                              iconSize: 25.0,
                                              color: widget._lightPurple,
                                              onPressed: () {
                                                Clipboard.setData(new ClipboardData(
                                                    text:
                                                        "`${snapshot.data.getQuote()}` - ${snapshot.data.author}"));
                                                _scaffoldKey.currentState
                                                    .showSnackBar(new SnackBar(
                                                  content: new Text(
                                                      "Copied to Clipboard"),
                                                ));
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 5.0,
                                            right: 5.0,
                                            child: FavIcon(snapshot.data.author,
                                                snapshot.data.quote),
                                          )
                                        ],
                                      );
                                    }
                                  }
                              }
                            })),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    child: Hero(
                      tag: 'Image',
                      child: CircleAvatar(
                          radius: 40.0,
                          backgroundImage: FileImage(widget.imageFile)),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget _buildPage() {
    return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            //QuoteList(labels: widget.labels),
            Container(
              alignment: Alignment.topCenter,
              child: Hero(
                tag: 'Image',
                child: CircleAvatar(
                    radius: 40.0, backgroundImage: FileImage(widget.imageFile)),
              ),
            )
          ],
        ));
  }

  Widget _buildNoQuotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Image.asset('assets/uploadasset.png'),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Text(
              'Sorry Error Fetching Quotes!\nPlease Try Again',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12.0,
                  fontFamily: 'Montserrat Light',
                  color: widget._darkPurple),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      backgroundColor: widget._lightPurple,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            child: Hero(
              tag: 'Title',
              child: SafeArea(
                child: Material(
                  color: Colors.transparent,
                  child: Text('QUOTAGE',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: _buildPageList(),
          ),
        ],
      ),
      bottomNavigationBar: GestureDetector(
        onTap: _showBottomSheet,
        child: BottomAppBar(
            color: Colors.transparent, child: _buildBottomAppBar()),
      ),
    );
  }

  Widget _buildBottomAppBar() {
    return SafeArea(
      child: SwipeDetector(
        onSwipeUp: _showBottomSheet,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0)),
                  color: widget._lightPurple,
                  boxShadow: [
                    BoxShadow(
                      color: widget._darkPurple,
                      blurRadius: 20.0, // has the effect of softening the shadow
                      spreadRadius: 0.0, // has the effect of extending the shadow
                      offset: Offset(
                        0.0, // horizontal, move right 10
                        -2.0, // vertical, move down 10
                      ),
                    )
                  ],
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(0.8, 0.0),
                      // 10% of the width, so there are ten blinds.
                      colors: [
                        const Color(0xFF5D5E90),
                        const Color(0xFF444569)
                      ])),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      height: 4.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                          color: widget._lightPurple,
                          borderRadius: BorderRadius.circular(15.0)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Select Category',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16.0, color: widget._darkPurple),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

//Transform.translate(
//offset: Offset(0.0, -1 * MediaQuery
//    .of(context)
//.viewInsets
//    .bottom),
//child: BottomAppBar(
//color: Colors.transparent,
//child: _buildBottomAppBar()
//),
//),
