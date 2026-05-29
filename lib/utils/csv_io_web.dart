import 'dart:js_interop';
import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';
import 'package:web/web.dart' as web;

/// Sur le web, « enregistrer » = déclencher un téléchargement navigateur.
/// Renvoie le nom du fichier téléchargé (jamais `null` : pas d'annulation possible).
Future<String?> saveCsv(String fileName, Uint8List bytes, {String? dialogTitle}) async {
  _download(fileName, bytes);
  return fileName;
}

/// Partage via l'API Web Share (si supportée), sinon repli sur le téléchargement.
Future<void> shareCsv(String fileName, Uint8List bytes, {String? subject, String? text}) async {
  try {
    await Share.shareXFiles(
      [XFile.fromData(bytes, name: fileName, mimeType: 'text/csv')],
      subject: subject,
      text: text,
    );
  } catch (_) {
    // Navigateur sans Web Share API (ex. desktop) → téléchargement.
    _download(fileName, bytes);
  }
}

void _download(String fileName, Uint8List bytes) {
  final blob = web.Blob(
    [bytes.toJS].toJS,
    web.BlobPropertyBag(type: 'text/csv'),
  );
  final url = web.URL.createObjectURL(blob);
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement
    ..href = url
    ..download = fileName
    ..style.display = 'none';
  web.document.body!.appendChild(anchor);
  anchor.click();
  anchor.remove();
  web.URL.revokeObjectURL(url);
}
