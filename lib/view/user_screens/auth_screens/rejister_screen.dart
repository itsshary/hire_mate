import 'package:flutter/material.dart';
import 'package:hire_mate/resources/constants/all_list/all_lists.dart';
import 'package:hire_mate/resources/constants/colors/app_colors.dart';
import 'package:hire_mate/resources/widgets/custom_button.dart';
import 'package:hire_mate/resources/widgets/input_decoration.dart';
import 'package:hire_mate/resources/widgets/spin_kit.dart';
import 'package:hire_mate/view_model/auth_vm/register_vm.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();
  String? _selectedSkill;
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegisterViewModel>(context);

    return ModalProgressHUD(
      inAsyncCall: viewModel.isLoading,
      progressIndicator: const SpinkitLoading(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _firstNameController,
                  decoration: CustomInputDecoration(
                      hintText: _selectedRole == 'Hiring for Jobs'
                          ? 'Enter Company First Name'
                          : 'Enter First Name'),
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your first name" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _lastNameController,
                  decoration: CustomInputDecoration(
                      hintText: _selectedRole == 'Hiring for Jobs'
                          ? 'Enter Company Last Name'
                          : 'Enter Last Name'),
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your last name" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: CustomInputDecoration(
                      hintText: _selectedRole == 'Hiring for Jobs'
                          ? 'Enter Company Email'
                          : 'Enter Email'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your email address";
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                        .hasMatch(value)) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: CustomInputDecoration(hintText: "Enter Password"),
                  validator: (value) => value!.length < 6
                      ? "Password must be at least 6 characters"
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration:
                      CustomInputDecoration(hintText: "Enter Phone No.."),
                  validator: (value) => value!.length < 10
                      ? "Phone Number must be at least 10 characters"
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _addressController,
                  decoration: CustomInputDecoration(
                      hintText: _selectedRole == 'Hiring for Jobs'
                          ? 'Enter Company Address'
                          : 'Enter Adress'),
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your address" : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: CustomInputDecoration(hintText: "Select Role"),
                  value: _selectedRole,
                  items: roles.map((role) {
                    return DropdownMenuItem(value: role, child: Text(role));
                  }).toList(),
                  onChanged: (newValue) {
                    _selectedRole = newValue;
                    setState(() {});
                  },
                  validator: (value) =>
                      value == null ? "Please select a role" : null,
                ),
                const SizedBox(height: 20),
                _selectedRole == 'Join for Jobs'
                    ? DropdownButtonFormField(
                        decoration:
                            CustomInputDecoration(hintText: "Select Skill"),
                        value: _selectedSkill,
                        items: skills.map((skill) {
                          return DropdownMenuItem(
                              value: skill, child: Text("$skill Developer"));
                        }).toList(),
                        onChanged: (newValue) {
                          _selectedSkill = newValue;
                        },
                        validator: (value) =>
                            value == null ? "Please select a skill" : null,
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 10.0,
                ),
                CustomButton(
                  text: "Register",
                  color: themecolor,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      viewModel.registerUser(
                        email: _emailController.text,
                        password: _passwordController.text,
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        phone: _phoneController.text,
                        address: _addressController.text,
                        skill: _selectedSkill ?? "",
                        role: _selectedRole!,
                        context: context,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
