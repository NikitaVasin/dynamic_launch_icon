import 'package:dynamic_launch_icon/dynamic_launch_icon.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: FutureBuilder<List<DynamicLaunchIconModel>?>(
          initialData: null,
          future: DynamicLaunchIconPlatform.instance.getAvailableIcons(),
          builder: (context, snapshot) {
            final list = snapshot.data;
            if (list == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return StreamBuilder<String?>(
              stream: DynamicLaunchIconPlatform.instance.getActiveIconIdStream(),
              builder: (context, snapshot) {
                final activeId = snapshot.data;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                      list.length,
                      (index) {
                        final item = list[index];
                        return GestureDetector(
                          onTap: () => DynamicLaunchIconPlatform.instance
                              .setActiveIcon(item.id),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("ID -> ${item.id}"),
                                      Text("NAME -> ${item.name ?? ''}"),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                if (item.imagePreview != null)
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: item.id == activeId
                                          ? Border.all(
                                              width: 5,
                                              color: Colors.red,
                                            )
                                          : null,
                                    ),
                                    child: Image(
                                      image: item.imagePreview!,
                                      width: 100,
                                      height: 100,
                                    ),
                                  )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
