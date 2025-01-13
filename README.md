В текущей конфигурации, для добавления еще одного сервиса в ServicesProvider нужно добавить два проперти:

```swift
    private var $cartService: some IServiceProvider<ICartService> { cartServiceWrapper.provider }
    
    private lazy var cartServiceWrapper = LazyServiceWrapper(
        serviceFactory: CartServiceFactory(
            profileServiceProvider: profileServiceWrapper.provider,
            productRepositoryProvider: productsRepositoryWrapper.provider
        )
    ).store(in: &disposeBag)

    var cartService: ICartService { cartServiceWrapper.service }
```

Тк в рамках этой архитектуры это общий паттерн для всех сервисов, то у меня была идея написать макрос для упрощения записи, который бы выглядел в коде как одна проперти:

```swift
    @ServiceDefinition(
        serviceFactory: CartServiceFactory(
            profileServiceProvider: $profileService,
            productRepositoryProvider: $productRepository
        ),
        cancellableStorage: ServicesProvider.disposeBag
    )
    var cartService: ICartService
```
и этот макрос должен был неявно разворачиваться в три проперти, как написано выше.

Я даже написал этот макрос, однако есть проблема - свифтовые макросы на данный момент не поддеживают генерацию lazy-пропертей. То есть, официальных ограничений в документации нет, однако при компиляции исходника с таким макросом крэшится компилятор с стек-трейсом и дампом. Я даже нашел обсуждение этого косяка на [swift.org](https://forums.swift.org/t/macros-with-lazy-var/69747) и пока что этот кейс не пофикшен. Теоретически, лейзи пропертю можно заменить на две: приватный опшионал для враппера, который будет синглтоном и создаваться при первом обращении, и  computed-property для доступа и первичного создания враппера. Ну, это если мы вдруг решим делать макрос.
