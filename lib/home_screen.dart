import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sqlite/database/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DBHelper dbRef = DBHelper.getinstance;
  List<Map<String, dynamic>> allUserInfo = [];

  final form = FormGroup({
    'name': FormControl<String>(validators: [Validators.required]),
    'age': FormControl<String>(validators: [Validators.number()]),
    'address': FormControl<String>(validators: [Validators.required]),
    'dob': FormControl<String>(validators: [Validators.required]),
  });

  @override
  void initState() {
    super.initState();
    getUser();
  }

  /// Fetch user information from the database
  void getUser() async {
    allUserInfo = await dbRef.getUserInfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text("User Info"),
      ),
      body: allUserInfo.isNotEmpty
          ? ListView.builder(
              itemCount: allUserInfo.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      'USER ID:${allUserInfo[index][DBHelper.COLUMN_USER_ID]}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'USER NAME: ${allUserInfo[index][DBHelper.COLUMN_USER_NAME]}'),
                      Text(
                          'USER AGE: ${allUserInfo[index][DBHelper.COLUMN_USER_AGE]}'),
                      Text(
                          'USER ADDRESS: ${allUserInfo[index][DBHelper.COLUMN_USER_ADDRESS]}'),
                      Text(
                          'USER DOB: ${allUserInfo[index][DBHelper.COLUMN_USER_DOB]}'),
                    ],
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: ()  {
                              form.control('name').value=
                                  allUserInfo[index][DBHelper.COLUMN_USER_NAME];
                              form.control('age').value =
                                  allUserInfo[index][DBHelper.COLUMN_USER_AGE];
                              form.control('address').value = allUserInfo[index]
                                  [DBHelper.COLUMN_USER_ADDRESS];
                              form.control('dob').value =
                                  allUserInfo[index][DBHelper.COLUMN_USER_DOB];

                              getReactiveFormData(
                                isupdate: true,
                                userid: allUserInfo[index]
                                    [DBHelper.COLUMN_USER_ID],);

                           },
),
                        //Delete Icon Button
                        IconButton(
                          onPressed: () async {
                            bool check = await dbRef.deleteUserInfo(
                                userid: allUserInfo[index]
                                    [DBHelper.COLUMN_USER_ID]);
                            if (check) {
                              getUser();
                            }
                          },
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                );
              })
          : const Center(
              child: Text("No User Register Yet"),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          form.control('name').clearValidators();
          form.control('age').clearValidators();
          form.control('address').clearValidators();
          form.control('dob').clearValidators();
          final addedUser = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => getReactiveFormData()),
          );

          if (addedUser == true) {
            getUser();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget getReactiveFormData({bool isupdate = false, int userid = 0}) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(isupdate ? "Update User Info" : 'Add User Info'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ReactiveForm(
            formGroup: form,
            child: Column(
              children: [
                ReactiveTextField(
                  formControlName: 'name',
                  decoration: InputDecoration(
                    labelText: 'Enter Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ReactiveTextField(
                  formControlName: 'age',
                  decoration: InputDecoration(
                    labelText: 'Enter Age',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ReactiveTextField(
                  formControlName: 'dob',
                  decoration: InputDecoration(
                    labelText: 'Enter Date of Birth',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ReactiveTextField(
                  maxLines: 2,
                  formControlName: 'address',
                  decoration: InputDecoration(
                    labelText: 'Enter Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    final String name = form.control('name').value;
                    final String age = form.control('age').value;
                    final String address = form.control('address').value;
                    final String dob = form.control('dob').value;

                    if (name.isNotEmpty &&
                        age.isNotEmpty &&
                        address.isNotEmpty &&
                        dob.isNotEmpty) {
                      bool check = isupdate
                          ? await dbRef.updateUserInfo(
                              userid: userid,
                              name: name,
                              age: age,
                              address: address,
                              dob: dob)
                          : await dbRef.addUserInfo(
                              name: name, age: age, address: address, dob: dob);
                      if (check) {
                        getUser();
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill all required Fields"),
                          ),
                        );
                      }
                    }
                  },
                  child: Text(isupdate ? "Update User Info" : "Save Info"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
