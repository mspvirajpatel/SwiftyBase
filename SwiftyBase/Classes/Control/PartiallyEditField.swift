//
//  PartiallyEditField.swift
//  SwiftyBase
//
//  Created by Viraj Patel on 13/11/17.
//

import Foundation

public enum PreTextSide: Int {
    case kNone
    case kLeft
    case kRight
}

/**
 *  The PartiallyEditField will generate pretext for the textfield.
 */
open class PartiallyEditField: UITextField {

    open var prevText = ""
    open var prevTextRange: UITextRange?
    open var originalColor: UIColor?

    open var preTextFont: UIFont?
    open var preTextColor: UIColor?
    open var preText = ""
    open var atributedPlaceHolderString: NSMutableAttributedString?

    /**
     *  The side that you want append for pretext.
     */
    open var preTextSide: PreTextSide?
    open var placeHolderColor: UIColor?


    /**
     *  This method will help to downlaod image with complete block. Block response will be an image.
     *
     *  @param string The pre text that you wanted to append.
     */

    //  The converted code is limited to 4 KB.
    //  Upgrade your plan to remove this limitation.
    open func setup(withPreText preText: String) {
        self.preText = preText
        prevText = text!
        originalColor = textColor
        if preTextSide == .kNone {
            preTextSide = .kRight
        }
        addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        createAtributedPlaceHolder()
    }

    /**
     *  This method will help to downlaod image with complete block. Block response will be an image.
     *
     *  @param string The pre text that you wanted to append.
     *  @param color The text color for pretext that you wanted.
     */

    open func setup(withPreText preText: String, color: UIColor) {
        preTextColor = color
        setup(withPreText: preText)
    }

    @objc open func textChanged(_ sender: PartiallyEditField) {
        if !(text == "") {
            if (text == preText) {
                text = ""
                prevText = ""
                return
            }
            if (prevText == "") {
                if preTextSide == .kLeft {
                    text = "\(preText)\(String(describing: text!))"
                }
                else {
                    text = "\(String(describing: text!))\(preText)"
                }
                prevText = text!
            }
            let range: NSRange? = (text! as NSString).range(of: preText)
            if preTextSide == .kLeft {
                if (text?.contains(preText))! && range?.location == 0 {
                    prevText = text!
                }
                else {
                    text = prevText
                }
            }
            else {
                if (self.text?.contains(self.preText))! {
                    if (Int(range!.location) + Int((range?.length)!)) >= (text?.lengthOfString)!
                        {
                        prevText = text!
                    }
                    else {
                        text = prevText
                    }
                }
                else {
                    text = prevText
                }
            }
            createAtributedText()
            changeRangeToBegin()
        }
    }

    open func changeRangeToBegin() {
        let range: NSRange? = (text! as NSString).range(of: preText)
        let idx: Int = offset(from: beginningOfDocument, to: prevTextRange!.start)
        if preTextSide == .kLeft {
            if idx > ((range?.location)! + (range?.length)!) {
                selectedTextRange = prevTextRange
            }
            else {
                let end: UITextPosition? = position(from: beginningOfDocument, offset: (range?.location)!)
                selectedTextRange = textRange(from: end ?? UITextPosition(), to: end ?? UITextPosition())
            }
        }
        else {
            if idx >= ((range?.location)! + (range?.length)!) {
                let end: UITextPosition? = position(from: beginningOfDocument, offset: (range?.location)!)
                selectedTextRange = textRange(from: end ?? UITextPosition(), to: end ?? UITextPosition())
            }
            else {
                selectedTextRange = prevTextRange
            }
        }
    }

    open func createAtributedPlaceHolder() {
        var placeHolderText = "\(String(describing: placeholder?.replacingOccurrences(of: preText, with: "")))\(preText)"
        if preTextSide == .kLeft {
            placeHolderText = "\(preText)\(String(describing: placeholder?.replacingOccurrences(of: preText, with: "")))"
        }
        attributedPlaceholder = atrributeText(fromText: placeHolderText, isText: false)
    }

    open func atrributeText(fromText str: String, isText: Bool) -> NSMutableAttributedString {
        let range: NSRange? = (str as NSString).range(of: preText)
        let string = NSMutableAttributedString(string: str)
        if isText {
            string.addAttribute(NSAttributedString.Key.foregroundColor, value: originalColor as Any, range: NSRange(location: 0, length: (str.count)))
        }
        else {
            if (placeHolderColor != nil) {
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: placeHolderColor as Any, range: NSRange(location: 0, length: (str.count)))
            }
        }
        if (preTextColor != nil) {
            string.addAttribute(NSAttributedString.Key.foregroundColor, value: preTextColor as Any, range: range ?? NSRange())
        }
        return string
    }

    open func createAtributedText() {
        prevTextRange = selectedTextRange
        attributedText = atrributeText(fromText: text!, isText: true)
    }

    open func setPreTextSide(_ preTextSide: PreTextSide) {
        self.preTextSide = preTextSide


        createAtributedPlaceHolder()

    }

    open func setPlaceHolderColor(_ placeHolderColor: UIColor) {
        self.placeHolderColor = placeHolderColor


        createAtributedPlaceHolder()

    }
}

