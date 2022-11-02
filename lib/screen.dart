import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'helper.dart';

Future<void> launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw 'Could not launch $url';
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // this to load all grocery items here
  // and update the screen
  List<Map<String, dynamic>> _adresseItem = [];
  @override
  // get all grocery item from Hive
  void initState() {
    setState(() {
      _adresseItem = HiveHelper.getAdresses();
    });
    super.initState();
  }

// for text fielld,
  final _nameController = TextEditingController();
  final _adresseController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.teal[800],
              child: Text(
                _adresseItem.length.toString(), // Number of Item in the liste
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              //foregroundColor: Colors.white,
              //backgroundImage: AssetImage(avatar),
            ),
            SizedBox(
              width: 10,
            ),
            const Text(
              'Liste de Livraison',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('Francais'),
              ),
              const PopupMenuItem(
                child: Text('Anglais'),
              ),
            ],
          ),
        ],
      ),
      body: _adresseItem.isEmpty
          ? const Center(
              child: Text(
                'Actuellement la liste est vide',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListView.builder(
                itemCount: _adresseItem.length,
                itemBuilder: (context, index) {
                  // get current item by index
                  final item = _adresseItem[index];
                  return Card(
                    ////margin: EdgeInsets.symmetric(vertical: 5.0),
                    elevation: 5,
                    child: ListTile(
                      title: Text(item['adresse']),
                      subtitle: Text(item['phone']),
                      leading: Text(item['name']),
                      trailing: FittedBox(
                        //fit: BoxFit.fill,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(
                                  FontAwesomeIcons.phone,
                                  color: Colors.green,
                                  size: 30,
                                ),
                                onPressed: () {
                                  launchURL("tel:" + item['phone']);
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                icon: const Icon(
                                  FontAwesomeIcons.trash,
                                  color: Colors.red,
                                  size: 30,
                                ),
                                onPressed: () async {
                                  HiveHelper.deleteItem(item['key']);

                                  setState(() {
                                    // refresh the screen after delete
                                    _adresseItem = HiveHelper.getAdresses();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () => _adresseModel(context, item['key']),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _adresseModel(context, null),
      ),
    );
  }

  // use this Model to add and update
  void _adresseModel(BuildContext context, int? key) {
    // if key is not null use this Model to update
    // if null use to add
    if (key != null) {
      final currentItem = _adresseItem.firstWhere((item) => item['key'] == key);
      _nameController.text = currentItem['name'];
      _adresseController.text = currentItem['adresse'];
      _phoneController.text = currentItem['phone'];
    }
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          // THIS IS A DART CONDTION
          title:
              key == null ? const Text('Ajouter') : const Text('Modification:'),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Minimize the boxe size
            children: <Widget>[
              // Text Field
              _buildTextField(_nameController, 'Name', TextInputType.text),
              const SizedBox(
                height: 10,
              ),
              _buildTextField(
                  _adresseController, 'Adresse', TextInputType.text),
              const SizedBox(
                height: 10,
              ),
              _buildTextField(_phoneController, 'Phone', TextInputType.number),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              // on Presse Add new Item to Hive
              onPressed: () {
                if (key == null) {
                  HiveHelper.addItem({
                    'name': _nameController.text,
                    'adresse': _adresseController.text,
                    'phone': '+33' + _phoneController.text,
                  });
                } else {
                  HiveHelper.updateItem(key, {
                    'name': _nameController.text,
                    'adresse': _adresseController.text,
                    'phone': _phoneController.text,
                  });
                }
                // Clear all Text Field
                _nameController.clear();
                _adresseController.clear();
                _phoneController.clear();

                // refresh and get latest List
                setState(() {
                  _adresseItem = HiveHelper.getAdresses();
                  Navigator.of(context).pop();
                });
              },
              // THIS IS A CONDTION IN DART
              child:
                  key == null ? const Text('Ajouter') : const Text('Modifier'),
            )
          ],
        );
      },
    );
  }

  // Function for Text Field controller
  TextField _buildTextField(
      TextEditingController controller, String hint, TextInputType keyboard) {
    return TextField(
      keyboardType: keyboard,
      controller: controller,
      decoration: InputDecoration(
        labelText: hint,
        hintText: hint,
        //border: const OutlineInputBorder(),
      ),
    );
  }
}
