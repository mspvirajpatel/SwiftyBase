//
//  BaseNotificationBadge.swift
//  Pods
//
//  Created by MacMini-2 on 07/09/17.
//
//

import Foundation

import UIKit

extension UIView {

    /*
     * Assign badge with only text.
     */

    /// - parameter text: The badge value, use nil to remove exsiting badge.
    public func badge(text badgeText: String!) {
        badge(text: badgeText, appearnce: AppBadgeAppearnce())
    }

    /// - parameter text: The badge value, use nil to remove exsiting badge.
    /// - parameter appearnce: The appearance of the badge.
    public func badge(text badgeText: String!, appearnce: AppBadgeAppearnce) {
        badge(text: badgeText, badgeEdgeInsets: nil, appearnce: appearnce)
    }

    /*
     * Assign badge with text and edge insets.
     */

    @available(*, deprecated, message: "Use badge(text: String!, appearnce:AppBadgeAppearnce)")
    public func badge(text badgeText: String!, badgeEdgeInsets: UIEdgeInsets) {
        badge(text: badgeText, badgeEdgeInsets: badgeEdgeInsets, appearnce: AppBadgeAppearnce())
    }

    /*
     * Assign badge with text,insets, and appearnce.
     */
    public func badge(text badgeText: String!, badgeEdgeInsets: UIEdgeInsets?, appearnce: AppBadgeAppearnce) {

        //Create badge label
        var badgeLabel: BadgeLabel!

        var doesBadgeExist = false

        //Find badge in subviews if exists
        for view in self.subviews {
            if view.tag == 1 && view is BadgeLabel {
                badgeLabel = view as! BadgeLabel
            }
        }

        //If assigned text is nil (request to remove badge) and badge label is not nil:
        if badgeText == nil && !(badgeLabel == nil) {

            if appearnce.animate {
                UIView.animate(withDuration: appearnce.duration, animations: {
                    badgeLabel.alpha = 0.0
                    badgeLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)

                }, completion: { (Bool) in

                    badgeLabel.removeFromSuperview()
                })
            } else {
                badgeLabel.removeFromSuperview()
            }
            return
        } else if badgeText == nil && badgeLabel == nil {
            return
        }

        //Badge label is nil (There was no previous badge)
        if (badgeLabel == nil) {

            //init badge label variable
            badgeLabel = BadgeLabel()

            //assign tag to badge label
            badgeLabel.tag = 1
        } else {
            doesBadgeExist = true
        }

        //Set the text on the badge label
        badgeLabel.text = badgeText

        //Set font size
        badgeLabel.font = UIFont.systemFont(ofSize: appearnce.textSize)

        badgeLabel.sizeToFit()

        //set the allignment
        badgeLabel.textAlignment = appearnce.textAlignment

        //set background color
        badgeLabel.layer.backgroundColor = appearnce.backgroundColor.cgColor

        //set text color
        badgeLabel.textColor = appearnce.textColor



        //get current badge size
        let badgeSize = badgeLabel.frame.size

        //calculate width and height with minimum height and width of 20
        let height = max(18, Double(badgeSize.height) + 5.0)
        let width = max(height, Double(badgeSize.width) + 10.0)

        badgeLabel.frame.size = CGSize(width: width, height: height)


        //add to subview

        if doesBadgeExist {
            //remove view to delete constraints
            badgeLabel.removeFromSuperview()
        }
        self.addSubview(badgeLabel)



        //The distance from the center of the view (vertically)
        let centerY = appearnce.distenceFromCenterY == 0 ? -(bounds.size.height / 2) : appearnce.distenceFromCenterY

        //The distance from the center of the view (horizontally)
        let centerX = appearnce.distenceFromCenterX == 0 ? (bounds.size.width / 2) : appearnce.distenceFromCenterX

        //disable auto resizing mask
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false

        //add height constraint
        self.addConstraint(NSLayoutConstraint(item: badgeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(height)))

        //add width constraint
        self.addConstraint(NSLayoutConstraint(item: badgeLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(width)))

        //add vertical constraint
        self.addConstraint(NSLayoutConstraint(item: badgeLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: centerX))

        //add horizontal constraint
        self.addConstraint(NSLayoutConstraint(item: badgeLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: centerY))

        badgeLabel.layer.borderColor = appearnce.borderColor.cgColor

        badgeLabel.layer.borderWidth = appearnce.borderWidth



        //corner radius
        badgeLabel.layer.cornerRadius = badgeLabel.frame.size.height / 2

