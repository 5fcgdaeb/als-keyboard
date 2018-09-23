# als-keyboard
A keyboard designed for ALS patients. The goal is to make ALS patients type with as little effort as possible. This implementation only makes use of the facial muscles to type letters and numbers.

![](https://media.giphy.com/media/dJWpSA29KSQfyP9RTC/giphy.gif)

A demo is available at: https://www.youtube.com/watch?v=t9lpnhLMFj4

# How to build

1) Clone the repository

```bash
$ git clone https://github.com/5fcgdaeb/als-keyboard.git
```

2) Install pods

```bash
$ cd als-keyboard
$ pod install
```

3) Open the workspace in Xcode

```bash
$ open "AlsKeyboard.xcworkspace"
```
 
4) Compile and run the unit tests (Command + U) on your simulator. Check that the tests are running fine!

5) Run the app on your physical device. Running it on iPhoneX is recommended since it uses ARKit 1.5 + TrueDepth camera.

# Requirements

* Xcode 10
* iOS 11.3+
* Swift 4.2
