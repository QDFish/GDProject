# GDProject

[![CI Status](https://img.shields.io/travis/QDFish/GDProject.svg?style=flat)](https://travis-ci.org/QDFish/GDProject)
[![Version](https://img.shields.io/cocoapods/v/GDProject.svg?style=flat)](https://cocoapods.org/pods/GDProject)
[![License](https://img.shields.io/cocoapods/l/GDProject.svg?style=flat)](https://cocoapods.org/pods/GDProject)
[![Platform](https://img.shields.io/cocoapods/p/GDProject.svg?style=flat)](https://cocoapods.org/pods/GDProject)

## 快速开发常用三段式app的框架
三段式即UITabbarController + UINavigationController + （滑动菜单） + UIViewController的三段式，框架采用的是分类方式集成，采用组件化的形式，UIViewController集成网络请求组件，用户交互组件，根据对组件的继承，自定义不同app的网络请求全局设置，自定义交互的UI

1、UITabbarController集成了流行的中间自定义button的功能

2、UINavigationController集成了截屏式的导航功能，重写了所有pop，push方法

3、可快速应用的滑动菜单

4、快速开发tableView，collectionView相关的控制器，cell具有手动算高，定高，自动算高功能（FD），简化代理

## Requirements

## Installation

GDProject is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GDProject'
```

## Author

QDFish, qdfishyooooooh@gmail.com

## License

GDProject is available under the MIT license. See the LICENSE file for more info.
