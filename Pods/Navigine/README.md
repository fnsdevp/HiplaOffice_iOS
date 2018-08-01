<a href="http://navigine.com"><img src="https://navigine.com/assets/web/images/logo.svg" align="right" height="60" width="180" hspace="10" vspace="5"></a> 

# iOS SDK 

The following sections describe the contents of the Navigine iOS SDK repository. Files in our public repository for iOS are:

- sources of the Navigine Demo Application for iOS
- Navigine SDK for iOS - header files and resources
- Sources of the Navigine application for setting up iBeacon (kontakt.io) infrastructure

## Useful Links

- Refer to the [Navigine official website](https://navigine.com/) for complete list of downloads, useful materials, information about the company, and so on.
- [Get started](http://client.navigine.com/login) with Navigine to get full access to Navigation services, SDKs, and applications.
- Refer to the Navigine [User Manual](http://docs.navigine.com/) for complete product usage guidelines.
- Find company contact information at the official website under <a href="https://navigine.com/contacts/">Contact</a> tab.

### iOS Demo Application

Navigine demo application for iOS enables you to test indoor navigation that you set up using Navigine CMS.
The NavigineDemo subfolder in this repository contains source files that you can use for compiling the Demo application.

To get the Navigine demo application for iOS, 

- Either find the [Navigine application in the Apple Store](https://itunes.apple.com/ru/app/navigine/id972099798) using your iOS device
- Or compile the application yourself [using source code, available at GitHub](https://github.com/Navigine/navigine_ios_framework).

For complete guidelines on using the Demo, refer to the [corresponding sections in the Navigine User Manual](http://docs.navigine.com/ud_ios_demo.html), or refer to the Help file incorporated into the application.

## Navigation SDK

Navigine SDK for iOS enables you to develop indoor navigation applications using the well-developed methods, classes, and functions created by the Navigine team.
SDK and corresponding header files reside in the Navigine_SDK folder.

Refer to the [Navigation_SDK sub-folder](https://github.com/Navigine/navigine_ios_framework/tree/master/Navigine%20Framework) for header files used for iOS indoor navigation.


## Navigation SDK

Navigine SDK for Android applications enables you to develop your own indoor navigation apps using the well-developed methods, classes, and functions created by the Navigine team.
The SDK file resides in the NavigineSDK folder.
Find formal description of Navigine-SDK API including the list of classes and their public fields and methods at [Navigine SDK wiki](https://github.com/Navigine/navigine_ios_framework/wiki).

## iBeacon Configuration Application

You can use the Navigine application for setting up your iBeacon infrastructure. Source files for this application reside in the bt5 folder.
Besides the bt5 application sources, the folder contains all necessary header files, XCode project files, tests, and whatever you might need when working with the bt5 application for setting up your iBeacon infrastructure.

Refer to [Setting Up iBeacon Infrastructure](http://docs.navigine.com/is_ibeacon_configuration.html) for details on creating an infrastructure based on using iBeacons.


## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like Navigine in your projects. See the ["Getting Started" guide for more information](https://github.com/Navigine/navigine_ios_framework/wiki/Getting-Started). You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build Navigine 1.0.0+.

#### Podfile

To integrate Navigine into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'Navigine'
end
```

Then, run the following command:

```bash
$ pod install
```

