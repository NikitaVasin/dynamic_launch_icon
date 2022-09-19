import 'dart:typed_data';

import 'package:flutter/material.dart';

class DynamicLaunchIconModel {
  final String id;
  final String? name;
  final ImageProvider? imagePreview;

  const DynamicLaunchIconModel({
    required this.id,
    this.name,
    this.imagePreview,
  });

  factory DynamicLaunchIconModel.fromMap(Map map) {
    ImageProvider? provider;
    final preview = map['iconPreview'];
    if (preview is List) {
      final imageByteList = preview.cast<int>();
      provider = MemoryImage(Uint8List.fromList(imageByteList));
    }
    return DynamicLaunchIconModel(
      id: map['id'] ?? '',
      name: map['name'],
      imagePreview: provider,
    );
  }

  @override
  String toString() =>
      'DynamicIconModel(id: $id, name: $name, imagePreview: $imagePreview)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DynamicLaunchIconModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
