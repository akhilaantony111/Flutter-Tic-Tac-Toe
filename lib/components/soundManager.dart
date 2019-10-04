//for finding commonly used locations on the filesystem
import 'package:path_provider/path_provider.dart';
//This library allows you to work with files, directories, sockets, processes, HTTP servers and clients, and more.
import "dart:io";
import 'package:flutter/services.dart';

class SoundManager {
  Future play(localFileName, audioPlayer) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = new File("${dir.path}/$localFileName");
    if (!(await file.exists())) {
      final soundData = await rootBundle.load("assets/$localFileName");
      final bytes = soundData.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
    }
    await audioPlayer.play(file.path, isLocal: true);

    audioPlayer.onPlayerStateChanged.listen((s) {
    });
  }
}
