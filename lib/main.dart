import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const ClipPathAnimationApp());
}

class ClipPathAnimationApp extends StatelessWidget {
  const ClipPathAnimationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AnimtedClipPath(),
    );
  }
}

class AnimtedClipPath extends StatefulWidget {
  const AnimtedClipPath({Key? key}) : super(key: key);

  @override
  State<AnimtedClipPath> createState() => _AnimtedClipPathState();
}

class _AnimtedClipPathState extends State<AnimtedClipPath>
    with SingleTickerProviderStateMixin {
  final colors = const [
    ColorModel(Color(0xffA232B8), Alignment.topLeft),
    ColorModel(Color(0xffDBDBDB), Alignment.topCenter),
    ColorModel(Color(0xffA8E0FF), Alignment.topRight),
    ColorModel(Color(0xffB08EA2), Alignment.centerRight),
    ColorModel(Color(0xffFA9DE7), Alignment.centerLeft),
    ColorModel(Color(0xffF0C0B6), Alignment.bottomLeft),
    ColorModel(Color(0xffC8B8E3), Alignment.bottomCenter),
    ColorModel(Color(0xffB6F0EB), Alignment.bottomRight),
  ];

  late AnimationController animationController;

  late ColorModel currentColor;
  late ColorModel prevColor;
  @override
  void initState() {
    super.initState();
    currentColor = colors.first;
    prevColor = colors.last;
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .6,
              color: prevColor.color,
              width: double.infinity,
            ),
            AnimatedBuilder(
                animation: animationController,
                builder: (context, _) {
                  return ClipPath(
                    clipper: CustomPath(
                        animationController.value, currentColor.alignment),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .6,
                      color: currentColor.color,
                      width: double.infinity,
                    ),
                  );
                }),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              itemCount: colors.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    currentColor = colors[index];
                    animationController.forward(from: 0.0).whenComplete(() {
                      prevColor = currentColor;
                      setState(() {});
                    });
                  },
                  child: GridViewItem(
                    color: colors[index].color,
                  ),
                );
              },
            ),
          ),
        )
      ]),
    );
  }
}

class GridViewItem extends StatelessWidget {
  const GridViewItem({Key? key, required this.color}) : super(key: key);

  final Color color;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color,
    );
  }
}

class ColorModel {
  final Color color;
  final Alignment alignment;
  const ColorModel(this.color, this.alignment);
}

class CustomPath extends CustomClipper<Path> {
  final double value;

  final Alignment alignment;
  CustomPath(this.value, this.alignment);
  @override
  Path getClip(Size size) {
    Path path = Path();

    if (alignment == Alignment.topLeft) {
      buildPath(
       
        path,
        size ,
        const Offset(0, 0),
      );
    } else if (alignment == Alignment.topCenter) {
      buildPath(
        path,
        size ,
        Offset(size.width / 2, 0),
      );
    } else if (alignment == Alignment.topRight) {
      buildPath(
       path,
        size ,
        Offset(size.width, 0),
      );
    } else if (alignment == Alignment.centerRight) {
      buildPath(
       path,
        size ,
        Offset(size.width, size.height / 2),
      );
    } else if (alignment == Alignment.bottomRight) {
      buildPath(
      path,
        size ,
        Offset(size.width, size.height),
      );
    } else if (alignment == Alignment.bottomCenter) {
      buildPath(
         path,
        size ,
        Offset(size.width / 2, size.height),
      );
    } else if (alignment == Alignment.bottomLeft) {
      buildPath(
        path,
        size ,
        Offset(0, size.height),
      );
    } else if (alignment == Alignment.centerLeft) {
      buildPath(
        path,
        size ,
        Offset(0, size.height / 2),
      );
    }

    return path;
  }

  void buildPath(Path path, Size size, Offset offset) {
    path.addOval(Rect.fromCenter(
      center: offset,
      width: size.width * 2 * value,
      height: size.height * 2 * value,
    ));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
