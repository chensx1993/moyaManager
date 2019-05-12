# Moya的使用

## 关于Moya
[Moya](https://github.com/Moya/Moya)是对[Alamofire](https://github.com/Alamofire/Alamofire)的再次封装。

让我们用一张图来简单来对比一下直接用Alamofire和用moya的区别：


![Moya Overview](images/diagram.png)

## 有关Alamofire
为了对Moya有更好的了解。让我们先复习一下Alamofire的用法。

### Alamofire的用法
用法一:

``` Swift
let parameters: Parameters = [
	"foo": [1,2,3],
	"bar": [
	"baz": "qux"
]
Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters, encoding: JSONEncoding.default)
```

用法二：

``` Swift
Alamofire.request("https://httpbin.org/get")
.validate(statusCode: 200..<300)
.validate(contentType: ["application/json"])
.responseData { response in
	switch response.result {
	case .success:
		print("Validation Successful")
		case .failure(let error):
		print(error)
	}
}
```

Alamofire请求时输入各种请求的条件(url, parameters, header,validate etc)的时候略显累赘，如果我们要设置默认parameters，还有针对特定API做修改的时候，实现起来就会很费劲。

然后，就有了我们Moya。


## Moya的简单实用

### Moya的快速上手
Moya是通过`POP`(面向协议编程)来设计的一个网络抽象库。

moya简单使用的example:

``` Swift
public enum GitHub {
    case zen
    case userProfile(String)
    case userRepositories(String)
}

extension GitHub: TargetType {
	// 略过
}

let provider = MoyaProvider<GitHub>()
provider.request(.zen) { result in
    // `result` is either .success(response) or .failure(error)
}
```


#### 1. 创建一个Provider
provider是网络请求的提供者，你所有的网络请求都通过provider来调用。我们先创建一个provider。

provider最简单的创建方法:

``` Swift
// GitHub就是一个遵循TargetType协议的枚举(看上面例子)
let provider = MoyaProvider<GitHub>()

```

让我看看provider是什么：

``` Swift
open class MoyaProvider<Target: TargetType>: MoyaProviderType {
	//略过....
}
```

provider是一个遵循	`MoyaProviderType`协议的公开类，**他需要传入一个遵循`TargetType`协议的对象名，这是泛型的常规用法，大家可以自行Google一下**。

如果我们要创建provider，我们要看看他的构造方法:

``` Swift
/// Initializes a provider.
    public init(endpointClosure: @escaping EndpointClosure = MoyaProvider.defaultEndpointMapping,
                requestClosure: @escaping RequestClosure = MoyaProvider.defaultRequestMapping,
                stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
                callbackQueue: DispatchQueue? = nil,
                manager: Manager = MoyaProvider<Target>.defaultAlamofireManager(),
                plugins: [PluginType] = [],
                trackInflights: Bool = false) {

        self.endpointClosure = endpointClosure
        self.requestClosure = requestClosure
        self.stubClosure = stubClosure
        self.manager = manager
        self.plugins = plugins
        self.trackInflights = trackInflights
        self.callbackQueue = callbackQueue
    }
    
```

provider所有的属性都是有默认值，具体怎么用我们往后再详谈。**现在主要是传入一个遵`TargetType`协议的对象**。

#### 2. 创建一个遵循TargetType协议的enum

让我们看看`TargetType`协议有什么:

``` Swift
public protocol TargetType {

    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: Moya.Method { get }

    /// Provides stub data for use in testing.
    var sampleData: Data { get }

    /// The type of HTTP task to be performed.
    var task: Task { get }

    /// The type of validation to perform on the request. Default is `.none`.
    var validationType: ValidationType { get }

    /// The headers to be used in the request.
    var headers: [String: String]? { get }
}
```
具体的使用方法如下：

``` Swift
public enum GitHub {
    case zen
    case userProfile(String)
    case userRepositories(String)
}

extension GitHub: TargetType {
    public var baseURL: URL { return URL(string: "https://api.github.com")! }
    
    // 对应的不同API path
    public var path: String {
        switch self {
        case .zen:
            return "/zen"
        case .userProfile(let name):
            return "/users/\(name.urlEscaped)"
        case .userRepositories(let name):
            return "/users/\(name.urlEscaped)/repos"
        }
    }
    public var method: Moya.Method {
        return .get
    }
    
    // parameters，upload or download
    public var task: Task {
        switch self {
        case .userRepositories:
            return .requestParameters(parameters: ["sort": "pushed"], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    // 通过statuscode过滤返回内容
    public var validationType: ValidationType {
        switch self {
        case .zen:
            return .successCodes
        default:
            return .none
        }
    }
    
    // 多用于单元测试
    public var sampleData: Data {
        switch self {
        case .zen:
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        case .userProfile(let name):
            return "{\"login\": \"\(name)\", \"id\": 100}".data(using: String.Encoding.utf8)!
        case .userRepositories(let name):
            return "[{\"name\": \"\(name)\"}]".data(using: String.Encoding.utf8)!
        }
    }
    public var headers: [String: String]? {
        return nil
    }
}
```
TargetType的设计理念是，先创建一个enum，如`Github`，那代表是你的服务器，case1，case2，case3代表各个API，这样就能统一处理，还可以针对个别API做不同的处理。

创建了

### 3. response

## Moya的高级用法

## Moya result<value, error>
