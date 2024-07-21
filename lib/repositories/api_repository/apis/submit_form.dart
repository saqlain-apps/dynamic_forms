import 'package:dynamic_form/models/form_model/submitted_form_model.dart';

import '/_libraries/http_services/http_services.dart';
import '/repositories/api_repository/api.dart';

class SubmitFormApi extends Api {
  const SubmitFormApi(super.repository);

  Future<bool> call(SubmittedFormModel data) async {
    var res = await raw(data);
    return properResponse<bool>(
          res,
          statusCode: {201},
          parser: (json) => true,
        ) ??
        false;
  }

  Future<HttpResponse> raw(SubmittedFormModel data) async {
    return await http.post(
      createRequest(url('/push'), body: {
        'data': data.fields.values.map((e) => {"response": e}).toList(),
      }),
    );
  }
}
