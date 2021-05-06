class Room {
  final double rgbLightR;
  final double rgbLightG;
  final double rgbLightB;
  final bool music;
  final bool room;
  final bool rgb;

  Room(
      {this.rgbLightR,
      this.rgbLightG,
      this.rgbLightB,
      this.music,
      this.room,
      this.rgb});

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        rgbLightR: json["rgbLightR"],
        rgbLightG: json["rgbLightG"],
        rgbLightB: json["rgbLightB"],
        music: json["music"],
        room: json["room"],
        rgb: json["rgb"],
      );

  Map<String, dynamic> toJson() => {
        "rgbLightR": rgbLightR,
        "rgbLightG": rgbLightG,
        "rgbLightB": rgbLightB,
        "music": music,
        "room": room,
        "rgb": rgb,
      };
}
