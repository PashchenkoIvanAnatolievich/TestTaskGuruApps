# Тестове Завдання для Universe Group

Цей проєкт є реалізацією тестового завдання для iOS-розробника. Додаток являє собою онбординг-флоу, який динамічно отримує дані з API, та екран продажів з реалізацією підписок через StoreKit 2.

## 🚀 Основні Можливості

-   **Динамічний онбординг:** Екрани та варіанти відповідей завантажуються з мережі.
-   **Чиста архітектура MVVM-C:** Чітке розділення відповідальності між логікою, даними, відображенням та навігацією.
-   **Програмний UI:** Весь інтерфейс створений у коді без використання Storyboard або XIB файлів.
-   **Реактивний підхід:** Використання RxSwift та RxCocoa для зв'язування даних (Data Binding) та обробки подій.
-   **Адаптивна верстка:** UI адаптується під різні розміри екранів за допомогою SnapKit та кастомного `LayoutHelper`.
-   **Інтеграція підписок:** Реалізовано завантаження продуктів, здійснення покупки через **StoreKit 2** (`async/await`).
-   **Локальне тестування покупок:** Налаштовано `Products.storekit` файл для тестування In-App Purchases без реального App Store.

## 🏛️ Технології та Архітектура

Основою проєкту є архітектура **MVVM-C (Model-View-ViewModel-Coordinator)**.

-   **Model:** Прості `Codable` структури (`OnboardingScreen`), що описують дані, отримані з API.
-   **View:** "Дурні" `UIViewController`'и, відповідальні лише за відображення UI. Вся верстка реалізована програмно за допомогою **SnapKit**.
-   **ViewModel:** Мозок кожного екрану. Містить всю бізнес-логіку, обробляє дії користувача та надає готові для відображення дані для `View` через **RxSwift (`Driver`)**.
-   **Coordinator:** Керує всією навігацією в додатку. Створює та показує модулі (ViewModel + ViewController) та вирішує, куди переходити далі.

#### Стек:
-   **Мова:** Swift 5
-   **UI:** UIKit (програмний)
-   **Верстка:** SnapKit
-   **Реактивність:** RxSwift, RxCocoa
-   **Робота з покупками:** StoreKit 2
-   **Контроль версій:** Git (з використанням спрощеного Git Flow)

## ⚙️ Структура Проєкту

Проєкт організовано за функціональними модулями для кращої читабельності та підтримки.

```
.
├── TestTaskGuruApps/
│   ├── Application/      # AppDelegate, SceneDelegate, AppCoordinator (головний)
│   ├── Coordinators/     # Управління навігацією (OnboardingCoordinator, SalesCoordinator)
│   ├── Models/           # Структури даних (OnboardingModels.swift)
│   ├── Screens/          # Папки для кожного екрану (View + ViewModel)
│   │   ├── Onboarding/
│   │   └── Sales/
│   ├── Services/         # Сервісні шари (NetworkService, StoreManager)
│   └── Helpers/          # Допоміжні класи (LayoutHelper, UIColor+Extension)
└── Products.storekit     # Файл для локального тестування покупок
```

## 🛠️ Принцип Роботи

Додаток працює як скінченний автомат, керований Координаторами.

#### 1. Запуск Додатку
-   `SceneDelegate` створює головне вікно та запускає `AppCoordinator`.
-   `AppCoordinator` є головним диригентом. Він вирішує, який флоу показати першим, і запускає `OnboardingCoordinator`.

#### 2. Флоу Онбордингу
-   `OnboardingCoordinator` створює `OnboardingViewModel` та `OnboardingViewController`.
-   `OnboardingViewModel` через `NetworkService` асинхронно завантажує дані для сторінок онбордингу.
-   `OnboardingViewController` підписаний на потік даних від `ViewModel` через **RxSwift**. Отримавши дані, він створює необхідну кількість дочірніх `OnboardingPageViewController` та відображає їх у `UIPageViewController`.
-   Коли користувач обирає відповідь, `OnboardingPageViewController` через делегат повідомляє про це `OnboardingViewController`, а той — у `ViewModel`.
-   `ViewModel` оновлює свій стан. Це автоматично робить кнопку "Continue" активною (завдяки `Driver`'у `isContinueButtonEnabled`).
-   При натисканні на "Continue", `ViewModel` або перемикає індекс поточної сторінки, або, якщо це остання сторінка, викликає замикання `onboardingDidFinish`.

#### 3. Перехід на Екран Продажів
-   `OnboardingCoordinator` "слухає" сигнал `onboardingDidFinish` від `ViewModel`.
-   Отримавши сигнал, він повідомляє `AppCoordinator` про своє завершення через делегат.
-   `AppCoordinator` видаляє `OnboardingCoordinator` з пам'яті та запускає `SalesCoordinator`.

#### 4. Флоу Екрану Продажів
-   `SalesCoordinator` створює та показує `SalesViewController`.
-   У `viewDidLoad` `SalesViewController` показує індикатор завантаження та запускає асинхронну задачу для завантаження продуктів через `StoreManager.shared.fetchProducts()`.
-   `StoreManager` за допомогою **StoreKit 2** та `async/await` звертається до файлу `Products.storekit` та отримує інформацію про підписки.
-   Після успішного завантаження `SalesViewController` оновлює UI, показуючи назву та ціну підписки.
-   При натисканні на кнопку "Start Now", викликається метод `StoreManager.shared.purchase()`. Він показує системний екран покупки.
-   Після успішної покупки `SalesViewController` викликає замикання `onPurchaseSuccess`, яке обробляється `AppCoordinator`'ом для переходу на головний екран додатку.
-   Кнопка "Закрити" також повідомляє координатору про завершення флоу, що дозволяє перейти на головний екран без підписки.

## 🚀 Встановлення та Запуск

Для запуску проєкту на симуляторі або пристрої виконайте наступні кроки:

1.  **Клонуйте репозиторій:**
    ```bash
    git clone https://github.com/PashchenkoIvanAnatolievich/TestTaskGuruApps.git
    ```
2.  **Відкрийте проєкт** у Xcode, знайшовши файл `TestTaskGuruApps.xcodeproj`.

3.  **ВАЖЛИВО: Налаштування StoreKit для тестування:**
    Щоб покупки працювали в симуляторі, потрібно активувати локальний файл конфігурації:
    -   У Xcode вгорі натисніть на назву схеми (`TestTaskGuruApps`).
    -   Виберіть **Edit Scheme...**
    -   У вікні, що з'явилося, виберіть секцію **Run** (ліва панель).
    -   Перейдіть на вкладку **Options** (центральна частина).
    -   Знайдіть поле **StoreKit Configuration** та у випадаючому меню виберіть `Products.storekit`.
    -   Натисніть **Close**.

4.  **Запуск:**
    -   Виберіть симулятор та натисніть **Command + R** для компіляції та запуску проєкту.
