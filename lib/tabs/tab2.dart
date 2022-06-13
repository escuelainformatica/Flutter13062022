import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:junio13/modelo/product_category.dart';
import '../modelo/producto.dart';
import 'dart:convert';

class Tab2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Tab2Estado();
  }
}
class Tab2Estado extends State<Tab2> {

  TextEditingController cont1=TextEditingController();
  TextEditingController cont3=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<DropdownMenuItem<int>> categorias=[];
  int? catSeleccionada;

  Future<int> insertarProducto() async {
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview
    var url =
    Uri.http('158.101.30.194', '/testcli/api/Product/insert');

    Producto prod=Producto.name(1, "??", 1, 1.1);
    prod.Name=cont1.value.text;
    prod.IdProductCategory=catSeleccionada??0;
    prod.Price=double.parse(cont3.value.text);
    var json=jsonEncode(prod.toMap());

    // Await the http get response, then decode the json-formatted response.
    var response = await http.post(url,body: json);
    if (response.statusCode >= 200 && response.statusCode<299) {
      var jsonResponse = jsonDecode(response.body);

      return jsonResponse;
    } else {
      throw Exception("Error al leer");
    }
    return 0;
  }

  Future<List<DropdownMenuItem<int>>> leeCategorias() async {
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview
    var url =
    Uri.http('158.101.30.194', '/testcli/api/Productcategory/listall');

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode >= 200 && response.statusCode<299) {
      var jsonResponse = jsonDecode(response.body).cast<Map<String,dynamic>>();
      List<ProductCategory> cats=jsonResponse.map<ProductCategory>( (p)=>ProductCategory.fromMap(p) ).toList();
      List<DropdownMenuItem<int>> itemCombo=cats.map<DropdownMenuItem<int>>( (p)=> DropdownMenuItem(value: p.IdProductCategory, child: Text(p.Name))).toList();
      setState(() { categorias=itemCombo;});

      return itemCombo;
    } else {
      throw Exception("Error al leer");
    }
  }

  @override
  void initState() {
    super.initState();
    leeCategorias();
  }

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText:  "Nombre del producto"),
            controller: cont1
          ),
          DropdownButtonFormField(
              decoration: InputDecoration(labelText:  "Categoria"),
              items: categorias,
              onChanged: (valor) {
                catSeleccionada=int.parse(valor.toString());
              }),

          TextFormField(
              decoration: InputDecoration(labelText:  "Precio"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (valor) {
                  if(double.tryParse(valor??"0")==null) {
                    return "Este valor debe ser un doble";
                  }
                  return "";
              },
              controller: cont3
          ),
          ElevatedButton(onPressed: () async {
              var num=await insertarProducto();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('product ingresado ${num}'),
                  action: SnackBarAction(
                    label: 'Action',
                    onPressed: () {
                      // Code to execute.
                    },
                  ),
                ),
              );

          }, child: Text("agregar"))
        ],
      ),
    );
  }

}