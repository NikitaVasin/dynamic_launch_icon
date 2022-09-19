import 'package:flutter/material.dart';

import 'dynamic_launch_icon_model.dart';
import 'dynamic_launch_icon_platform_interface.dart';

class DynamicIconCurrentIconIdWidget extends StatefulWidget {
  final Widget Function(BuildContext context, String? id) builder;

  const DynamicIconCurrentIconIdWidget({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  State<DynamicIconCurrentIconIdWidget> createState() =>
      _DynamicIconCurrentIconIdWidgetState();
}

class _DynamicIconCurrentIconIdWidgetState
    extends State<DynamicIconCurrentIconIdWidget> {
  final _stream = DynamicLaunchIconPlatform.instance.getActiveIconIdStream();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
      stream: _stream,
      builder: (context, snapshot) {
        return widget.builder(context, snapshot.data);
      },
    );
  }
}

class DynamicIconAvalableStateWidget extends StatefulWidget {
  final Widget Function(BuildContext context, bool isAvalable) builder;

  const DynamicIconAvalableStateWidget({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  State<DynamicIconAvalableStateWidget> createState() =>
      _DynamicIconAvalableStateWidgetState();
}

class _DynamicIconAvalableStateWidgetState
    extends State<DynamicIconAvalableStateWidget> {
  late Future<bool> _future;

  @override
  void initState() {
    _future = DynamicLaunchIconPlatform.instance.isAvailable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _future,
      builder: (context, snapshot) =>
          widget.builder(context, snapshot.data ?? false),
    );
  }
}

class DynamicIconAvaliableIconsWidget extends StatefulWidget {
  final Widget Function(BuildContext context, List<DynamicLaunchIconModel>? icons)
      builder;

  const DynamicIconAvaliableIconsWidget({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  State<DynamicIconAvaliableIconsWidget> createState() =>
      _DynamicIconAvaliableIconsWidgetState();
}

class _DynamicIconAvaliableIconsWidgetState
    extends State<DynamicIconAvaliableIconsWidget> {
  late Future<List<DynamicLaunchIconModel>?> _future;

  @override
  void initState() {
    _future = DynamicLaunchIconPlatform.instance.getAvailableIcons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DynamicLaunchIconModel>?>(
      future: _future,
      builder: (context, snapshot) => widget.builder(context, snapshot.data),
    );
  }
}
