import 'package:flutter/material.dart';
import 'package:kiffi/librairies/globals.dart' as globals;
import 'package:contacts_service/contacts_service.dart';
import 'package:simple_permissions/simple_permissions.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          leading: IconButton(icon: Icon(Icons.menu), onPressed: (){}),
          backgroundColor: Colors.blue,
          elevation: 0.0,
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.person), onPressed: (){}),
          ],
          bottom: new TabBar(
            labelStyle: new TextStyle(
              //fontWeight: FontWeight.bold,
              fontFamily: globals.generalFontFamily,
              fontSize: globals.generalFontSize,
            ),
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            isScrollable: true,
            tabs: [
              new Tab(
                icon: Icon(Icons.email,size: 35.0),
              ),
              new Tab(
                icon: Icon(Icons.monetization_on,size: 35.0),
              ),
              new Tab(
                icon: Icon(Icons.people,size: 35.0),
              ),
            ],
          ),
          title: Center(
            child: new Text(
                "Kiffi"
            ),
          ),
        ),
        body: new TabBarView(
          children: [
            //First Tab
            Container(),
            //Second Tab
            Container(),
            //Third tab
            FutureBuilder(
              future: ContactsService.getContacts(),
              builder: (context, snapshot){
                if(!snapshot.hasData) return const Text('Loading ...');
                return ListView.separated(
                  itemCount: snapshot.data.length,
                  separatorBuilder: (BuildContext context, int index) => Divider(
                    indent: 5.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    Contact _contact = snapshot.data[index];
                    var _phonesList = _contact.phones.toList();

                    return _buildListTile(_contact, _phonesList);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildListTile(Contact c, List<Item> list) {
    return ListTile(
      leading: (c.avatar != null)
          ? CircleAvatar(
        radius: 30.0,
        backgroundImage: MemoryImage(c.avatar),
      )
          : CircleAvatar(
        radius: 30.0,
        child: Text(
            (c.displayName[0] +
                c.displayName[1].toUpperCase()),
            style: TextStyle(color: Colors.white)
        ),
      ),
      title: Text(c.displayName ?? ""),
      subtitle: list.length >= 1 && list[0]?.value != null
          ? Text(list[0].value)
          : Text(''),

      /*trailing: Checkbox(
        activeColor: Colors.green,
        value: c.isChecked,
        onChanged: (bool value) {
          setState(() {
            c.isChecked = value;
          });
        }),*/
    );
  }

  @override
  void initState() {
    super.initState();
    SimplePermissions.requestPermission(Permission.ReadContacts);
  }
}