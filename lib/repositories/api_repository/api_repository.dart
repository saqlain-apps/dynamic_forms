import '../../_libraries/base_api_repository/base_api_repository.dart';
import 'apis/get_form_data.dart';
import 'apis/submit_form.dart';

class ApiRepository extends BaseApiRepository {
  ApiRepository(super.httpService);
  //----------------------------------------------------------------------------

  late final GetFormDataApi getFormData = GetFormDataApi(this);
  late final SubmitFormApi submitForm = SubmitFormApi(this);
}
