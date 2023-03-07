class Document {
  final String name;
  final String url;

  Document({required this.name, required this.url});
}

class ProductVisit {
  final int id;
  final int prodId;
  final int visitId;

  ProductVisit({required this.id, required this.prodId, required this.visitId});
}

class Product {
  final String name;
  final List<Document> docs;
  final List<String> imgsUrls;
  final int id;
  final String categoryName;
  final ProductVisit? productVisit;

  Product({
    required this.name,
    required this.docs,
    required this.imgsUrls,
    required this.id,
    required this.categoryName,
    this.productVisit,
  });

  ///Convert [json] from json map to Product
  factory Product.fromJson(Map<String, dynamic> json) {
    final attachments = json['attachments'] as List<dynamic>;

    final List<Document> docs = attachments
        .where(
          (attachment) =>
              attachment['type'] == 'DOC' && attachment['fileUrl'] != null,
        )
        .map(
          (attachment) => Document(
            name: attachment['details'] as String? ?? "Nome sconosciuto",
            url: attachment['fileUrl'] as String,
          ),
        )
        .toList();

    final imgsUrls = attachments
        .where(
          (attachment) =>
              attachment['type'] == 'IMG' && attachment['fileUrl'] != null,
        )
        .map((attachment) => attachment['fileUrl'] as String)
        .toList();

    final id = json["id"] as int;
    final productName = json['ProductName'] as String?;
    final fetchedCategoryName = json["productCategory"]?["name"] as String?;

    ProductVisit? productVisit;
    if (json["ProductVisit"] != null) {
      final productVisitId = json["ProductVisit"]["id"] as int;
      final productVisitProdId = json["ProductVisit"]["productId"] as int;

      final productVisitVisitId = json["ProductVisit"]["visitId"] as int;
      productVisit = ProductVisit(
        id: productVisitId,
        prodId: productVisitProdId,
        visitId: productVisitVisitId,
      );
    }

    return Product(
      id: id,
      name: productName ?? "Prodotto Revée",
      docs: docs,
      imgsUrls: imgsUrls,
      categoryName: fetchedCategoryName ?? "Senza categoria",
      productVisit: productVisit,
    );
  }
}
