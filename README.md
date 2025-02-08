# Image Feed

A multi-page application designed for viewing images via the Unsplash API.

### Application Goals:
* View an infinite feed of images from Unsplash Editorial.
* View brief user profile information.

<img src="https://github.com/prostokot14/ImageFeed/assets/86567361/c0b035d2-e57f-42c4-b063-9f2111538a84" width="250">
<img src="https://github.com/prostokot14/ImageFeed/assets/86567361/8d1c4944-f236-4a22-96b6-57792ff4e851" width="250">
<img src="https://github.com/prostokot14/ImageFeed/assets/86567361/5f592a0d-c800-4ef1-9a88-264d223634e5" width="250">
<img src="https://github.com/prostokot14/ImageFeed/assets/86567361/587ba369-b4c8-4e44-9469-0da65509212c" width="250">

## Brief Application Description
* The application requires authorization via Unsplash OAuth.
* The main screen consists of an image feed. Users can browse, add, and remove images from favorites.
* Users can view each image separately and share links to them outside the application.
* Users have a profile with favorite images and brief user information.
* The application has two versions: basic and extended. The extended version includes the favorites feature and the ability to like photos when viewing an image in full-screen mode.

## System Requirements
* Swift 5.9
* iOS 13.0+
* [Kingfisher](https://github.com/onevcat/Kingfisher)
* [SwiftKeychainWrapper](https://github.com/jrendel/SwiftKeychainWrapper)
* [ProgressHUD](https://github.com/relatedcode/ProgressHUD)
* [Unsplash API](https://unsplash.com/documentation)

## Technology Stack
* MVP
* OAuth 2.0 Unsplash (user authorization)
* HTTP requests (URLSession) and REST
* UITableView, TabBarController, NavigationController, WebViewController
* GCD
* DateFormatter
* UI tests and Unit tests
