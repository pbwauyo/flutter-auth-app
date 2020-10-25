import 'package:auth_app/cubit/auth_cubit.dart';
import 'package:auth_app/cubit/home_cubit.dart';
import 'package:auth_app/cubit/login_cubit.dart';
import 'package:auth_app/cubit/signup_cubit.dart';
import 'package:auth_app/cubit/signup_method_cubit.dart';
import 'package:auth_app/cubit/t_and_cs_cubit.dart';
import 'package:auth_app/pages/contacts_list.dart';
import 'package:auth_app/pages/contacts_permission.dart';
import 'package:auth_app/pages/home.dart';
import 'package:auth_app/pages/landing_page.dart';
import 'package:auth_app/pages/login.dart';
import 'package:auth_app/pages/splash.dart';
import 'package:auth_app/providers/file_path_provider.dart';
import 'package:auth_app/providers/moment_id_provider.dart';
import 'package:auth_app/providers/take_picture_type_provider.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.signOut();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FilePathProvider()),
        ChangeNotifierProvider(create: (context) => TakePictureTypeProvider()),
        ChangeNotifierProvider(create: (context) => MomentIdProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LoginCubit()),
          BlocProvider(create: (context) => SignupCubit()),
          BlocProvider(create: (context) => AuthCubit()),
          BlocProvider(create: (context) => TAndCsCubit()),
          BlocProvider(create: (context) => SignupMethodCubit()),
          BlocProvider(create: (context) => HomeCubit()),
        ],
        child: MaterialApp(
            title: 'Happr',
            theme: ThemeData(
              primaryColor: AppColors.PRIMARY_COLOR,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: MyHomePage(),
            debugShowCheckedModeBanner: false,
          ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, (){
      context.bloc<AuthCubit>().checkLoggedInUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state){
        if(state is AuthLoggedIn){ //if theres a logged in user, goto the Home screen else show Login screen
          return Home();
        }else {
          return LandingPage();
        }
      }
    );
  }
}
