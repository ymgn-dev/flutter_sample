import 'package:flutter/material.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends HookConsumerWidget
    with DragFeedback, DragPlaceHolder, DragCompletion {
  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget feedback(List<DraggableGridItem> list, int index) {
    return SizedBox(
      child: list[index].child,
      width: 200,
      height: 150,
    );
  }

  @override
  PlaceHolderWidget placeHolder(List<DraggableGridItem> list, int index) {
    return PlaceHolderWidget(
      child: Container(
        color: Colors.white,
      ),
    );
  }

  @override
  void onDragAccept(List<DraggableGridItem> list) {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = useState(false);
    final list = useState(<DraggableGridItem>[]);

    useEffect(
      () {
        list.value = [
          for (var i = 0; i < 8; i++)
            DraggableGridItem(
              child: _GridItem(text: '$i'),
              isDraggable: isEditing.value,
            ),
        ];
        return null;
      },
      [isEditing.value],
    );

    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('isEditing: ${isEditing.value}'),
          actions: [
            IconButton(
              onPressed: () => isEditing.value = !isEditing.value,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: SafeArea(
          child: DraggableGridViewBuilder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 3),
            ),
            children: list.value,
            dragCompletion: this,
            isOnlyLongPress: true,
            dragFeedback: this,
            dragPlaceHolder: this,
          ),
        ),
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  const _GridItem({required this.text, Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Container(
        width: 80,
        height: 80,
        color: Colors.amber,
        child: Text(text),
      ),
    );
  }
}
