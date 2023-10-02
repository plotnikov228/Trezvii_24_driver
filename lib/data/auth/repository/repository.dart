import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:trezvii_24_driver/data/firebase/auth/models/driver.dart';
import 'package:trezvii_24_driver/data/firebase/auth/repository.dart';
import 'package:trezvii_24_driver/data/firebase/storage/repository.dart';
import 'package:trezvii_24_driver/domain/auth/models/auth_result.dart';
import 'package:trezvii_24_driver/domain/db/usecases/db_delete.dart';
import 'package:trezvii_24_driver/domain/db/usecases/db_insert.dart';
import 'package:trezvii_24_driver/domain/db/usecases/db_query.dart';
import 'package:trezvii_24_driver/domain/firebase/auth/models/user_model.dart';
import 'package:trezvii_24_driver/domain/firebase/auth/usecases/add_user_to_existed.dart';
import 'package:trezvii_24_driver/domain/firebase/auth/usecases/send_driver_data_for_verification.dart';
import 'package:trezvii_24_driver/domain/firebase/auth/usecases/user_is_exist.dart';
import 'package:trezvii_24_driver/domain/firebase/storage/usecases/upload_file_to_cloud_storage.dart';
import 'package:trezvii_24_driver/extensions/firebase_auth_exeption_extension.dart';
import '../../../domain/auth/models/auth_type.dart';
import '../../../domain/auth/repository/repository.dart';
import '../../../domain/db/usecases/init_db.dart';
import '../../../domain/firebase/auth/usecases/get_driver_by_id.dart';
import '../../db/repository/repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final _authInstance = auth.FirebaseAuth.instance;
  static const phonePrefix = '+7';

  @override
  Future signIn(String number, Function(AuthResult) onError,
      Function(AuthResult) onSuccess) async {
    try {
      final userAlreadyExist = await UserIsExist(_repo).call(phonePrefix + number);
      if (!userAlreadyExist) {
        onError(AuthResult(successful: false, exception: 'Аккаунт ещё не создан, перейдите в окно регистрации'));
      } else {
        await _authInstance.verifyPhoneNumber(
          phoneNumber: phonePrefix + number,
          verificationCompleted: (auth.PhoneAuthCredential credential) async {},
          verificationFailed: (auth.FirebaseAuthException e) {
            onError(
                AuthResult(successful: false, exception: e.getExceptionText()));
          },
          codeSent: (String verificationId, int? resendToken) async {
            onSuccess(
                AuthResult(verificationId: verificationId, number: number));
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      }
    } on auth.FirebaseAuthException catch (_) {
      onError(AuthResult(successful: false, exception: _.getExceptionText()));
      rethrow;
      return AuthResult(successful: false, exception: _.getExceptionText());
    }

  }

  @override
  Future signUp(String number, String email, Function(AuthResult) onError,
      Function(AuthResult) onSuccess) async {
    try {


      await _authInstance.verifyPhoneNumber(
        phoneNumber: phonePrefix + number,
        verificationCompleted: (auth.PhoneAuthCredential credential) async {},
        verificationFailed: (auth.FirebaseAuthException e) {
          onError(
              AuthResult(successful: false, exception: e.getExceptionText()));
        },
        codeSent: (String verificationId, int? resendToken) async {
          onSuccess(AuthResult(
              verificationId: verificationId, number: number, mail: email));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on auth.FirebaseAuthException catch (_) {
      return AuthResult(successful: false, exception: _.getExceptionText());
    }
  }

  final _repo = FirebaseAuthRepositoryImpl();
  final _dbRepo = DBRepositoryImpl();

  @override
  Future signUpForDriver(String number, Driver driver,
      {required Function(AuthResult p1) onError,
      required Function(AuthResult p1) onSuccess}) async {
    try {
      await _authInstance.verifyPhoneNumber(
        phoneNumber: phonePrefix + number,
        verificationCompleted: (auth.PhoneAuthCredential credential) async {},
        verificationFailed: (auth.FirebaseAuthException e) {
          onError(
              AuthResult(successful: false, exception: e.getExceptionText()));
        },
        codeSent: (String verificationId, int? resendToken) async {
          onSuccess(AuthResult(
            verificationId: verificationId,
            number: number,
            driver: driver,
          ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on auth.FirebaseAuthException catch (_) {
      return AuthResult(successful: false, exception: _.getExceptionText());
    }
  }

  @override
  Future<AuthResult> verifyCode(String code, AuthResult authResult,
      {required Function(bool) whenComplete, required AuthType type}) async {
    try {
      auth.PhoneAuthCredential authCredential =
          auth.PhoneAuthProvider.credential(
              verificationId: authResult.verificationId!, smsCode: code);
      final credential =
          await _authInstance.signInWithCredential(authCredential);
      var _type = type;
      UserModel? userModel;
      if (credential.user != null) {
        if (_type == AuthType.signIn) {
          userModel = await GetDriverById(_repo).call(credential.user!.uid);
          if (!(userModel as Driver).confirmed) {
            userModel = null;
          }
        } else if (_type == AuthType.signUp) {
          if (await GetDriverById(_repo).call(credential.user!.uid) != null) {
            return AuthResult(
                successful: false,
                exception:
                    'Вы уже подавали заявку используя данный номер телефона');
          } else {
            final usecase =
                UploadFileToCloudStorage(FirebaseStorageRepositoryImpl());
            final pass = await usecase.call(
                authResult.driver!.personalDataOfTheDriver!.passPhoto!,
                'паспорт',
                credential.user!.uid);
            final registration = await usecase.call(
                authResult.driver!.personalDataOfTheDriver!.registrationPhoto!,
                'прописка',
                credential.user!.uid);
            final front = await usecase.call(
                authResult
                    .driver!.personalDataOfTheDriver!.driverLicenseFrontPhoto!,
                'передняя сторона удостоверения',
                credential.user!.uid);
            final back = await usecase.call(
                authResult
                    .driver!.personalDataOfTheDriver!.driverLicenseBackPhoto!,
                'задняя сторона удостоверения',
                credential.user!.uid);
            final driver = await usecase.call(
                authResult.driver!.personalDataOfTheDriver!.driverPhoto!,
                'photo',
                credential.user!.uid);
            final _driver = await authResult.driver!.copyWith(
                userId: credential.user!.uid,
                personalDataOfTheDriver:
                    authResult.driver!.personalDataOfTheDriver!.fillUrls(
                        passPhotoUrl: pass.imageUrl,
                        registrationPhotoUrl: registration.imageUrl,
                        driverLicenceFrontUrl: front.imageUrl,
                        driverLicenseBackUrl: back.imageUrl,
                        driverPhotoUrl: driver.imageUrl));
            await SendDriverDataForVerification(_repo).call(_driver);
          }
        }

        if (userModel != null) {
          final db = await InitDB(_dbRepo).call();
          final inserUsecase = DBInsert(_dbRepo);
          final removeUsecase = DBDelete(_dbRepo);
          final listUsers = await DBQuery(_dbRepo).call('user');
          if (listUsers.isNotEmpty) {
            for (var item in listUsers) {
              await removeUsecase.call(
                  'user', (item as UserModel).toJson(), 'userId');
            }
          }
          await AddUserToExisted(_repo).call(userModel);
          await inserUsecase.call('user', userModel.toDB());
        }
      }
      if (userModel == null) {
        try {
          _authInstance.signOut();
        } catch (_) {}
      }
      whenComplete(userModel == null);

      return AuthResult();
    } on auth.FirebaseAuthException catch (e) {
      print(e);
      return AuthResult(
          successful: false,
          exception:
              'Проверьте правильность введённого вами кода ил попробуйте позднее');
    } catch (_) {
      try {
        _authInstance.signOut();
      } catch (_) {
        print('exception - $_');
      }
      print('exception - $_');
      return AuthResult(
          successful: false,
          exception:
              'Возникла непредвиденная ошибка, проверьте подключение к интернету или попробуйте позднее');
    }
  }

  @override
  Future<String> getUserId() async {
    try {
      return _authInstance.currentUser!.uid;
    } catch (_) {
      return (await DBQuery(DBRepositoryImpl()).call('user')).first['userId'];
    }
  }
}
