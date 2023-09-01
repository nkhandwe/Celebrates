
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class PlaceOrderBody {
  List<Cart>? _cart;
  double? _couponDiscountAmount;
  String? _couponDiscountTitle;
  double? _orderAmount;
  String? _orderType;
  List<XFile>? _imagesList;

  int? _branchId;
  int? _deliveryAddressId;
  int? _timeSlotId;
  String? _deliveryDate;
  String? _paymentMethod;
  String? _orderNote;
  String? _couponCode;
  double? _distance;
  String? _transactionReference;
  String? _paymentBy;
  String? _paymentNote;
  String? _ordermessage;

  PlaceOrderBody copyWith({String? paymentMethod, String? transactionReference}) {
    _paymentMethod = paymentMethod;
    _transactionReference = transactionReference;
    return this;
  }

  PlaceOrderBody setOfflinePayment({
    required String paymentBy,
    required String transactionReference,
    required String paymentNote,
  }) {
    _transactionReference = transactionReference;
    _paymentBy = paymentBy;
    _paymentNote = paymentNote;
    return this;
  }

  PlaceOrderBody(
      {List<Cart>? cart,
        double? couponDiscountAmount,
        String? couponDiscountTitle,
        double? orderAmount,
        String? orderType,
        String? ordermessage,
        int? branchId,
        int? deliveryAddressId,
        int? timeSlotId,
        String? deliveryDate,
        List<XFile>? imagesList,
        List<String>? addOnIds,
        List<String>? addOnQty,
        String? paymentMethod,
        String? orderNote,

        String? couponCode,
        double? distance,
        String? transactionReference,
        String? paymentBy,
        String? paymentNote,
      }) {
    _cart = cart;
    _couponDiscountAmount = couponDiscountAmount;
    _couponDiscountTitle = couponDiscountTitle;
    _orderAmount = orderAmount;
    _orderType = orderType;
    _ordermessage = ordermessage;
    _branchId = branchId;
    _imagesList = imagesList;

    _deliveryAddressId = deliveryAddressId;
    _timeSlotId = timeSlotId;
    _deliveryDate = deliveryDate;
    _paymentMethod = paymentMethod;
    _orderNote = orderNote;
    _couponCode = couponCode;
    _distance = distance;
    _transactionReference = transactionReference;
    _paymentBy = paymentBy;
    _paymentNote = paymentNote;
  }

  List<Cart>? get cart => _cart;
  double? get couponDiscountAmount => _couponDiscountAmount;
  String? get couponDiscountTitle => _couponDiscountTitle;
  double? get orderAmount => _orderAmount;
  String? get orderType => _orderType;
  int? get branchId => _branchId;
  List<XFile>? get imagesList => _imagesList;
  int? get deliveryAddressId => _deliveryAddressId;
  int? get timeSlotId => _timeSlotId;
  String? get deliveryDate => _deliveryDate;
  String? get ordermessage => _ordermessage;
  String? get paymentMethod => _paymentMethod;
  String? get orderNote => _orderNote;
  String? get couponCode => _couponCode;
  double? get distance => _distance;
  String? get transactionReference => _transactionReference;
  String? get paymentBy => _paymentBy;
  String? get paymentNote => _paymentNote;

  PlaceOrderBody.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      _cart = [];
      json['cart'].forEach((v) {
        _cart!.add(Cart.fromJson(v));
      });
    }
    _couponDiscountAmount = json['coupon_discount_amount'].toDouble();
    _couponDiscountTitle = json['coupon_discount_title'];
    _orderAmount = json['order_amount'].toDouble();
    _orderType = json['order_type'];
    _branchId = json['branch_id'];
    // _imagesList = json['customimage[]'];
    // _ordermessage = json['custommsg'];
    _deliveryAddressId = json['delivery_address_id'];
    _timeSlotId = json['time_slot_id'];
    _deliveryDate = json['delivery_date'];
    _paymentMethod = json['payment_method'];
    _orderNote = json['order_note'];
    _couponCode = json['coupon_code'];
    _distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_cart != null) {
      data['cart'] = _cart!.map((v) => v.toJson()).toList();
    }
    data['coupon_discount_amount'] = _couponDiscountAmount;
    data['coupon_discount_title'] = _couponDiscountTitle;
    data['order_amount'] = _orderAmount;
    data['order_type'] = _orderType;
    data['branch_id'] = _branchId;
    // data['customimage[]'] = _imagesList;
    // data['custommsg'] = _ordermessage;
    data['delivery_address_id'] = _deliveryAddressId;
    data['time_slot_id'] = _timeSlotId;
    data['delivery_date'] = _deliveryDate;
    data['payment_method'] = _paymentMethod;
    data['order_note'] = _orderNote;
    data['coupon_code'] = _couponCode;
    data['distance'] = _distance;
    if(_transactionReference != null) {
      data['transaction_reference'] = _transactionReference;
    }
    if(_paymentBy != null) {
      data['payment_by'] = _paymentBy;
    }
    if(_paymentNote != null) {
      data['payment_note'] = _paymentNote;
    }
    return data;
  }
}

class Cart {
  int? _productId;
  double? _price;
  String? _variant;
  List<Variation>? _variation;
  List<String>? _addOnIds;
  List<String>? _addOnQty;
  double? _discountAmount;
  String? _quantity;
  double? _taxAmount;

  Cart(
      {int? productId,
        double? price,
        String? variant,
        List<Variation>? variation,
        List<String>? addOnIds,
        List<String>? addOnQty,
        double? discountAmount,
        String? quantity,
        double? taxAmount}) {
    _productId = productId;
    _price = price;
    _variant = variant;
    _variation = variation;
    _addOnQty = addOnQty;
    _addOnIds = addOnIds;
    _discountAmount = discountAmount;
    _quantity = quantity;
    _taxAmount = taxAmount;
  }

  int? get productId => _productId;
  double? get price => _price;
  String? get variant => _variant;
  List<Variation>? get variation => _variation;
  List<String>? get addOnIds => _addOnIds;
  List<String>? get addOnQty => _addOnQty;
  double? get discountAmount => _discountAmount;
  String? get quantity => _quantity;
  double? get taxAmount => _taxAmount;

  Cart.fromJson(Map<String, dynamic> json) {
    _productId = json['product_id'];
    _price = json['price'].toDouble();
    _variant = json['variant'];
    _addOnQty = json['add_on_qtys'].cast<String>();
    _addOnIds = json['add_on_ids'].cast<String>();
    if (json['variation'] != null) {
      _variation = [];
      json['variation'].forEach((v) {
        _variation!.add(Variation.fromJson(v));
      });
    }
    _discountAmount = json['discount_amount'].toDouble();
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = _productId;
    data['price'] = _price;
    data['variant'] = _variant;
    data['add_on_ids'] = _addOnIds;
    data['add_on_qtys'] = _addOnQty;
    if (_variation != null) {
      data['variation'] = _variation!.map((v) => v.toJson()).toList();
    }
    data['discount_amount'] = _discountAmount;
    data['quantity'] = _quantity;
    data['tax_amount'] = _taxAmount;
    return data;
  }
}

class Variation {
  String? _type;

  Variation({String? type}) {
    _type = type;
  }

  String? get type => _type;

  Variation.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = _type;
    return data;
  }
}
