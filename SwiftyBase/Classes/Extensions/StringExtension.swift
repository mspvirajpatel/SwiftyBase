//
//  StringExtension.swift
//  Pods
//
//  Created by MacMini-2 on 30/08/17.
//
//

import Foundation
import UIKit

// MARK: - String Extension -

/**
 *  x || X -> Any character
 *  c || C -> Alphabetic character
 *  n || N -> Numerical character
 */

public extension String {
    
    subscript(i: Int) -> String { String(self[index(startIndex, offsetBy: i)]) }
    
//    subscript (i: Int) -> String {
//        return self[Range(i ..< i + 1)]
//    }
    
    subscript(r: Range<Int>) -> String {
        let startIndex = index(self.startIndex, offsetBy: r.lowerBound)
        return String(self[startIndex..<index(startIndex, offsetBy: r.count)])
    }
    
//    subscript (r: Range<Int>) -> String {
//        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
//                                            upper: min(count, max(0, r.upperBound))))
//        let start = index(startIndex, offsetBy: range.lowerBound)
//        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
//        return String(self[Range(start ..< end)])
//    }
}
public extension String {
    
    fileprivate static let ANYONE_CHAR_UPPER = "X"
    fileprivate static let ONLY_CHAR_UPPER = "C"
    fileprivate static let ONLY_NUMBER_UPPER = "N"
    fileprivate static let ANYONE_CHAR = "x"
    fileprivate static let ONLY_CHAR = "c"
    fileprivate static let ONLY_NUMBER = "n"
    
    func format(_ format: String, oldString: String) -> String {
        let stringUnformated = self.unformat(format, oldString: oldString)
        var newString = String()
        var counter = 0
        if stringUnformated.count == counter {
            return newString
        }
        for i in 0..<format.count {
            var stringToAdd = ""
            let unicharFormatString = format[i]
            let charFormatString = unicharFormatString
            let charFormatStringUpper = unicharFormatString.uppercased()
            let unicharString = stringUnformated[counter]
            let charString = unicharString
            let charStringUpper = unicharString.uppercased()
            if charFormatString == String.ANYONE_CHAR {
                stringToAdd = charString
                counter += 1
            } else if charFormatString == String.ANYONE_CHAR_UPPER {
                stringToAdd = charStringUpper
                counter += 1
            } else if charFormatString == String.ONLY_CHAR_UPPER {
                counter += 1
                if charStringUpper.isChar() {
                    stringToAdd = charStringUpper
                }
            } else if charFormatString == String.ONLY_CHAR {
                counter += 1
                if charString.isChar() {
                    stringToAdd = charString
                }
            } else if charFormatStringUpper == String.ONLY_NUMBER_UPPER {
                counter += 1
                if charString.isNumber() {
                    stringToAdd = charString
                }
            } else {
                stringToAdd = charFormatString
            }
            
            newString += stringToAdd
            if counter == stringUnformated.count {
                if i == format.count - 2 {
                    let lastUnicharFormatString = format[i + 1]
                    let lastCharFormatStringUpper = lastUnicharFormatString.uppercased()
                    let lasrCharControl = (!(lastCharFormatStringUpper == String.ONLY_CHAR_UPPER) &&
                        !(lastCharFormatStringUpper == String.ONLY_NUMBER_UPPER) &&
                        !(lastCharFormatStringUpper == String.ANYONE_CHAR_UPPER))
                    if lasrCharControl {
                        newString += lastUnicharFormatString
                    }
                }
                break
            }
        }
        return newString
    }
    
    func unformat(_ format: String, oldString: String) -> String {
        var string: String = self
        var undefineChars = [String]()
        for i in 0..<format.count {
            let unicharFormatString = format[i]
            let charFormatString = unicharFormatString
            let charFormatStringUpper = unicharFormatString.uppercased()
            if !(charFormatStringUpper == String.ANYONE_CHAR_UPPER) &&
                !(charFormatStringUpper == String.ONLY_CHAR_UPPER) &&
                !(charFormatStringUpper == String.ONLY_NUMBER_UPPER) {
                var control = false
                for i in 0..<undefineChars.count {
                    if undefineChars[i] == charFormatString {
                        control = true
                    }
                }
                if !control {
                    undefineChars.append(charFormatString)
                }
            }
        }
        if oldString.count - 1 == string.count {
            var changeCharIndex = 0
            for i in 0..<string.count {
                let unicharString = string[i]
                let charString = unicharString
                let unicharString2 = oldString[i]
                let charString2 = unicharString2
                if charString != charString2 {
                    changeCharIndex = i
                    break
                }
            }
            let changedUnicharString = oldString[changeCharIndex]
            let changedCharString = changedUnicharString
            var control = false
            for i in 0..<undefineChars.count {
                if changedCharString == undefineChars[i] {
                    control = true
                    break
                }
            }
            if control {
                var i = changeCharIndex - 1
                while i >= 0 {
                    let findUnicharString = oldString[i]
                    let findCharString = findUnicharString
                    var control2 = false
                    for j in 0..<undefineChars.count {
                        if findCharString == undefineChars[j] {
                            control2 = true
                            break
                        }
                    }
                    if !control2 {
                        string = (oldString as NSString).replacingCharacters(in: NSRange(location: i, length: 1), with: "")
                        break
                    }
                    i -= 1
                }
            }
        }
        for i in 0..<undefineChars.count {
            string = string.replacingOccurrences(of: undefineChars[i], with: "")
        }
        return string
    }
    
