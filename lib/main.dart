import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(MyApp());
}

class Product {
  final String name;
  final String price;

  Product(this.name, this.price);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App Mejorada',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

// LOGIN SCREEN
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MenuScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Faltan datos"),
          content: Text("Por favor ingresa email y contraseña."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(title: Text("LOGIN")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Bienvenido", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
                TextField(controller: passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password")),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: StadiumBorder(), padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12)),
                  child: Text("LOGIN"),
                  onPressed: _handleLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// MENU SCREEN
class MenuScreen extends StatelessWidget {
  final List<Product> products = [];
  final DateTime birthDate = DateTime.now();

  void _addProduct(Product product) {
    products.add(product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MENÚ PRINCIPAL")),
      body: ListView(
        children: [
          ListTile(
            title: Text("🏠 Home"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(products: products),
                ),
              );
            },
          ),
          ListTile(
            title: Text("👤 Profile"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    birthDate: birthDate,
                    onDateSelected: (date) {},
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text("🛒 Registro de Productos"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegistroProductosScreen(onSave: _addProduct),
                ),
              );
            },
          ),
          ListTile(
            title: Text("🚪 Cerrar sesión"),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

// HOME SCREEN
class HomeScreen extends StatelessWidget {
  final List<Product> products;

  HomeScreen({required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: products.isEmpty
          ? Center(child: Text("No hay productos registrados."))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Text("Precio: \$${product.price}"),
                  ),
                );
              },
            ),
    );
  }
}

// PROFILE SCREEN
class ProfileScreen extends StatefulWidget {
  final DateTime birthDate;
  final Function(DateTime) onDateSelected;

  ProfileScreen({required this.birthDate, required this.onDateSelected});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.birthDate;
  }

  void _selectDate(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Colors.white,
        child: CupertinoDatePicker(
          initialDateTime: selectedDate,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (DateTime newDate) {
            setState(() {
              selectedDate = newDate;
            });
            widget.onDateSelected(newDate);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Perfil")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text("Fecha de Nacimiento"),
            subtitle: Text("${selectedDate.toLocal()}".split(' ')[0]),
            trailing: Icon(Icons.calendar_today),
            onTap: () => _selectDate(context),
          ),
        ),
      ),
    );
  }
}

// REGISTRO DE PRODUCTOS SCREEN
class RegistroProductosScreen extends StatefulWidget {
  final Function(Product) onSave;

  RegistroProductosScreen({required this.onSave});

  @override
  _RegistroProductosScreenState createState() => _RegistroProductosScreenState();
}

class _RegistroProductosScreenState extends State<RegistroProductosScreen> {
  final nombreController = TextEditingController();
  final precioController = TextEditingController();

  void _guardarProducto() {
    if (nombreController.text.isNotEmpty && precioController.text.isNotEmpty) {
      Product newProduct = Product(nombreController.text, precioController.text);
      widget.onSave(newProduct);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Campos vacíos"),
          content: Text("Por favor, completa todos los campos."),
          actions: [
            TextButton(child: Text("OK"), onPressed: () => Navigator.pop(context)),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrar Producto")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(labelText: "Nombre del producto"),
                ),
                TextField(
                  controller: precioController,
                  decoration: InputDecoration(labelText: "Precio"),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  onPressed: _guardarProducto,
                  child: Text("GUARDAR"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
