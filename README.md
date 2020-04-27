# WMSegmentControl
Custom segment control for iOS

![](https://github.com/malekwasim/WMSegmentControl/blob/master/Screenshots/screenshot.png)

### Usage
Using WMSegment control is easy

With Storybord
```
Drag a UIView and change its class to WMSegment.
now you can set the properties as per your requirements.
```
Programatically
```
let anotherSegment = WMSegment(frame: frame)
anotherSegment.type = .normal // normal (Default),imageOnTop, onlyImage
anotherSegment.selectorType = .bottomBar //normal (Default), bottomBar
// If you want round selector 
anotherSegment.isRounded = true //By default false
//Set titles of your segment
anotherSegment.buttonTitles = "Apple,Google,Facebook"
//Set images 
anotherSegment.buttonImages = "apple_light,google_light,facebook_light"
//Set selected images 
anotherSegment.buttonSelectedImages = "apple_dark,google_dark,facebook_dark"

// set text color for non - selected segment values
anotherSegment.textColor = .black
// set text color for selected segment value
anotherSegment.selectorTextColor = .orange
//set Color for selected segment
anotherSegment.selectorColor = .green
//set font for selcted segment value
anotherSegment.SelectedFont = UIFont(name: "ChalkboardSE-Bold", size: 15)!
// set font for segment options
anotherSegment.normalFont = UIFont(name: "ChalkboardSE-Regular", size: 15)!
self.view.addSubview(anotherSegment)
```
### Get selected Index
```
you can get the selected index two ways
1. Using Callback (swifty way)
anotherSegment.onValueChanged = { index in
            print("I have selected index \(index) from WMSegment")
        }
 2. Using Function - connect with segment for valueChange event
 @IBAction func segmentValueChange(_ sender: WMSegment) {
        print("selected index = \(sender.selectedSegmentIndex)")
    }
```
### Installation
Using CocoaPods

```
pod 'WMSegmentControl'
```
Manually
```
Copy WMSegment.swift file from source folder and add it to your project.
```
