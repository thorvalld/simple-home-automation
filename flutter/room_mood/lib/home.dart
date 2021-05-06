import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/room.dart';

String roomId = "w9XyWgpKyqb8tKw4oVS7";
bool isActive;
double sval = 0.0;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 26, left: 14, right: 14),
          child: HomeBody(),
        ),
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("room")
              .doc(roomId)
              .get()
              .asStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('Loading...'),
              );
            }
            Room roomDocument = Room.fromJson(snapshot.data.data());
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkResponse(
                      onTap: () {},
                      radius: 24,
                      child: Icon(
                        CupertinoIcons.bars,
                        color: Colors.black87,
                        size: 34,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    RichText(
                        text: TextSpan(
                            text: "Hello, ",
                            style: TextStyle(
                                fontFamily: "Netflix",
                                fontSize: 20,
                                color: Colors.black87,
                                fontWeight: FontWeight.w300),
                            children: <TextSpan>[
                          TextSpan(
                              text: "Thor",
                              style: TextStyle(
                                  color: Colors.indigo,
                                  fontSize: 22,
                                  fontFamily: "Netflix",
                                  fontWeight: FontWeight.bold))
                        ])),
                    Spacer(),
                    Image.asset(
                      "assets/user.png",
                      height: 34,
                      width: 34,
                    )
                  ],
                ),
                SizedBox(
                  height: 28,
                ),
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1.3,
                  shrinkWrap: true,
                  controller: new ScrollController(keepScrollOffset: false),
                  children: [
                    InkWell(
                      child: ApplianceCard(
                        icon: CupertinoIcons.chart_bar_fill,
                        label: "RGB",
                        isEnabled: roomDocument.rgb,
                      ),
                    ),
                    ApplianceCard(
                      icon: CupertinoIcons.lightbulb_fill,
                      label: "ROOM",
                      isEnabled: roomDocument.room,
                    ),
                    ApplianceCard(
                      icon: CupertinoIcons.speaker_2_fill,
                      label: "MUSIC",
                      isEnabled: roomDocument.music,
                    ),
                  ],
                ),
                SizedBox(
                  height: 22,
                ),
                RGBSlider(
                  label: "R HUE",
                  val: roomDocument.rgbLightR,
                ),
                SizedBox(
                  height: 8,
                ),
                RGBSlider(
                  label: "G HUE",
                  val: roomDocument.rgbLightG,
                ),
                SizedBox(
                  height: 8,
                ),
                RGBSlider(
                  label: "B HUE",
                  val: roomDocument.rgbLightB,
                ),
              ],
            );
          }),
    );
  }
}

class ApplianceCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isEnabled;

  ApplianceCard({this.icon, this.label, this.isEnabled});

  @override
  _ApplianceCardState createState() => _ApplianceCardState();
}

class _ApplianceCardState extends State<ApplianceCard> {
  @override
  void initState() {
    isActive = widget.isEnabled;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //bool isActive = widget.isEnabled;

    void toggleSwitch(bool value) {
      setState(() {
        isActive = value;
      });
    }

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14), color: Colors.indigo),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(
                  width: 13,
                ),
                Text(widget.label,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "Netflix",
                        fontWeight: FontWeight.w400))
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Switch(
                  onChanged: (mv) async {
                    /*setState(() {
                      isActive = !isActive;
                    });*/
                    toggleSwitch(mv);
                    if (widget.label == 'RGB') {
                      await FirebaseFirestore.instance
                          .collection("room")
                          .doc(roomId)
                          .update({"rgb": mv}).then((value) => initState());
                    } else if (widget.label == 'ROOM') {
                      await FirebaseFirestore.instance
                          .collection("room")
                          .doc(roomId)
                          .update({"room": mv}).then((value) => initState());
                    } else if (widget.label == 'MUSIC') {
                      await FirebaseFirestore.instance
                          .collection("room")
                          .doc(roomId)
                          .update({"music": mv}).then((value) => initState());
                    }
                  },
                  value: isActive,
                  activeColor: Colors.green,
                  activeTrackColor: Colors.greenAccent,
                  inactiveThumbColor: Colors.redAccent,
                  inactiveTrackColor: Colors.orange,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class RGBSlider extends StatefulWidget {
  final String label;
  final double val;

  RGBSlider({this.label, this.val});

  @override
  _RGBSliderState createState() => _RGBSliderState();
}

class _RGBSliderState extends State<RGBSlider> {
  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  @override
  void initState() {
    sval = widget.val;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 3,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.label + ":",
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: "Netflix",
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    roundDouble(sval, 2).toString(),
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: "Netflix",
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      min: 0.1,
                      max: 1000,
                      value: roundDouble(sval, 2),
                      onChanged: (value) async {
                        if (widget.label == 'R HUE') {
                          await FirebaseFirestore.instance
                              .collection("room")
                              .doc(roomId)
                              .update({"rgbLightR": roundDouble(value, 2)});
                        } else if (widget.label == 'G HUE') {
                          await FirebaseFirestore.instance
                              .collection("room")
                              .doc(roomId)
                              .update({"rgbLightG": roundDouble(value, 2)});
                        } else if (widget.label == 'B HUE') {
                          await FirebaseFirestore.instance
                              .collection("room")
                              .doc(roomId)
                              .update({"rgbLightB": roundDouble(value, 2)});
                        }
                        setState(() {
                          sval = value;
                        });
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
