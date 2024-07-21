# Polaris Dynamic Form Documentation

## Project Architecture
This project uses a customized architecture based on MVVM. The whole can be divided into different layers.

The project uses getit for dependency injection, for which all the dependencies are defined in DependencyManager.

### Libraries & Services Layer
These are custom libraries, usable across projects. Can be removed when not need, don't affect app performance or app size. Have no effect whatsoever if not used.

Separated into a folder named _libraries

### Repository Layer
Complex Services/libraries which cannot be directly used and need some configuration are stored in the repository layer. They are customized according to the requirements of the project, so that they can be used easily.

There are 4 major repositories.
- ApiRepository
This is a collection of the api methods, which may be used across the application. Apis are defined individually, where they define, their endpoint, call method, data type and all the other variable parts.
Api Repository defines how the apis are called, adds any common headers if required. Provides input and output interceptors, for encryption and other purposes. And also handles failures.

- BackgroundTasksRepository
A small separated component which defines, initiates, and controls the background process.

- StorageRepository
A repository which contains only a single method, to upload images. Uses Firebase Cloud Storage to upload Files.

- HiveRepository
Local Storage Repository, It defines the different boxes, to store data across. It also defines all the methods required to access local storage.

### Models
Models serve as the the objects to facilitate easy and predictable data transfer. Models define how the data should look like, its behavior and allow easier conversion to different forms.

There is two major model used in the application.
- FormModel
This model represents the form as received from the server.
It uses a nested FormFieldModel to represent individual fields.
    - FormFieldModel
    This model is an abstraction over actual field models. Currently there are 5 implementations for this.
        - FormCaptureImagesFieldModel
        - FormEditTextFieldModel
        - FormRadioGroupFieldModel
        - FormCheckBoxesFieldModel
        - FormDropDownFieldModel

- SubmittedFormModel
This model represents the submitted form, with the fields and their respective responses. It is also used for storing the data in local storage.


### Controller and BLoC Layer
User Interface is separated from Business Logic, through Bloc. Any kind of interaction, with the repository, network, services, is done via controller.

User Interface serves the user, and interactes with only the Bloc Controllers. Mostly their own Bloc Controllers.

There are 3 controllers used across the project:
- AppController
AppController handles all the application logic which is not specific to any single screen. It stores, submits and uploads the forms. It detects network changes and based on internet availabilty, tries to upload any pending forms.

- HomeController
HomeController is directly linked with the HomeScreen. It detects changes from the AppController, if any new form is submitted, or if the internet is back and the form is being uploaded.

- FormController
FormController is directly linked with the FormScreen. It fetches the form from the server. It handles the validation, whether the form is ready to be submitted or not. It also submits the form to AppController for further processing when done.

### UI Layer
User Interface is made of widgets. This layer defines how the UI should look like and how it should change based on user interaction and application state changes.

There are many custom widgets used across the project. But the most important one would be DynamicForm.

- DynamicForm
Dynamic Form takes a FormModel and builds the form dynamically based on configured Field Types. It also takes a ValueNotifier which serves to return the response. The ValueNotifier is also used for validation.

Dynamic Form internally creates multiple DynamicFormField based on the fields in FormModel. It creates a ValueNotifier for each field, and uses them to update the state, and notify back via its own response notifier.

- DynamicFormField
This widget is an abstraction over actual fields. Currently there are 5 implementations. each take the corresponding FormFieldModel, use a ValueNotifier to report back their responses.
    - FormCaptureImagesField
    - FormEditTextField
    - FormRadioGroupField
    - FormCheckBoxesField
    - FormDropDownField

## Packages
These are the most of the packages used across the project. Divided based on their usage.

#### Bloc
- flutter_bloc

#### Internet Checks
- connectivity_plus

#### Background Service
- flutter_background_service

#### Cloud Storage
- firebase_core
- firebase_storage

#### Local Storage
- hive_flutter

#### Camera
- cross_file
- image_picker
- mime
- permission_handler

#### Network Calls
- http
- http_parser

#### General UI and Logic
- async
- cached_network_image
- cupertino_icons
- flutter_svg
- get_it
- intl
- shared_preferences
- universal_html

## Configuration and Installation Instructions
This project uses .env files, included through --dart-define-from-file
```flutter run --dart-define-from-file .env --dart-define mode=dev```

Flutter SDK: 3.22.3 (Latest)
Dart SDK: 3.4.4
