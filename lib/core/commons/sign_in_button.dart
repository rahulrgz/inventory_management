import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/asset_constants/asset_constants.dart';
import '../global_variables/global_variables.dart';

class SignInButton extends ConsumerWidget {
  final BuildContext mainContext;
  const SignInButton({Key? key,required this.mainContext}) : super(key: key);

  // void signInWithgoogle(WidgetRef ref){
  //   ref.read(authControllerProvider.notifier).signinWithGoogle(mainContext);
  // }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(onPressed: (){} ,//signInWithgoogle(ref), //onpressed returns this function
        label: Text('Continue with Google',style: TextStyle(fontSize: deviceHeight*0.025),),
        icon: Image.asset(AssetConstants.google,height: deviceHeight*0.05),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            minimumSize: Size(deviceWidth, deviceHeight*0.07),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            )
        ),
      ),
    );
  }
}
