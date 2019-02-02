import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/Quotes .txt');
  }

  Future<String> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();
      return (contents);
    } catch (e) {
      // If we encounter an error, return 0
      return 'File NOt Found';
    }
  }
}

class SavedQuotes extends StatefulWidget {
  @override
  _SavedQuotesState createState() => _SavedQuotesState();
}

class _SavedQuotesState extends State<SavedQuotes> {
  
  static final Color _darkPurple = const Color(0xFF555683);
  static final _lightPurple = const Color(0xFFF3EBEE);

 CounterStorage storage;
  String _savedQuotes;
  
  @override
  void initState() {
    storage = new CounterStorage();
    super.initState();
    storage.readCounter().then((String value) {
      setState(() {
        _savedQuotes = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SafeArea(child: Align(
          alignment: Alignment.center,
          child: Text('QUOTAGE',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline),
        ),),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text('Saved Quotes',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Montserrat Light',
              color: _darkPurple,
              fontWeight: FontWeight.w200,
              fontSize: 14.0,
              letterSpacing: 1.0,
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
              ],),),
        ),
       Center(child: _savedQuotes == null ? Text('No Saved Quotes') : Text('$_savedQuotes', style: TextStyle(color: Colors.black12)))
      ],
    );
  }
}