    func isChar() -> Bool {
        return regexControlString(pattern: "[a-zA-ZğüşöçıİĞÜŞÖÇ]")
    }
    
    func isNumber() -> Bool {
        return regexControlString(pattern: "^[0-9]*$")
    }
    
    func regexControlString(pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let numberOfMatches = regex.numberOfMatches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            return numberOfMatches == self.count
        } catch {
            return false
        }
    }
}


public extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(fromValue: Int) -> String {
        let start = index(startIndex, offsetBy: fromValue)
        return String(self[start ..< endIndex])
    }
    
    func substring(toValue: Int) -> String {
        let start = index(startIndex, offsetBy: toValue)
        return String(self[start ... endIndex])
    }
    
//    subscript (i: Int) -> String {
//        return self[Range(i ..< i + 1)]
//    }
//
//    subscript (r: Range<Int>) -> String {
//        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
//                                            upper: min(count, max(0, r.upperBound))))
//        let start = index(startIndex, offsetBy: range.lowerBound)
//        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
//        return String(self[Range(start ..< end)])
//    }
    
    func substring(withValue r: Range<Int>) -> String {
        return String(self[r])
        
    }
    
    func stringHeightWithFontSize(_ fontSize: CGFloat,width: CGFloat) -> CGFloat {
        let font = UIFont(name: UIView.toastFontName(), size: BaseToastFontSize)
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributes = [NSAttributedString.Key.font:font!,
                          NSAttributedString.Key.paragraphStyle:paragraphStyle.copy()]
        
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
    }
    
    func withoutWhitespace() -> String {
        return self.replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "\0", with: "")
    }
    
    func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }
    
    var isEven:Bool     {return (self.toInt()! % 2 == 0)}
    var isOdd:Bool      {return (self.toInt()! % 2 != 0)}
    
    func localize(comment: String?) -> String {
        if comment != nil
        {
            return NSLocalizedString(self, comment: comment!)
        }
        else
        {
            return NSLocalizedString(self, comment: "")
        }
    }
    
    func localize() -> String {
        
        return NSLocalizedString(self, comment: "")
        
    }
  
    var urlEncoded: String {
        var allowed: CharacterSet = .urlQueryAllowed
        allowed.remove(charactersIn: "\n:#/?@!$&'()*+,;=")
        
        return self.addingPercentEncoding(withAllowedCharacters: allowed) ?? self
    }
    
    var queryParameters: [String: String] {
        var parameters = [String: String]()
        
        let scanner = Scanner(string: self)
        
        var key: NSString?
        var value: NSString?
        
        while !scanner.isAtEnd {
            key = nil
            scanner.scanUpTo("=", into: &key)
            scanner.scanUpTo("=", into: nil)
            
            value = nil
            scanner.scanUpTo("&", into: &value)
            scanner.scanUpTo("&", into: nil)
            
            if let key = key as String?, let value = value as String? {
                parameters.updateValue(value, forKey: key)
            }
        }
        
        return parameters
    }
    
    /**
     * Replace substring with template.
     * Usages:
     "abc123".subReplace("abc", "ABC")               //ABC123
     "abc123".subReplace("([a-z]+)(\\d+)", "$2$1")   //"123abc"
     */
    @discardableResult func subReplace(_ pattern: String, _ template: String) -> String {
        let options = NSRegularExpression.Options(rawValue: 0)
        
        if let exp = try? NSRegularExpression(pattern: pattern, options: options) {
            let options = NSRegularExpression.MatchingOptions(rawValue: 0)
            
            return exp.stringByReplacingMatches(in: self,
                                                options: options,
                                                range: NSMakeRange(0, self.count),
                                                withTemplate: template)
        }
        
        return ""
    }
    
    // MARK: - Variables -
    
    var first: String {
        return String(prefix(1))
    }
    var lowerFirst: String {
        return first.lowercased() + String(dropFirst())
    }
    
    
    /// Return the float value
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    
    var parseJSONString: AnyObject?
    {
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        if let jsonData = data
        {
            // Will return an object or nil if JSON decoding fails
            do
            {
                let message = try JSONSerialization.jsonObject(with: jsonData, options:.mutableContainers)
                if let jsonResult = message as? NSMutableArray {
                    return jsonResult //Will return the json array output
                } else if let jsonResult = message as? NSMutableDictionary {
                    return jsonResult //Will return the json dictionary output
                } else {
                    return nil
                }
            }
            catch let error as NSError
            {
                print("An error occurred: \(error)")
                return nil
            }
        }
        else
        {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
    
    /**
     Returns if self is a valid UUID or not
     
     - returns: Returns if self is a valid UUID or not
     */
    func isUUID() -> Bool {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", options: .caseInsensitive)
            let matches: Int = regex.numberOfMatches(in: self as String, options: .reportCompletion, range: NSMakeRange(0, self.lengthOfString))
            return matches == 1
        } catch {
            return false
        }
    }
    
    func convertToAPNSUUID() -> NSString {
        
        return self.trimmingCharacters(in: NSCharacterSet(charactersIn: "<>") as CharacterSet).replacingOccurrences(of: "", with: "").replacingOccurrences(of:"-", with: "") as NSString
    }
    
    
    /**
     Returns if self is a valid UUID for APNS (Apple Push Notification System) or not
     
     - returns: Returns if self is a valid UUID for APNS (Apple Push Notification System) or not
     */
    func isUUIDForAPNS() -> Bool {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: "^[0-9a-f]{32}$", options: .caseInsensitive)
            
            let matches: Int = regex.numberOfMatches(in: self as String, options: .reportCompletion, range: NSMakeRange(0, self.lengthOfString))
            return matches == 1
        } catch {
            return false
        }
    }
    
    
    /**
     Used to create an UUID as String
     
     - returns: Returns the created UUID string
     */
    static func generateUUID() -> String {
        let theUUID: CFUUID? = CFUUIDCreate(kCFAllocatorDefault)
        let string: CFString? = CFUUIDCreateString(kCFAllocatorDefault, theUUID)
        return string! as String
    }
    
    //MARK: Helper methods
    
    /**
     Returns the length of the string.
     
     - returns: Int length of the string.
     */
    
    
    var objcLength: Int {
        return self.utf16.count
    }
    
    //MARK: - Linguistics
    
    /**
     Returns the langauge of a String
     
     NOTE: String has to be at least 4 characters, otherwise the method will return nil.
     
     - returns: String! Returns a string representing the langague of the string (e.g. en, fr, or und for undefined).
     */
    func detectLanguage() -> String? {
        if self.lengthOfString > 4 {
            let tagger = NSLinguisticTagger(tagSchemes:[NSLinguisticTagScheme.language], options: 0)
            tagger.string = self
            return tagger.tag(at: 0, scheme: NSLinguisticTagScheme.language, tokenRange: nil, sentenceRange: nil).map { $0.rawValue }
        }
        return nil
    }
    
    /**
     Returns the script of a String
     
     - returns: String! returns a string representing the script of the String (e.g. Latn, Hans).
     */
    func detectScript() -> String? {
        if self.lengthOfString > 1 {
            let tagger = NSLinguisticTagger(tagSchemes:[NSLinguisticTagScheme.script], options: 0)
            tagger.string = self
            return tagger.tag(at: 0, scheme: NSLinguisticTagScheme.script, tokenRange: nil, sentenceRange: nil).map { $0.rawValue }
        }
        return nil
    }
    
    /**
     Check the text direction of a given String.
     
     NOTE: String has to be at least 4 characters, otherwise the method will return false.
     
     - returns: Bool The Bool will return true if the string was writting in a right to left langague (e.g. Arabic, Hebrew)
     
     */
    var isRightToLeft : Bool {
        let language = self.detectLanguage()
        return (language == "ar" || language == "he")
    }
    
    
    //MARK: - Usablity & Social
    
    
    /**
     Check that a String is 'tweetable' can be used in a tweet.
     
     - returns: Bool
     */
    func isTweetable() -> Bool {
        let tweetLength = 140,
        // Each link takes 23 characters in a tweet (assuming all links are https).
        linksLength = self.getLinks().count * 23,
        remaining = tweetLength - linksLength
        
        if linksLength != 0 {
            return remaining < 0
        } else {
            return !(self.utf16.count > tweetLength || self.utf16.count == 0 )
        }
    }
    
    /**
     Gets an array of Strings for all links found in a String
     
     - returns: [String]
     */
    func getLinks() -> [String] {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        let links = detector?.matches(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, lengthOfString)).map {$0 }
        
        return links!.filter { link in
            return link.url != nil
            }.map { link -> String in
                return link.url!.absoluteString
        }
    }
    
    /**
     Gets an array of URLs for all links found in a String
     
     - returns: [NSURL]
     */
    //    func getURLs() -> [NSURL] {
    //        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
    //
    //        let links = detector?.matches(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, length)).map {$0 }
    //
    //        return links!.filter { link in
    //            return link.url != nil
    //            }.map { link -> NSURL in
    //                return link.url!
    //        }
    //    }
    //
    //
    /**
     Gets an array of dates for all dates found in a String
     
     - returns: [NSDate]
     */
    //    func getDates() -> [NSDate] {
    //        var error: NSError = NSError()
    //        let detector: NSDataDetector?
    //        do {
    //            detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
    //        } catch let error1 as NSError {
    //            error = error1
    //            detector = nil
    //        }
    //        let dates = detector?.matches(in: self, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: NSMakeRange(0, self.utf16.count)) .map {$0 }
    //
    //        return dates!.filter { date in
    //            return date.date != nil
    //            }.map { link -> NSDate in
    //                return link.date!
    //        }
    //    }
    
    /**
     Gets an array of strings (hashtags #acme) for all links found in a String
     
     - returns: [String]
     */
    func getHashtags() -> [String]? {
        let hashtagDetector = try? NSRegularExpression(pattern: "#(\\w+)", options: NSRegularExpression.Options.caseInsensitive)
        let results = hashtagDetector?.matches(in: self, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, self.utf16.count)).map { $0 }
        
        return results?.map({
            (self as NSString).substring(with: $0.range(at: 1))
        })
    }
    
    /**
     Gets an array of distinct strings (hashtags #acme) for all hashtags found in a String
     
     - returns: [String]
     */
    func getUniqueHashtags() -> [String]? {
        return Array(Set(getHashtags()!))
    }
    
    
    
    /**
     Gets an array of strings (mentions @apple) for all mentions found in a String
     
     - returns: [String]
     */
    func getMentions() -> [String]? {
        let hashtagDetector = try? NSRegularExpression(pattern: "@(\\w+)", options: NSRegularExpression.Options.caseInsensitive)
        let results = hashtagDetector?.matches(in: self, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, self.utf16.count)).map { $0 }
        
        return results?.map({
            (self as NSString).substring(with: $0.range(at: 1))
        })
    }
    
    /**
     Check if a String contains a Date in it.
     
     - returns: Bool with true value if it does
     */
    func getUniqueMentions() -> [String]? {
        return Array(Set(getMentions()!))
    }
    
    
    /**
     Check if a String contains a link in it.
     
     - returns: Bool with true value if it does
     */
    func containsLink() -> Bool {
        return self.getLinks().count > 0
    }
    
    /**
     Check if a String contains a date in it.
     
     - returns: Bool with true value if it does
     */
    //    func containsDate() -> Bool {
    //        return self.getDates().count > 0
    //    }
    
    /**
     - returns: Base64 encoded string
     */
    func encodeToBase64Encoding() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
        
    }
    /**
     Encode the given string to Base64
     
     - parameter string: String to encode
     
     - returns: Returns the encoded string
     */
    static func encodeToBase64(string: String) -> String {
        let data: NSData = string.data(using: String.Encoding.utf8)! as NSData
        return data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
    
    /**
     Decode the given Base64 to string
     
     - parameter string: String to decode
     
     - returns: Returns the decoded string
     */
    static func decodeBase64(string: String) -> String {
        let data: NSData = NSData(base64Encoded: string as String, options: NSData.Base64DecodingOptions(rawValue: 0))!
        return NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)! as String
    }
    
    /**
     Remove double or more duplicated spaces
     
     - returns: String without additional spaces
     */
    func removeSpaces() -> String {
        return self.removeExtraSpaces() as String
    }
    
    /**
     - returns: Decoded Base64 string
     */
    func decodeFromBase64Encoding() -> String {
        let base64data = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        return NSString(data: base64data! as Data, encoding: String.Encoding.utf8.rawValue)! as String
    }
    

    
    /**
     Used to calculate text height for max width and font
     
     - parameter width: Max width to fit text
     - parameter font:  Font used in text
     
     - returns: Returns the calculated height of string within width using given font
     */
    func heightForWidth(width: CGFloat, font: UIFont) -> CGFloat {
        var size: CGSize = CGSize.zero
        if self.lengthOfString > 0 {
            let frame: CGRect = self.boundingRect(with: CGSize.init(width: width, height: 999999), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
            size = CGSize.init(width: frame.size.width, height: frame.size.height)
            
        }
        return size.height
    }

    
    /// Converted into CGFloat
    func toFloat() -> CGFloat{
        
        var floatNumber : CGFloat = 0.0
        
        let number : NSNumber! = NumberFormatter().number(from: self)
        if (number != nil){
            floatNumber = CGFloat(truncating: number)
            
        }
        return floatNumber
    }
    
    /// Converted into Int
    func toUInt() -> UInt? {
        return UInt(self)
    }
    
    /// Converted into Double
    var toDouble: Double? {
        let numberFormatter = NumberFormatter()
        return numberFormatter.number(from: self)?.doubleValue
    }
    
    
    /// Converted into Bool
    ///
    ///		"1".bool -> true
    ///		"False".bool -> false
    ///		"Hello".bool = nil
    ///
    var bool: Bool? {
        let selfLowercased = trimmed.lowercased()
        if selfLowercased == "true" || selfLowercased == "1" {
            return true
        } else if selfLowercased == "false" || selfLowercased == "0" {
            return false
        }
        return nil
    }
    
    /// True if it is palindrome, false otherwise.
    func isPalindrome() -> Bool {
        let selfString = self.lowercased().replacingOccurrences(of: " ", with: "")
        let otherString = String(selfString.reversed())
        return selfString == otherString
    }
    
    /// Cut blank and newline characters
    mutating func trim() {
        self = trimmed
    }
    
    /// Cut a space and a newline character, returning a new string.
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Delete two or more duplicate spaces
    func removeExtraSpaces() -> String {
        let squashed = replacingOccurrences(of: "[ ]+", with: " ", options: .regularExpression, range: nil)
        return squashed.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// Converted into Data
    var data: Data? {
        return self.data(using: .utf8)
    }
    
    func addToPasteboard() {
        UIPasteboard.general.string = self
    }
    
    func capitalize() -> String {
        return capitalized
    }
    
    func contains(_ substring: String) -> Bool {
        return range(of: substring) != nil
    }
    
    func chompLeft(_ prefix: String) -> String {
        if let prefixRange = range(of: prefix) {
            if prefixRange.upperBound >= endIndex {
                return String(self[startIndex..<prefixRange.lowerBound])
            } else {
                return String(self[prefixRange.upperBound..<endIndex])
            }
        }
        return self
    }
    
    func chompRight(_ suffix: String) -> String {
        if let suffixRange = range(of: suffix, options: .backwards) {
            if suffixRange.upperBound >= endIndex {
                return String(self[startIndex..<suffixRange.lowerBound])
            } else {
                return String(self[suffixRange.upperBound..<endIndex])
            }
        }
        return self
    }
    
    func collapseWhitespace() -> String {
        let components = self.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter { !$0.isEmpty }
        return components.joined(separator: " ")
    }
    
    func clean(with: String, allOf: String...) -> String {
        var string = self
        for target in allOf {
            string = string.replacingOccurrences(of: target, with: with)
        }
        return string
    }
    
    func count(_ substring: String) -> Int {
        return components(separatedBy: substring).count-1
    }
    
    func endsWith(_ suffix: String) -> Bool {
        return hasSuffix(suffix)
    }
    
    func ensureLeft(_ prefix: String) -> String {
        if startsWith(prefix) {
            return self
        } else {
            return "\(prefix)\(self)"
        }
    }
    
    func ensureRight(_ suffix: String) -> String {
        if endsWith(suffix) {
            return self
        } else {
            return "\(self)\(suffix)"
        }
    }
    
    //Calculate the number of symbols
    
    func countSymbols() -> Int {
        var countSymbol = 0
        for i in 0 ..< self.lengthOfString {
            guard let character = UnicodeScalar((NSString(string: self)).character(at: i)) else {
                return 0
            }
            let isSymbol = CharacterSet(charactersIn: "`~!?@#$€£¥§%^&*()_+-={}[]:\";.,<>'•\\|/").contains(character)
            if isSymbol {
                countSymbol += 1
            }
        }
        
        return countSymbol
    }
    
    /// Calculate the number of Numbers
    func countNumbers() -> Int {
        var countNumber = 0
        for i in 0 ..< self.lengthOfString {
            guard let character = UnicodeScalar((NSString(string: self)).character(at: i)) else {
                return 0
            }
            let isNumber = CharacterSet(charactersIn: "0123456789").contains(character)
            if isNumber {
                countNumber += 1
            }
        }
        
        return countNumber
    }
    
    /// Returns the inverted string
    ///
    /// - parameter preserveFormat: If set to true preserve the String format.
    ///                             The default value is false.
    ///                             **Example:**
    ///                                 "Let's try this function?" ->
    ///                                 "?noitcnuf siht yrt S'tel"
    func reversed(preserveFormat: Bool = false) -> String {
        guard !self.isEmpty else {
            return ""
        }
        
        var reversed = String(self.removeExtraSpaces().reversed())
        
        if !preserveFormat {
            return reversed
        }
        
        let words = reversed.components(separatedBy: " ").filter { $0 != "" }
        
        reversed.removeAll()
        for word in words {
            if let char = word.unicodeScalars.last {
                if CharacterSet.uppercaseLetters.contains(char) {
                    reversed += word.lowercased().uppercased()
                } else {
                    reversed += word.lowercased()
                }
            } else {
                reversed += word.lowercased()
            }
            
            if word != words[words.count - 1] {
                reversed += " "
            }
        }
        
        return reversed
    }
    
    /// Converts self to an UUID APNS valid (No "<>" or "-" or spaces).
    ///
    /// - Returns: Converts self to an UUID APNS valid (No "<>" or "-" or spaces).
    func readableUUID() -> String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: "<>")).replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
    }
    
   
    func isAlpha() -> Bool {
        for chr in self {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
    
    
    func indexOf(_ substring: String) -> Int? {
        if let range = range(of: substring) {
            return distance(from: startIndex, to: range.lowerBound)
        }
        return nil
    }
    
    func isAlphaNumeric() -> Bool {
        let alphaNumeric = CharacterSet.alphanumerics
        return components(separatedBy: alphaNumeric).joined(separator: "").lengthOfString == 0
    }
    
    func isEmpty() -> Bool {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).lengthOfString == 0
    }
    
    func join<S: Sequence>(_ elements: S) -> String {
        return elements.map{String(describing: $0)}.joined(separator: self)
    }
    
    func latinize() -> String {
        return self.folding(options: .diacriticInsensitive, locale: Locale.current)
    }
    
    func lines() -> [String] {
        return self.components(separatedBy: CharacterSet.newlines)
    }
    
    var lengthOfString: Int {
        get {
            return self.count
        }
    }
    
    func slugify(withSeparator separator: Character = "-") -> String {
        let slugCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\(separator)")
        return latinize().lowercased()
            .components(separatedBy: slugCharacterSet.inverted)
            .filter { $0 != "" }
            .joined(separator: String(separator))
    }
    
    func split(_ separator: Character) -> [String] {
        return split{$0 == separator}.map(String.init)
    }
    
    func startsWith(_ prefix: String) -> Bool {
        return hasPrefix(prefix)
    }
    
    func toFloat() -> Float? {
        if let number = defaultNumberFormatter().number(from: self) {
            return number.floatValue
        }
        return nil
    }
    
    func toInt() -> Int? {
        if let number = defaultNumberFormatter().number(from: self) {
            return number.intValue
        }
        return nil
    }
    
    func toBool() -> Bool? {
        let trimmed = self.trimmed.lowercased()
        if trimmed == "true" || trimmed == "false" {
            return (trimmed as NSString).boolValue
        }
        return nil
    }
    
    func toDate(_ format: String = "yyyy-MM-dd") -> Date? {
        return dateFormatter(format).date(from: self)
    }
    
    func toDateTime(_ format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        return toDate(format)
    }
    
    func trimmedLeft() -> String {
        if let range = rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines.inverted) {
            return String(self[range.lowerBound..<endIndex])
        }
        return self
    }
    
    func trimmedRight() -> String {
        if let range = rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines.inverted, options: NSString.CompareOptions.backwards) {
            return String(self[startIndex..<range.upperBound])
        }
        return self
    }
    
