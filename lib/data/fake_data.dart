import '../models/product.dart';

class FakeData {
  static List<Product> products = [
    Product(
      id: 1,
      name: "Traje Smoking",
      description: "Traje savile carbón",
      price: 700.00,
      image:
          "https://cdn.sanity.io/images/vxy259ii/production/77507da7e34f9fd5321192990e0788cbbec2eaea-600x671.jpg?auto=format&fit=max&q=75&w=600",
    ),
    Product(
      id: 2,
      name: "Blazer",
      description: "Blazer azul medianoche",
      price: 300.00,
      image:
          "https://arturocalle.vtexassets.com/arquivos/ids/603401/HOMBRE-BLAZER-10121070-AZUL-790_1.jpg?v=638398498714100000",
    ),
    Product(
      id: 3,
      name: "Reloj",
      description: "Dial soberano",
      price: 2000000.00,
      image:
          "https://www.gq.com.mx/relojes/articulo/relojes-montblanc-de-correa-cafe-para-hombre-2021",
    ),
    Product(
      id: 4,
      name: "Zapatillas hombre",
      description: "Mocasines Velez Mocasin",
      price: 400.00,
      image:
          "https://shopialo.com/cdn/shop/files/1035172-02-01-Zapatos-cordon-de-cuero_1200x1798.webp?v=1705018508",
    ),
  ];
}
