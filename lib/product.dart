class Product {
  final String id,
      productName,
      productCode,
      image,
      unitPrice,
      quantity,
      totalPrice,
      createdAt;

  Product(
    this.id,
    this.productName,
    this.productCode,
    this.quantity,
    this.totalPrice,
    this.unitPrice,
    this.createdAt,
    this.image,
  );

  factory Product.toJson(Map<String, dynamic> e) {
    return Product(
      e['_id'],
      e['ProductName'],
      e['ProductCode'],
      e['Qty'],
      e['TotalPrice'],
      e['UnitPrice'],
      e['CreatedDate'],
      e['Img'],
    );
  }
}
