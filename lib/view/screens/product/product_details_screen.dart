import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/cart_model.dart';
import 'package:flutter_grocery/data/model/response/product_model.dart';
import 'package:flutter_grocery/helper/price_converter.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/localization_provider.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/custom_directionality.dart';
import 'package:flutter_grocery/view/base/custom_loader.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/base/footer_view.dart';
import 'package:flutter_grocery/view/base/custom_zoom_widget.dart';
import 'package:flutter_grocery/view/base/rating_bar.dart';
import 'package:flutter_grocery/view/base/web_app_bar/web_app_bar.dart';
import 'package:flutter_grocery/view/screens/product/widget/details_app_bar.dart';
import 'package:flutter_grocery/view/screens/product/widget/product_image_view.dart';
import 'package:flutter_grocery/view/screens/product/widget/product_title_view.dart';
import 'package:flutter_grocery/view/screens/product/widget/rating_bar.dart';
import 'package:flutter_grocery/view/screens/product/widget/variation_view.dart';
import 'package:flutter_grocery/view/screens/product/widget/web_product_information.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../base/custom_text_field.dart';
import '../cart/widget/custom_image_and_tile_for_order.dart';
import 'widget/addon_bottom_sheet.dart';
import 'widget/product_review.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final bool? fromSearch;
  const ProductDetailsScreen(
      {Key? key, required this.product, this.fromSearch = false})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  List<XFile> selectImage = [];
  TextEditingController descriptionNote = TextEditingController();
  int _tabIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);

    Provider.of<ProductProvider>(context, listen: false).getProductDetails(
      context,
      '${widget.product.id}',
      Provider.of<LocalizationProvider>(context, listen: false)
          .locale
          .languageCode,
      searchQuery: widget.fromSearch!,
    );
    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<CartProvider>(context, listen: false).getCartData();
    Provider.of<CartProvider>(context, listen: false).setSelect(0, false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Variations? variation;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(
              preferredSize: Size.fromHeight(120), child: WebAppBar())
          : DetailsAppBar(key: UniqueKey()),
      body: Consumer<CartProvider>(builder: (context, cart, child) {
        return Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            double? price = 0;
            int? stock = 0;
            double? priceWithQuantity = 0;
            CartModel? cartModel;

            if (productProvider.product != null) {
              List<String> variationList = [];

              productProvider.FileData(
                  context,
                  productProvider.product!.image![0].toString(),
                  productProvider.product!.name.toString());

              for (int index = 0;
                  index < productProvider.product!.choiceOptions!.length;
                  index++) {
                variationList.add(productProvider.product!.choiceOptions![index]
                    .options![productProvider.variationIndex![index]]
                    .replaceAll(' ', ''));
              }
              String variationType = '';
              bool isFirst = true;
              for (var variation in variationList) {
                if (isFirst) {
                  variationType = '$variationType$variation';
                  isFirst = false;
                } else {
                  variationType = '$variationType-$variation';
                }
              }

              price = productProvider.product!.price;
              stock = productProvider.product!.totalStock;

              for (Variations variationData
                  in productProvider.product!.variations!) {
                if (variationData.type == variationType) {
                  price = variationData.price;
                  variation = variationData;
                  stock = variationData.stock;
                  break;
                }
              }
              double? priceWithDiscount = 0;
              double? categoryDiscountAmount;

              if (productProvider.product!.categoryDiscount != null) {
                categoryDiscountAmount = PriceConverter.convertWithDiscount(
                  price,
                  productProvider.product!.categoryDiscount!.discountAmount,
                  productProvider.product!.categoryDiscount!.discountType,
                  maxDiscount:
                      productProvider.product!.categoryDiscount!.maximumAmount,
                );
              }
              priceWithDiscount = PriceConverter.convertWithDiscount(
                  price,
                  productProvider.product!.discount,
                  productProvider.product!.discountType);

              if (categoryDiscountAmount != null &&
                  categoryDiscountAmount > 0 &&
                  categoryDiscountAmount < priceWithDiscount!) {
                priceWithDiscount = categoryDiscountAmount;
              }

              cartModel = CartModel(
                  productProvider.product!.id,
                  productProvider.product!.image!.isNotEmpty
                      ? productProvider.product!.image![0]
                      : '',
                  productProvider.product!.name,
                  price,
                  priceWithDiscount,
                  productProvider.quantity,
                  variation,
                  (price! - priceWithDiscount!),
                  (price -
                      PriceConverter.convertWithDiscount(
                          price,
                          productProvider.product!.tax,
                          productProvider.product!.taxType)!),
                  productProvider.product!.capacity,
                  productProvider.product!.unit,
                  stock,
                  [],
                  [],
                  productProvider.product,
                  [],
                  "");

              productProvider.setExistData(
                  Provider.of<CartProvider>(context).isExistInCart(cartModel));

              try {
                priceWithQuantity = priceWithDiscount *
                    (productProvider.cartIndex != null
                        ? cart.cartList[productProvider.cartIndex!].quantity!
                        : productProvider.quantity);
              } catch (e) {
                priceWithQuantity = priceWithDiscount;
              }
            }

            return productProvider.product != null
                ? !ResponsiveHelper.isDesktop(context)
                    ? Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              physics: ResponsiveHelper.isMobilePhone()
                                  ? const BouncingScrollPhysics()
                                  : null,
                              child: Center(
                                child: SizedBox(
                                  width: Dimensions.webScreenWidth,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Column(
                                        children: [
                                          ProductImageView(
                                              productModel:
                                                  productProvider.product),
                                          ProductTitleView(
                                              product: productProvider.product,
                                              stock: stock,
                                              cartIndex:
                                                  productProvider.cartIndex),
                                          Padding(
                                            padding: const EdgeInsets.all(
                                                Dimensions.paddingSizeSmall),
                                            child: Row(children: [
                                              Text(
                                                  '${getTranslated('total_amount', context)}:',
                                                  style: joseFinSansMedium
                                                      .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeLarge)),
                                              const SizedBox(
                                                  width: Dimensions
                                                      .paddingSizeExtraSmall),
                                              CustomDirectionality(
                                                  child: Text(
                                                PriceConverter.convertPrice(
                                                    context, priceWithQuantity),
                                                style: joseFinSansBold.copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize:
                                                      Dimensions.fontSizeLarge,
                                                ),
                                              )),
                                            ]),
                                          ),
                                          VariationView(
                                              product: productProvider.product),
                                          const SizedBox(
                                              height:
                                                  Dimensions.paddingSizeLarge),

                                          // CustomImageAndTitle(product: productProvider),

                                          productProvider.product!.msgStatus ==
                                                  "1"
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10.0),
                                                      child: Text("Message",
                                                          style: joseFinSansBold
                                                              .copyWith(
                                                                  fontSize:
                                                                      16)),
                                                    ),
                                                    Padding(
                                                        padding: const EdgeInsets
                                                            .all(Dimensions
                                                                .paddingSizeSmall),
                                                        child: TextFormField(
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText:
                                                                      "Enter Message on Cake",
                                                                  hintStyle: joseFinSansLight.copyWith(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .fontSizeLarge,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .hintColor
                                                                          .withOpacity(
                                                                              0.6)),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(0.0)),
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(
                                                                                0.8),
                                                                        width:
                                                                            0.5),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(0.0)),
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(
                                                                                0.8),
                                                                        width:
                                                                            0.5),
                                                                  )),
                                                          // validator: (value) => value!.isEmpty ? 'Please, fill this field.' : null,
                                                          controller:
                                                              descriptionNote,
                                                        )),
                                                  ],
                                                )
                                              : const SizedBox(),
                                          productProvider.product!.imgStatus ==
                                                  "1"
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10.0),
                                                      child: Text(
                                                          "Upload Images*",
                                                          style: joseFinSansBold
                                                              .copyWith(
                                                                  fontSize:
                                                                      16)),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 12),
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: Dimensions
                                                              .paddingSizeSmall),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.4),
                                                            width: 0.8),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              selectImages();
                                                            },
                                                            child: const Row(
                                                              children: [
                                                                Icon(Icons
                                                                    .cloud_upload_outlined),
                                                                SizedBox(
                                                                  width: 3,
                                                                ),
                                                                Text(
                                                                    "Choose file",
                                                                    style:
                                                                        joseFinSansMedium)
                                                              ],
                                                            ),
                                                          ),
                                                          selectImage.isNotEmpty
                                                              ? const SizedBox(
                                                                  height: 10,
                                                                )
                                                              : SizedBox(),
                                                          selectImage.isNotEmpty
                                                              ? SizedBox(
                                                                  height: 120,
                                                                  child: ListView
                                                                      .builder(
                                                                    itemCount: selectImage
                                                                            .isNotEmpty
                                                                        ? selectImage
                                                                            .length
                                                                        : 0,
                                                                    shrinkWrap:
                                                                        true,
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return SizedBox(
                                                                          height:
                                                                              120,
                                                                          width:
                                                                              120,
                                                                          child:
                                                                              Stack(children: [
                                                                            Image.file(
                                                                              File(selectImage[index].path),
                                                                              height: 120,
                                                                              width: 120,
                                                                              fit: BoxFit.fill,
                                                                            ),
                                                                            Align(
                                                                              alignment: Alignment.topRight,
                                                                              child: InkWell(
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    selectImage.removeAt(index);
                                                                                  });
                                                                                },
                                                                                child: const Padding(
                                                                                  padding: EdgeInsets.all(8),
                                                                                  child: Icon(
                                                                                    Icons.cancel,
                                                                                    color: Colors.red,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ]));
                                                                    },
                                                                  ),
                                                                )
                                                              : const SizedBox(),
                                                          selectImage.isNotEmpty
                                                              ? const SizedBox(
                                                                  height: 10,
                                                                )
                                                              : SizedBox(),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox(),
                                          const SizedBox(
                                            height: 20,
                                          ),

                                          // Description
                                          _description(
                                              context, productProvider),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              width: 1170,
                              child: CustomButton(
                                margin: Dimensions.paddingSizeSmall,
                                buttonText: getTranslated(
                                    productProvider.cartIndex != null
                                        ? 'already_added'
                                        : stock! <= 0
                                            ? 'out_of_stock'
                                            : 'add_to_card',
                                    context),
                                onPressed: (productProvider.cartIndex == null &&
                                        stock! > 0)
                                    ? () {
                                        if (productProvider.cartIndex == null &&
                                            stock! > 0) {
                                          if (selectImage.isNotEmpty) {
                                            print(
                                                "sadfdsafr${selectImage.length}");
                                            cartModel!.imageListData =
                                                selectImage;
                                          }

                                          cartModel?.messageData =
                                              descriptionNote.text.toString();
                                          // cartModel?.messageData =
                                          //     descriptionNote.text.toString();
                                          /* Provider.of<CartProvider>(context,
                                                  listen: false)
                                              .addToCart(cartModel!);*/
                                          //
                                          // print(
                                          //     "asfdsdaf${cartModel.imageList!.length}");
                                          // //   _key.currentState.shake();

                                          if (productProvider
                                              .product!.addOn!.isNotEmpty) {
                                            openAddonItemBottomSheet(
                                                context,
                                                cartModel!,
                                                productProvider
                                                    .product!.addOn!);
                                          } else {
                                            Provider.of<CartProvider>(context,
                                                    listen: false)
                                                .addToCart(cartModel!);
                                          }

                                          showCustomSnackBar(
                                              getTranslated(
                                                  'added_to_cart', context)!,
                                              isError: false);
                                        } else {
                                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('already_added', context)), backgroundColor: Colors.red,));
                                          showCustomSnackBar(getTranslated(
                                              'already_added', context)!);
                                        }
                                      }
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: ResponsiveHelper.isDesktop(context)
                                      ? MediaQuery.of(context).size.height - 400
                                      : MediaQuery.of(context).size.height),
                              child: Column(children: [
                                const SizedBox(
                                    height: Dimensions.paddingSizeSmall),
                                Center(
                                  child: SizedBox(
                                    width: 1170,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            flex: 5,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  height: 350,
                                                  child: Consumer<CartProvider>(
                                                      builder: (context,
                                                          cartProvider, child) {
                                                    return CustomZoomWidget(
                                                      image: FadeInImage
                                                          .assetNetwork(
                                                        placeholder:
                                                            Images.placeholder(
                                                                context),
                                                        fit: BoxFit.cover,
                                                        image:
                                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${productProvider.product!.image!.isNotEmpty ? productProvider.product!.image![cartProvider.productSelect] : ''}',
                                                        imageErrorBuilder: (c,
                                                                o, s) =>
                                                            Image.asset(
                                                                Images
                                                                    .placeholder(
                                                                        context),
                                                                fit: BoxFit
                                                                    .cover),
                                                      ),
                                                    );
                                                  }),
                                                ),
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeSmall),
                                                SizedBox(
                                                  height: 100,
                                                  child: productProvider
                                                              .product!.image !=
                                                          null
                                                      ? ListView.builder(
                                                          itemCount:
                                                              productProvider
                                                                  .product!
                                                                  .image!
                                                                  .length,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Padding(
                                                              padding: const EdgeInsets
                                                                  .only(
                                                                  right: Dimensions
                                                                      .paddingSizeSmall),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  Provider.of<CartProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .setSelect(
                                                                          index,
                                                                          true);
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets.all(
                                                                      Provider.of<CartProvider>(context, listen: false).productSelect ==
                                                                              index
                                                                          ? 3
                                                                          : 0),
                                                                  width: 100,
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color: Provider.of<CartProvider>(context, listen: false).productSelect == index
                                                                              ? Theme.of(context).primaryColor
                                                                              : ColorResources.getGreyColor(context),
                                                                          width: 1)),
                                                                  child: FadeInImage
                                                                      .assetNetwork(
                                                                    placeholder:
                                                                        Images.placeholder(
                                                                            context),
                                                                    image:
                                                                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${productProvider.product!.image![index]}',
                                                                    width: 100,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    imageErrorBuilder: (c, o, s) => Image.asset(
                                                                        Images.placeholder(
                                                                            context),
                                                                        width:
                                                                            100,
                                                                        fit: BoxFit
                                                                            .cover),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          })
                                                      : const SizedBox(),
                                                )
                                              ],
                                            )),
                                        const SizedBox(width: 30),
                                        Expanded(
                                            flex: 6,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  productProvider.product !=
                                                          null
                                                      ? WebProductInformation(
                                                          product:
                                                              productProvider
                                                                  .product,
                                                          stock: stock,
                                                          cartIndex:
                                                              productProvider
                                                                  .cartIndex,
                                                          priceWithQuantity:
                                                              priceWithQuantity)
                                                      : CustomLoader(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                  const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeExtraLarge),
                                                  Builder(
                                                    builder: (context) =>
                                                        Center(
                                                      child: SizedBox(
                                                        width: 1170,
                                                        child: CustomButton(
                                                          buttonText: getTranslated(
                                                              productProvider.cartIndex != null
                                                                  ? 'already_added'
                                                                  : stock! <= 0
                                                                      ? 'out_of_stock'
                                                                      : 'add_to_card',
                                                              context),
                                                          onPressed:
                                                              (productProvider.cartIndex ==
                                                                          null &&
                                                                      stock! >
                                                                          0)
                                                                  ? () {
                                                                      if (productProvider.cartIndex ==
                                                                              null &&
                                                                          stock! >
                                                                              0) {
                                                                        Provider.of<CartProvider>(context,
                                                                                listen: false)
                                                                            .addToCart(cartModel!);

                                                                        showCustomSnackBar(
                                                                            getTranslated('added_to_cart',
                                                                                context)!,
                                                                            isError:
                                                                                false);
                                                                      } else {
                                                                        showCustomSnackBar(getTranslated(
                                                                            'already_added',
                                                                            context)!);
                                                                      }
                                                                    }
                                                                  : null,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                                //Description
                                Center(
                                    child: SizedBox(
                                        width: Dimensions.webScreenWidth,
                                        child: _description(
                                            context, productProvider))),
                                const SizedBox(
                                  height: Dimensions.paddingSizeDefault,
                                ),
                              ]),
                            ),
                            const FooterView(),
                          ],
                        ),
                      )
                : Center(
                    child: CustomLoader(color: Theme.of(context).primaryColor));
          },
        );
      }),
    );
  }

  final ImagePicker imagePicker = ImagePicker();
  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();

    if (selectedImages!.isNotEmpty) {
      for (int i = 0; i < selectedImages.length; i++) {
        selectImage.add(selectedImages[i]);
      }
    }
    print("Image List Length:${selectImage.length}");
    setState(() {});
  }

  Widget _description(BuildContext context, ProductProvider productProvider) {
    print("${productProvider.product!.description}");
    return Column(
      children: [
        Center(
            child: Container(
          width: Dimensions.webScreenWidth,
          color: Theme.of(context).cardColor,
          child: TabBar(
            controller: _tabController,
            onTap: (index) {
              setState(() {
                _tabIndex = index;
              });
            },
            indicatorColor: Theme.of(context).primaryColor,
            indicatorWeight: 3,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).disabledColor,
            unselectedLabelStyle: joseFinSansRegular.copyWith(
              color: Theme.of(context).disabledColor,
              fontSize: Dimensions.fontSizeSmall,
            ),
            labelStyle: joseFinSansRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).primaryColor,
            ),
            tabs: [
              Tab(text: getTranslated('description', context)),
              Tab(text: getTranslated('review', context)),
            ],
          ),
        )),
        _tabIndex == 0
            ? Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                width: Dimensions.webScreenWidth,
                child: HtmlWidget(
                  productProvider.product!.description.toString() ?? "",
                  // key: Key(Html),
                  textStyle: joseFinSansRegular.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.color
                          ?.withOpacity(0.6)),
                ),

                /*Text(
                  productProvider.product!.description
                          .toString()
                          ??
                      '',
                  style:
                      joseFinSansRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                ),*/
              )
            : Column(children: [
                SizedBox(
                  width: 700,
                  child: Column(children: [
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            '${productProvider.product!.rating!.isNotEmpty ? double.parse(productProvider.product!.rating!.first.average!).toStringAsFixed(1) : 0.0}',
                            style: joseFinSansRegular.copyWith(
                              fontSize: Dimensions.fontSizeMaxLarge,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColor,
                            )),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),
                        RatingBar(
                          rating: productProvider.product!.rating!.isNotEmpty
                              ? double.parse(
                                  productProvider.product!.rating![0].average!)
                              : 0.0,
                          size: 25,
                        ),
                        const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall),
                        Text(
                          '${productProvider.product!.activeReviews!.length} ${getTranslated('review', context)}',
                          style: joseFinSansRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Colors.deepOrange),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: Dimensions.paddingSizeSmall,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault),
                      child: RatingLine(),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                  ]),
                ),
                ListView.builder(
                  itemCount: productProvider.product!.activeReviews!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeDefault,
                      horizontal: Dimensions.paddingSizeDefault),
                  itemBuilder: (context, index) {
                    return productProvider.product!.activeReviews != null
                        ? ReviewWidget(
                            reviewModel:
                                productProvider.product!.activeReviews![index])
                        : const ReviewShimmer();
                  },
                ),
              ]),
      ],
    );
  }
}
