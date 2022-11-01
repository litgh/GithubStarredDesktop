import 'dart:io';

bool isDesktop() {
  return Platform.isMacOS || Platform.isWindows || Platform.isLinux;
}