//    public subscript(i: Int) -> Character {
//        get {
//            let index = self.index(self.startIndex, offsetBy: i)
//            return self[index]
//        }
//    }

    
    /// Returns the last path component
    var lastPathComponent: String {
        get {
            return (self as NSString).lastPathComponent
        }
    }
    
    func fileExtension() -> String? {
        
        if let fileExtension = NSURL(fileURLWithPath: self).pathExtension {
            return fileExtension
        } else {
            return nil
        }
    }
    /**
     Encode the given string to Base64
     
     - returns: Returns the encoded string
     */
    func encodeToBase64() -> String {
        return String.encodeToBase64(string: self)
    }
    
    /**
     Decode the given Base64 to string
     
     - returns: Returns the decoded string
     */
    func decodeBase64() -> String {
        return String.decodeBase64(string: self)
    }
    
    /**
     Convert self to a NSData
     
     - returns: Returns self as NSData
     */
    func convertToNSData() -> NSData {
        return NSString.convertToNSData(string: self as NSString)
    }
    
    
    /**
     Returns a new string containing matching regular expressions replaced with the template string
     
     - parameter regexString: The regex string
     - parameter replacement: The replacement string
     
     - returns: Returns a new string containing matching regular expressions replaced with the template string
     */
    func stringByReplacingWithRegex(regexString: NSString, withString replacement: NSString) throws -> NSString {
        let regex: NSRegularExpression = try NSRegularExpression(pattern: regexString as String, options: .caseInsensitive)
        return regex.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range:NSMakeRange(0, self.lengthOfString), withTemplate: "") as NSString
    }
    
    
    /// Returns the path extension
    var pathExtension: String {
        get {
            return (self as NSString).pathExtension
        }
    }
    
    /// Delete the last path component
    var stringByDeletingLastPathComponent: String {
        get {
            return (self as NSString).deletingLastPathComponent
        }
    }
    
    /// Delete the path extension
    var stringByDeletingPathExtension: String {
        get {
            return (self as NSString).deletingPathExtension
        }
    }
    
    /// Returns an array of path components
    var pathComponents: [String] {
        get {
            return (self as NSString).pathComponents
        }
    }
    
    /**
     Appends a path component to the string
     
     - parameter path: Path component to append
     
     - returns: Returns all the string
     */
    func stringByAppendingPathComponent(path: String) -> String {
        let string = self as NSString
        
        return string.appendingPathComponent(path)
    }
    
    /**
     Appends a path extension to the string
     
     - parameter ext: Extension to append
     
     - returns: returns all the string
     */
    func stringByAppendingPathExtension(ext: String) -> String? {
        let nsSt = self as NSString
        
        return nsSt.appendingPathExtension(ext)
    }
   
    func substring(_ startIndex: Int, length: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: startIndex)
        let end = self.index(self.startIndex, offsetBy: startIndex + length)
        return String(self[start..<end])
    }
    

    // Returns true if the string has at least one character in common with matchCharacters.
    func containsCharactersIn(_ matchCharacters: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: matchCharacters)
        return self.rangeOfCharacter(from: characterSet) != nil
    }
    
    // Returns true if the string contains only characters found in matchCharacters.
    func containsOnlyCharactersIn(_ matchCharacters: String) -> Bool {
        let disallowedCharacterSet = CharacterSet(charactersIn: matchCharacters).inverted
        return self.rangeOfCharacter(from: disallowedCharacterSet) == nil
    }
    
    // Returns true if the string has no characters in common with matchCharacters.
    func doesNotContainCharactersIn(_ matchCharacters: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: matchCharacters)
        return self.rangeOfCharacter(from: characterSet) == nil
    }
    
    // Returns true if the string represents a proper numeric value.
    // This method uses the device's current locale setting to determine
    // which decimal separator it will accept.
    func isNumeric() -> Bool
    {
        let scanner = Scanner(string: self)
        
        // A newly-created scanner has no locale by default.
        // We'll set our scanner's locale to the user's locale
        // so that it recognizes the decimal separator that
        // the user expects (for example, in North America,
        // "." is the decimal separator, while in many parts
        // of Europe, "," is used).
        scanner.locale = Locale.current
        
        return scanner.scanDecimal(nil) && scanner.isAtEnd
    }
    
    
    /// String size
    func toSize(size: CGSize, fontSize: CGFloat, maximumNumberOfLines: Int = 0) -> CGSize {
        let font = UIFont.systemFont(ofSize: fontSize)
        var size = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes:[NSAttributedString.Key.font : font], context: nil).size
        if maximumNumberOfLines > 0 {
            size.height = min(size.height, CGFloat(maximumNumberOfLines) * font.lineHeight)
        }
        return size
    }
    
    /// String width
    func toWidth(fontSize: CGFloat, maximumNumberOfLines: Int = 0) -> CGFloat {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        return toSize(size: size, fontSize: fontSize, maximumNumberOfLines: maximumNumberOfLines).width
    }
    
    /// String Height
    func toHeight(width: CGFloat, fontSize: CGFloat, maximumNumberOfLines: Int = 0) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        return toSize(size: size, fontSize: fontSize, maximumNumberOfLines: maximumNumberOfLines).height
    }
    
    /// Calculate the height of the string and limit the width
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil)
        return boundingBox.height
    }
    
    /// Underline
    func underline() -> NSAttributedString {
        let underlineString = NSAttributedString(string: self, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        return underlineString
    }
    
    // italic
    func italic() -> NSAttributedString {
        let italicString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
        return italicString
    }
    
    /// Set the specified text color
    func makeSubstringColor(_ text: String, color: UIColor) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: self)
        
        let range = (self as NSString).range(of: text)
        if range.location != NSNotFound {
            attributedText.setAttributes([NSAttributedString.Key.foregroundColor: color], range: range)
        }
        
        return attributedText
    }
    
}

