import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/cart_model.dart';
import 'package:flutter_grocery/data/model/response/product_model.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';

import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../../../../localization/language_constraints.dart';

class CustomImageAndTitle extends StatelessWidget {
  final ProductProvider? product;
  const CustomImageAndTitle({Key? key, @required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool messageTextOn = false;
    bool customImageOn = false;
    messageTextOn = false;
    customImageOn = false;
    // TextEditingController cakeNameController = TextEditingController();
    FocusNode cakeNameNode = FocusNode();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //   messageTextOn?
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
        //   child: Text(getTranslated('cake_name', context),style: joseFinSansMedium),
        // ):SizedBox(),
        // SizedBox(height: messageTextOn?Dimensions.PADDING_SIZE_SMALL:0),
        // messageTextOn?
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
        //   child: CustomTextField(
        //     // hintText: 'white something',
        //     isShowBorder: true,
        //     controller: cart.customMessage,
        //     focusNode: cakeNameNode,
        //     inputType: TextInputType.name,
        //     capitalization: TextCapitalization.words,
        //     onChanged: (text) => cart.setMessageText(text),
        //   ),
        // ):SizedBox(),
        // SizedBox(height:customImageOn? Dimensions.PADDING_SIZE_LARGE:0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: product != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      /* Container(width: 100, height: 100,
                  child: ResponsiveHelper.isWeb()? Image.network(product!.imageFile.path, width: 100, height: 100,
                    fit: BoxFit.cover,
                  ):Image.file(File(product!.imageFile.path), width: 100, height: 100,
                    fit: BoxFit.cover,
                  )
                  ,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),*/
                      /* Positioned(
                  top:0,right:0,
                  child: InkWell(
                    onTap :() => product!.removeImage(),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(Icons.clear,color: Colors.red,size: 15,),
                        )),
                  ),
                ),*/
                    ],
                  ),
                )
              : SizedBox(),
        ),
        customImageOn
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(getTranslated('upload_image', context)!,
                    style: joseFinSansMedium),
              )
            : SizedBox(),
        SizedBox(height: customImageOn ? 10 : 0),
        customImageOn
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  onTap: () async {
                    Provider.of<ProductProvider>(context, listen: false)
                        .pickImage(false);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                            width: .15, color: Theme.of(context).hintColor)),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Text(getTranslated('choose_file', context)!),
                          Spacer(),
                          Icon(Icons.cloud_upload_outlined)
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
