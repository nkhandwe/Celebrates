import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/cart_model.dart';
import 'package:flutter_grocery/data/model/response/product_model.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

import '../../../../localization/language_constraints.dart';
import '../../../../provider/cart_provider.dart';
import '../../../../provider/splash_provider.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_snackbar.dart';

class AddonItemBottomSheet extends StatefulWidget {
  CartModel? cartModel;
  List<AddOns>? list;

  AddonItemBottomSheet(this.cartModel, this.list);

  @override
  _AddonItemBottomSheetState createState() => _AddonItemBottomSheetState();
}

class _AddonItemBottomSheetState extends State<AddonItemBottomSheet> {
  List<String> selectedAddons = [];
  List<bool> isSelect = [];

  // Dummy addon items for demonstration
  List<int> addonItemsQty = [];

  void _toggleAddonSelection(String addon) {
    setState(() {
      if (selectedAddons.contains(addon)) {
        selectedAddons.remove(addon);
      } else {
        selectedAddons.add(addon);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.list!.isNotEmpty) {
      for (int i = 0; i < widget.list!.length; i++) {
        isSelect.add(false);
        addonItemsQty.add(1);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Addon Items',
            style: joseFinSansMedium.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.list!.length,
              itemBuilder: (context, index) {
                print(
                    "https://celebrates.in/admin/storage/app/public/addon/${widget.list![index].image!}");
                // final addon = addonItems[index];
                // final isSelected = selectedAddons.contains(addon);
                return Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder(context),
                          image:
                              'https://celebrates.in/admin/storage/app/public/addon/${widget.list![index].image!}',
                          width: double.infinity,
                          fit: BoxFit.fill,
                          imageErrorBuilder: (c, o, s) => Image.asset(
                              Images.placeholder(context),
                              width: 85),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 7,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.list![index].name.toString()),
                                  Text(
                                    "₹ " + widget.list![index].price.toString(),
                                    style: joseFinSansMedium.copyWith(
                                        fontSize: 14,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (addonItemsQty[index] > 0) {
                                            setState(() {
                                              addonItemsQty[index]--;
                                            });
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeSmall,
                                              vertical: Dimensions
                                                  .paddingSizeExtraSmall),
                                          child: Icon(Icons.remove,
                                              size: 20,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                      Text("${addonItemsQty[index].toString()}",
                                          style: joseFinSansSemiBold.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeExtraLarge,
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            addonItemsQty[index]++;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeSmall,
                                              vertical: Dimensions
                                                  .paddingSizeExtraSmall),
                                          child: Icon(Icons.add,
                                              size: 20,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Checkbox(
                                  value: isSelect[index],
                                  checkColor: Theme.of(context).cardColor,
                                  activeColor: Theme.of(context).primaryColor,
                                  visualDensity: VisualDensity(
                                      horizontal: -4, vertical: -4),
                                  onChanged: (value) {
                                    setState(() {
                                      isSelect[index] = value!;
                                    });
                                  }),
                            )
                          ],
                        )

                        /*CheckboxListTile(value: isSelect[index],
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity(horizontal: -4,vertical: -4),
                          title: Text(widget.list![index].name.toString()),
                          checkColor: Theme.of(context).cardColor,
                          activeColor: Theme.of(context).primaryColor,
                          subtitle: Column(
                            crossAxisAlignment:CrossAxisAlignment.start,

                            children: [
                              Text("₹ "+widget.list![index].price.toString(),style: joseFinSansMedium.copyWith(fontSize: 14,color: Theme.of(context).primaryColor),),
                               Row(
                                 children: [
                                   InkWell(
                                        onTap: () {
                                         if(addonItemsQty[index]>1)
                                           {
                                             addonItemsQty[index]--;
                                             setState(() {

                                             });
                                           }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: Dimensions.paddingSizeSmall,
                                              vertical: Dimensions.paddingSizeExtraSmall),
                                          child: Icon(Icons.remove,
                                              size: 20, color: Theme.of(context).primaryColor),
                                        ),
                                      ),
                                   Text("${addonItemsQty[index].toString()}",
                                       style: joseFinSansSemiBold.copyWith(
                                           fontSize: Dimensions.fontSizeExtraLarge,
                                           color: Theme.of(context).primaryColor)),
                                   InkWell(
                                     onTap: () {
                                       if (addonItemsQty[index]>1) {
                                         addonItemsQty[index]++;
                                         setState(() {

                                         });
                                       }

                                     },
                                     child: Padding(
                                       padding: const EdgeInsets.symmetric(
                                           horizontal: Dimensions.paddingSizeSmall,
                                           vertical: Dimensions.paddingSizeExtraSmall),
                                       child: Icon(Icons.add,
                                           size: 20, color: Theme.of(context).primaryColor),
                                     ),
                                   ),
                                 ],
                               ),

                            ],
                          ),
                          onChanged: (value){

                        setState(() {
                          isSelect[index] = value!;
                        });
                      }),*/
                        ),
                  ],
                );

                /*ListTile(
                  title: Text(widget.list![index].name.toString()),
                  subtitle: Text(widget.list![index].name.toString(),style: joseFinSansMedium.copyWith(fontSize: 14),),
                  trailing: isSelected
                      ? Icon(Icons.check_box, color: Theme.of(context).primaryColor)
                      : Icon(Icons.check_box_outline_blank),
                  onTap: () => _toggleAddonSelection(addon),
                );*/
              },
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: CustomButton(
                    margin: Dimensions.paddingSizeSmall,
                    buttonText: "Skip",
                    backgroundColor: Colors.white,
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(widget.cartModel!);

                      showCustomSnackBar(
                          getTranslated('added_to_cart', context)!,
                          isError: false);
                      Navigator.pop(context);
                    }),
              ),
              Expanded(
                flex: 6,
                child: CustomButton(
                    margin: Dimensions.paddingSizeSmall,
                    buttonText: getTranslated('add_to_card', context),
                    onPressed: () {
                      List<AddOns> item = [];
                      List<int> itemQty = [];
                      for (int i = 0; i < isSelect.length; i++) {
                        if (isSelect[i]) {
                          item.add(widget.list![i]);
                          itemQty.add(addonItemsQty[i]);
                        }
                      }
                      widget.cartModel!.addOnItem = item;
                      widget.cartModel!.addOnQtySet = itemQty;

                      print(widget.cartModel!.addOn);

                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(widget.cartModel!);

                      showCustomSnackBar(
                          getTranslated('added_to_cart', context)!,
                          isError: false);
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Example usage
void openAddonItemBottomSheet(
    BuildContext context, CartModel cartModel, List<AddOns> list) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    isScrollControlled: false,
    builder: (BuildContext context) {
      return AddonItemBottomSheet(cartModel, list);
    },
  );
}
