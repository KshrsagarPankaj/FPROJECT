import 'package:crypto_app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({super.key});

  final TextEditingController Name= TextEditingController();
  final TextEditingController Email = TextEditingController();
  final TextEditingController Age = TextEditingController();

  Future<void>saveData(String key, String value)async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
  }

  void saveUserDetail() async{
    await saveData("Name",Name.text);
    await saveData("Email", Email.text);
    await saveData("Age", Age.text);
    print("Data saved in terminal");
  }
   bool isDarkModeEnabled = AppTheme.isDarkModeEnabled;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkModeEnabled ? Colors.black :Colors.white,
      appBar: AppBar(
        title: Text("Profile update"),
      ),
      body: Column(
        children: [
          customTextfield("Name",Name, false),
          customTextfield("Email",Email, false),
          customTextfield("Age", Age,true),
          ElevatedButton(
            onPressed: (){
              saveUserDetail();
                 },
            child: Text("Save detail"),)
        ],
      ),
    );
  }
  Widget customTextfield(String title, TextEditingController controller, bool isAgeTextField ){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: isDarkModeEnabled ? Colors.white :Colors.grey),
            ),
            hintText: title,
          hintStyle: TextStyle(color: isDarkModeEnabled ? Colors.white :null),
        ),
        keyboardType: isAgeTextField? TextInputType.number:null,
      ),
    );
  }
}
