import 'package:flutter_test/flutter_test.dart';
import 'package:randebul/Screens/registration_screen.dart';

void main(){
  test('empty username field returns error message', (){
    var result = UsernameFieldValidator.validate('');
    expect(result,'Username cannot be Empty');
  });

  test('invalid username field returns error message', (){
    var result = UsernameFieldValidator.validate('xx');
    expect(result,'Enter Valid username(Min. 3 Character)');
  });

  test('empty firstname field returns error message', (){
    var result = FirstNameFieldValidator.validate('');
    expect(result,'First Name cannot be Empty');
  });

  test('invalid firstname field returns error message', (){
    var result = FirstNameFieldValidator.validate('ab');
    expect(result,'Enter Valid name(Min. 3 Character)');
  });

  test('empty surname field returns error message', (){
    var result = SurnameFieldValidator.validate('');
    expect(result,'Second Name cannot be Empty');
  });

  test('empty email field returns error message', (){
    var result = EmailFieldValidator.validate('');
    expect(result,'Please Enter Your Email');
  });

  test('invalid email field returns error message', (){
    var result = EmailFieldValidator.validate('thisisnotanemail');
    expect(result,'Please Enter a valid email');
  });

  test('empty password field returns error message', (){
    var result = PasswordFieldValidator.validate('');
    expect(result,'Password is required for login');
  });

  test('invalid password field returns error message', (){
    var result = PasswordFieldValidator.validate('12345');
    expect(result,'Enter Valid Password(Min. 6 Character)');
  });

  test('empty phone number field returns error message', (){
    var result = PhoneNumberFieldValidator.validate('');
    expect(result,'Please Enter Your Phone number');
  });

  test('invalid phone number field returns error message', (){
    var result = PhoneNumberFieldValidator.validate('thisisnotaphonenumber');
    expect(result,'Please Enter a valid phone number');
  });

  test('empty address field returns error message', (){
    var result = AddressFieldValidator.validate('');
    expect(result,'Please Enter Your adress');
  });




}