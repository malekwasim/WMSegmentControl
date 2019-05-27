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
anotherSegment.isRounded = true //By default flase
//Set titles of your segment
anotherSegment.buttonTitles = "Apple,Google,Facebook"
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
### Installation
Using CocoaPods

```
pod 'WMSegmentControl'
```
Manually
```
Copy WMSegment.swift file from source folder and add it to your project.
```