        //setup shadow
        if appearnce.allowShadow {
            badgeLabel.layer.shadowOffset = CGSize(width: 1, height: 1)

            badgeLabel.layer.shadowRadius = 1

            badgeLabel.layer.shadowOpacity = 0.5

            badgeLabel.layer.shadowColor = UIColor.black.cgColor
        }




        //badge does not exist, meaning we are adding a new one
        if !doesBadgeExist {

            //should it animate?
            if appearnce.animate {
                badgeLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
                UIView.animate(withDuration: appearnce.duration,
                               delay: 0,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 0.5,
                               options: [],
                               animations: {
                                   badgeLabel.transform = .identity
                               },
                               completion: nil)

            }
        }
    }

}


extension UIBarButtonItem {

    /*
     * Assign badge with only text.
     */
    public func badge(text badgeText: String!) {
        if let view = getView() {
            view.badge(text: badgeText, appearnce: AppBadgeAppearnce())
        } else {
            NSLog("Attempted setting badge with value '\(badgeText ?? "nil")' on a nil UIBarButtonItem view.")
        }
    }


    public func badge(text badgeText: String!, appearnce: AppBadgeAppearnce) {
        if let view = getView() {
            view.badge(text: badgeText, appearnce: appearnce)
        } else {
            NSLog("Attempted setting badge with value '\(badgeText ?? "nil")' on a nil UIBarButtonItem view.")
        }
    }

    /*
     * Assign badge with text and edge insets.
     */
    @available(*, deprecated, message: "Use badge(text: String!, appearnce:AppBadgeAppearnce)")
    public func badge(text badgeText: String!, badgeEdgeInsets: UIEdgeInsets) {
        if let view = getView() {
            view.badge(text: badgeText, badgeEdgeInsets: badgeEdgeInsets, appearnce: AppBadgeAppearnce())
        } else {
            NSLog("Attempted setting badge with value '\(badgeText ?? "nil")' on a nil UIBarButtonItem view.")
        }

    }

    /*
     * Assign badge with text,insets, and appearnce.
     */
    @available(*, deprecated, message: "Use badge(text: String!, appearnce:AppBadgeAppearnce)")
    public func badge(text badgeText: String!, badgeEdgeInsets: UIEdgeInsets!, appearnce: AppBadgeAppearnce) {
        if let view = getView() {
            view.badge(text: badgeText, badgeEdgeInsets: badgeEdgeInsets, appearnce: appearnce)
        } else {
            NSLog("Attempted setting badge with value '\(badgeText ?? "nil")' on a nil UIBarButtonItem view.")
        }
    }

    private func getView() -> UIView? {
        return value(forKey: "view") as? UIView
    }

}


/*
 * BadgeLabel - This class is made to avoid confusion with other subviews that might be of type UILabel.
 */
class BadgeLabel: UILabel { }

/*
 * AppBadgeAppearnce - This struct is used to design the badge.
 */
public struct AppBadgeAppearnce {
    public var textSize: CGFloat
    public var textAlignment: NSTextAlignment
    public var borderColor: UIColor
    public var borderWidth: CGFloat
    public var allowShadow: Bool
    public var backgroundColor: UIColor
    public var textColor: UIColor
    public var animate: Bool
    public var duration: TimeInterval
    public var distenceFromCenterY: CGFloat
    public var distenceFromCenterX: CGFloat

    public init() {
        textSize = 12
        textAlignment = .center
        backgroundColor = .red
        textColor = .white
        animate = true
        duration = 0.2
        borderColor = .clear
        borderWidth = 0
        allowShadow = false
        distenceFromCenterY = 0
        distenceFromCenterX = 0
    }

}

// Use
//To add a badge with default settings use this (This also applies to updating an existing badge):
//
//view.badge(text: "5")

//barButtonItem.badge(text: "7")

//To remove the badge:
//
//view.badge(text: nil)

//barButtonItem.badge(text: nil)

//Advanced Usage
//
//let badgeAppearnce = AppBadgeAppearnce()
//appearnce.backgroundColor = UIColor.blue //default is red
//appearnce.textColor = UIColor.white // default is white
//appearnce.alignment = .center //default is center
//appearnce.textSize = 15 //default is 12
//appearnce.distenceFromCenterX = 15 //default is 0
//appearnce.distenceFromCenterY = -10 //default is 0
//appearnce.allowShadow = true
//appearnce.borderColor = .blue
//appearnce.borderWidth = 1
//view.badge(text: "Your text", appearnce: badgeAppearnce)

