//
//  StringExtension.swift
//  Pods
//
//  Created by MacMini-2 on 30/08/17.
//
//

import Foundation

// MARK: - String Extension -

public extension String {
   
    public func localize(comment: String?) -> String {
        if comment != nil
        {
            return NSLocalizedString(self, comment: comment!)
        }
        else
        {
            return NSLocalizedString(self, comment: "")
        }
    }
    
    public func localize() -> String {
        
        return NSLocalizedString(self, comment: "")
        
    }
    
    public var parseJSONString: AnyObject?
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
    
    /// Converted into CGFloat
    public func toFloat() -> CGFloat{
        
        var floatNumber : CGFloat = 0.0
        
        let number : NSNumber! = NumberFormatter().number(from: self)
        if (number != nil){
            floatNumber = CGFloat(number)
            
        }
        return floatNumber
    }
    
    /// Converted into Int
    public func toUInt() -> UInt? {
        return UInt(self)
    }
    
    /// Converted into Double
    public var toDouble: Double? {
        let numberFormatter = NumberFormatter()
        return numberFormatter.number(from: self)?.doubleValue
    }
    
    
    /// Converted into Bool
    ///
    ///		"1".bool -> true
    ///		"False".bool -> false
    ///		"Hello".bool = nil
    ///
    public var bool: Bool? {
        let selfLowercased = trimmed.lowercased()
        if selfLowercased == "true" || selfLowercased == "1" {
            return true
        } else if selfLowercased == "false" || selfLowercased == "0" {
            return false
        }
        return nil
    }
    
    /// True if it is palindrome, false otherwise.
    public func isPalindrome() -> Bool {
        let selfString = self.lowercased().replacingOccurrences(of: " ", with: "")
        let otherString = String(selfString.characters.reversed())
        return selfString == otherString
    }
    
    /// Cut blank and newline characters
    public mutating func trim() {
        self = trimmed
    }
    
