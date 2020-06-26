import 'package:flutter/material.dart';

List images = [
  'https://picsum.photos/200',
  'https://i.pinimg.com/originals/8c/d0/d7/8cd0d722e65ccd87fffb844980977b3c.jpg',
  'http://4.bp.blogspot.com/_3GTOQGJNP5k/SbCbBCQB3vI/AAAAAAAABIg/PcBhcRjLuVk/s320/halloates.jpg',
  'https://img.buzzfeed.com/buzzfeed-static/static/2014-10/22/17/campaign_images/webdr04/29-essential-albums-every-90s-kid-owned-2-19453-1414013372-8_dblbig.jpg',
  'https://isteam.wsimg.com/ip/88fde5f6-6e1c-11e4-b790-14feb5d39fb2/ols/580_original/:/rs=w:600,h:600',
  'https://www.covercentury.com/covers/audio/b/baby_justin-bieber_218-vbr_1462296.jpg',
  'https://thebrag.com/wp-content/uploads/2015/10/artvsscienceofftheedgeoftheearthandintoforeverforever1015.jpg',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS95jA18s6vnmWIk4z6jTuaINYm4jBoWWRC5yp7cXvwKikEASRR&s',
  'https://list.lisimg.com/image/2239608/500full.jpg',
  'https://images-na.ssl-images-amazon.com/images/I/513D1NEWPXL.jpg'
];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: Scaffold(
        body: Ipod(),
      ),
    );
  }
}

class Ipod extends StatefulWidget {
  @override
  _IpodState createState() => _IpodState();
}

class _IpodState extends State<Ipod> {
  final _pageCtrl = PageController(viewportFraction: 0.6);

  double currentPage = 0.0;

  @override
  void initState() {
    _pageCtrl.addListener(() {
      setState(() {
        currentPage = _pageCtrl.page;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: <Widget>[
        Container(
            height: 350,
            color: Colors.black,
            child: PageView.builder(
              controller: _pageCtrl,
              scrollDirection: Axis.horizontal,
              itemCount: 9,
              itemBuilder: (context, currentIdx) {
                return AlbumCard(
                    color: Colors.accents[currentIdx],
                    currentIdx: currentIdx,
                    currentPage: currentPage);
              },
            )),
        Spacer(),
        Center(
          child: Stack(alignment: Alignment.center, children: [
            GestureDetector(
                onPanUpdate: _panHandler,
                child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: Text("MENU",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.only(top: 36),
                        ),
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.fast_forward),
                            iconSize: 40,
                            onPressed: () => _pageCtrl.animateToPage(
                                (_pageCtrl.page + 1).toInt(),
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeIn),
                          ),
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 30),
                        ),
                        Container(
                            child: IconButton(
                              icon: Icon(Icons.fast_rewind),
                              iconSize: 40,
                              onPressed: () => _pageCtrl.animateToPage(
                                  (_pageCtrl.page - 1).toInt(),
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn),
                            ),
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 30)),
                        Container(
                          child: Icon(
                            Icons.play_arrow,
                            size: 40,
                          ),
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.only(bottom: 30),
                        )
                      ],
                    ))),
            Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white38)),
          ]),
        )
      ]),
    );
  }

  void _panHandler(DragUpdateDetails d) {
    double radius = 150;

    bool onTop = d.localPosition.dy <= radius;
    bool onLeftSide = d.localPosition.dx <= radius;
    bool onBottom = !onTop;
    bool onRightSide = !onLeftSide;

    bool panUp = d.delta.dy <= 0.0;
    bool panLeft = d.delta.dx <= 0.0;
    bool panDown = !panUp;
    bool panRight = !panLeft;

    double yChange = d.delta.dy.abs();
    double xChange = d.delta.dx.abs();

    double verticalRotation = (onRightSide && panDown) || (onLeftSide && panUp)
        ? yChange
        : yChange * -1;
    double horizontalRotation =
        (onTop && panRight) || (onBottom && panLeft) ? xChange : xChange * -1;

    double rotationalChange =
        (verticalRotation + horizontalRotation) * d.delta.distance * 0.2;

    _pageCtrl.jumpTo(_pageCtrl.offset + rotationalChange);
  }
}

class AlbumCard extends StatelessWidget {
  final Color color;
  final int currentIdx;
  final double currentPage;

  AlbumCard({this.color, this.currentIdx, this.currentPage});
  @override
  Widget build(BuildContext context) {
    double relativePosition = currentIdx - currentPage;

    return Container(
        width: 250,
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.003)
            ..scale((1 - relativePosition.abs()).clamp(0.2, 0.6) + 0.4)
            ..rotateY(relativePosition),
          alignment: relativePosition >= 0
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Container(
            margin: EdgeInsets.only(top: 20, bottom: 20, left: 5, right: 5),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: color,
              image: DecorationImage(
                  image: NetworkImage(images[currentIdx]), fit: BoxFit.cover),
            ),
          ),
        ));
  }
}