//Validation
public extension String {
   
    /// Whether it is a mailbox
    func isEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        //        let emailRegex = "^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\\.[a-zA-Z0-9_-]{2,3}){1,2})$"
        let testPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return testPredicate.evaluate(with: self)
    }
    
    
    /// Whether it is a mobile phone number at the beginning
    func isPhoneNumber() -> Bool {
        let regex = "^1\\d{10}$"
        let testPredicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return testPredicate.evaluate(with: self)
    }
    
    
    /// Regular match phone number
    func checkMobile() -> Bool {
        /**
         * cellphone number:
         * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
         * Mobile number: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
         * Unicom number: 130,131,132,155,156,185,186,145,176,1709
         * Signal section: 133,153,180,181,189,177,1700
         */
        let MOBIL = "^1((3[0-9]|4[57]|5[0-35-9]|7[0678]|8[0-9])\\d{8}$)"
        /**
         * China Mobile
         * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
         */
        let CM = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)"
        /**
         * China Unicom
         * 130,131,132,155,156,185,186,145,176,1709
         */
        let CU = "(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)"
        /**
         * China Telecom
         * 133,153,180,181,189,177,1700
         */
        let CT = "(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@", MOBIL)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@", CM)
        let regextestcu = NSPredicate(format: "SELF MATCHES %@", CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@", CT)
        if regextestmobile.evaluate(with: self) || regextestcm.evaluate(with: self) || regextestcu.evaluate(with: self) || regextestct.evaluate(with: self) {
            return true
        }
        return false
    }
    

    /// Regular match user password 6-18 digits and letter combination
    func checkPassword() -> Bool {
        let pattern = "^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }
    
    /// Regular match URL
    func checkURL() -> Bool {
        let pattern = "^[0-9A-Za-z]{1,50}"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }
    
    /// Regular match user name, 20 English
    func checkUserName() -> Bool {
        let pattern = "^[a-zA-Z\\u4E00-\\u9FA5]{1,20}"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }
    
    /// Verify that it is a number
//    public func isNumber() -> Bool {
//        let cs: CharacterSet = CharacterSet(charactersIn: "0123456789")
//
//        let specialrang: NSRange = (self as NSString).rangeOfCharacter(from: cs)
//
//        return specialrang.location != NSNotFound
//    }
   
    ///*
    func matchRegex(_ pattern: String) -> Bool {
        /*
         guard let searchResults = range(of: pattern, options: .regularExpression) else {return false}
         return searchResults.lowerBound == startIndex && searchResults.count == characters.count
         */
        guard let searchResults = range(of: pattern, options: .regularExpression) else {
            return false
        }
        return searchResults.lowerBound == startIndex && searchResults.description.count == count
    }

    
    ///Verify that it contains "special characters"
    func isSpecialCharacter() -> Bool {
        let character = CharacterSet(charactersIn: "@／:;（）¥「」!,.?<>£＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\"/" +
            "")
        
        let specialrang: NSRange = (self as NSString).rangeOfCharacter(from: character)
        
        return specialrang.location != NSNotFound
    }
    
    func containerWD() -> Bool {
        let regex = "^\\w+:\\d+:\\w+;$"
        let testPredicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return testPredicate.evaluate(with: self)
    }
}


