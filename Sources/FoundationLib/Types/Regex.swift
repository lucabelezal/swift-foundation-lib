//
//  Regex.swift
//
//
//  Created by lonnie on 2020/9/6.
//

import Foundation

public enum Regex: String, CaseIterable {
    
    case email = "([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})"
    
    case url = "(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?"
    
    case ip = "(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)"
    
    public func validate(text: String) -> Bool {
        let predicate =  NSPredicate(format: "SELF MATCHES %@" ,self.rawValue)
        return predicate.evaluate(with: text)
    }
    
    public func matches(text: String) throws -> [String] {
        let regex = try NSRegularExpression(pattern: rawValue, options:[NSRegularExpression.Options.caseInsensitive])
        let results = regex.matches(in: text.lowercased(), options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, text.count))
        var strings = [String]()
        let nsText = text as NSString
        for result in results {
            strings.append(nsText.substring(with: result.range))
        }
        return strings
    }
    
    static func scan(text: String) -> [Regex: [String]] {
        var dic = [Regex: [String]]()
        for item in allCases {
            do {
                let strings = try item.matches(text: text)
                if strings.count > 0 {
                    dic[item] = strings
                }
            } catch let error {
                print(error)
            }
        }
        return dic
    }
    
}