import '../models/product.dart';

class FakeData {
  static List<Product> products = [
    Product(
      id: 1,
      name: "Traje Smoking",
      description:
          "Traje smoking de corte clásico confeccionado en lana premium tono carbón. Diseñado para eventos formales y ocasiones especiales, ofrece una silueta impecable, solapas satinadas y acabados de alta sastrería que realzan una presencia sofisticada y atemporal.",
      price: 700.00,
      image:
          "https://cdn.sanity.io/images/vxy259ii/production/77507da7e34f9fd5321192990e0788cbbec2eaea-600x671.jpg?auto=format&fit=max&q=75&w=600",
    ),

    Product(
      id: 2,
      name: "Blazer",
      description:
          "Blazer azul medianoche de diseño contemporáneo, elaborado con tejido estructurado de alta calidad. Su ajuste moderno y detalles cuidadosamente acabados lo convierten en una pieza versátil ideal tanto para reuniones formales como para combinaciones elegantes casuales.",
      price: 300.00,
      image:
          "https://arturocalle.vtexassets.com/arquivos/ids/603401/HOMBRE-BLAZER-10121070-AZUL-790_1.jpg?v=638398498714100000",
    ),

    Product(
      id: 3,
      name: "Reloj",
      description:
          "Reloj de lujo con dial soberano y acabado metálico pulido. Incorpora maquinaria de alta precisión y diseño minimalista, fusionando elegancia y funcionalidad en una pieza atemporal que complementa perfectamente un estilo distinguido y refinado.",
      price: 2000000.00,
      image:
          "https://minimalistyle.shop/wp-content/uploads/2024/05/main-image-1-13.jpeg",
    ),

    Product(
      id: 4,
      name: "Zapatillas",
      description:
          "Mocasines de cuero genuino con acabado artesanal y textura suave al tacto. Su diseño sobrio y elegante brinda máxima comodidad y distinción, convirtiéndolos en el complemento ideal para atuendos formales y smart casual.",
      price: 400.00,
      image:
          "https://shopialo.com/cdn/shop/files/1035172-02-01-Zapatos-cordon-de-cuero_1200x1798.webp?v=1705018508",
    ),
  ];
}
