import 'package:flutter_test/flutter_test.dart';
import 'package:randebul/Screens/login_screen.dart';

void main(){
  test('empty mail returns error string', (){
    var result = EmailFieldValidator.validate('');
    expect(result, 'Please Enter Your Email');
  });

  test('incorrect mail returns error string', (){
    var result = EmailFieldValidator.validate('thisisnotanemail');
    expect(result, 'Please Enter a valid email');
  });

  test('empty password returns error string',(){
    var result = PasswordFieldValidator.validate('');
    expect(result, 'Password is required for login');
  });

  test('invalid password returns error string',(){
    var result = PasswordFieldValidator.validate('12345');
    expect(result, 'Enter Valid Password(Min. 6 Character)');
  });
}