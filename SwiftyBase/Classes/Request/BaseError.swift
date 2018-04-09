//
//  BaseError.swift
//  ViewControllerDemo
//
//  Created by SamSol on 01/07/16.
//  Copyright © 2016 SamSol. All rights reserved.
//

import Foundation

class BaseError: NSObject {

    // MARK: - Attributes -

    var errorCode: String = ""
    var serverMessage: String = ""
    var alertMessage: String = ""

    // MARK: - Lifecycle -

    deinit {

    }

    // MARK: - Public Interface -

    class func getError(responseObject: AnyObject) -> BaseError {

        let error: BaseError = BaseError()

        if let code = responseObject["error_code"] as? Int
            {
            error.errorCode = String(code)
        }
        else {
            error.errorCode = (responseObject["error_code"] as? String)!
        }

        if(error.errorCode == "") {
            error.errorCode = "1"
        }

        if let code = responseObject["message"] as? String
            {
            error.serverMessage = String(code)
        }
        else {
            error.serverMessage = ""
        }

        error.alertMessage = error.serverMessage

        print("---------------------")
        print("Error Code: %@", error.errorCode)
        print("Server Message: %@", error.serverMessage)

        print("Alert Message: %@", error.alertMessage)
        print("---------------------")

        return error

    }

    // MARK: - Internal Helpers -

}
