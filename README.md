<p align="center">
  <img src="https://github.com/Jiar/SegementSlide/blob/master/Images/Logo.png?raw=true">
</p>

<p align="center">
<a href="https://github.com/Jiar/SegementSlide"><img src="https://img.shields.io/badge/language-swift-orange.svg"></a>
<a href="https://travis-ci.org/Jiar/SegementSlide"><img src="https://img.shields.io/travis/Jiar/SegementSlide.svg?branch=master"></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"></a>
<a href="https://cocoapods.org/pods/SegementSlide"><img src="https://img.shields.io/cocoapods/v/SegementSlide.svg?style=flat"></a>
<a href="https://cocoapods.org/pods/SegementSlide"><img src="https://img.shields.io/cocoapods/p/SegementSlide.svg?style=flat"></a>
<a href="https://github.com/Jiar/SegementSlide/blob/master/LICENSE"><img src="https://img.shields.io/cocoapods/l/SegementSlide.svg?style=flat"></a>
<a href="https://codebeat.co/projects/github-com-jiar-segementslide-master"><img alt="codebeat badge" src="https://codebeat.co/badges/79bddc2a-a4d8-46b3-ba59-c4efaf0e2abc" /></a>
<a href="https://codecov.io/gh/Jiar/SegementSlide"><img src="https://codecov.io/gh/Jiar/SegementSlide/branch/master/graph/badge.svg" /></a>
<a href="https://twitter.com/JiarYoo"><img src="https://img.shields.io/badge/twitter-@JiarYoo-blue.svg"></a>
<a href="https://weibo.com/u/2268197591"><img src="https://img.shields.io/badge/weibo-@Jiar-red.svg"></a>
</p>

<p align="center">
Multi-tier UIScrollView nested scrolling solution.
</p>

## Snapshots

<p align="center">
<div style="display:flex">
  <img style="flex-grow:1" src="https://github.com/Jiar/ImageHosting/blob/master/Github/Repositories/SegementSlide/v2/Snapshots/childBouncesType.gif?raw=true" width="32%">
  <img style="flex-grow:1" src="https://github.com/Jiar/ImageHosting/blob/master/Github/Repositories/SegementSlide/v2/Snapshots/transparent1.gif?raw=true" width="33%">
  <img style="flex-grow:1" src="https://github.com/Jiar/ImageHosting/blob/master/Github/Repositories/SegementSlide/v2/Snapshots/inNavigationBar.gif?raw=true" width="32%">
</div>
</p>

<p align="center">
<div style="display:flex">
  <img style="flex-grow:1" src="https://github.com/Jiar/ImageHosting/blob/master/Github/Repositories/SegementSlide/v2/Snapshots/parentBouncesType.gif?raw=true" width="32%">
  <img style="flex-grow:1" src="https://github.com/Jiar/ImageHosting/blob/master/Github/Repositories/SegementSlide/v2/Snapshots/transparent2.gif?raw=true" width="33%">
  <img style="flex-grow:1" src="https://github.com/Jiar/ImageHosting/blob/master/Github/Repositories/SegementSlide/v2/Snapshots/parentBouncesType_segementSwitcherType.gif?raw=true" width="32%">
</div>
</p>

## Requirements

- iOS 9.0+
- Xcode 10.0+
- Swift 4.2+

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required to build SegementSlide.

To integrate SegementSlide into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'SegementSlide', '3.0.1'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](https://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate SegementSlide into your Xcode project using Carthage

1. specify it in your `Cartfile`:

```ogdl
github "Jiar/SegementSlide" "3.0.1"
```

Run `carthage update` to build the framework.

2. Copy Carthage Frameworks:
- open the `Build Phases` tab of the project Settings
- add `New Run Script Phase`
- add `/usr/local/bin/carthage copy-frameworks` to the input field
- add `$(SRCROOT)/Carthage/Build/iOS/SegementSlide.framework` to `Input Files`
![Copy Carthage Frameworks](https://github.com/Jiar/ImageHosting/blob/master/Github/Repositories/SegementSlide/v2/Snapshots/Copy%20Carthage%20Frameworks.png?raw=true)

3. Embedded Binaries:
- open the `general` tab of the project Settings
- add `SegementSlide.framework` in `$(SRCROOT)/Carthage/Build/iOS` to the `Embedded Binaries`
![Embed Binaries](https://github.com/Jiar/ImageHosting/blob/master/Github/Repositories/SegementSlide/v2/Snapshots/Embed%20Binaries.png?raw=true)

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate SegementSlide into your project manually.

---

## Usage

### Quick Start

```swift
import SegementSlide

class HomeViewController: SegementSlideDefaultViewController {

    ......
    
    override func segementSlideHeaderView() -> UIView? {
        let headerView = UIView()
        let headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.heightAnchor.constraint(equalToConstant: view.bounds.height/4).isActive = true
        return headerView
    }

    override var titlesInSwitcher: [String] {
        return ["Swift", "Ruby", "Kotlin"]
    }

    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        return ContentViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSelectedIndex = 0
        reloadData()
    }

}
```

```swift
import SegementSlide

class ContentViewController: UITableViewController, SegementSlideContentScrollViewDelegate {

    ......

    @objc var scrollView: UIScrollView {
        return tableView
    }

}
```

## Structure

<p align="center">
  <img src="https://github.com/Jiar/SegementSlide/blob/master/Images/Structure.png?raw=true">
</p>

## Author

- Twitter: ([@JiarYoo](https://twitter.com/JiarYoo))
- Weibo: ([@Jiar](https://weibo.com/u/2268197591))

## License

SegementSlide is released under the Apache-2.0 license. See LICENSE for details.
