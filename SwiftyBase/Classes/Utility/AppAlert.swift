//
//  AppAlert.swift
//  Pods
//
//  Created by MacMini-2 on 31/08/17.
//
//

import Foundation

public class AppAlert {
    private var alertController: UIAlertController

    public init(title: String? = nil, message: String? = nil, preferredStyle: UIAlertControllerStyle) {
        self.alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
    }

    public func setTitle(_ title: String) -> Self {
        alertController.title = title
        return self
    }

    public func setMessage(_ message: String) -> Self {
        alertController.message = message
        return self
    }

    public func setPopoverPresentationProperties(sourceView: UIView? = nil, sourceRect: CGRect? = nil, barButtonItem: UIBarButtonItem? = nil, permittedArrowDirections: UIPopoverArrowDirection? = nil) -> Self {

        if let poc = alertController.popoverPresentationController {
            if let view = sourceView {
                poc.sourceView = view
            }
            if let rect = sourceRect {
                poc.sourceRect = rect
            }
            if let item = barButtonItem {
                poc.barButtonItem = item
            }
            if let directions = permittedArrowDirections {
                poc.permittedArrowDirections = directions
            }
        }

        return self
    }

    public func addAction(title: String = "", style: UIAlertActionStyle = .default, handler: @escaping ((UIAlertAction!) -> Void) = { _ in }) -> Self {
        alertController.addAction(UIAlertAction(title: title, style: style, handler: handler))
        return self
    }

    public func addTextFieldHandler(_ handler: @escaping ((UITextField!) -> Void) = { _ in }) -> Self {
        alertController.addTextField(configurationHandler: handler)
        return self
    }

    public func build() -> UIAlertController {
        return alertController
    }
}


////Used For Open AlertBox
//
//AppAlert(title: "Enter Tilte", message: "Please type message", preferredStyle: .alert)
//    .addAction(title: "NO", style: .cancel) { _ in
//        // action
//    }
//    .addAction(title: "Okay", style: .default) { _ in
//         // action
//    }
//    .build()
//    .show(animated: true)
//
// --------------------------------------------------------------------------------
//
////Used For ActionSheet Open
//
//if UIDevice.current.userInterfaceIdiom != .pad {
//    // Sample to show on iPad
//    AppAlert(title: "Question", message: "Are you sure?", preferredStyle: .actionSheet)
//        .addAction(title: "NO", style: .cancel) {_ in
//            print("No")
//        }
//        .addAction(title: "YES", style: .default) { _ in
//            print("Yes")
//        }
//        .build()
//        .showAlert(animated: true)
//} else {
//    // Sample to show on iPad
//    AppAlert(title: "Question", message: "Are you sure?", preferredStyle: .actionSheet)
//        .addAction(title: "Not Sure", style: .default) {
//            _ in
//            print("No")
//        }
//        .addAction(title: "YES", style: .default) { _ in
//           print("Yes")
//        }
//        .setPopoverPresentationProperties(sourceView: self, sourceRect: CGRect.init(x: 0, y: 0, width: 100, height: 100), barButtonItem: nil, permittedArrowDirections: .any)
//        .build()
//        .showAlert(animated: true)
//}
//
