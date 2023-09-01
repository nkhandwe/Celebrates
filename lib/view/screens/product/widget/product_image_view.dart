import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/product_model.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/view/screens/product/image_zoom_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

import '../../../../utill/app_constants.dart';

class ProductImageView extends StatelessWidget {
  final Product? productModel;
  const ProductImageView({Key? key, required this.productModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(children: [
          InkWell(
            onTap: () => Navigator.of(context).pushNamed(
              RouteHelper.getProductImagesRoute(
                  productModel!.name, jsonEncode(productModel!.image)),
              arguments: ProductImageScreen(
                  imageList: productModel!.image, title: productModel!.name),
            ),
            child: SizedBox(
              height: ResponsiveHelper.isDesktop(context)
                  ? 350
                  : MediaQuery.of(context).size.width - 80,
              // width: double.infinity,
              child: PageView.builder(
                itemCount: productModel!.image!.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    child: FadeInImage.assetNetwork(
                      placeholder: Images.placeholder(context),
                      image:
                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${productModel!.image![index]}',
                      width: double.infinity,
                      fit: BoxFit.fill,
                      imageErrorBuilder: (c, o, s) =>
                          Image.asset(Images.placeholder(context), width: 85),
                    ),
                  );
                },
                onPageChanged: (index) {
                  Provider.of<ProductProvider>(context, listen: false)
                      .setImageSliderSelectedIndex(index);
                },
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _indicators(context),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding:  EdgeInsets.only(bottom: 40,left: MediaQuery.of(context).size.width-60),
              child:InkWell(
                onTap: () async {
                  // final url = Uri.parse("${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${productModel!.image![0]}");
                  // final response = await http.get(url);
                  //
                  // final directory = await getApplicationDocumentsDirectory();
                  // final directoryPath = directory.path;
                  // final imagePath = '$directoryPath/images/${productModel!.name!.replaceAll(" ", "_")}.png';
                  //
                  // final directory2 = Directory('$directoryPath/images');
                  // if (!directory2.existsSync()) {
                  //   directory2.createSync(recursive: true);
                  // }
                  //
                  // await File(imagePath).writeAsBytes(response.bodyBytes);

                  await Share.shareFiles([Provider.of<ProductProvider>(context, listen: false).imagePath!], text: "${productModel!.name!}\nhttps://play.google.com/store/apps/details?id=com.celebrates.app", subject: AppConstants.appName);

                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white
                  ),
                  child: Icon(Icons.share,color: Theme.of(context).primaryColor,),
                ),
              )
            ),
          ),
        ]),
      ],
    );
  }

  List<Widget> _indicators(BuildContext context) {
    List<Widget> indicators = [];
    for (int index = 0; index < productModel!.image!.length; index++) {
      indicators.add(Container(
        width: index == Provider.of<ProductProvider>(context).imageSliderIndex
            ? 18
            : 7,
        height: 7,
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
            color: index ==
                    Provider.of<ProductProvider>(context).imageSliderIndex
                ? Theme.of(context).primaryColor
                : Theme.of(context).hintColor.withOpacity(0.6).withOpacity(.8),
            borderRadius:
                index == Provider.of<ProductProvider>(context).imageSliderIndex
                    ? BorderRadius.circular(50)
                    : BorderRadius.circular(25)),
      ));
    }
    return indicators;
  }
}
