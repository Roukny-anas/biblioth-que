import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/home_page.dart';
import 'screens/book_details_page.dart';
import 'screens/search_page.dart';
import 'screens/category_page.dart';
import 'screens/mybooks_page.dart';
import 'screens/Menuadmin.dart';
import 'screens/category_management.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomePage(),
        '/bookDetails': (context) => BookDetailsPage(),
        '/search': (context) => SearchPage(),
        '/category': (context) => CategoryPage(), 
        '/myBooks': (context) => MyBooksPage(),
        '/Menuadmin': (context) => MenuAdmin(),
        '/categories': (context) => CategoryManagementPage(),
      },
    );
  }
}
