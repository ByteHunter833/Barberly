import 'package:barberly/core/models/user.dart';
import 'package:barberly/core/network/api_service.dart';

class ProfileRepository {
  final ApiService api;
  ProfileRepository(this.api);
  Future<User> getProfile() async {
    final response = await api.getData('user'); // пример endpoint
    return User.fromJson(response['data']);
  }
}
