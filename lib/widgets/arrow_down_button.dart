import 'package:chat_ai/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ArrowDownButton extends StatefulWidget {
  final ScrollController controller;

  const ArrowDownButton({Key? key, required this.controller}) : super(key: key);

  @override
  State<ArrowDownButton> createState() => _ArrowDownButtonState();
}

class _ArrowDownButtonState extends State<ArrowDownButton> {
  bool isBottom = false;
  double opacity = 1;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (!widget.controller.hasClients) return;
      if (widget.controller.position.atEdge) {
        setState(() {
          isBottom = widget.controller.position.pixels != 0;
          if (isBottom) opacity = 0;
        });
      } else if (isBottom) {
        setState(() {
          opacity = 1;
          isBottom = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: 200.ms,
      child: FloatingActionButton(
        onPressed: () {
          if (!isBottom) {
            widget.controller
                .jumpTo(widget.controller.position.maxScrollExtent);
          }
        },
        child: const Icon(Icons.arrow_downward),
      ),
    );
  }
}
