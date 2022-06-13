import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../modelo/producto.dart';

class Tab1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Tab1Estado();
  }
}
class Tab1Estado extends State<Tab1> {

  Stream<List<Producto>> leerProductos() async* {
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview
    var url =
    Uri.http('158.101.30.194', '/testcli/api/Product/listall');

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode >= 200 && response.statusCode<299) {
      var jsonResponse = convert.jsonDecode(response.body).cast<Map<String,dynamic>>();
      List<Producto> productos=jsonResponse.map<Producto>( (p)=>Producto.fromMap(p) ).toList();
      yield productos;
    } else {
     throw Exception("Error al leer");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: leerProductos(),
      builder: (contexto,snapshot) {
        if(snapshot.hasError) {
          return Text("Hay un error ${snapshot.error}");
        }
        if(snapshot.connectionState==ConnectionState.done && snapshot.data!=null) {
          List<Producto> productos=snapshot.data as List<Producto>;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context,num) {
              return ListTile(
                  title: Text(productos[num].Name),
                leading: Text(productos[num].Price.toString()),
                subtitle: Text(productos[num].IdProductCategory.toString()),
              );
            },
          );
        }
        return Text("cargando..");
      },
    );
  }

}