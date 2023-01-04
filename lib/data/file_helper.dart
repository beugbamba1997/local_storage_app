import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  Future<String> get _docsPath async {
    final Directory dir = await getApplicationSupportDirectory();
    String fullPath = join(dir.path, 'globefiles');
    Directory globeDir = Directory(fullPath);
    if (!globeDir.existsSync()) {
      await globeDir.create();
    }

    return fullPath;
  }

  Future<List<File>> getFiles() async {
    final String dirPath = await _docsPath;
    List<File> files = [];
    List<FileSystemEntity> fse = Directory(dirPath).listSync();

    fse.forEach((element) {
      if (element is File) {
        files.add(element);
      }
    });
    return files;
  }

  Future writeToFile(String filename, String content) async {
    final String dirPath = await _docsPath;
    final String filePah = join(dirPath, filename);

    File file = File(filePah);
    return file.writeAsStringSync(content);
  }

  Future<String> readFromFile(File file) async {
    String content = await file.readAsString();
    return content;
  }

  Future deleteFile(File file) async {
    await file.delete();
  }
}
