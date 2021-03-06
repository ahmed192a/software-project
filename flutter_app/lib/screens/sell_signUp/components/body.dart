import 'package:flutter_app/Pages/Seller.dart';
import 'package:flutter_app/services/auth.dart';

import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/constants.dart';
import '../../../common/size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(60)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //SizedBox(height: SizeConfig.screenHeight * 0.08),
              /* Image(
                  image: AssetImage('assets/icons/logo.png'),
                  width: double.infinity,
                  height: getProportionateScreenHeight(100)),*/
              SizedBox(height: SizeConfig.screenHeight * 0.03),
              Text(
                "Create Your Account.",
                style: TextStyle(
                    fontSize: (getProportionateScreenWidth(35)),
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              SellSignUpForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class SellSignUpForm extends StatefulWidget {
  @override
  _SellSignUpFormState createState() => _SellSignUpFormState();
}

class _SellSignUpFormState extends State<SellSignUpForm> {
  //final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';
  String confirmpassword = '';
  String phone = '';
  String brand = '';
  String type = '';
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          //USERNAME TEXT FIELD
          TextFormField(
            decoration: InputDecoration(
              labelText: "User Name",
              hintText: "Enter your User Name.",
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            style: TextStyle(fontSize: getProportionateScreenWidth(30)),
            cursorColor: Colors.black,
            keyboardType: TextInputType.name,
            onSaved: (newValue) => name = newValue,
            onChanged: (value) {
              setState(() => name = value);
            },
            validator: (value) {
              if (value.isEmpty) {
                addError(error: kNameNullError);
                return "";
              } else if (value.isNotEmpty) {
                removeError(error: kNameNullError);
              }
              return null;
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.02),

          buildEmailFormField(),
          SizedBox(height: SizeConfig.screenHeight * 0.02),
          buildPasswordFormField(),
          buildConfirmPasswordFormField(),
          //PHONE TEXT FIELD
          TextFormField(
            decoration: InputDecoration(
              labelText: "Phone number",
              hintText: "Enter a valid phone number.",
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            style: TextStyle(fontSize: getProportionateScreenWidth(30)),
            cursorColor: Colors.black,
            keyboardType: TextInputType.number,
            onSaved: (newValue) => phone = newValue,
            onChanged: (value) {
              setState(() => phone = value);
            },
            validator: (value) {
              if (value.isEmpty) {
                addError(error: kPhoneNullError);
                return "";
              } else if (value.isNotEmpty) {
                removeError(error: kPhoneNullError);
                if (value.length < 11 || value.length > 11) {
                  addError(error: kPhoneInvalidError);
                  return "";
                } else if (value.length == 11) {
                  removeError(error: kPhoneInvalidError);
                }
              }
              return null;
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.02),
          //BRAND TEXT FIELD
          TextFormField(
            decoration: InputDecoration(
              labelText: "Company/Brand name",
              hintText: "Enter a Brand or a company name.",
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            style: TextStyle(fontSize: getProportionateScreenWidth(30)),
            cursorColor: Colors.black,
            keyboardType: TextInputType.name,
            onSaved: (newValue) => brand = newValue,
            onChanged: (value) {
              setState(() => brand = value);
            },
            validator: (value) {
              if (value.isEmpty) {
                addError(error: kBrandNameNullError);
                return "";
              } else if (value.isNotEmpty) {
                removeError(error: kBrandNameNullError);
              }
              return null;
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.01),
          FormError(errors: errors),
          SizedBox(height: SizeConfig.screenHeight * 0.02),

          DefaultButton(
            text: "Create",
            press: () async {
              //GO TO HOME PAGE WITH NEW PROFILE INFO

              if (_formKey.currentState.validate()) {
                //_formKey.currentState.save();
                // print(name);
                // print(email);
                // print(password);
                // print(phone);
                // print(brand);
                type = 'seller';
                dynamic result = await await context
                    .read<AuthService>()
                    .signUp(name, email, password, phone, brand, type);
                if (result is String) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Error'),
                        actions: [
                          MaterialButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('back'),
                          )
                        ],
                        content: Text(result),
                      );
                    },
                  );
                } else
                  Navigator.pop(context);
                /*Navigator.popAndPushNamed(
                  context,
                  SellerInterface.routeName,
                );*/
              }
            },
          )
        ],
      ),
    );
  }

  TextFormField buildConfirmPasswordFormField() {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      maxLength: 20,
      cursorColor: Colors.black,
      obscureText: true,
      onSaved: (newValue) => confirmpassword = newValue,
      onChanged: (value) {
        // if (password == confirmpassword) {
        //   removeError(error: kMatchPassError);
        // }
        // return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "";
        } else if (value.isNotEmpty) {
          if (value == password) {
            removeError(error: kMatchPassError);
          } else if (value != password) {
            addError(error: kMatchPassError);
            return "";
          }
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Confirm password",
        hintText: "Re-enter password.",
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      style: TextStyle(fontSize: getProportionateScreenWidth(30)),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      maxLength: 20,
      cursorColor: Colors.black,
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPasswordNullError);
          if (value.length >= 8) {
            removeError(error: kPasswordShortError);
          }
        }
        setState(() => password = value);
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPasswordNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kPasswordShortError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password.",
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      style: TextStyle(fontSize: getProportionateScreenWidth(30)),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
          if (emailValidatorRegExp.hasMatch(value)) {
            removeError(error: kInvalidEmailError);
          }
        }
        setState(() => email = value);
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email.",
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      style: TextStyle(fontSize: getProportionateScreenWidth(30)),
    );
  }
}
