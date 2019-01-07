<p align="center">
  <img src="https://github.com/Jiar/SegementSlide/blob/master/Snapshots/SegementSlide.png?raw=true">
</p>
<p align="center">
Multi-tier UIScrollView nested scrolling solution.
</p>

## Snapshots

<p align="center">
<div style="display:flex">
  <img style="flex-grow:1" src="https://github.com/Jiar/SegementSlide/blob/master/Snapshots/childBouncesType.gif?raw=true" width="33%">
  <img style="flex-grow:1" src="https://github.com/Jiar/SegementSlide/blob/master/Snapshots/transparent1.gif?raw=true" width="33%">
  <img style="flex-grow:1" src="https://github.com/Jiar/SegementSlide/blob/master/Snapshots/childBouncesType_tabSwitcherType.gif?raw=true" width="33%">
</div>
</p>

<p align="center">
<div style="display:flex">
  <img style="flex-grow:1" src="https://github.com/Jiar/SegementSlide/blob/master/Snapshots/parentBouncesType.gif?raw=true" width="33%">
  <img style="flex-grow:1" src="https://github.com/Jiar/SegementSlide/blob/master/Snapshots/transparent2.gif?raw=true" width="33%">
  <img style="flex-grow:1" src="https://github.com/Jiar/SegementSlide/blob/master/Snapshots/parentBouncesType_segementSwitcherType.gif?raw=true" width="33%">
</div>
</p>

## Requirements

- iOS 9.0+
- Xcode 10.0+
- Swift 4.2+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

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
    pod 'SegementSlide'
end
```

Then, run the following command:

```bash
$ pod install
```

## Usage

### Quick Start

```swift
import SegementSlide

class HomeViewController: SegementSlideViewController {

    ......

    override func headerHeight() -> CGFloat {
        return view.bounds.height/4
    }
    
    override func headerView() -> UIView {
        return UIView()
    }

    override func titlesInSwitcher() -> [String] {
        return ["Swift", "Ruby", "Kotlin"]
    }

    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        return ContentViewController()
    }

}
```

```swift
import SegementSlide

class ContentViewController: UITableViewController, SegementSlideContentScrollViewDelegate {

    ......

    var scrollView: UIScrollView {
        return tableView
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentViewCell", for: indexPath) as! ContentViewCell
        cell.config(languages[indexPath.row])
        return cell
    }

}
```

## Author

- Twitter: ([@JiarYoo](https://twitter.com/JiarYoo))
- Weibo: ([@Jiar](https://weibo.com/u/2268197591))

## License

SegementSlide is released under the Apache-2.0 license. See LICENSE for details.