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
      appBar: AppBar(title: Text(widget.name)),
    );
  }
}
