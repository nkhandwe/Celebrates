import 'dart:convert';

import 'package:flutter_grocery/data/model/response/product_model.dart';
import 'package:image_picker/image_picker.dart';

class CartModel {
  int? _id;
  String? _image;
  String? _name;
  String? _message;
  double? _price;
  List<XFile>?_imageList;
  List<AddOns>?_addOn;
  List<int>?_addOnQty;
  double? _discountedPrice;
  int? _quantity;
  Variations? _variation;
  double? _discount;
  double? _tax;
  double? _capacity;
  String? _unit;
  int? _stock;
  Product? _product;


  CartModel(this._id, this._image, this._name, this._price, this._discountedPrice, this._quantity, this._variation, this._discount,
       this._tax, this._capacity, this._unit, this._stock,
      this._addOn,this._addOnQty,
      this._product,this._imageList,this._message);


  Variations? get variation => _variation;
  // ignore: unnecessary_getters_setters
  int? get quantity => _quantity;
  // ignore: unnecessary_getters_setters
  set quantity(int? value) {
    _quantity = value;
  }

  set imageListData(List<XFile>value)
  {
    print(value.length);
    _imageList = value;
    print(_imageList!.length);
  }

  set addOnItem(List<AddOns>value)
  {
    print(value.length);
    _addOn = value;
    print(_addOn!.length);
  }

  set addOnQtySet(List<int>value)
  {
    print(value.length);
    _addOnQty = value;
    print(_addOn!.length);
  }

  set messageData(String? message)
  {
    _message = message;
  }


  double? get price => _price;
  double? get capacity => _capacity;
  String? get unit => _unit;
  double? get discountedPrice => _discountedPrice;
  String? get name => _name;
  String? get message => _message;
  List<XFile>? get imageList => _imageList;
  List<AddOns>? get addOn => _addOn;
  List<int>? get addOnQty => _addOnQty;
  String? get image => _image;
  int? get id => _id;
  double? get discount => _discount;
  double? get tax => _tax;
  int? get stock => _stock;
  Product? get product =>_product;




  CartModel.fromJson(Map<String, dynamic> json) {
    if (json['imagesList[]'] != null) {
      _imageList = [];

      List<dynamic> jsonList = jsonDecode(json['imagesList[]']);

      jsonList.forEach((dynamic item) {
        String path = item as String;
        _imageList!.add(XFile(path));
        print(path);
        // Perform further operations with the path
      });

     /* List<Map<String, dynamic>> jsonList = List<Map<String, dynamic>>.from(jsonDecode(imagesList[]));
      json['imagesList[]'].forEach((v) {
        _imageList!.add(XFile(v));
      });*/
    }

    if (json['addonQTY[]'] != null) {
      _addOnQty = [];

      List<dynamic> jsonList = jsonDecode(json['addonQTY[]']);

      jsonList.forEach((dynamic item) {
        int path = int.parse(item.toString());
        _addOnQty!.add(path);
        print(path);
        // Perform further operations with the path
      });


    }

    if (json['addOn[]'] != null) {
      _addOn = [];

      List<dynamic> jsonList = jsonDecode(json['addOn[]']);

      jsonList.forEach((dynamic item) {
        AddOns path = AddOns.fromJson(item);
        _addOn!.add(path);
        print(path);
        // Perform further operations with the path
      });


    }
    _id = json['id'];
    _name = json['name'];
    _image = json['image'];
    _price = json['price'];
    // _imageList = json['imagesList'];
    _message = json['message'];
    _discountedPrice = json['discounted_price'];
    _quantity = json['quantity'];
    _variation = json['variations'] != null ? Variations.fromJson(json['variations']) : null;
    _discount = json['discount'];
    _tax = json['tax'];
    _capacity = json['capacity'];
    _unit = json['unit'];
    _stock = json['stock'];
    _product = json['product'] != null ? Product.fromJson(json['product']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (_imageList != null) {
      data['imagesList[]'] = jsonEncode(_imageList!.map((v) => v.path).toList());
    }

    if (_addOn != null) {
      data['addOn[]'] = jsonEncode(_addOn!.map((v) => v).toList());
    } if (_addOnQty != null) {
      data['addonQTY[]'] = jsonEncode(_addOnQty!.map((v) => v).toList());
    }
    data['id'] = _id;
    data['name'] = _name;
    data['image'] = _image;
    data['message'] = _message;
    // data['imagesList'] = _imageList;
    data['price'] = _price;
    data['discounted_price'] = _discountedPrice;
    data['quantity'] = _quantity;
    if (_variation != null) {
      data['variations'] = _variation!.toJson();
    }
    data['discount'] = _discount;
    data['tax'] = _tax;
    data['capacity'] = _capacity;
    data['unit'] = _unit;
    data['stock'] = _stock;
    if (_product != null) {
      data['product'] = _product!.toJson();
    }
    return data;
  }
}
