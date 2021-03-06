
# PixaBay
[![Platform](https://img.shields.io/cocoapods/p/DLAutoSlidePageViewController.svg?style=flat)]()
[![Swift 5](https://img.shields.io/badge/Swift-5-orange.svg?style=flat)](https://developer.apple.com/swift/)
<img src="https://github.com/hilalalhakani/Pixabay/workflows/CI/badge.svg">

## Screenshots

<img src="Screenshots/Login.jpeg" width=300 height=450>&emsp; <img src="Screenshots/Registration.jpeg" width=300 height=450> &emsp;  <img src="Screenshots/Home.jpeg" width=300 height=450 > &emsp; <img src="Screenshots/ImageDetails.jpeg" width=300 height=450> 

## PixaBay 
The architecture used to build PixaBay app is MVVM, with helping hands from RxSwift. 
The navigation is handled by a coordinator. It is responsable to remove navigation logic from each view and have them all in just one place. 

i created a project for each feature which has 2 frameworks:
1. Presentation: which contains all the iOS files and views 
2. Network: Which contains the api endpoints 
3. Cache can be added as well or other frameworks but in this project it wasn't needed 

each feature can be selected as a target and ran on the simulator 

the DI Container resolves the HTTPClient to the URLSessionHTTPClient and the repositories to their corresponding objects .  
 
 
## Third-party Libraries
 
[Resolver](https://github.com/hmlongco/Resolver) Dependency injection framework for Swift.

[SVProgressHUD](https://github.com/SVProgressHUD/SVProgressHUD) Loader Animation 

[AJMessage](https://github.com/ajijoyo/AJMessage) View To display Error Messages

## References 
 1. [Essential Developer](https://www.essentialdeveloper.com/) youtube channel and course 
 2. [danielt1263](https://github.com/danielt1263?tab=repositories) repositories 

# Views Overview
All views are created using storyboards where they are instantiated using a decoder and a viewModel 
<details>
  <summary>Login</summary>

The Login View has 2 fields (Email and Password) which both inherit `ErrorTextField`,`TextFieldRule` where each once has it owns Validation policy and when it's valid the `errorLabel` appears and when it's not it becomes Hidden 
when Both TextField Are Valid the `LoginButton` becomes enabled 

The `LoginViewModel` handles the state of each textfield , and has an injected `UserRepository` that contains all the requests for the Registration, 
The Correct credentials are **test@mail.com** and **123456**
 
The ScrollView bottom insets is Binded to the `KeyboardHeight`
The LoadingAnimation is Binded to the `loaderSubject` that exists in the viewModel 
The `LoginCoordinator` handles the transition to the RegistrationView and asWell as transition to the HomeView

</details>

<details>
  <summary>Registration</summary>
  

The Registration has 3 fields (Email,Password,Age) where each has its own validation policy same as the LoginView, 
it's similar to the login screen in terms of validation , Loading behavior and architecture
 
</details>


<details>
  <summary>Home</summary>


The HomeView contains Images downloaded From pixabay. 
Instead of waiting to scroll to load the images i `preload` them in advance, and if the cell has ended Displaying i cancel the download or `cancelPrefetchingForRowsAt` has been called

</details>

<details>
  <summary>Network</summary>

The mapping is done in the `ResponseMapper` where it has an injected `DecodedType` which is the Decodable object , `URLResponse` and `Data` 
if the status code isn't `200`, the api error is returned with a custom message according to the response status code. 

</details>

<details>
  <summary>Unit Tests</summary>

 All Tests covered handle retain cycles, i set a weak variable value to an instance and observe its value when the test is completed the instance should be nil thus the weak variable as well , if not then we would have a retain cycle . any by using **Leaks** i made sure there are no leaks as well 
(`trackForMemoryLeaks in XCTestCase+MemoryLeakTracking`)

<img src="Screenshots/Leaks.jpeg" width=800 height=450>&emsp;

 

## PixaBaySnapshotsTests: 
 
I use the func `record` to take a screenshot of the view for `LightMode` and `DarkMode` and save it in the same directory of the test, then i use `assert` func to make sure that the new screenshot is the same as the old value .Usually i use this test to quickly check the change for each Language and Appearance 
for each view.


## The PixaBayTests: 

#### TextFields: 

 Handled all states to check if it's valid or not as well as checking the error Label 

#### ViewModels: 

 Handled all states to check if the loginButton or Registration Button will get enabled  

#### ImageDetails: 

Assert That the injected ViewModelValues are the same as the ImageDetails Label Text

#### HomeView:

     1)`RefreshControl` is Visible and Refreshing on start
     2)on Refresh the viewModel calls the Repository to getData (Using a repositorySpy to observe that the call has been made)
     3)Received item is properly rendered on Screen (Get the cell from tableView and compare the values of model and tableViewCell)
     4)Test Preload and `cancelPreload` and `DidEndEditing` if it will cancel the APiRequest(check the SubscribeBlock on disposed if it gets called)
     5)OnError the `retryButton` is visible (Emitting an Error from the `PixaBayRepositoryMock` and  checking the cell if its `retryButton` is visible)
     6) OnErrorPress the image gets downloaded ( Using a `repositorySpy` to check if the Api function is called)
     7) Check if the image is Animating at start (Check if the View `layer.mask.animation(forKey: shimmerAnimationKey) != nil`)
     8) Check if an image that exists in the `DocumentsDirectory` will be used instead of downloading it from the internet
     9)Check if an image that doesn't exist in the `DocumentsDirectory` will be downloaded and saved in the Documents

#### Scene Delegate: 

Check if the window is visible and the `loginViewController` is the rootViewController

#### Coordinators: 

 Tested the start function and the navigation for each Coordinator 

## PixaBayNetworkTests

-Tested the `ResponseMapper` for each status code , and for a valid and invalid Data 

-Stubbed the `URLSession` where i used the `URLProtocol` to set a custom Response using the `URLProtocolStub` 


</details>
 
