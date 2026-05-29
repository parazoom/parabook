import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Enregistre le CSV via le sélecteur système (mobile/desktop).
/// Renvoie le chemin choisi, ou `null` si l'utilisateur annule.
Future<String?> saveCsv(String fileName, Uint8List bytes, {String? dialogTitle}) {
  return FilePicker.platform.saveFile(
    dialogTitle: dialogTitle,
    fileName: fileName,
    type: FileType.custom,
    allowedExtensions: ['csv'],
    bytes: bytes,
  );
}

/// Partage le CSV via la feuille de partage système (mail, messagerie, cloud…).
Future<void> shareCsv(String fileName, Uint8List bytes, {String? subject, String? text}) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$fileName');
  await file.writeAsBytes(bytes);
  await Share.shareXFiles([XFile(file.path)], subject: subject, text: text);
}
