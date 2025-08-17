import 'package:file/file.dart';




import 'package:flutter/cupertino.dart';

class ImageInputAdapter {
  /// Initialize from either a URL or a file, but not both.
  ImageInputAdapter({
    required this.file,
    required this.url
  }); //: assert(file != null || url != null), assert(file != null && url == null), assert(file == null);

  /// An image file
  final File file;
  /// A direct link to the remote image
  final String url;

  /// Render the image from a file or from a remote source.
  Widget widgetize() {
    return Image.file(file);
    }
}