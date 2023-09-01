class OrderDetailsModel {
  int? id;
  int? productId;
  int? orderId;
  double? price;
  ProductDetails? productDetails;
  double? discountOnProduct;
  String? discountType;
  String? addOnIds;
  String? addOnQtys;
  int? quantity;
  double? taxAmount;
  String? createdAt;
  String? updatedAt;
  String? variant;
  int? timeSlotId;
  String? variation;
  bool? isVatInclude;


  OrderDetailsModel(
      {this.id,
      this.productId,
      this.orderId,
      this.price,
      this.productDetails,
      this.discountOnProduct,
      this.discountType,
      this.quantity,
      this.addOnIds,
      this.addOnQtys,
      this.taxAmount,
      this.createdAt,
      this.updatedAt,
      this.variant,
        this.timeSlotId,
        this.variation,
        this.isVatInclude,
      });

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    orderId = json['order_id'];
    addOnIds = json['add_on_ids'];
    addOnQtys = json['add_on_qtys'];
    price = json['price'].toDouble();
    productDetails = json['product_details'] != null && json['product_details'] != "" ? ProductDetails.fromJson(json['product_details']) : null;
    variation = json['variation'];
    discountOnProduct = json['discount_on_product'].toDouble();
    discountType = json['discount_type'];
    quantity = json['quantity'];
    taxAmount = json['tax_amount'].toDouble();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isVatInclude = '${json['vat_status']}' == 'included';
    if(json['variant'] != null){
      variant = json['variant'];
    }
    try{
      timeSlotId = json['time_slot_id'];

    }catch(e){
      timeSlotId = int.parse(json['time_slot_id']);
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['order_id'] = orderId;
    data['price'] = price;
    data['add_on_ids'] = addOnIds;
    data['add_on_qtys'] = addOnQtys;
    if (productDetails != null) {
      data['product_details'] = productDetails!.toJson();
    }
    data['discount_on_product'] = discountOnProduct;
    data['discount_type'] = discountType;
    data['quantity'] = quantity;
    data['tax_amount'] = taxAmount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['variant'] = variant;
    data['time_slot_id'] = timeSlotId;
    data['variation'] = variation;
    data['vat_status'] = variation;
    return data;
  }
}

class ProductDetails {
  int? id;
  String? name;
  String? description;
  List<dynamic>? image;
  double? price;
  List<CategoryIds>? categoryIds;
  List<AddOns>?addOns;
  double? capacity;
  String? unit;
  double? tax;
  int? status;
  String? createdAt;
  String? updatedAt;
  double? discount;
  String? discountType;
  String? taxType;

  ProductDetails(
      {this.id,
      this.name,
      this.description,
      this.image,
      this.price,
      this.categoryIds,
      this.capacity,
        this.addOns,
      this.unit,
      this.tax,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.discount,
      this.discountType,
      this.taxType});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    price = json['price'].toDouble();
    if (json['category_ids'] != null) {
      categoryIds = [];
      json['category_ids'].forEach((v) {
        categoryIds!.add(CategoryIds.fromJson(v));
      });
    }

    if (json['add_ons'] != null) {
      addOns = [];
      json['add_ons'].forEach((v) {
        addOns?.add(AddOns.fromJson(v));
      });
    }
    capacity = json['capacity'].toDouble();
    unit = json['unit'];
    tax = json['tax'].toDouble();
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    discount = json['discount'].toDouble();
    discountType = json['discount_type'];
    taxType = json['tax_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['price'] = price;
    if (categoryIds != null) {
      data['category_ids'] = categoryIds!.map((v) => v.toJson()).toList();
    }
    if (addOns != null) {
      data['add_ons'] = addOns?.map((v) => v.toJson()).toList();
    }
    data['capacity'] = capacity;
    data['unit'] = unit;
    data['tax'] = tax;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['tax_type'] = taxType;
    return data;
  }
}

class CategoryIds {
  String? id;

  CategoryIds({this.id});

  CategoryIds.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

class AddOns {
  AddOns({
    num? id,
    String? name,
    String? image,
    num? price,
    String? createdAt,
    String? updatedAt,
    List<dynamic>? translations,}){
    _id = id;
    _name = name;
    _image = image;
    _price = price;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _translations = translations;
  }

  AddOns.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'];
    _price = json['price'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    /* if (json['translations'] != null) {
      _translations = [];
      json['translations'].forEach((v) {
        _translations?.add(Dynamic.fromJson(v));
      });
    }*/
  }
  num? _id;
  String? _name;
  String? _image;
  num? _price;
  String? _createdAt;
  String? _updatedAt;
  List<dynamic>? _translations;
  AddOns copyWith({  num? id,
    String? name,
    String? image,
    num? price,
    String? createdAt,
    String? updatedAt,
    List<dynamic>? translations,
  }) => AddOns(  id: id ?? _id,
    name: name ?? _name,
    image: image ?? _image,
    price: price ?? _price,
    createdAt: createdAt ?? _createdAt,
    updatedAt: updatedAt ?? _updatedAt,
    translations: translations ?? _translations,
  );
  num? get id => _id;
  String? get name => _name;
  String? get image => _image;
  num? get price => _price;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<dynamic>? get translations => _translations;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['image'] = _image;
    map['price'] = _price;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_translations != null) {
      map['translations'] = _translations?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
