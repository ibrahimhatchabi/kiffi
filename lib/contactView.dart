import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

List<Contact> _contacts = new List<Contact>();
bool _isLoading = false;

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => new _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  @override
  void initState() {
    super.initState();
    refreshContacts();
  }

  refreshContacts() async {
    setState(() {
      _isLoading = true;
    });
    var contacts = await ContactsService.getContacts();
    _contacts = contacts.where((item) => item.displayName != null).toList();
    _contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
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
  Widget build(BuildContext context) {
    return new Container(
      child: ListView.separated(
        itemCount: _contacts?.length,
        separatorBuilder: (BuildContext context, int index) => Divider(
          indent: 5.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          Contact _contact = _contacts[index];
          var _phonesList = _contact.phones.toList();

          return _buildListTile(_contact, _phonesList);
        },
      ),
    );
  }
}

