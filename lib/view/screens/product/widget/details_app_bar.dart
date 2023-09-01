import 'package:flutter/material.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/view/screens/menu/menu_screen.dart';
import 'package:provider/provider.dart';

class DetailsAppBar extends StatefulWidget implements PreferredSizeWidget {
  const DetailsAppBar({Key? key}) : super(key: key);

  @override
  DetailsAppBarState createState() => DetailsAppBarState();

  @override
  Size get preferredSize => const Size(double.maxFinite, 50);
}

class DetailsAppBarState extends State<DetailsAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  void shake() {
    controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 15.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });

    return AppBar(
      leading: Container(
        height: 50,
        width: 50,
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        alignment: Alignment.center,
        child: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              color: Theme.of(context).primaryColor, size: 25),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      elevation: 0.0,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      actions: [
        AnimatedBuilder(
          animation: offsetAnimation,
          builder: (buildContext, child) {
            return Container(
              padding: EdgeInsets.only(
                  left: offsetAnimation.value + 15.0,
                  right: 15.0 - offsetAnimation.value),
              child: Container(
                height: 50,
                width: 50,
                padding: const EdgeInsets.all(1),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                child: IconButton(
                  icon: Stack(clipBehavior: Clip.none, children: [
                    Image.asset(Images.cartIcon,
                        width: 23,
                        height: 25,
                        color: Theme.of(context).primaryColor),
                    Positioned(
                      top: -7,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor),
                        child: Text(
                            '${Provider.of<CartProvider>(context).cartList.length}',
                            style: TextStyle(
                                color: Theme.of(context).cardColor,
                                fontSize: 10)),
                      ),
                    ),
                  ]),
                  onPressed: () {
                    Provider.of<SplashProvider>(context, listen: false)
                        .setPageIndex(2);
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const MenuScreen()));
                  },
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
