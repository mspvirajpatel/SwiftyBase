//
//  BaseRadioButton.swift
//  Pods
//
//  Created by MacMini-2 on 11/09/17.
//
//

import Foundation
import UIKit

/// RadioButtonControllerDelegate. Delegate optionally implements didSelectButton that receives selected button
@objc public protocol BaseRadioButtonDelegate {

    /**
     This function is called when a button is selected. If 'shouldLetDeSelect' is true, and a button is deselected, this function
     is called with a nil.
     
     */
    @objc optional func didSelectButton(_ aButton: BaseButton?)
}

open class BaseRadioButton: NSObject
{

    fileprivate var buttonsArray = [BaseButton]()
    public var currentSelectedButton: BaseButton!
    weak public var delegate: BaseRadioButtonDelegate? = nil

    /**
     Set whether a selected radio button can be deselected or not. Default value is false.
     */
    public var shouldLetDeSelect = false

    /**
     Variadic parameter init that accepts BaseButtons.
     
     - parameter buttons: Buttons that should behave as Radio Buttons
     */
    public init(buttons: BaseButton...) {
        super.init()
        for aButton in buttons {
            aButton.addTarget(self, action: #selector(BaseRadioButton.pressed(_:)), for: UIControl.Event.touchUpInside)
        }
        self.buttonsArray = buttons
    }

    /**
     Add a BaseButton to Controller
     - parameter button: Add the button to controller.
     */
    open func addButton(_ aButton: BaseButton) {
        buttonsArray.append(aButton)
        aButton.addTarget(self, action: #selector(BaseRadioButton.pressed(_:)), for: UIControl.Event.touchUpInside)
    }

    /**
     Remove a BaseButton from controller.
     - parameter button: Button to be removed from controller.
     */
    func removeButton(_ aButton: BaseButton) {
        let iteration = 0
        var iteratingButton: BaseButton? = nil
        for i in iteration..<buttonsArray.count {
            iteratingButton = buttonsArray[i]
            if(iteratingButton == aButton) {
                break
            } else {
                iteratingButton = nil
            }
        }

        if(iteratingButton != nil) {
            buttonsArray.remove(at: iteration)
            iteratingButton!.removeTarget(self, action: #selector(BaseRadioButton.pressed(_:)), for: UIControl.Event.touchUpInside)
            if currentSelectedButton == iteratingButton {
                currentSelectedButton = nil
            }
        }
    }
    /**
     Set an array of UIButons to behave as controller.
     
     - parameter buttonArray: Array of buttons
     */
    func setButtonsArray(_ aButtonsArray: [BaseButton]) {
        for aButton in aButtonsArray {
            aButton.addTarget(self, action: #selector(BaseRadioButton.pressed(_:)), for: UIControl.Event.touchUpInside)
        }
        buttonsArray = aButtonsArray
    }

    @objc open func pressed(_ sender: BaseButton) {
        if(sender.isSelected) {
            if shouldLetDeSelect {
                sender.isSelected = true
                currentSelectedButton = sender

            }
        } else {
            for aButton in buttonsArray {
                aButton.isSelected = false
            }
            sender.isSelected = true
            currentSelectedButton = sender
            //            sender.tintColor = UIColor.clearColor()
        }
        delegate?.didSelectButton?(currentSelectedButton)
    }
    /**
     Get the currently selected button.
     
     - returns: Currenlty selected button.
     */
    open func selectedButton() -> BaseButton? {
        return currentSelectedButton
    }
}
