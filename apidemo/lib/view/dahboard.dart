import 'package:apidemo/controller/uicontroller.dart';
import 'package:apidemo/models/TournamentModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final dataBlock = ApiData();
  ScrollController _controller = new ScrollController();
  TournamentModel modelData;
  List<Tournaments> tournaments = new List<Tournaments>();

  @override
  void initState() {
    dataBlock.eventSink.add('');
    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        dataBlock.eventSink.add(modelData.data.cursor);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: SafeArea(
          child: StreamBuilder<TournamentModel>(
        stream: dataBlock.customListStream,
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            modelData = snapshots.data;
            tournaments.addAll(snapshots.data.data.tournaments);
            return getMainView();
          }
          if (snapshots.connectionState == ConnectionState.waiting)
            return Container(
              child: Center(
                child: SpinKitPulse(
                  color: Colors.black,
                  size: 50.0,
                ),
              ),
            );
          if (snapshots.hasError)
            return Container(
              child: Center(
                child: getTextView(snapshots.error),
              ),
            );
        },
      )),
    );
  }

  Widget getTextView(String textMessage) {
    return new Text(textMessage,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w400, fontSize: 15));
  }

  Widget getMainView() {
    return CustomScrollView(controller: _controller, slivers: <Widget>[
      SliverAppBar(
        snap: false,
        pinned: false,
        floating: false,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text("Flyingwolf",
              style: TextStyle(
                color: Color(0xFF2D2D32),
                fontSize: 16.0,
              ) //TextStyle
              ),
        ),
        backgroundColor: Color(0xFFFAFAFA),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Color(0xFF2D2D32),
          ),
          tooltip: 'Menu',
          onPressed: () {},
        ),
      ),
      SliverToBoxAdapter(
        child: getUserProfileUi(),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return InkWell(
              onTap: () {},
              child: getTournamentView(
                tournaments[index],
              ),
            );
          },
          childCount: tournaments.length,
        ),
      ),
    ]);
  }

  Widget getTournamentView(Tournaments data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Container(
            height: 17.h,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                      foregroundDecoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(data.coverUrl),
                              fit: BoxFit.fill))),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 70.w,
                                  child: new Text(
                                    data.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.grey.shade600
                                            .withOpacity(0.6),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                new Text(
                                  data.gameName,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w300),
                                )
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 10,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getUserProfileUi() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                'https://cdn.shopify.com/s/files/1/0069/7267/0052/files/500x500_87a5c444-0cb6-4fa6-a35d-027999f6231f_125x125@2x.jpg?v=1581634990',
                height: 20.0.h,
                width: 20.0.w,
              ),
              SizedBox(
                width: 1.w,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Text(
                    "Simon Baker",
                    textScaleFactor: 1.0,
                    style: TextStyle(fontSize: 12.sp, color: Colors.black),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Container(
                    width: 40.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      border: Border.all(
                        width: 1,
                        color: Colors.blue,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 1.w,
                        ),
                        new Text(
                          "2250",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue.shade500.withOpacity(0.8)),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        new Text(
                          "Elo rating",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black.withOpacity(0.8)),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              height: 9.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [
                              const Color(0xFFffb347),
                              const Color(0xFFffcc33),
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      child: Center(
                          child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: RichText(
                          text: new TextSpan(
                            children: <TextSpan>[
                              new TextSpan(
                                  text: '34',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  )),
                              new TextSpan(
                                  text: '\nTournament',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.sp,
                                  )),
                              new TextSpan(
                                  text: '\nplayed',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.sp,
                                  )),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [
                              const Color(0xFF182848),
                              const Color(0xFF4b6cb7),
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      child: Center(
                          child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: RichText(
                          text: new TextSpan(
                            children: <TextSpan>[
                              new TextSpan(
                                  text: '09',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  )),
                              new TextSpan(
                                  text: '\nTournament',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.sp,
                                  )),
                              new TextSpan(
                                  text: '\nwon',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.sp,
                                  )),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [
                              const Color(0xFFff9472),
                              const Color(0xFFf2709c),
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      child: Center(
                          child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: RichText(
                          text: new TextSpan(
                            children: <TextSpan>[
                              new TextSpan(
                                  text: '26%',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  )),
                              new TextSpan(
                                  text: '\nWinning',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.sp,
                                  )),
                              new TextSpan(
                                  text: '\npercentage',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.sp,
                                  )),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 3.w),
          child: new Text(
            "Recommended for you",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18.sp),
          ),
        )
      ],
    );
  }
}
