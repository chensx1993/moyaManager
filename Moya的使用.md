# Moya的使用

## 关于Moya
[Moya](https://github.com/Moya/Moya)是对[Alamofire](https://github.com/Alamofire/Alamofire)的再次封装。

让我们用一张图来简单来对比一下直接用Alamofire和用moya的区别：


![Moya Overview](web/diagram.png)

## Moya的简单实用

为了对Moya有更好的了解。让我们先复习一下Alamofire的用法。

### Alamofire的用法
用法一:

``` Swift
   let parameters: Parameters = [
	    "foo": [1,2,3],
	    "bar": [
	        "baz": "qux"
	    ]
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

### Moya的快速上手
Moya是通过`POP`(面向协议编程)来设计的一个网络抽象库。

#### 创建一个Provider
 

- 创建enum
- 继承TargetType协议
- 新建一个Provider

### 高级用法
### Moya result<value, error>


# 利用Moya进行网络层封装
### enum取名规范：模块名 + API