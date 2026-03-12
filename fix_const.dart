import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    String content = file.readAsStringSync();
    String newContent = content.replaceAll('SizedBox.shrink()(', 'Container(');

    if (content != newContent) {
      file.writeAsStringSync(newContent);
    }
  }
}