    /// Cut a space and a newline character, returning a new string.
    public var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Delete two or more duplicate spaces
    public func removeExtraSpaces() -> String {
        let squashed = replacingOccurrences(of: "[ ]+", with: " ", options: .regularExpression, range: nil)
        return squashed.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// Converted into Data
    public var data: Data? {
        return self.data(using: .utf8)
    }
    
    public func addToPasteboard() {
        UIPasteboard.general.string = self
    }
    
    // https://gist.github.com/stevenschobert/540dd33e828461916c11
   
    public func camelize() -> String {
        let source = clean(with: " ", allOf: "-", "_")
        if source.characters.contains(" ") {
            let first = source.substring(to: source.characters.index(source.startIndex, offsetBy: 1))
            let cammel = NSString(format: "%@", (source as NSString).capitalized.replacingOccurrences(of: " ", with: "", options: [], range: nil)) as String
            let rest = String(cammel.characters.dropFirst())
            return "\(first)\(rest)"
        } else {
            let first = (source as NSString).lowercased.substring(to: source.characters.index(source.startIndex, offsetBy: 1))
            let rest = String(source.characters.dropFirst())
            return "\(first)\(rest)"
        }
    }
    
    public func capitalize() -> String {
        return capitalized
    }
    
    public func contains(_ substring: String) -> Bool {
        return range(of: substring) != nil
    }
    
    public func chompLeft(_ prefix: String) -> String {
        if let prefixRange = range(of: prefix) {
            if prefixRange.upperBound >= endIndex {
                return self[startIndex..<prefixRange.lowerBound]
            } else {
                return self[prefixRange.upperBound..<endIndex]
            }
        }
        return self
    }
    
    public func chompRight(_ suffix: String) -> String {
        if let suffixRange = range(of: suffix, options: .backwards) {
            if suffixRange.upperBound >= endIndex {
                return self[startIndex..<suffixRange.lowerBound]
            } else {
                return self[suffixRange.upperBound..<endIndex]
            }
        }
        return self
    }
    
    public func collapseWhitespace() -> String {
        let components = self.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter { !$0.isEmpty }
        return components.joined(separator: " ")
    }
    
    public func clean(with: String, allOf: String...) -> String {
        var string = self
        for target in allOf {
            string = string.replacingOccurrences(of: target, with: with)
        }
        return string
    }
    
    public func count(_ substring: String) -> Int {
        return components(separatedBy: substring).count-1
    }
    
    public func endsWith(_ suffix: String) -> Bool {
        return hasSuffix(suffix)
    }
    
    public func ensureLeft(_ prefix: String) -> String {
        if startsWith(prefix) {
            return self
        } else {
            return "\(prefix)\(self)"
        }
    }
    
    public func ensureRight(_ suffix: String) -> String {
        if endsWith(suffix) {
            return self
        } else {
            return "\(self)\(suffix)"
        }
    }
    
    //Calculate the number of symbols
    
    public func countSymbols() -> Int {
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
    public func countNumbers() -> Int {
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
    public func reversed(preserveFormat: Bool = false) -> String {
        guard !self.characters.isEmpty else {
            return ""
        }
        
        var reversed = String(self.removeExtraSpaces().characters.reversed())
        
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
    public func readableUUID() -> String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: "<>")).replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
    }
    
    public static func random(ofLength length: Int) -> String {
        guard length > 0 else { return "" }
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return (0..<length).reduce("") {
            let randomIndex = arc4random_uniform(UInt32(base.characters.count))
            let randomCharacter = "\(base[base.index(base.startIndex, offsetBy: IndexDistance(randomIndex))])"
            return $0.0 + randomCharacter
        }
    }
    
    public func indexOf(_ substring: String) -> Int? {
        if let range = range(of: substring) {
            return characters.distance(from: startIndex, to: range.lowerBound)
        }
        return nil
    }
    
    public func isAlpha() -> Bool {
        for chr in characters {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
    
    public func isAlphaNumeric() -> Bool {
        let alphaNumeric = CharacterSet.alphanumerics
        return components(separatedBy: alphaNumeric).joined(separator: "").lengthOfString == 0
    }
    
    public func isEmpty() -> Bool {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).lengthOfString == 0
    }
    
    public func join<S: Sequence>(_ elements: S) -> String {
        return elements.map{String(describing: $0)}.joined(separator: self)
    }
    
    public func latinize() -> String {
        return self.folding(options: .diacriticInsensitive, locale: Locale.current)
    }
    
    public func lines() -> [String] {
        return self.components(separatedBy: CharacterSet.newlines)
    }
    
    public var lengthOfString: Int {
        get {
            return self.characters.count
        }
    }
    
    public func pad(_ n: Int, _ string: String = " ") -> String {
        return "".join([string.times(n), self, string.times(n)])
    }
    
    public func padLeft(_ n: Int, _ string: String = " ") -> String {
        return "".join([string.times(n), self])
    }
    
    public func padRight(_ n: Int, _ string: String = " ") -> String {
        return "".join([self, string.times(n)])
    }
    
    public func slugify(withSeparator separator: Character = "-") -> String {
        let slugCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\(separator)")
        return latinize().lowercased()
            .components(separatedBy: slugCharacterSet.inverted)
            .filter { $0 != "" }
            .joined(separator: String(separator))
    }
    
    public func split(_ separator: Character) -> [String] {
        return characters.split{$0 == separator}.map(String.init)
    }
    
    public func startsWith(_ prefix: String) -> Bool {
        return hasPrefix(prefix)
    }
    
    public func times(_ n: Int) -> String {
        return (0..<n).reduce("") { $0.0 + self }
    }
    
    public func toFloat() -> Float? {
        if let number = defaultNumberFormatter().number(from: self) {
            return number.floatValue
        }
        return nil
    }
    
    public func toInt() -> Int? {
        if let number = defaultNumberFormatter().number(from: self) {
            return number.intValue
        }
        return nil
    }
    
    public func toBool() -> Bool? {
        let trimmed = self.trimmed.lowercased()
        if trimmed == "true" || trimmed == "false" {
            return (trimmed as NSString).boolValue
        }
        return nil
    }
    
    public func toDate(_ format: String = "yyyy-MM-dd") -> Date? {
        return dateFormatter(format).date(from: self)
    }
    
    public func toDateTime(_ format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        return toDate(format)
    }
    
    public func trimmedLeft() -> String {
        if let range = rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines.inverted) {
            return self[range.lowerBound..<endIndex]
        }
        return self
    }
    
    public func trimmedRight() -> String {
        if let range = rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines.inverted, options: NSString.CompareOptions.backwards) {
            return self[startIndex..<range.upperBound]
        }
        return self
    }
    
//    public subscript(r: Range<Int>) -> String {
//        get {
//            let startIndex = self.characters.index(self.startIndex, offsetBy: r.lowerBound)
//            let endIndex = self.characters.index(self.startIndex, offsetBy: r.upperBound - r.lowerBound)
//            return self[startIndex..<endIndex]
//        }
//    }
    
    public func substring(_ startIndex: Int, length: Int) -> String {
        let start = self.characters.index(self.startIndex, offsetBy: startIndex)
        let end = self.characters.index(self.startIndex, offsetBy: startIndex + length)
        return self[start..<end]
    }
    
