Abra
====

![image](http://guidesmedia.ign.com/guides/9846/images/abra.gif)

**Abra** is a **work in progress** framework. In the current version only the cache module is available. It will be released over **Cocoapods** at a later stage.

#Spec

**Overview**: **Abra** is a library that aim to simplify the backend/model layer of your application if you use a **RESTful** API. 
The end goal is that you should be able to have a working model layer mapped to your API without the need to write any line of code. The only things you'll need is to create your models and add your properties inside. Then you'll be able to do GET/POST/PUT/PATCH/DELETE against any of your model and it will return a correctly initialised instance. (It'll supports arrays of models + nested models) 

Abra is built over already existing libraries, it combine the power of **Mantle** (JSON automatic parsing and more) and **AFNetworking** (Network) and wrap them in something even simpler.

**Abra is a framework built around 3 modules**

##ABModel

ABModel is the Abra most important component. 
All your models that you want to map to some REST path/call should inherit of `ABModel`
As Abra is built around Mantle, it will support any feature you want from it. I invite you to have a look [here](https://github.com/github/Mantle).

`+ (NSDictionary *)JSONKeyPathsByPropertyKey`
Especially you should implement this method from Mantle if you JSON response have different properties name than your local models. 

ABModel will automatically generate the needed `NSValueTransformer` for your nested models at runtime. But you are in charge to implement your own value transformers if you need to do some operation in some of the values of your JSON response. (NSDate transformation, etc...)

##ABCache

ABCache is a singleton which Abra use for both in memory cache and disk cache. 
Models are cached on disk using `<NSCoder>` (which is automatically implemented by Mantle).
You don't need to use ABCache directly, it is used by ABAPI when you do a GET request.
ABCache allow Abra to return to you both the cached response (from the in memory store or disk) and then the new response from the API call. And then it'll automatically cache the new response.

You can look at the header for a more in depth look of the available methods. You can use it as a standalone module if you want. 

Each models that inherit ABModel will provide their GET/POST/PUT/PATCH/DELETE methods, with some variation if you want to do some custom parsing. 
The idea is that the only thing to do is to call this method

```objc
- (void)getForPath:(NSString *)path
        completion:(void(^)(BOOL success,         BOOL cached, instanceOrArrayOfInstance))completion;
```
A lot of variations of those methods will exist (With parameters, will multiple return block etc..).


###Transformations generated at runtime
#####NSURL
#####Nested model that inherit from ABModel

##ABAPI

**ABAPI** is a subclass of `AFHTTPSessionManager` and provide some useful and Abra specific helpers.
You don't need to use this class directly, the only required things to do is to call the `setupWithBaseURL:` method before attempting any model call.
This class is in charge of the API call/Cache mechanism and logic. ABModel use it extensively.