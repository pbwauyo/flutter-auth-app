import 'dart:io';

import 'package:auth_app/cubit/auth_cubit.dart';
import 'package:auth_app/cubit/home_cubit.dart';
import 'package:auth_app/cubit/login_cubit.dart';
import 'package:auth_app/cubit/signup_cubit.dart';
import 'package:auth_app/cubit/signup_method_cubit.dart';
import 'package:auth_app/cubit/t_and_cs_cubit.dart';
import 'package:auth_app/cubit/test_login_cubit.dart';
import 'package:auth_app/cubit/test_signup_cubit.dart';
import 'package:auth_app/getxcontrollers/edit_image_controller.dart';
import 'package:auth_app/getxcontrollers/overlay_text_position_controller.dart';
import 'package:auth_app/getxcontrollers/logged_in_username.dart';
import 'package:auth_app/getxcontrollers/selected_calendar_controller.dart';
import 'package:auth_app/getxcontrollers/video_controller.dart';
import 'package:auth_app/pages/contacts_list.dart';
import 'package:auth_app/pages/contacts_permission.dart';
import 'package:auth_app/pages/home.dart';
import 'package:auth_app/pages/interests.dart';
import 'package:auth_app/pages/interests_v2.dart';
import 'package:auth_app/pages/landing_page.dart';
import 'package:auth_app/pages/login.dart';
import 'package:auth_app/pages/splash.dart';
import 'package:auth_app/pages/test_invitation_landing_page.dart';
import 'package:auth_app/providers/camera_type_provider.dart';
import 'package:auth_app/providers/file_path_provider.dart';
import 'package:auth_app/providers/moment_id_provider.dart';
import 'package:auth_app/providers/moment_provider.dart';
import 'package:auth_app/providers/moment_type_provider.dart';
import 'package:auth_app/providers/take_picture_type_provider.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/utils/pref_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/instance_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'getxcontrollers/categories_controller.dart';
import 'getxcontrollers/create_moment_controller.dart';

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
        ChangeNotifierProvider(create: (context) => MomentProvider()),
        ChangeNotifierProvider(create: (context) => CameraTypeProvider()),
        ChangeNotifierProvider(create: (context) => MomentTypeProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LoginCubit()),
          BlocProvider(create: (context) => SignupCubit()),
          BlocProvider(create: (context) => AuthCubit()),
          BlocProvider(create: (context) => TAndCsCubit()),
          BlocProvider(create: (context) => SignupMethodCubit()),
          BlocProvider(create: (context) => HomeCubit()),
          BlocProvider(create: (context) => TestSignupCubit()),
          BlocProvider(create: (context) => TestLoginCubit()),
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
  final LoggedInUsernameController loggedInUsernameController = Get.put(LoggedInUsernameController());
  final CreateMomentController controller = Get.put(CreateMomentController());
  final SelectedCalendarController selectedCalendarController = Get.put(SelectedCalendarController());
  final OverlayTextPositionController imageTextPositionController = Get.put(OverlayTextPositionController());
  final EditImageController editImageController = Get.put(EditImageController());
  final VideoController videoController = Get.put(VideoController());
  final CategoriesController _categoriesController = Get.put(CategoriesController());
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  FlutterFFmpegConfig _fFmpegConfig;

  @override
  void initState() {
    super.initState();

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    WidgetsBinding.instance.addPostFrameCallback((_) async{ 
      final loggedIn = context.bloc<AuthCubit>().checkLoggedInUser();
      if(loggedIn){
        final username = await PrefManager.getLoginUsername();
        print("USERNAME: $username");
        loggedInUsernameController.loggedInUserEmail = username;
      }
    });

    _fFmpegConfig = new FlutterFFmpegConfig();
    _setFfMpegFontConfig();
    _initialiseLocalNotificationsPlugin();
    Methods.showLocalNotification(body: "Welcome back to Happr", flutterLocalNotificationsPlugin: _flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    // return ContactsPermission();
    
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state){
        if(state is AuthLoggedIn){ //if theres a logged in user, goto the Home screen else show Login screen
          return Home();
        }else {
          return TestInvitationLandingPage();
        }
      }
    );
  }

  _setFfMpegFontConfig() async{
    var tempDir = await getTemporaryDirectory();
    final fontDirPath = "${tempDir.path}/fonts";
    final fontDir =  Directory(fontDirPath);

    if(!await fontDir.exists()){
      try{
        await fontDir.create(recursive: true);
        final assetFontByteData = await rootBundle.load("assets/fonts/OpenSans-Light.ttf");
        final buffer = assetFontByteData.buffer;

        await File("${fontDir.path}/OpenSans-Light.ttf").writeAsBytes(
          buffer.asInt8List(assetFontByteData.offsetInBytes, assetFontByteData.lengthInBytes) //copy asset font to folder
        );
      }catch(error){
        print("FONT SAVE ERROR: $error");
      }

    }
    _fFmpegConfig.setFontDirectory("${fontDir.path}", null);
  }

  _initialiseLocalNotificationsPlugin(){
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification
    );
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, 
      iOS: initializationSettingsIOS
    );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future _onDidReceiveLocalNotification(int id, String title, String body, String payload){ //for iOS

  }
}
