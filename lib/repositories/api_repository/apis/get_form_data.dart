import 'package:dynamic_form/models/form_model/form_model.dart';

import '/_libraries/http_services/http_services.dart';
import '/repositories/api_repository/api.dart';

class GetFormDataApi extends Api {
  const GetFormDataApi(super.repository);

  Future<FormModel?> call() async {
    return FormModel.fromMap(sample());
    var res = await raw();
    return properResponse<FormModel>(
      res,
      statusCode: {200},
      parser: FormModel.fromMap,
    );
  }

  Future<HttpResponse> raw() async {
    return await http.get(createRequest(url('/')));
  }

  Map<String, dynamic> sample() {
    return {
      "form_name": "Consumer Survey Form",
      "fields": [
        {
          "meta_info": {
            "label": "Consumer Name",
            "component_input_type": "TEXT",
            "mandatory": "no"
          },
          "component_type": "EditText"
        },
        {
          "meta_info": {
            "label": "Consumer Mobile Number",
            "component_input_type": "INTEGER",
            "mandatory": "yes"
          },
          "component_type": "EditText"
        },
        {
          "meta_info": {
            "label": "Consumer Status",
            "options": ["OK", "Door Locked", "Bill Not available"],
            "mandatory": "yes"
          },
          "component_type": "CheckBoxes"
        },
        {
          "meta_info": {
            "label": "Meter Status",
            "options": ["Metered", "UnMetered"],
            "mandatory": "yes"
          },
          "component_type": "DropDown"
        },
        {
          "meta_info": {
            "label": "Phase Type",
            "options": ["Single Phase", "Three Phase", "Dual Phase"],
            "mandatory": "yes"
          },
          "component_type": "RadioGroup"
        },
        {
          "meta_info": {
            "label": "Survey Images",
            "component_input_type": "",
            "mandatory": "yes",
            "no_of_images_to_capture": 1,
            "saving_folder": "PolarisSurvey"
          },
          "component_type": "CaptureImages"
        },
        {
          "meta_info": {
            "label": "Meter Validation Status",
            "options": ["Tested", "Verified"],
            "mandatory": "yes"
          },
          "component_type": "DropDown"
        },
        {
          "meta_info": {
            "label": "Consumer Status",
            "options": ["OK", "Door Locked", "Bill Not available"],
            "mandatory": "yes"
          },
          "component_type": "CheckBoxes"
        },
        {
          "meta_info": {
            "label": "Consumer Images",
            "component_input_type": "",
            "mandatory": "yes",
            "no_of_images_to_capture": 1,
            "saving_folder": "PolarisSurvey"
          },
          "component_type": "CaptureImages"
        }
      ]
    };
  }
}
