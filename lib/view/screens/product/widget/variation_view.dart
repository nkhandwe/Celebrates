import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/product_model.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

import '../../../../helper/responsive_helper.dart';

class VariationView extends StatelessWidget {
  final Product? product;
  const VariationView({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: product!.choiceOptions!.length,
          padding: ResponsiveHelper.isDesktop(context)
              ? const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeSmall)
              : const EdgeInsets.all(Dimensions.paddingSizeSmall),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  product!.choiceOptions![index].title!,
                  style: joseFinSansMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge),
                ),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 10,
                    childAspectRatio: (1 / 0.35),
                  ),
                  padding: const EdgeInsets.only(top: 10.0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: product!.choiceOptions![index].options!.length,
                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: () {
                        productProvider.setCartVariationIndex(index, i);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeExtraSmall,
                        ),
                        decoration: BoxDecoration(
                          color: productProvider.variationIndex![index] != i
                              ? Theme.of(context).canvasColor
                              : Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(50),
                          border: productProvider.variationIndex![index] != i
                              ? Border.all(
                                  color: ColorResources.getGreyColor(context),
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Text(
                          product!.choiceOptions![index].options![i].trim(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: joseFinSansRegular.copyWith(
                            color: productProvider.variationIndex![index] != i
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: index != product!.choiceOptions!.length - 1
                      ? Dimensions.paddingSizeSmall
                      : 0,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
