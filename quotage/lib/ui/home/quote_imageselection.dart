import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:quotage/ui/home/MLImageLabel.dart';

class ImageSelection extends StatefulWidget {


  final Color _darkPurple = const Color(0xFF555683);
  final Color _lightPurple = const Color(0xFFF3EBEE);

  @override
  _ImageSelectionState createState() => _ImageSelectionState();
}

class _ImageSelectionState extends State<ImageSelection> with TickerProviderStateMixin{
  File _imageFile;
  Animation animation;
  AnimationController animationController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List labels = new List<String>();

  @override
  void initState() {
    super.initState();
    _getImage();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.ease))
    ..addListener((){
      setState(() {
            });
    });
    animationController.forward();
  }

  Future<void> _scanImage() async {
    labels.clear(); 
    final FirebaseVisionImage visionImage =
    FirebaseVisionImage.fromFile(_imageFile);

    final LabelDetector labelDetector = FirebaseVision.instance.labelDetector();

    final currentLabel = await labelDetector.detectInImage(visionImage);

    if(currentLabel != null){
      
      print('----Copying Labels to String ---');
      
      for(Label label in currentLabel){
        String text = "";
        text = label.label;
        print("Labels: " + text);
        labels.add(text);
      }
    }
    else{
      throw Exception('Sorry! Could not analyze image!');
    }

  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: widget._lightPurple,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            child: Hero(
              tag: 'Title',
              child: SafeArea(child: Material(
                color: Colors.transparent,
                child: Text('QUOTAGE',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline),
              ),),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: _getImage,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: _imageFile == null ? Padding(
                    padding: EdgeInsets.only(top: 60.0),
                      child: Image.asset('assets/uploadasset.png')) :
                  Hero(
                    tag: 'Image',
                    child:FadeTransition(
                      opacity: animation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox.fromSize(
                          size: Size.fromHeight(400.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Material(
                                  elevation: 8.0,
                                  shadowColor: Colors.black12,
                                  child: Image.file(_imageFile, fit: BoxFit.cover,)),),
                        ),
                      ),
                    )
                  ),
                )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 14.0),
                child: Text('Tap to reselect an image', textAlign: TextAlign.center, style: TextStyle(fontSize: 12.0, fontFamily: 'Montserrat Light', color: widget._darkPurple.withOpacity(0.4)),),
              )
            ],
          ),
        ],
      ),
      bottomNavigationBar: _imageFile == null ? Container(width: 0.0, height: 0.0,): BottomAppBar(
        shape: CircularNotchedRectangle(),
        elevation: 5.0,
        color: widget._darkPurple,
        notchMargin: 4.0,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft,
                  end: Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
                  colors: [const Color(0xFF555683), const Color(0xFF444569)])
          ),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
            onTap: _cancelButtonPressed,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Cancel', softWrap: true, style: TextStyle(color: widget._lightPurple, fontSize: 16.0),),
            ),),
              GestureDetector(
                onTap: _analyzeButtonPressed,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Analyze', softWrap: true,style: TextStyle(color: widget._lightPurple, fontSize: 16.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _getImage() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(imageFile != null) {
          setState(() {
            _imageFile = imageFile;
          });
          animationController.forward();
    }else
      return _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Please Select the image again')));
  }

  _analyzeButtonPressed() async {

    await _scanImage();
    try{
      if(labels == null || _imageFile == null) {
        throw Exception('Sorry! Please try again!');
      }
      Navigator.push(context, CupertinoPageRoute(builder: (context) => ImageLabel(_imageFile, labels)));

    }catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('File Not Selected' + e.toString()),
      ));
    }
  }
  _cancelButtonPressed(){

    if(animationController.status == AnimationStatus.completed)
       animationController.reverse();
    setState(() {
      _imageFile = null;
    });
     }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
