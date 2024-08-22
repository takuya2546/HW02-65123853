import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'product.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'IT@WU Shop',
          style: TextStyle(color: Colors.white), 
        ),
        backgroundColor: Colors.blue, 
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ProductList(products: snapshot.data!);
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  final List<Product> products;

  ProductList({required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.network(
            products[index].image,
            fit: BoxFit.cover,
            width: 50,
            height: 50,
          ),
          title: Text(
            products[index].title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text('\$${products[index].price.toString()}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsScreen(product: products[index]),
              ),
            );
          },
        );
      },
    );
  }
}

class DetailsScreen extends StatelessWidget {
  final Product product;

  DetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
        backgroundColor: Colors.white, 
        iconTheme: IconThemeData(color: Colors.black), 
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200, 
                width: double.infinity,
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 10),
              Text(
                product.title,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, 
                ),
              ),
              SizedBox(height: 5),
              Text(
                '\$${product.price}',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Category',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              Text(
                product.category,
                style: TextStyle(fontSize: 18.0, color: Colors.black), 
              ),
              SizedBox(height: 10),
              Text(product.description),
              SizedBox(height: 10),
              Text(
                'Rating : ${product.rating} / 5 of ${product.count}', 
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              RatingBar.builder(
                initialRating: product.rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
