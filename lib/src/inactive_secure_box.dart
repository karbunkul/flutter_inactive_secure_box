import 'dart:ui';

import 'package:flutter/widgets.dart';

class InactiveSecureBox extends StatefulWidget {
  final Widget child;
  final double? sigma;

  const InactiveSecureBox({required this.child, Key? key, this.sigma})
      : super(key: key);

  @override
  _InactiveSecureBoxState createState() => _InactiveSecureBoxState();
}

class _InactiveSecureBoxState extends State<InactiveSecureBox>
    with WidgetsBindingObserver {
  GlobalKey key = GlobalKey();
  Size? size;
  bool hasSecure = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    final renderObject = key.currentContext;

    setState(() {
      size = renderObject?.size;
      hasSecure = state == AppLifecycleState.inactive;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final otherBox = context.findAncestorWidgetOfExactType<InactiveSecureBox>();

    if (!hasSecure || otherBox != null) {
      return RepaintBoundary(key: key, child: widget.child);
    }

    double sigma = 10;
    if ((widget.sigma ?? 0) > 0) {
      sigma = widget.sigma!;
    }

    const inactiveKey = Key('inactive');

    final filter = ImageFilter.blur(sigmaX: sigma, sigmaY: sigma);

    if (MediaQuery.of(context).size == size) {
      // fullscreen logic
      return Stack(
        key: inactiveKey,
        children: [
          widget.child,
          BackdropFilter(
            filter: filter,
            child: const SizedBox.expand(),
          ),
        ],
      );
    } else {
      // blur only widget
      return ImageFiltered(
        key: inactiveKey,
        imageFilter: filter,
        child: widget.child,
        // child: const SizedBox.expand(),
      );
    }
  }
}
