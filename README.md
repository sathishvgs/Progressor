# Progressor

[![CI Status](https://img.shields.io/travis/sathishvgs/Progressor.svg?style=flat)](https://travis-ci.org/sathishvgs/Progressor)
[![Version](https://img.shields.io/cocoapods/v/Progressor.svg?style=flat)](https://cocoapods.org/pods/Progressor)
[![License](https://img.shields.io/cocoapods/l/Progressor.svg?style=flat)](https://cocoapods.org/pods/Progressor)
[![Platform](https://img.shields.io/cocoapods/p/Progressor.svg?style=flat)](https://cocoapods.org/pods/Progressor)

## Requirments

- Swift 4 or greater
- Deployment Target = iOS 9.0 
- Supports iPhone and iPad

## Installation

Progressor is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Progressor'
```

## ChangeLogs
For ChangeLogs, Please visit [Releases](https://github.com/sathishvgs/Progressor/releases)

## About Pod
Progressor is the fully customized native Progress Bar. The use case of the pod is which will do the percentage and time left calculations by own. Just you have to update the progress value from 0.0 to 1.0. Also, we have opened the UI related things to make more customize.

## How to Use?

### setup Instance
You can easily start consuming the Progressor by creating the instance.

- Create the instance for ProgressView with the appropriate frame size.

  We are proposing this frame size to get better user interactive
  ```
        let x = (self.view.frame.width / 2) - (300 / 2)
        let y = (self.view.frame.height / 2) - (100 / 2)
        let frame = CGRect(x: x, y: y, width: 300, height: 120)
  ```
  ```
        let progressView = ProgressorView(frame: frame)
  ```
- Update the contents

- Set the delegate and conform the protocol to get the callbacks

## View Structure


       -----------------------------------------------
       -                                             -
       -                                             -
       -                                             -
       -                                             -
       -                                             -
       -                                             -
       -                                             -
       -                                             -
       -                                             -
       -----------------------------------------------


## Author

sathishvgs, vgsathish1995@gmail.com

## License

Progressor is available under the MIT license. See the LICENSE file for more info.
