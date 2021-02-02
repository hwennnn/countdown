# Countdown
<br />
<p align="center">
  <a href="https://github.com/alexanderritik/Best-README-Template">
    <img src="logo.jpeg" alt="Logo" width="80" height="80">
  </a>
  <p align="center">
    One to two paragraph statement about your product and what it does.
  </p>
</p>

<p align="row">
<img src= "https://media.giphy.com/media/HYOlBKJBqgAfe/giphy.gif" width="400" >
<img src= "https://media.giphy.com/media/HYOlBKJBqgAfe/giphy.gif" width="400" >
</p>

## Features

- [x] Feature 1
- [x] Feature 2
- [x] Feature 3
- [x] Feature 4
- [x] Feature 5

## Requirements

- iOS 8.0+
- Xcode 7.3

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `YourLibrary` by adding it to your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!
pod 'YourLibrary'
```

To get the full benefits import `YourLibrary` wherever you import UIKit

``` swift
import UIKit
import YourLibrary
```
#### Carthage
Create a `Cartfile` that lists the framework and run `carthage update`. Follow the [instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios) to add `$(SRCROOT)/Carthage/Build/iOS/YourLibrary.framework` to an iOS project.

```
github "yourUsername/yourlibrary"
```
#### Manually
1. Download and drop ```YourLibrary.swift``` in your project.  
2. Congratulations!  

## Usage example

```swift
import EZSwiftExtensions
ez.detectScreenShot { () -> () in
    print("User took a screen shot")
}
```

## Contribute

We would love you for the contribution to **YourLibraryName**, check the ``LICENSE`` file for more info.

