> 软件开发[最佳实践](https://12factor.net/config)规定了`配置与代码的严格分离`，如果你有其他后端开发经验如 Node.js 之类就会更理解这句话，但是在 iOS 开发中我们的各种环境变量以及关键的API_KEY 等基本都是硬编码在项目代码中的，并未遵循“最佳实践”。而`.xcconfig` 会帮助我们实现这一切。

- [简介](#%E7%AE%80%E4%BB%8B)
  - [xcconfig 可以帮我们做什么？](#xcconfig-%E5%8F%AF%E4%BB%A5%E5%B8%AE%E6%88%91%E4%BB%AC%E5%81%9A%E4%BB%80%E4%B9%88)
- [实践](#%E5%AE%9E%E8%B7%B5)
  - [添加一个(.xcconfig)文件](#%E6%B7%BB%E5%8A%A0%E4%B8%80%E4%B8%AAxcconfig%E6%96%87%E4%BB%B6)
  - [将 .xcconfig 映射到 build configuration](#%E5%B0%86-xcconfig-%E6%98%A0%E5%B0%84%E5%88%B0-build-configuration)
  - [在 .xcconfig 文件中配置 build setting](#%E5%9C%A8-xcconfig-%E6%96%87%E4%BB%B6%E4%B8%AD%E9%85%8D%E7%BD%AE-build-setting)
  - [在 .xcconfig 文件中配置不同环境的业务变量](#%E5%9C%A8-xcconfig-%E6%96%87%E4%BB%B6%E4%B8%AD%E9%85%8D%E7%BD%AE%E4%B8%8D%E5%90%8C%E7%8E%AF%E5%A2%83%E7%9A%84%E4%B8%9A%E5%8A%A1%E5%8F%98%E9%87%8F)
  - [在运行时获取 .xcconfig 文件中的配置](#%E5%9C%A8%E8%BF%90%E8%A1%8C%E6%97%B6%E8%8E%B7%E5%8F%96-xcconfig-%E6%96%87%E4%BB%B6%E4%B8%AD%E7%9A%84%E9%85%8D%E7%BD%AE)
  - [设置并检查 .xcconfig 是否生效](#%E8%AE%BE%E7%BD%AE%E5%B9%B6%E6%A3%80%E6%9F%A5-xcconfig-%E6%98%AF%E5%90%A6%E7%94%9F%E6%95%88)
    - [build setting 生效的继承关系](#build-setting-%E7%94%9F%E6%95%88%E7%9A%84%E7%BB%A7%E6%89%BF%E5%85%B3%E7%B3%BB)
    - [案例1： target 的 xcconfig 文件生效](#%E6%A1%88%E4%BE%8B1-target-%E7%9A%84-xcconfig-%E6%96%87%E4%BB%B6%E7%94%9F%E6%95%88)
    - [案例2： target 的 xcconfig 文件未生效](#%E6%A1%88%E4%BE%8B2-target-%E7%9A%84-xcconfig-%E6%96%87%E4%BB%B6%E6%9C%AA%E7%94%9F%E6%95%88)
    - [案例3：如何使 target 的 xcconfig 文件生效](#%E6%A1%88%E4%BE%8B3%E5%A6%82%E4%BD%95%E4%BD%BF-target-%E7%9A%84-xcconfig-%E6%96%87%E4%BB%B6%E7%94%9F%E6%95%88)
  - [在版本控制中忽略 .xcconfig，使配置信息保密](#%E5%9C%A8%E7%89%88%E6%9C%AC%E6%8E%A7%E5%88%B6%E4%B8%AD%E5%BF%BD%E7%95%A5-xcconfig%E4%BD%BF%E9%85%8D%E7%BD%AE%E4%BF%A1%E6%81%AF%E4%BF%9D%E5%AF%86)
  - [.xcconfig 的编写格式和规则](#xcconfig-%E7%9A%84%E7%BC%96%E5%86%99%E6%A0%BC%E5%BC%8F%E5%92%8C%E8%A7%84%E5%88%99)
- [结语](#%E7%BB%93%E8%AF%AD)
- [reference](#reference)

## 简介

软件开发的[最佳实践](https://12factor.net/config)规定了`配置与代码的严格分离`。 然而，iOS 平台上的开发人员一般很难在 Xcode 繁重的 Workflow 中应用这些最佳实践。

理解每个项目的设置以及它们如何相互作用是一项需要花费数年时间磨练的技能。 尤其是当这些信息都需要在 Xcode 的 GUI 界面配置的时候，对我们理解它远不如直接用配置文件来的直观。

当你打开 Xcode project 的 Build Settings tab 你会发现成百上千的配置，头都大了。

![](https://ipic-1257320768.cos.ap-chengdu.myqcloud.com/20190529135335.png)

幸好我们有 xcconfig 文件。

### xcconfig 可以帮我们做什么？
1. 将配置与代码的严格分离,遵循软件开发的最佳实践。
2. 自定义构建时配置，如应用名称和图标
3. 跨不同环境管理常量，如 BASE_URL ,消除 `“#if DEBUG”` 判断
4. 使关键的配置信息如 API_KEY 等脱离版本控制，项目更安全。

## 实践

### 添加一个(.xcconfig)文件
1. Select File > New File or (command + n)
2. Select Configuration Settings File
    ![](https://ipic-1257320768.cos.ap-chengdu.myqcloud.com/20190529144016.png)
3. Click Next.
4. Click Create.
    `不需要选中任何 Target。`，然后一个 xcconfig 文件就被添加到项目中了
    ![](https://ipic-1257320768.cos.ap-chengdu.myqcloud.com/20190529144127.png)

### 将 .xcconfig 映射到 build configuration
1. 在项目编辑器中选中 project.
2. 单击项目编辑器顶部的 info tab.
3. 在 Configurations 区域中，点击三角形展开一个 build configuration
4. 在展开的 projec 或者 target 中点击右侧上下三角
5. 在弹出的配置中为 projec 或者 target 选一个配置
    ![](https://ipic-1257320768.cos.ap-chengdu.myqcloud.com/20190529144557.png)
    
### 在 .xcconfig 文件中配置 build setting
在这里我们尝试使用 xcconfig 文件为每个配置分配一个不同的名称和应用程序图标，从而使事情变得更简单。

现在你不用关注语法，后面我会详细讲。
```c
// Development.xcconfig
PRODUCT_NAME = $(inherited) α
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon-Alpha

---

// Staging.xcconfig
PRODUCT_NAME = $(inherited) β
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon-Beta
```

另外你还可以通过打开  assistant editor， 直接拖拽 build setting 来设置

![](https://ipic-1257320768.cos.ap-chengdu.myqcloud.com/20190529145429.png)

### 在 .xcconfig 文件中配置不同环境的业务变量
如果你们的后端开发人员按照[12 Factor App](https://12factor.net/config)的理念进行工作，那么他们会有dev、test、pro 环境的配置。
在 iOS 上，我们是这么处理的：

```swift
import Foundation

#if DEBUG
let apiBaseURL = URL(string: "https://api.example.dev")!
let apiKey = "9e053b0285394378cf3259ed86cd7504"
#else
let apiBaseURL = URL(string: "https://api.example.com")!
let apiKey = "4571047960318d233d64028363dfa771"
#endif
```

这么做看起来没问题，但是与代码和配置分离的原则相冲突。

另一种方法是将这些特定于环境的值放置到它们所属的xcconfig 文件中。


```c
// Development.xcconfig
// 注:在 "//" 之间使用 "$()" 来转义,例如 https:/$()/
API_BASE_URL = @"https:/$()/www.qq.com"
API_KEY = @"devKey"

---

// Production.xcconfig
// 注:在 "//" 之间使用 "$()" 来转义,例如 https:/$()/
API_BASE_URL = @"https:/$()/www.v2ex.com"
API_KEY = @"proKey"

```
> 注：xcconfig 文件将序列 / / 视为注释分隔符，而不管它是否包含在引号中。
所以在 "//" 之间使用 "$$()" 来转义,例如 https:/$()/
> 注：根据 [POSIX 标准](http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap08.html#tag_08) 环境变量的名称只包含大写字母、数字和下划线()

### 在运行时获取 .xcconfig 文件中的配置
xcconfig 文件和环境变量定义的构建设置仅在构建时可用。 运行编译后的应用程序时，xcconfig 定义的变量都不可用。

这里有两种方法来访问 xcconfig 定义的变量：
1. 通过GCC_PREPROCESSOR_DEFINITIONS将配置文件中定义的常量定义成预编译宏，以便于在代码中获取
2. Info.plist 会根据构建设置生成，并会复制到包中，所以可以通过给Info.plist 添加key，复制编译时候的配置，然后在App 内访问 Info.plist 中的 key 值来获取。

在和朋友讨论后，我们倾向于GCC_PREPROCESSOR_DEFINIYIONS。因为info.plist的数据会被暴露，GCC_PREPROCESSOR_DEFINIYIONS只在编译前时可见。而xcconfig 的目的之一就是把重要的 key 移除版本控制，如果搞到  Info.plist 就白费了。

所以这里只说下通过GCC_PREPROCESSOR_DEFINITIONS的方法，至于通过 Info.plist 访问的方法你可以到[这里](https://nshipster.com/xcconfig/)查看

方法很简单，就是在控制文件中加入
```c
// 将配置文件中定义的常量定义成预编译宏，以便于在代码中获取
GCC_PREPROCESSOR_DEFINITIONS = $(inherited) API_BASE_URL='$(API_BASE_URL)' API_KEY='$(API_KEY)'
```

其中 GCC_PREPROCESSOR_DEFINITIONS, 文档如下：
> Space-separated list of option specifications. Specifies preprocessor macros in the form foo (for a simple #define) or foo=1 (for a value definition). This list is passed to the compiler through the gcc -D option when compiling precompiled headers and implementation files.

GCC_PREPROCESSOR_DEFINITIONS 是 GCC 预编译头参数，通常我们可以在 Project 文件下的 Build Settings 对预编译宏定义进行默认赋值。可以在 Build Settings 搜索 Preprocessor Macros 查看

![](https://ipic-1257320768.cos.ap-chengdu.myqcloud.com/20190529151521.png)
 
### 设置并检查 .xcconfig 是否生效
 这里会涉及到一点前置知识`build setting 生效的继承关系`

#### build setting 生效的继承关系

Xcode 按照以下顺序分配继承值(从最低到最高) :
* Platform Defaults
* xcconfig File for the Xcode Project
* Xcode Project File Build Settings
* xcconfig File for the Active Target
* Active Target Build Settings

当同一个键同时存在于 target-level、project-level 和配置文件中时，到底是哪一个键值对起作用了呢？举个例子说明：
#### 案例1： target 的 xcconfig 文件生效
当前我在项目中设置 product_name 的层级是 
* Project level 设置为 test
* Xcode Project 的 .xcconfig 文件设置为 dev.xcconfig
    dev.xcconfig 内容如下：
```c
PRODUCT_NAME = $(inherited) α
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon-Alpha
```
    
* 当前（DEBUG） Target 的 .xcconfig 文件设置为 dev.xcconfig
* Active Target Build Settings 中未设置

在当前target 点击 build setting tap 可以看到下图

![](https://ipic-1257320768.cos.ap-chengdu.myqcloud.com/20190529153250.png)

说明:
1. Xcode以从左至右的顺序设置解析的优先级，从左至右优先级降低，最左边的具有最高优先级,且`最左列 Resolved 列显示的是最终使用的值`。
2.  xcconfig 的配置文件列被标记为绿色。标记为绿色代表该列的值生效，其值应该与 Resolved 列的值相同。

#### 案例2： target 的 xcconfig 文件未生效

那么假如我在当前 Target Build Settings 中给 PRODUCT_NAME 设置值会发生什么？
![](https://ipic-1257320768.cos.ap-chengdu.myqcloud.com/20190529154847.png)
1. 最左列 Resolved 列显示的是当前 target 设置的值，target 的 xcconfig 未生效
2. 当前 target 被标记为绿色，target 的 xcconfig 未生效

这是由上文说的继承关系所决定的。

#### 案例3：如何使 target 的 xcconfig 文件生效

那么如何使 Xcode 使用配置文件中的配置项呢？这需要选中要使用配置文件的行，点击 Delete 按键，你会发现项目的默认设置已经被删除，且 target xcconfig 的配置文件列被标记为绿色， target xcconfig 的配置文件生效。

你可以设置不同的配置文件并在项目中验证
```objectivec
    // 验证 .xcconfig 是否生效
    NSLog(@"%@",API_BASE_URL);
```



### 在版本控制中忽略 .xcconfig，使配置信息保密
`Don’t commit secrets to source code. Instead, store them securely in a password manager or the like.`

为了防止机密泄露到 GitHub 上，请将以下代码添加到 .gitignore 文件:

```ruby
# .gitignore
Development.xcconfig
Staging.xcconfig
Production.xcconfig
```
放到安全的地方，需要时复制给对应人的即可。




### .xcconfig 的编写格式和规则
* 基本语法
* 保留已经存在的变量值
* 引用变量值
* 条件化配置的值（if/else）
* 引用其他的 .xcconfig 文件

以上编写格式和规则可到[Xcode Build Configuration Files Xcode](https://nshipster.com/xcconfig/)查看，写的很详细，限于篇幅和精力，不在展开。



## 结语
祝学习愉快～
[demo 地址](https://github.com/Allyess/xcconfigDemo)
## reference
* [Xcode Build Configuration Files Xcode](https://nshipster.com/xcconfig/)
* [Xcode使用xcconfig文件配置环境](http://liumh.com/2016/05/22/use-xcconfig-config-specific-variable/#inherits-build-setting)
* [Add a build configuration (xcconfig) file](https://help.apple.com/xcode/mac/10.2/#/deve97bde215)
* [xcconfig的使用与xcode环境变量](https://www.jianshu.com/p/aad1f9e72382)