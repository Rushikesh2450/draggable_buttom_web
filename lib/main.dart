import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: AnimatedDock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedDock extends StatefulWidget {
  const AnimatedDock({
    super.key,
    required this.items,
  });

  final List<IconData> items;

  @override
  State<AnimatedDock> createState() => _AnimatedDockState();
}

class _AnimatedDockState extends State<AnimatedDock> {
  late List<IconData> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedSize(
          duration: Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black12,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: _items.asMap().map((index, icon) => MapEntry(index, _buildDraggableItem(index, icon))).values.toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDraggableItem(int index, IconData icon) {
    return Draggable<IconData>(
      data: icon,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.primaries[icon.hashCode % Colors.primaries.length],
            ),
            child: Icon(icon, color: Colors.white, size: 30)),
      ),
      childWhenDragging: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        child: SizedBox(),
      ) /*Opacity(
        opacity: 0.5,
        child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.primaries[icon.hashCode % Colors.primaries.length],
            ),
            child: Icon(icon, color: Colors.white, size: 30)),
      )*/
      ,
      child: DragTarget<IconData>(
        onAccept: (receivedIcon) {
          setState(() {
            // Handle item drop: Reorder items
            final fromIndex = _items.indexOf(receivedIcon);
            final toIndex = index;
            if (fromIndex != toIndex) {
              final item = _items.removeAt(fromIndex);
              _items.insert(toIndex, item);
            }
          });
        },
        builder: (context, candidateData, rejectedData) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.primaries[icon.hashCode % Colors.primaries.length],
            ),
            child: Center(child: Icon(icon, color: Colors.white, size: 24)),
          );
        },
      ),
    );
  }
}