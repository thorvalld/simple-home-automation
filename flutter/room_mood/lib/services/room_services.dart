import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:room_mood/model/room.dart';

class RoomServices {
  var firestoreInstance = FirebaseFirestore.instance;
  String roomId = "w9XyWgpKyqb8tKw4oVS7";

  updateRoomData(Room room) async {
    firestoreInstance.collection('room').doc(roomId).update({
      "rgbLightR": room.rgbLightR,
      "rgbLightG": room.rgbLightG,
      "rgbLightB": room.rgbLightB,
      "music": room.music,
      "room": room.room,
      "rgb": room.rgb,
    });
  }
}
