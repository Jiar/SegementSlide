//
//  DataManager.swift
//  Example
//
//  Created by Jiar on 2018/12/13.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit

struct Language {
    let id: Int
    let title: String
    let icon: UIImage
    let summary: String
}

class DataManager {
    static let shared = DataManager()
    
    private let languages: [Language] = [
        Language(id: 1, title: "Swift", icon: UIImage(named: "Swift")!, summary: "Swift is a powerful and intuitive programming language for macOS, iOS, watchOS and tvOS. Writing Swift code is interactive and fun, the syntax is concise yet expressive, and Swift includes modern features developers love. Swift code is safe by design, yet also produces software that runs lightning-fast."),
        Language(id: 2, title: "Ruby", icon: UIImage(named: "Ruby")!, summary: "Ruby is a dynamic, open source programming language with a focus on simplicity and productivity. It has an elegant syntax that is natural to read and easy to write."),
        Language(id: 3, title: "Kotlin", icon: UIImage(named: "Kotlin")!, summary: "Kotlin is a statically typed programming language that runs on the Java virtual machine"),
        Language(id: 4, title: "Java", icon: UIImage(named: "Java")!, summary: "Java is a general-purpose computer-programming language that is concurrent, class-based, object-oriented, and specifically designed to have as few implementation dependencies as possible."),
        Language(id: 5, title: "Objective-C", icon: UIImage(named: "Objective-C")!, summary: "Objective-C is a general-purpose, object-oriented programming language that adds Smalltalk-style messaging to the C programming language."),
        Language(id: 6, title: "Go", icon: UIImage(named: "Go")!, summary: "Go (often referred to as Golang) is a programming language designed by Google engineers Robert Griesemer, Rob Pike, and Ken Thompson."),
        Language(id: 7, title: "JavaScript", icon: UIImage(named: "JavaScript")!, summary: "JavaScript often abbreviated as JS, is a high-level, interpreted programming language."),
        Language(id: 8, title: "Python", icon: UIImage(named: "Python")!, summary: "Python is an interpreted, high-level, general-purpose programming language."),
        Language(id: 9, title: "C", icon: UIImage(named: "C")!, summary: "C was created by Dennis Ritchie at Bell Labs in the early 1970s as an augmented version of Ken Thompson's B."),
        Language(id: 10, title: "C++", icon: UIImage(named: "C++")!, summary: "C++ is a general-purpose programming language. It has imperative, object-oriented and generic programming features, while also providing facilities for low-level memory manipulation."),
        Language(id: 11, title: "PHP", icon: UIImage(named: "PHP")!, summary: "PHP: Hypertext Preprocessor (or simply PHP) is a server-side scripting language designed for Web development, and also used as a general-purpose programming language.")
    ]
    
    var allLanguageTitles: [String] {
        return Array(languages.map({ $0.title }))
    }
    
    var homeLanguageTitles: [String] {
        return Array(allLanguageTitles[0..<4])
    }
    
    var exploreLanguageTitles: [String] {
        return allLanguageTitles
    }
    
    var interestLanguageTitles: [String] {
        return allLanguageTitles
    }
    
    var mineLanguageTitles: [String] {
        return Array(allLanguageTitles[0..<3])
    }
    
    var languageCenterTitles: [String] {
        return Array(allLanguageTitles[0..<3])
    }
    
    var noticeLanguageTitles: [String] {
        return Array(allLanguageTitles[0..<2])
    }
    
    var postLanguageTitles: [String] {
        return Array(allLanguageTitles[0..<3])
    }
    
    var allLanguages: [Language] {
        return languages
    }
    
    func language(by id: Int) -> Language? {
        return languages.first(where: { $0.id == id })
    }
    
    var randomLanguages: [Language] {
        return Array(languages.shuffled()[0..<10])
    }
    
}
