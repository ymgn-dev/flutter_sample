import 'dart:io';

import 'package:flutter/material.dart';
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

final nameProvider = StateProvider.autoDispose<String?>((ref) {
  ref.onDispose(() => print('disposed'));
  return null;
});
final name2Provider = StateProvider.autoDispose<String?>((ref) {
  ref.onDispose(() => print('disposed'));
  return null;
});

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('rebuild');

    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: SafeArea(
          child: CustomScrollView(
            physics: Platform.isIOS
                ? const BouncingScrollPhysics()
                : const ClampingScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  HookConsumer(builder: (context, ref, child) {
                    final name = ref.watch(nameProvider);
                    final notifier = ref.watch(nameProvider.state);
                    return _MyTextForm(
                      initialValue: name,
                      onChanged: (newName) =>
                          notifier.update((state) => newName),
                    );
                  }),
                  Builder(builder: (context) {
                    final name = ref.watch(name2Provider);
                    final notifier = ref.watch(name2Provider.state);
                    return _MyTextForm(
                      initialValue: name,
                      onChanged: (newName) =>
                          notifier.update((state) => newName),
                    );
                  }),
                  for (var i = 0; i < 40; i++)
                    SizedBox(height: 64, child: Text('$i')),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyTextForm extends HookConsumerWidget {
  const _MyTextForm({Key? key, this.initialValue, this.onChanged})
      : super(key: key);

  final String? initialValue;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFormField(initialValue: initialValue, onChanged: onChanged);
  }
}
