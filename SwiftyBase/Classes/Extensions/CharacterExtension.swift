//
//  CharacterExtension.swift
//  Pods
//
//  Created by MacMini-2 on 11/09/17.
//
//

import Foundation


public extension UserDefaults {
    
    func bool(forKey key: String, defaultValue: Bool) -> Bool {
        if value(forKey: key) == nil {
            set(defaultValue, forKey: key)
        }
        return bool(forKey: key)
    }
}

public extension UserDefaults {
    
    func integer(forKey key: String, defaultValue: Int) -> Int {
        if value(forKey: key) == nil {
            set(defaultValue, forKey: key)
        }
        return integer(forKey: key)
    }
}

public extension UserDefaults {
    
    func string(forKey key: String, defaultValue: String) -> String {
        if value(forKey: key) == nil {
            set(defaultValue, forKey: key)
        }
        return string(forKey: key) ?? defaultValue
    }
}

public extension UserDefaults {
    
    func double(forKey key: String, defaultValue: Double) -> Double {
        if value(forKey: key) == nil {
            set(defaultValue, forKey: key)
        }
        return double(forKey: key)
    }
}

public extension UserDefaults {
    
    func object(forKey key: String, defaultValue: AnyObject) -> Any? {
        if object(forKey: key) == nil {
            set(defaultValue, forKey: key)
        }
        return object(forKey: key)
    }
}


// MARK: -

public extension UserDefaults {
    
    func color(forKey key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
    
    func setColor(_ color: UIColor?, forKey key: String) {
        var colorData: Data?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color)
        }
        set(colorData, forKey: key)
    }
}

public extension UserDefaults {
    
    func setArchivedData(_ object: Any?, forKey key: String) {
        var data: Data?
        if let object = object {
            data = NSKeyedArchiver.archivedData(withRootObject: object)
        }
        set(data, forKey: key)
    }
    
    func unarchiveObjectWithData(forKey key: String) -> Any? {
        guard let object = object(forKey: key) else { return nil }
        guard let data = object as? Data else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data)
    }
}


// MARK: - Character Extension -

public extension Character {
    /// Return true if character is emoji.
    public var isEmoji: Bool {
        // http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
        guard let scalarValue = String(self).unicodeScalars.first?.value else {
            return false
        }
        switch scalarValue {
        case 0x3030, 0x00AE, 0x00A9,// Special Characters
        0x1D000...0x1F77F, // Emoticons
        0x2100...0x27BF, // Misc symbols and Dingbats
        0xFE00...0xFE0F, // Variation Selectors
        0x1F900...0x1F9FF: // Supplemental Symbols and Pictographs
            return true
        default:
            return false
        }
    }
    
    /// Return true if character is number.
    public var isNumber: Bool {
        return Int(String(self)) != nil
    }
    
    /// Return integer from character (if applicable).
    public var toInt: Int? {
        return Int(String(self))
    }
    
    /// Return string from character.
    public var toString: String {
        return String(self)
    }
}
