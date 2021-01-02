# UnsplashSwiftUI

This SwiftUI package makes using the Unsplash API in an app simple and easy. 

Call the view and apply modifiers to it like you would with anyother view. The package will fetch the image metadata from the API and it will load the remote image, temporarily caching the image as well. The view also has a text in the botom left corner crediting the photographer as well as hotlinking to the image on Unsplash (A requirement while using the API). 

## Requirements:
The package is only compatible with iOS 14 and iPadOS 14 for now.

The package requires a Access Key (Client ID) for the Unsplash API. You can get one from the [Unsplash Developers](https://unsplash.com/developers) page. You'll need to register your app there and you will be Rate Limited (limited number of API requests per hour) until you apply for a high-volume application (refer to the [Unsplash Developers](https://unsplash.com/developers) page for more details)

Disclamer: I have not attempted applying for a high-volume application using this library as of yet. I believe that I have met all the requirements of the API and you should have no problem with it however I am not completely sure.

### Installation: 
In Xcode go to `File -> Swift Packages -> Add Package Dependency` and paste in the repo's url: `https://github.com/ArnavMotwani/UnsplashSwiftUI.git` then either select a version or the main branch (I will update the main branch more frequently with minor changes, while the version number will only increase with significant changes)

## Usage:
Import the package into the file with  `import UnsplashSwiftUI` then call the `UnsplashRandom` view wherever you want.

### Examples:

```swift
import SwiftUI
import UnsplashSwiftUI

struct UnsplashRandomTest: View {
    var body: some View {
        UnsplashRandom(clientId: "YOUR_ACCESS_KEY")
    }
}

struct UnsplashRandomTest_Previews: PreviewProvider {
    static var previews: some View {
        UnsplashRandomTest()
    }
}
```

```swift
import SwiftUI
import UnsplashSwiftUI

struct UnsplashRandomTest: View {
    var body: some View {
        UnsplashRandom(clientId: "YOUR_ACCESS_KEY")
        .padding(25)
    }
}

struct UnsplashRandomTest_Previews: PreviewProvider {
    static var previews: some View {
        UnsplashRandomTest()
    }
}
```

```swift
import SwiftUI
import UnsplashSwiftUI

struct UnsplashRandomTest: View {
    var body: some View {
        UnsplashRandom(clientId: "YOUR_ACCESS_KEY")
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct UnsplashRandomTest_Previews: PreviewProvider {
    static var previews: some View {
        UnsplashRandomTest()
    }
}
```
## Customizations:

| Parameter           | Optional? | Type         | Description                                                                            | Default         |
|---------------------|-----------|--------------|----------------------------------------------------------------------------------------|-----------------|
| clientId            | No        | String       | Client ID from the Unsplash Developer page                                             | -               |
| orientation         | Yes       | Orientations | Filter by photo orientation. (Valid values:   .landscape, .portrait, .squarish, .none) | -               |
| query               | Yes       | String       | Limit selection to photos matching a search term.                                      | -               |
| textColor           | Yes       | Color        | Color of the text hotlinked to image on Unsplash                                       | Color.white     |
| textBackgroundColor | Yes       | Color        | Color of text background (opacity set to 0.2 automatically)                            | Color.black     |
| aspectRatio         | Yes       | ContentMode  | Choose whether the image fits or fills the container                                   | ContentMode.fit |

### Examples: 

#### orientation
```swift
    UnsplashRandom(clientId: "YOUR_ACCESS_KEY", orientation: .landscape)
    
    UnsplashRandom(clientId: "YOUR_ACCESS_KEY", orientation: .portrait)
    
    UnsplashRandom(clientId: "YOUR_ACCESS_KEY", orientation: .squarish)
```

#### query

```swift
    UnsplashRandom(clientId: "YOUR_ACCESS_KEY", query: "trees")
    
    UnsplashRandom(clientId: "YOUR_ACCESS_KEY", query: "landscapes")
    
    UnsplashRandom(clientId: "YOUR_ACCESS_KEY", query: "space")
```

### textColor

```swift
    UnsplashRandom(clientId: "YOUR_ACCESS_KEY", textColor: .black)
    
    UnsplashRandom(clientId: "YOUR_ACCESS_KEY", textColor: .blue)
    
    UnsplashRandom(clientId: "YOUR_ACCESS_KEY", textColor: .primary)
```

### textBackgroundColor

```swift
    UnsplashRandom(clientId: "YOUR_ACCESS_KEY", textBackgroundColor: .white)
    
    UnsplashRandom(clientId: "YOUR_ACCESS_KEY", textBackgroundColor: .blue)
    
    UnsplashRandom(clientId: "YOUR_ACCESS_KEY", textBackgroundColor: .primary)
```

### aspectRatio

```swift
    UnsplashRandom(clientId: "YOUR_ACCESS_KEY", aspectRatio: .fit)
    
    UnsplashRandom(clientId: "YOUR_ACCESS_KEY", aspectRatio: .fill)
```