    public subscript(i: Int) -> Character {
        get {
            let index = self.characters.index(self.startIndex, offsetBy: i)
            return self[index]
        }
    }
    
    // Returns true if the string has at least one character in common with matchCharacters.
    public func containsCharactersIn(_ matchCharacters: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: matchCharacters)
        return self.rangeOfCharacter(from: characterSet) != nil
    }
    
    // Returns true if the string contains only characters found in matchCharacters.
    public func containsOnlyCharactersIn(_ matchCharacters: String) -> Bool {
        let disallowedCharacterSet = CharacterSet(charactersIn: matchCharacters).inverted
        return self.rangeOfCharacter(from: disallowedCharacterSet) == nil
    }
    
    // Returns true if the string has no characters in common with matchCharacters.
    public func doesNotContainCharactersIn(_ matchCharacters: String) -> Bool {
        let characterSet = CharacterSet(charactersIn: matchCharacters)
        return self.rangeOfCharacter(from: characterSet) == nil
    }
    
    // Returns true if the string represents a proper numeric value.
    // This method uses the device's current locale setting to determine
    // which decimal separator it will accept.
    public func isNumeric() -> Bool
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
    public func toSize(size: CGSize, fontSize: CGFloat, maximumNumberOfLines: Int = 0) -> CGSize {
        let font = UIFont.systemFont(ofSize: fontSize)
        var size = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes:[NSFontAttributeName : font], context: nil).size
        if maximumNumberOfLines > 0 {
            size.height = min(size.height, CGFloat(maximumNumberOfLines) * font.lineHeight)
        }
        return size
    }
    
    /// String width
    public func toWidth(fontSize: CGFloat, maximumNumberOfLines: Int = 0) -> CGFloat {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        return toSize(size: size, fontSize: fontSize, maximumNumberOfLines: maximumNumberOfLines).width
    }
    
    /// String Height
    public func toHeight(width: CGFloat, fontSize: CGFloat, maximumNumberOfLines: Int = 0) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        return toSize(size: size, fontSize: fontSize, maximumNumberOfLines: maximumNumberOfLines).height
    }
    
    /// Calculate the height of the string and limit the width
    public func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSFontAttributeName: font],
            context: nil)
        return boundingBox.height
    }
    
    /// Underline
    public func underline() -> NSAttributedString {
        let underlineString = NSAttributedString(string: self, attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        return underlineString
    }
    
    // italic
    public func italic() -> NSAttributedString {
        let italicString = NSMutableAttributedString(string: self, attributes: [NSFontAttributeName: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
        return italicString
    }
    
    /// Set the specified text color
    public func makeSubstringColor(_ text: String, color: UIColor) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: self)
        
        let range = (self as NSString).range(of: text)
        if range.location != NSNotFound {
            attributedText.setAttributes([NSForegroundColorAttributeName: color], range: range)
        }
        
        return attributedText
    }
    
}

//Validation
public extension String {
   
    /// Whether it is a mailbox
    public func isEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        //        let emailRegex = "^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\\.[a-zA-Z0-9_-]{2,3}){1,2})$"
        let testPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return testPredicate.evaluate(with: self)
    }
    
    
    /// Whether it is a mobile phone number at the beginning
    public func isPhoneNumber() -> Bool {
        let regex = "^1\\d{10}$"
        let testPredicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return testPredicate.evaluate(with: self)
    }
    
    
    /// Regular match phone number
    public func checkMobile() -> Bool {
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
    public func checkPassword() -> Bool {
        let pattern = "^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }
    
    /// Regular match URL
    public func checkURL() -> Bool {
        let pattern = "^[0-9A-Za-z]{1,50}"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }
    
    /// Regular match user name, 20 English
    public func checkUserName() -> Bool {
        let pattern = "^[a-zA-Z\\u4E00-\\u9FA5]{1,20}"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }
    
    /// Verify that it is a number
    public func isNumber() -> Bool {
        let cs: CharacterSet = CharacterSet(charactersIn: "0123456789")
        
        let specialrang: NSRange = (self as NSString).rangeOfCharacter(from: cs)
        
        return specialrang.location != NSNotFound
    }
    
    ///Verify that it contains "special characters"
    public func isSpecialCharacter() -> Bool {
        let character = CharacterSet(charactersIn: "@／:;（）¥「」!,.?<>£＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\"/" +
            "")
        
        let specialrang: NSRange = (self as NSString).rangeOfCharacter(from: character)
        
        return specialrang.location != NSNotFound
    }
    
    public func containerWD() -> Bool {
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


