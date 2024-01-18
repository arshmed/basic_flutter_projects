import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CartModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(title: '',),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required String title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 80, right: 80, bottom: 40, top: 100),
            child: Image.network('https://previews.123rf.com/images/tatianasun/tatianasun1705/tatianasun170500037/77814968-avocado-sticker,-vector-emblem-or-badge-illustration..jpg',), //https://i.pinimg.com/736x/23/27/67/232767db7f167ccb2cb3d3233916221e.jpg
          ),
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'We deliver groceries at your doorstep',
              style: TextStyle(
                  fontSize: 40,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Text(
            'Fresh items everyday',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
              color: Colors.grey,
            ),
          ),
          const Spacer(),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith((states) => Colors.green)
            ),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductsOverview()),
                );
              },
              child: Text('Get Started'),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class ProductsOverview extends StatefulWidget {
  const ProductsOverview({Key? key}) : super(key: key);

  @override
  State<ProductsOverview> createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Cart()),
          );
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.shopping_cart_sharp),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:80.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    SizedBox(width: 20,),
                    Icon(Icons.location_on),
                    Text('Sivas,Turkey'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right:40.0),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.person),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                          color: Colors.grey[200]
                    ),
                  ),
                ),
              ],
            ),
          ),
          Message(),
          ProductPage(),
        ],
      ),
    );
  }
}
class Message extends StatelessWidget {
  const Message({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(15.0),
      margin: EdgeInsets.only(top: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(child: Text('Good Morning', style: TextStyle(fontSize: 12,))),
          SizedBox(height: 15,),
          Container(child: Text("Let's Order Fresh Items For You", style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),width: 250,),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Divider(),
          ),
          const SizedBox(height: 24,),
          Text('Fresh Items', style: TextStyle(fontSize: 16))
        ],
      ),

    );
  }
}
class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(
        builder: (context, value, child){
          return Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(12.0),
              itemCount: value.shopItems.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1/1.3),
                itemBuilder: (context, index){
                  return ProductItem(title: value.shopItems[index][0],
                      price: value.shopItems[index][1],
                      imageUrl: value.shopItems[index][2],
                      color: value.shopItems[index][3],
                    onPressed: (){
                      Provider.of<CartModel>(context, listen: false).addItemToCart(index);
                    },
                  );
                },
            ),
          );
        }
    );
  }
}

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.black,),
          onPressed: (){
              Navigator.pop(context);
          },
        ),
      ),
      body: Consumer<CartModel>(
        builder: (context, value, index){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text("My Cart", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),),
            ),
            Expanded(child: ListView.builder(
              padding: EdgeInsets.all(12.0),
              itemCount: value._cartItems.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      leading: Image.network(value._cartItems[index][2],height: 36,),
                      title: Text(value._cartItems[index][0]),
                      subtitle: Text("\$"+value._cartItems[index][1].toString()),
                      trailing: IconButton(
                          icon: Icon(Icons.cancel),
                        onPressed: () => Provider.of<CartModel>(context, listen: false).removeItemFromCart(index),
                      ),
                    ),
                  ),
                );
              },
            ),
            ),
            Padding(
              padding: const EdgeInsets.all(36.0),
              child: Container(
                padding: EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(14.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total Price", style: TextStyle(color: Colors.green[100]),),
                        const SizedBox(height: 4.0,),
                        Text(value.calculateTotal().toString(), style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green.shade100),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Text("Pay Now",style: TextStyle(color: Colors.white),),
                          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
    },
      ),
    );
  }
}

class CartModel extends ChangeNotifier{
  final List _shopItems = [

    ["Avocado", 4.0, 'https://previews.123rf.com/images/tatianasun/tatianasun1705/tatianasun170500037/77814968-avocado-sticker,-vector-emblem-or-badge-illustration..jpg', Colors.lightGreenAccent],  //https://i.pinimg.com/736x/23/27/67/232767db7f167ccb2cb3d3233916221e.jpg
    ["Chicken", 16.50, 'https://img.freepik.com/free-vector/fried-chicken-sticker-white-background_1308-64824.jpg?w=2000', Colors.purpleAccent],
    ["Water", 1.50, 'https://ih1.redbubble.net/image.983296940.3984/st,small,507x507-pad,600x600,f8f8f8.jpg', Colors.lightBlueAccent],
    ["Banana", 2.50, 'https://img.freepik.com/free-vector/sticker-design-with-banana-isolated_1308-77292.jpg?w=2000', Colors.yellowAccent],
    ["Avocado", 4.0, 'https://i.pinimg.com/736x/23/27/67/232767db7f167ccb2cb3d3233916221e.jpg', Colors.lightGreenAccent],
    ["Avocado", 4.0, 'https://i.pinimg.com/736x/23/27/67/232767db7f167ccb2cb3d3233916221e.jpg', Colors.lightGreenAccent],
    ["Avocado", 4.0, 'https://i.pinimg.com/736x/23/27/67/232767db7f167ccb2cb3d3233916221e.jpg', Colors.lightGreenAccent],
  ];

  List _cartItems = [];
  get cartItems => _cartItems;
  get shopItems => _shopItems;

  void addItemToCart(int index){
    _cartItems.add(_shopItems[index]);
    notifyListeners();
  }

  void removeItemFromCart(int index){
    _cartItems.removeAt(index);
    notifyListeners();
  }

  double calculateTotal(){
    double totalPrice = 0;

    for(int i=0; i<_cartItems.length; i++){
      totalPrice += _cartItems[i][1];
    }
    return totalPrice;
  }

}

class Product{
  
  final String title;
  final double price;
  final String imageUrl;
  final Color color;
  
  const Product({
   required this.title,
   required this.price,
   required this.imageUrl,
   required this.color,
});
}

class ProductItem extends StatelessWidget {

  final String title;
  final double price;
  final String imageUrl;
  final Color color;
  final void Function()? onPressed;

  const ProductItem({
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.network(imageUrl, height: 80,),
            Text(title),
            MaterialButton(
                onPressed: onPressed,
              child: Text("\$"+price.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              color: color.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }
}






