# QRContactTracingCore

A generic framework to build secured QR code for contact tracing. (ie. to fight COVID-19)

**Disclamer: not production ready! Not validated by a security audit. Don't integrate it in a product. It's only a demonstration.**

## Installation

Simply add `https://github.com/florentmorin/QRContactTracingCore` to Swift Package via Xcode.

## Usage

This will describe a generic workflow.

### Your `Code` implementation

First, implement `Code` to describe the code your users will scan or will enter manually.

```swift

import QRContactTracingCore

struct MyCode: Code {

    enum Option: String, Hashable {
        case type
        case capacity
    }

    enum CodeType: String, Hashable {
       case person
       case house
       case enterprise
       case shop
    }
    
    let id: UUID
    let options: [Option: Any]

    var type: CodeType? {
        options[.type] as? CodeType
    }

    var capacity: Int? {
        options[.capacity] as? Int
    }
    
    init?(url: URL) {
        <# set `id` and `options` from url #>
    }
    
    init(id: UUID, options: [Option : Any] = [:]) {
        self.id = id
        self.options = options
    }
    
    func buildURL() -> URL? {
        <# build URL from `id` and `options` #>
    }
}

```

### Receive / Generate a code

Then, you can create a code from URL after a scan:

```swift
let code = MyCode(url: <# received URL #>)
```

Or you can create a code from raw data after a manual input:

```swift
let code = MyCode(id: <# UUID from text #>)
```

This can also be used to generate a code. The URL will be built with:

```swift
let code = MyCode(id: UUID())
let url = myCode.buildURL()
```

### Display code as Image

You can generate an image of your QR code for your favorite platform:

```swift

// Raw PNG data (to store in file)
let imageData = code.pngData()
let imageData = code.pngData(length: 200)

// SwiftUI Image (macOS, iOS, macOS Catalyst, tvOS)
let image = code.image()
let image = code.image(length: 200)

// UIImage (iOS, macOS Catalyst, tvOS)
let image = code.uiImage()
let image = code.uiImage(length: 200)

// NSImage (macOS)
let image = code.nsImage()
let image = code.nsImage(length: 200)

// CGImage (macOS, iOS, macOS Catalyst, tvOS)
let image = code.cgImage()
let image = code.cgImage(length: 200)

// CIImage (macOS, iOS, macOS Catalyst, tvOS)
let image = code.ciImage()
let image = code.ciImage(length: 200)

```

### Store a code locally

You can store a code with your preferred method: Core Data, Realm, JSON file, raw data.

You need to store 3 informations:

* Code identifier
* Date of scan / manual input
* A 128 bits key generated from code identifier and date _(called transportableKey)_

So, once you received the code, you need to generate local content like this:

```swift
let content = LocalContent(codeId: <# The ID from code #>, date: <# Date of scan #>)

// Then, you can use `content.codeId`, `content.date` and `content.transportableKey`

<# Store your data from content #>

```

### Export data from local storage

Your data are stored locally and you want to share them with other users.

First, rebuild your content:

```swift
let localContent = LocalContent((codeId: <# UUID #>, date: <# Date #>, transportableKey: <# Data #>)
```

Then, create transportable content with data required for diagnosis:

```swift
let transportableContent = TransportableContent(localContent: <# LocalContent #>, clearData: <# Data #>)
```

Now, you can export diagnosis data, now encrypted:

```swift
let key = transportableContent.key
let encryptedData = transportableContent.encryptedData

// Here, you can package key + encrypted data
```

### Retrieve local content from transportable content

Your users will receive key and, now or later, encrypted data.

How to find `LocalContent` from `TransportableContent`?

Simply search local content in your local storage with  `LocalContent.transportableKey` which is the same than `TransportableContent.key`.

You've got LocalContent with corresponding `transportableKey`? Retrieve all the encrypted data corresponding to this key.

Now, you can rebuild transportable data:

```swift
let content = TransportableContent(key: <# Data #>, encryptedData: <# Data #>)
```

### Decrypt diagnosis

It's so easy:

```swift
let localContent: LocalContent
let receivedContent: TransportableContent

let diagnosisData = receivedContent.decryptData(localContent: localContent)
```

## How it works

First, local content generate a local identifier using UUIDv4, which is a random 16 bytes content. Perfect 128-bits key. Stored locally, exclusively.

An other 128-bits key is generated using PBKDF2, which is slow to avoid brute-force attacks. This key is generated using  date as password and local identifier as salt. This new key is stored on every device scanning the QR code at the same date (not date and time, date only).

When user need to share its keys and diagnosis informations, these informations are encrypted using AES-128 algorithm with a PKCS7 padding. Local key is used as encryption key and transportable key as initialization vector.

If you scan a QR code for multiple times a day, you will have a 128 bits transportable key associated to multiple diagnosis informations. (date & time, sickness level)

So, encrypted data will be shared across network. Then distributed by a server. And received by every users devices.

Once receiving transportable content, device will first check the transportable key then download associated encrypted diagnosis information. With its local content, it will have a stored local key slowly generated by scan. The local key will be used to decrypt content.

## Privacy and security considerations

It seems to be OK for privacy and security because sensitive key is generated locally and don't move outside except if user want to share securely its diagnosis.

QR code can be generated locally, without internet connection.

Every information leaving the device is encrypted.

## How it can help to fight COVID-19?

A shop can have a QR code. An enterprise can also have a QR code. Or simply your house.

Everyone can have a QR code generated by device. You can scan QR code like checking your hands to say "hello!".

And it's also inclusive: a QR code can be printed for disabled or old persons. The 16 bytes code can be manually written on a paper or simply distributed as printed piece of paper when you enter in a shop.

Complementary diagnosis informations can be shared here.
