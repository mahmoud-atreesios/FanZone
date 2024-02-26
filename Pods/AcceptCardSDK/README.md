# AcceptCardSDK

[![CI Status](https://img.shields.io/travis/mohamedghoneim/AcceptCardSDK.svg?style=flat)](https://travis-ci.org/mohamedghoneim/AcceptCardSDK)
[![Version](https://img.shields.io/cocoapods/v/AcceptCardSDK.svg?style=flat)](https://cocoapods.org/pods/AcceptCardSDK)
[![License](https://img.shields.io/cocoapods/l/AcceptCardSDK.svg?style=flat)](https://cocoapods.org/pods/AcceptCardSDK)
[![Platform](https://img.shields.io/cocoapods/p/AcceptCardSDK.svg?style=flat)](https://cocoapods.org/pods/AcceptCardSDK)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

AcceptCardSDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AcceptCardSDK'
```

If you are using intel mac, use the following instead

```ruby
pod 'AcceptCardSDK', '5.5.1'
```

And in the general settings of your project, under libraried and frameworks
change the library from "Do not embed" to "Embed and Sign"

## Usage

import the framework
```swift
import AcceptSDK
```

add the delegate to the class, and add the protocol stubs
```swift
class ViewController: UIViewController, AcceptSDKDelegate {
```

then create a constant
```swift
let accept = AcceptSDK()
```

then pass self to delegate
```swift
accept.delegate = self
```

then create the variables
```swift
// Replace this string with your payment key
let KEY: String = "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SjFjMlZ5WDJsa0lqb3pNU3dpYjNKa1pYSWlPbnNpWkdWc2FYWmxjbmxmYm1WbFpHVmtJanBtWVd4elpTd2lZVzF2ZFc1MFgyTmxiblJ6SWpveE1EQXNJbU4xY25KbGJtTjVJam9pUlVkUUlpd2lhWFJsYlhNaU9sdGRmU3dpWTNWeWNtVnVZM2tpT2lKRlIxQWlMQ0pwYm5SbFozSmhkR2x2Ymw5cFpDSTZOVGMyTWl3aWJHOWphMTl2Y21SbGNsOTNhR1Z1WDNCaGFXUWlPbVpoYkhObExDSndiV3RmYVhBaU9pSXhOVFl1TWpFMUxqRTNOeTR4TWpNaUxDSmlhV3hzYVc1blgyUmhkR0VpT25zaVptbHljM1JmYm1GdFpTSTZJa05zYVdabWIzSmtJaXdpYkdGemRGOXVZVzFsSWpvaVRtbGpiMnhoY3lJc0luTjBjbVZsZENJNklrVjBhR0Z1SUV4aGJtUWlMQ0ppZFdsc1pHbHVaeUk2SWpnd01qZ2lMQ0ptYkc5dmNpSTZJalF5SWl3aVlYQmhjblJ0Wlc1MElqb2lPREF6SWl3aVkybDBlU0k2SWtwaGMydHZiSE5yYVdKMWNtZG9JaXdpYzNSaGRHVWlPaUpWZEdGb0lpd2lZMjkxYm5SeWVTSTZJa05TSWl3aVpXMWhhV3dpT2lKamJHRjFaR1YwZEdVd09VQmxlR0V1WTI5dElpd2ljR2h2Ym1WZmJuVnRZbVZ5SWpvaUt6ZzJLRGdwT1RFek5USXhNRFE0TnlJc0luQnZjM1JoYkY5amIyUmxJam9pTURFNE9UZ2lMQ0psZUhSeVlWOWtaWE5qY21sd2RHbHZiaUk2SWs1QkluMHNJbUZ0YjNWdWRGOWpaVzUwY3lJNk1UQXdmUS5OVmFuOU5IUXM3NWowb2g4LTNaYkU0QkhLY05Jb0RkQmlJbGpiWUs3UUptMDZqN3VTX0dTVGpaeUtONElWem1JajktUEhFak5GdnluNEFhOUkzb1p5Zw=="
```
now call the function
```swift
do {
           try accept.presentPayVC(vC: self, paymentKey: KEY, saveCardDefault:
           true, showSaveCard: true, showAlerts: true)
       } catch AcceptSDKError.MissingArgumentError(let errorMessage) {
           print(errorMessage)
       }  catch let error {
           print(error.localizedDescription)
       }
```
and if you are using paymob pakistan, add the country parameter and set it to .Pakistan
```swift
do {
           try accept.presentPayVC(vC: self, paymentKey: KEY, country: .Pakistan, saveCardDefault:
           true, showSaveCard: true, showAlerts: true)
       } catch AcceptSDKError.MissingArgumentError(let errorMessage) {
           print(errorMessage)
       }  catch let error {
           print(error.localizedDescription)
       }
```

and if you already have a saved token
```swift
do {
try accept.presentPayVC(vC: self, paymentKey: KEY,  saveCardDefault: true,
showSaveCard: false, showAlerts: true, token: "123", maskedPanNumber: "xxxx-xxxx-xxxx-1234")
} catch AcceptSDKError.MissingArgumentError(let errorMessage) {
           print(errorMessage)
       }  catch let error {
           print(error.localizedDescription)
       }
```

what the parameters do
```swift
//Show the user whether or not he wants to save the card
showSaveCard: true
//Initially, the save card option is on or off
saveCardDefault: true
//either show the user some alerts on success / failure or not
showAlerts: true
```

you can change the language such as
```swift
//for english langauge
language: .English
//for arabic language
language: .Arabic

//used like this
try accept.presentPayVC(vC: self, paymentKey: KEY, country: .Egypt, saveCardDefault: true, showSaveCard: true, showAlerts: true, language: .English)
```

you can customize the UI of the SDK such as
```swift
// the extra UI Customization parameters are

//Shows or Hides the scan card button in the navigation bar
showScanCardButton


//changes the color of the main title
titleLabelTextColor

//changes the color of the pay button and the save card checkbox
buttonsColor

//changes the color of the background
backgroundColor

//changes the color of the navigation bar
navBarColor

//changes the color of the navigation bar texts
navBarTextColor

//changes the color of the backgrounds of all textfields
textFieldBackgroundColor

//changes the color of the texts of all textfields
textFieldTextColor

//changes the color of all the labels
inputLabelTextColor


//changes the text of the pay button
buttonText

//changes the text of the card name label
cardNameLabelText

//changes the text of the card number label
cardNumberLabelText

//changes the text of the card expiration label
expirationLabelText

//changes the text of the card cvv label
 cvvLabelText

//used like this
let accept = AcceptSDK()
accept.customization?.backgroundColor = UIColor.white

try accept.presentPayVC(vC: self, paymentKey: KEY, country: .Egypt, saveCardDefault: true, showSaveCard: true, showAlerts: true, language: .English)
```


## Author

mohamedghoneim, mohamedghoneim@weaccept.co

## License

AcceptCardSDK is available under the MIT license. See the LICENSE file for more info.
