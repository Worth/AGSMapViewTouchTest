# AGSMapViewTouchTest
Testing touch interaction with AGSMapView in ArcGIS Runtime SDK for iOS version 100.4. This app uses a gesture recognizer to capture single-finger-touch strokes. When a stroke gesture is detected and started, the mapView interaction is disabled using the following line of code:
```
    mapView.interactionOptions.isEnabled = false
```

This project was created to demonstrate an issue where, even though mapView interaction is disabled, the mapView sporadically zooms in and out at the center of the view, even with just one finger. Sometimes in testing, it is hard to recreate the issue. I have found it to occur on any iOS device or simulator but it occurs more often on physical iPhones.

See me making it happen in an iPhone XR simulator: https://youtu.be/egnxTwN6jBA

To duplicate this issue for yourself, build this app in Xcode and run it on your iOS device or simulator. Imagine touching and dragging with one finger in a north or south direction to make a stroke. Because this is a test program, the touch samples are only being consumed (no actual stroke will show on the screen). As you are making your imaginary stroke, an indicator appears showing when the interaction options are disabled. Many of your imaginary strokes will not cause the problem. Keep trying, though, and you will eventually see the map zoom in on a down stroke or out on an up stroke.

# Requires Xcode 10.1 and CocoaPods
To build this in Xcode, follow these steps:
1. Clone this project to your computer.
2. This project uses CocoaPods to install _ArcGIS Runtime SDK for iOS_ for this project. From a command prompt in the project's root directory (where Podfile is), run 'pod install'. If you don't see `Installing ArcGIS-Runtime-SDK-iOS (100.4)`, try running 'pod update' instead.
3. Open the Xcode workspace, `AGSMapViewTouchTest.xcworkspace`, in Xcode. Warning: do not load the Xcode project, `AGSMapViewTouchTest.xcodeproj`. To pull in the ArcGIS Runtime SDK for iOS pod, the Xcode workspace is required.
4. In Xcode, go to your project target, general settings and personalize your _Bundle Identifier_ and _Signing Team_.
5. Done. It should now be ready to build and run.

