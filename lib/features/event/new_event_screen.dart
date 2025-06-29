import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewEventScreen extends ConsumerWidget {
  const NewEventScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("data"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.done))],
      ),
      body: Column(
        children: [
          Row(
            children: [Text("data"), Flexible(child: TextField())],
          ),
          Row(
            children: [Text("data"), Flexible(child: TextField())],
          ),
          Row(
            children: [Text("data"), Flexible(child: TextField())],
          ),
          Row(
            children: [Text("data"), Flexible(child: TextField())],
          ),
          Row(
            children: [Text("data"), Flexible(child: TextField())],
          ),
          Row(
            children: [Text("data"), Flexible(child: TextField())],
          ),
          Row(
            children: [Text("data"), Flexible(child: TextField())],
          )
        ],
      ),
    );
  }
}
