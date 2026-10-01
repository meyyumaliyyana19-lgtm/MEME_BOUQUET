class ProductModel {
  final int? id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final String category;

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.description = '',
    this.category = 'Pita Satin',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
      'category': category,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    String nameText = map['name']?.toString() ?? '';
    String descText = map['description']?.toString() ?? '';
    String catText = map['category']?.toString() ?? '';
    String lowerName = nameText.toLowerCase();

    // 1. OTOMATIS DETEKSI KATEGORI BERDASARKAN NAMA PRODUK
    if (catText.isEmpty || catText == 'Pita Satin' || catText == 'Uncategorized') {
      if (lowerName.contains('jajan') || 
          lowerName.contains('snack') || 
          lowerName.contains('mini')) {
        catText = 'Buket Jajan';
      } else if (lowerName.contains('bunga') || 
                 lowerName.contains('segar') || 
                 lowerName.contains('pink') || 
                 lowerName.contains('lily') || 
                 lowerName.contains('rokok')) {
        catText = 'Bunga Segar';
      } else if (lowerName.contains('boneka')) {
        catText = 'Boneka';
      } else {
        catText = 'Pita Satin';
      }
    }

    // 2. OTOMATIS DETEKSI DESKRIPSI JIKA DI DATABASE KOSONG
    if (descText.isEmpty) {
      if (catText == 'Buket Jajan' || lowerName.contains('jajan')) {
        descText = 'Buket snack cantik berisi aneka jajanan favorit yang dirangkai rapi. Sangat cocok untuk kado ultah, wisuda, atau event spesial.';
      } else if (lowerName.contains('rokok')) {
        descText = 'Buket pilihan berkesan elegan dengan isi rokok premium. Pilihan kado unik dan eksklusif dari MEME BOUQUET.';
      } else if (catText == 'Bunga Segar' || lowerName.contains('bunga')) {
        descText = 'Buket bunga dengan perpaduan warna yang fresh, manis, dan elegan. Rangkaian rapi dari MEME BOUQUET.';
      } else if (catText == 'Pita Satin' || lowerName.contains('satin')) {
        descText = 'Buket mawar buatan tangan dari pita satin berkualitas tinggi. Tahan lama, indah, dan tidak akan layu.';
      } else {
        descText = 'Buket spesial dari MEME BOUQUET dirangkai dengan rapi dan menggunakan bahan pilihan berkualitas.';
      }
    }

    return ProductModel(
      id: map['id'],
      name: nameText,
      price: (map['price'] is num)
          ? (map['price'] as num).toDouble()
          : double.tryParse(map['price']?.toString() ?? '0') ?? 0.0,
      imageUrl: map['imageUrl']?.toString() ?? '',
      description: descText,
      category: catText,
    );
  }
}