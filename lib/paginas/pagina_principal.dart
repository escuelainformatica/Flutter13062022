import 'package:flutter/material.dart';

import '../tabs/tab1.dart';
import '../tabs/tab2.dart';
import '../tabs/tab3.dart';

class PaginaPrincipal extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PaginaPrincipalEstado();
  }
}

class PaginaPrincipalEstado extends State<PaginaPrincipal> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("hola"),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.cloud_outlined)),
                Tab(icon: Icon(Icons.cloud_outlined)),
                Tab(icon: Icon(Icons.cloud_outlined)),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Center(
                child: Tab1(),
              ),
              Center(
                child: Tab2(),
              ),
              Center(
                child: Tab3(),
              ),
            ],
          ),
        ));
  }
}