//For String

private enum ThreadLocalIdentifier {
    case dateFormatter(String)
    
    case defaultNumberFormatter
    case localeNumberFormatter(Locale)
    
    var objcDictKey: String {
        switch self {
        case .dateFormatter(let format):
            return "SS\(self)\(format)"
        case .localeNumberFormatter(let l):
            return "SS\(self)\(l.identifier)"
        default:
            return "SS\(self)"
        }
    }
}

private func threadLocalInstance<T: AnyObject>(_ identifier: ThreadLocalIdentifier, initialValue: @autoclosure () -> T) -> T {
    let storage = Thread.current.threadDictionary
    let k = identifier.objcDictKey
    
    let instance: T = storage[k] as? T ?? initialValue()
    if storage[k] == nil {
        storage[k] = instance
    }
    
    return instance
}

private func dateFormatter(_ format: String) -> DateFormatter {
    return threadLocalInstance(.dateFormatter(format), initialValue: {
        let df = DateFormatter()
        df.dateFormat = format
        return df
    }())
}

private func defaultNumberFormatter() -> NumberFormatter {
    return threadLocalInstance(.defaultNumberFormatter, initialValue: NumberFormatter())
}

private func localeNumberFormatter(_ locale: Locale) -> NumberFormatter {
    return threadLocalInstance(.localeNumberFormatter(locale), initialValue: {
        let nf = NumberFormatter()
        nf.locale = locale
        return nf
    }())
}


