# Image Feed
Многостраничное приложение предназначено для просмотра изображений через API Unsplash.
Цели приложения:
* Просмотр бесконечной ленты картинок из Unsplash Editorial.
* Просмотр краткой информации из профиля пользователя.

<img src="https://github.com/prostokot14/ImageFeed/assets/86567361/c0b035d2-e57f-42c4-b063-9f2111538a84" width="250">
<img src="https://github.com/prostokot14/ImageFeed/assets/86567361/8d1c4944-f236-4a22-96b6-57792ff4e851" width="250">
<img src="https://github.com/prostokot14/ImageFeed/assets/86567361/5f592a0d-c800-4ef1-9a88-264d223634e5" width="250">
<img src="https://github.com/prostokot14/ImageFeed/assets/86567361/587ba369-b4c8-4e44-9469-0da65509212c" width="250">

## Краткое описание приложения
* В приложении обязательна авторизация через OAuth Unsplash.
* Главный экран состоит из ленты с изображениями. Пользователь может просматривать ее, добавлять и удалять изображения из избранного.
* Пользователи могут просматривать каждое изображение отдельно и делиться ссылкой на них за пределами приложения.
* У пользователя есть профиль с избранными изображениями и краткой информацией о пользователе.
* У приложения есть две версии: расширенная и базовая. В расширенной версии добавляется механика избранного и возможность лайкать фотографии при просмотре изображения на весь экран.
## Системный требования
* Swift 5.9
* iOS 13.0+
* [Kingfisher](https://github.com/onevcat/Kingfisher)
* [SwiftKeychainWrapper](https://github.com/jrendel/SwiftKeychainWrapper)
* [ProgressHUD](https://github.com/relatedcode/ProgressHUD)
* [Unsplash API](https://unsplash.com/documentation)
## Стек технологий
* MVP
* OAuth 2.0 Unsplash (авторизация пользователя)
* запросы HTTP (URLSession) и REST
* UITableView, TabBarController, NavigationController, WebViewController
* GCD
* DateFormatter
* UI-тесты и Unit-тесты
