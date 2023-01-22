# RealtyFeedSDK-iOS

This is RealtyFeedSDK for iOS apps.

# Setup
## Step 1. Add RealtyFeedSDK to your project
There are two ways to add the RealtyFeedSDK into your project:
A) Add RealtyFeedSDK from the xcode package manager via its github URL
B) Download the RealtyFeedSDK latest release from Github and add it as local package 

## Step 2. Add the RealtyFeedSDK Initialization Code
Add the RealtyFeedSDK initialization code to didFinishLaunchingWithOptions.
Make sure to import the RealtyFeedSDK header:
```swift
import RealtyFeedSDK
```

```swift
RealtyFeedSDK.initial("YOUR-API-KEY")
```
YOUR-API-KEY with your RealtyFeedSDK API Key.

Now you can call RealtyFeedSDK APIs anywhere of your project,

## Get Listings list
```swift
    RealtyFeedSDK.API.instance.getListings(receiver: { data, error in
        guard let data = data, let res = String(data: data, encoding: String.Encoding.utf8) else {
            print("Failed to load listings!")
            return
        }
        print("Done! \(res)"
    })
```

## Get Property detail
```swift
    RealtyFeedSDK.API.instance.getProperty("P_5dba1fb94aa4055b9f29691f",receiver: { data, error in
        guard let data = data, let res = String(data: data, encoding: String.Encoding.utf8) else {
            print("Failed to load property!")
            return
        }
        print("Done! \(res)"
    })
```

