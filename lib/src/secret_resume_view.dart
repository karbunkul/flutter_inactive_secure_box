import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SecretResumeView extends StatefulWidget {
  final Widget child;
  final double? sigma;
  const SecretResumeView({required this.child, Key? key, this.sigma})
      : super(key: key);

  @override
  _SecretResumeViewState createState() => _SecretResumeViewState();
}

class _SecretResumeViewState extends State<SecretResumeView>
    with WidgetsBindingObserver {
  final _key = GlobalKey();
  MemoryImage? _capture;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    MemoryImage? newCapture;
    var boundary = _key.currentContext?.findRenderObject();
    if (state == AppLifecycleState.inactive && boundary != null) {
      var image = await (boundary as RenderRepaintBoundary).toImage();
      var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();
      newCapture = MemoryImage(pngBytes);
    } else {
      newCapture = null;
    }

    if (_capture != newCapture) {
      setState(() => _capture = newCapture);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_capture != null) {
      double sigma = 10;
      if ((widget.sigma ?? 0) > 0) {
        sigma = widget.sigma!;
      }
      return LayoutBuilder(
        builder: (_, constraints) {
          return Stack(
            children: [
              Image(image: _capture!),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                child: SizedBox(
                  width: constraints.smallest.width,
                  height: constraints.smallest.height,
                ),
              )
            ],
          );
        },
      );
    }

    return RepaintBoundary(key: _key, child: widget.child);
  }
}
