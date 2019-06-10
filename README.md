<!--# MoyaManager-->
<!---->
<!--[![CI Status](https://img.shields.io/travis/chensx/MoyaManager.svg?style=flat)](https://travis-ci.org/chensx/MoyaManager)-->
<!--[![Version](https://img.shields.io/cocoapods/v/MoyaManager.svg?style=flat)](https://cocoapods.org/pods/MoyaManager)-->
<!--[![License](https://img.shields.io/cocoapods/l/MoyaManager.svg?style=flat)](https://cocoapods.org/pods/MoyaManager)-->
<!--[![Platform](https://img.shields.io/cocoapods/p/MoyaManager.svg?style=flat)](https://cocoapods.org/pods/MoyaManager)-->
<!---->
<!--## Example-->
<!---->
<!--To run the example project, clone the repo, and run `pod install` from the Example directory first.-->
<!---->
<!--## Requirements-->
<!---->
<!--## Installation-->
<!---->
<!--MoyaManager is available through [CocoaPods](https://cocoapods.org). To install-->
<!--it, simply add the following line to your Podfile:-->
<!---->
<!--```ruby-->
<!--pod 'MoyaManager'-->
<!--```-->
<!---->
<!--## Author-->
<!---->
<!--chensx, 844711603@qq.com-->
<!---->
<!--## License-->
<!---->
<!--MoyaManager is available under the MIT license. See the LICENSE file for more info.-->


# 基于moya的二次封装的网络框架(swift)
> 对于一个项目来说，网络层设计一直至关重要，最近在做一个swift的新项目，认真构思了一个星期，琢磨了一套swift方面的网络框架。仅供大家参考。

## 为什么选择moya
moya是对Alamofire的再次封装。它可以实现各种自定义配置，真正实现了对网络层的高度抽象。

还有一个优秀的网络框架([github地址](https://github.com/mmoaay/Bamboots))，大家可以看看，跟`moya`对比一下。

有关moya的介绍可以看看: [Moya的使用](https://www.jianshu.com/p/2ee5258828ff)

框架GitHub地址：[GitHub地址](https://github.com/chensx1993/moyaManager)

## 网络层设计
现在我们默认大家都很熟练用`moya`了，我们想想一个网络层设计需要什么，怎么通过`moya`更好的实现。

* *server层* ：可动态修改的域名，timeout，自定义HTTP parameters，header
* *安全性* ：SSL
* *缓存* ：沿用`moya`
* *回调方法* ：沿用`moya`, `response`需要根据自己服务器返回格式做出修改
* *拦截器* ：直接使用`moya`

### server层
我们先建个`WebService`类, 我目的是用来动态修改，虽然不一定你一修改，就马上能够应用到Network，ㄟ( ▔, ▔ )ㄏ，可是我们要保留这个设计。

``` Swift
class WebService: NSObject {
    
    var rootUrl: String = "https://api.github.com"
    var manager: Alamofire.SessionManager = createManager()
    var headers: [String: String]? = defaultHeaders()
    var parameters: [String: Any]? = defaultParameters()
    var timeoutIntervalForRequest: Double = 20.0
    
    static let sharedInstance = WebService()
    private override init() {}
    
    static func defaultHeaders() -> [String : String]? {
        return ["deviceID" : "qwertyyu1234545",
                "Authorization": "tyirhjkkokjjjbggstvj"
        ]
    }
    
    static func defaultParameters() -> [String : Any]? {
        return ["platform" : "ios",
                "version" : "1.2.3",
        ]
    }
    
    // 自定义 session manager
    static func createManager() -> Alamofire.SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 20.0
        
        let manager = Alamofire.SessionManager(configuration: configuration)
        manager.startRequestsImmediately = false
        return manager
    }
    
}

```

### 自定义一个TargetType
自定义一个适合自己的`TargetType`，可以扩展其他的属性，同时设置一些默认值：

``` Swift
public protocol MyServerType: TargetType {
    var isShowLoading: Bool { get }
    var parameters: [String: Any]? { get }
    var stubBehavior: MyStubBehavior { get } //测试用的
    var sampleResponse: MySampleResponse { get } //测试用的
}

extension MyServerType {
    public var base: String { return WebService.shared.rootUrl }
    
    public var baseURL: URL { return URL(string: base)! }
    
    public var headers: [String : String]? { return WebService.shared.headers }
    
    public var parameters: [String: Any]? { return WebService.shared.parameters }
    
    public var isShowLoading: Bool { return false }
    
    public var task: Task {
        let encoding: ParameterEncoding
        switch self.method {
        case .post:
            encoding = JSONEncoding.default
        default:
            encoding = URLEncoding.default
        }
        if let requestParameters = parameters {
            return .requestParameters(parameters: requestParameters, encoding: encoding)
        }
        return .requestPlain
    }
    
    
    public var method: HTTPMethod {
        return .post
    }
    
    public var validationType: MyValidationType {
        return .successCodes
    }
    
    public var stubBehavior: StubBehavior {
        return .never
    }
    
    public var sampleData: Data {
        return "response: test data".data(using: String.Encoding.utf8)!
    }
    
    //可 mock 404，500 etc response
    public var sampleResponse: MySampleResponse {
        return .networkResponse(200, self.sampleData)
    }
}
```

### 设置一个通用的Provider
 新建一个网络管理的结构体，方便以后扩展:

``` Swift
public struct Networking<T: MyServerType> {
public let provider: MoyaProvider<T>

public init(provider: MoyaProvider<T> = newDefaultProvider()) {
self.provider = provider
}
}

```

 设置一个通用的Provider，可自定义多个属性。

* 自定义`endpointClosure`, 可额外添加`Request Header`, 修改`task`等

``` Swift
static func endpointsClosure<T>() -> (T) -> Endpoint where T: MyServerType {
        return { target in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            return defaultEndpoint;
        }
    }
```

* 自定义`requestClosure `，可对`request`进行进一步修改。

``` Swift
static func endpointResolver() -> MoyaProvider<T>.RequestClosure {
        return { (endpoint, closure) in
            do {
                var request = try endpoint.urlRequest()
                request.httpShouldHandleCookies = false
                closure(.success(request))
            } catch let error {
                closure(.failure(MoyaError.underlying(error, nil)))
            }
        }
    }
```

* 自定义`stubClosure `，可用来显示离线数据，模拟延迟测试，还有`Unit test`。

``` Swift
static func APIKeysBasedStubBehaviour<T>(_ target: T) -> Moya.StubBehavior where T: MyServerType {
        return target.stubBehavior;
    }
```
  
* 自定义`plugins`, 拦截器

``` Swift
static var plugins: [PluginType] {
        let activityPlugin = NewNetworkActivityPlugin { (state, targetType) in
            switch state {
            case .began:
                if targetType.isShowLoading { //这是我扩展的协议
                    // 显示loading
                }
            case .ended:
                if targetType.isShowLoading { //这是我扩展的协议
                    // 关闭loading
                }
            }
        }
        
        return [
            activityPlugin, myLoggorPlugin
        ]
    }
```

### 网络请求方法
网络请求方法，总有一些小伙伴难以接受`Moya`利用`enum`的用法,所以设计两种用法:

用法一：

``` Swift

/// 直接传参，进行网络请求
extension Network {
    @discardableResult
    public static func get(_ url: String,
                    parameters: [String : Any]? = nil,
                    headers: [String : String]? = nil,
                    callbackQueue: DispatchQueue? = DispatchQueue.main,
                    progress: ProgressBlock? = .none,
                    success: @escaping Success,
                    failure: @escaping Failure) -> Cancellable {
        
        let network = Networking<CommonAPI>()
        return network.request(.get(url, parameters: parameters, header: headers), callbackQueue: callbackQueue, progress: progress, success: success, failure: failure)
    }
    
    @discardableResult
    public static func post(_ url: String,
                     parameters: [String : Any]? = nil,
                     headers: [String : String]? = nil,
                     callbackQueue: DispatchQueue? = DispatchQueue.main,
                     progress: ProgressBlock? = .none,
                     success: @escaping Success,
                     failure: @escaping Failure) -> Cancellable {
        
        let network = Networking<CommonAPI>()
        return network.request(.post(url, parameters: parameters, header: headers), callbackQueue: callbackQueue, progress: progress, success: success, failure: failure)
    }
}
```

用法二：

``` Swift

/// Moya常规用法
    @discardableResult
    public func requestJson(_ target: T,
                            callbackQueue: DispatchQueue? = DispatchQueue.main,
                            progress: ProgressBlock? = .none,
                            success: @escaping JsonSuccess,
                            failure: @escaping Failure) -> Cancellable {
        return self.request(target, callbackQueue: callbackQueue, progress: progress, success: { (response) in
            do {
                let json = try handleResponse(response)
                success(json)
            }catch (let error) {
                failure(error as! NetworkError)
            }
        }) { (error) in
            failure(error)
        }
    }
    
    @discardableResult
    public func request(_ target: T,
                        callbackQueue: DispatchQueue? = DispatchQueue.main,
                        progress: ProgressBlock? = .none,
                        success: @escaping Success,
                        failure: @escaping Failure) -> Cancellable {
        return self.provider.request(target, callbackQueue: callbackQueue, progress: progress) { (result) in
            switch result {
            case let .success(response):
                success(response);
            case let .failure(error):
                failure(NetworkError.init(error: error));
                break
            }
        }
    }
```

#### 自定义网络层Error
最近项目需要，研究了一下`Moya.MoyaError`，发现`Moya`的`Error`处理有点混乱，没有`Alamofire`处理得优美，所以自己又重写了一遍。

``` Swift
public enum NetworkError: Swift.Error {
    
    /// Indicates a response failed to map to an image.
    case imageMapping(Response)
    
    /// Indicates a response failed to map to a JSON structure.
    case jsonMapping(Response)
    
    /// Indicates a response failed to map to a String.
    case stringMapping(Response)
    
    /// Indicates a response failed to map to a Decodable object.
    case objectMapping(Swift.Error, Response)
    
    /// Indicates that Encodable couldn't be encoded into Data
    case encodableMapping(Swift.Error)
    
    /// Indicates a response failed with an invalid HTTP status code.
    case statusCode(Response)
    
    /// fails to create a valid `URL`.
    case invalidURL
    
    /// when a parameter encoding object throws an error during the encoding process.
    case parameterEncodingFailed(Swift.Error)
    
    /// Indicates a response failed due to an underlying `Error`.
    case underlying(Swift.Error, Response?)
}
```

## 总结
该框架还没有进行大规模的应用，有什么错漏的地方，欢迎大家提出，大家有什么更好的设计，可以评论。
