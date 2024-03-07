import 'dart:async';

import 'package:flutter/material.dart';
import 'package:palm_client/client_provider.dart';
import 'package:provider/provider.dart';

class Interact extends StatefulWidget {
  final String name;
  const Interact({
    super.key,
    required this.name,
  });

  @override
  State<StatefulWidget> createState() => _InteractState();
}

class _InteractState extends State<Interact> {
  late ClientProvider clientProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    clientProvider = Provider.of<ClientProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    clientProvider.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
          automaticallyImplyLeading: false,
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Consumer<ClientProvider>(
                builder: (context, clientProvider, _) => Wrap(
                  spacing: 10,
                  children: [
                    GestureDetector(
                        onTap: () => clientProvider.sendKey(KeyInput.f5),
                        child: const Chip(label: Text("Trình chiếu từ đầu"))),
                    GestureDetector(
                        onTap: () => clientProvider.sendKey(KeyInput.shiftf5),
                        child: const Chip(
                            label: Text("Trình chiếu trang hiện tại"))),
                    GestureDetector(
                        onTap: () => clientProvider.sendKey(KeyInput.esc),
                        child: const Chip(label: Text("Thoát trình chiếu"))),
                  ],
                ),
              ),
            ),
          ),
          const ColumnBigIconButton(
              icon: Icon(Icons.expand_less), input: KeyInput.right),
          const ColumnBigIconButton(
              icon: Icon(Icons.expand_more), input: KeyInput.left),
        ]));
  }
}

class ColumnBigIconButton extends StatelessWidget {
  final Icon icon;
  final KeyInput input;
  const ColumnBigIconButton(
      {super.key, required this.icon, required this.input});

  @override
  Widget build(BuildContext context) {
    Timer? longHold;
    return Expanded(
      child: Consumer<ClientProvider>(
        builder: (context, clientProvider, _) => GestureDetector(
          onTap: () => clientProvider.sendKey(input),
          onLongPress: () => longHold = Timer.periodic(
            const Duration(milliseconds: 100),
            (_) => clientProvider.sendKey(input),
          ),
          onLongPressUp: () => longHold?.cancel(),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}
