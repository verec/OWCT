//
//  String.swift
//  __core_sources
//
//  Created by verec on 31/10/2015.
//  Copyright © 2015 Cantabilabs Ltd. All rights reserved.
//

import Foundation

extension String {

    func advance(root:String.Index, by:Int) -> String.Index {
        var count = by
        var index = root
        while count > 0 && index != self.endIndex {
            count -= 1
            index = index.successor()
        }
        return index
    }

    func range(from: Int, length: Int) -> Range<String.Index> {
        let beg     = self.startIndex
        let st      = self.advance(beg, by: from)
        let en      = self.advance(st, by: length)

        return st ..< en
    }
}


extension String {

    var NS:NSString {
        return self as NSString
    }
}

extension String {

    func padRight(toLength: Int) -> String {
        var s = self
        while s.characters.count < toLength {
            s = s + " "
        }
        return s
    }
}

extension String {

    func format0dot00() -> String {
        var s = self.NS

        if s.length > 4 {
            s = s.substringToIndex(4)
        }

        while s.length < 4 {
            s = s.stringByAppendingString("0")
        }
        return s as String
    }
}

extension String {

    var hasGremlins: Bool {
        get {
            struct Cache {
                static let alphabet = "abcdefghijklmnopqrstuvwxyz"
                static let letters = NSCharacterSet(charactersInString:alphabet)
//                static let letters = NSCharacterSet.letterCharacterSet()
            }
            for w in self.unicodeScalars {
                let c:unichar = unichar(w.value)
                if !Cache.letters.characterIsMember(c) {
                    return true
                }
            }
            return false
        }
    }

    var lowercase:String {
        get {
            var lower: String = ""
            for w in self.unicodeScalars {
                let c:unichar = unichar(w.value | 0x020)
                let k = Character(UnicodeScalar(c))
                let u:String = String(k)
                lower = lower + u
            }
            return lower
        }
    }

    var letters:String {
        get {
            let alpha = NSCharacterSet.lowercaseLetterCharacterSet()
            var ascii: String = ""
            for w in self.unicodeScalars {
                let c:unichar = unichar(w.value)
                if alpha.characterIsMember(c) {
                    let k = Character(UnicodeScalar(c))
                    let u:String = String(k)
                    ascii = ascii + u
                }
            }
            return ascii
        }
    }

    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}

extension String {
    var alphaRank: Int? {
        get {
            if let value = self.uppercaseString.utf8.first {
                return Int(value) - 0x041
            }
            return .None
        }
    }
}

extension String {

    func split(delimiter:String) -> [String] {
        let s = self.NS
        let a = s.componentsSeparatedByString(delimiter)
        return a as [String]
    }

    static func join(strings: [String], withSeparator sep: String = "") -> String {
        let s = (strings as NSArray).componentsJoinedByString(sep)
        return s as String
    }
}


