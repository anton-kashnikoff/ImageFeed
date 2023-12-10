# Image Feed
Многостраничное приложение предназначено для просмотра изображений через API Unsplash.
Цели приложения:
* Просмотр бесконечной ленты картинок из Unsplash Editorial.
* Просмотр краткой информации из профиля пользователя.
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
