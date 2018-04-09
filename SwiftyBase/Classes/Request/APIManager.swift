//
//  APIManager.swift
//  Pods
//
//  Created by MacMini-2 on 01/09/17.
//
//

import Foundation
import MobileCoreServices

public enum Result {
    case Success(response: AnyObject?, error: AnyObject?)
    case Error(error: AnyObject?)
    case Internet(isOn: Bool)
}

private var _baseURL: String! = ""

//  MARK: - Server APIManager -

open class APIManager {

    static let instance: APIManager = APIManager()

    open class var shared: APIManager {
        return instance
    }

    @IBInspectable open var baseUrlString: String {
        get {
            return _baseURL
        }
        set {
            _baseURL = newValue
        }
    }

    open func getRequest(URL url: String, Parameter param: NSDictionary, completionHandler: @escaping (_ result: Result) -> ()) {
        AppUtility.isNetworkAvailableWithBlock { (isAvailable) in
            if isAvailable == true {
                completionHandler(Result.Internet(isOn: true))

                var requestURL: String! = _baseURL + url
                _ = [
                    "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
                    "Accept": "application/json"
                ]

                print("---------------------")
                print("Request :- \(param .JSONString())")
                print("Request URL :- \(requestURL!)")
                print("---------------------")

                var request = URLRequest(url: URL(string: requestURL)!)
                request.httpMethod = "get"
                let strings: String = param.JSONString() as String
                request.httpBody = strings.data(using: .utf8)

                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else { // check for fundamental networking error
                        print("error=\(String(describing: error))")

                        completionHandler(Result.Error(error: self.handleFailure(error: error!)))
                        return
                    }

                    if let httpResponse = response as? HTTPURLResponse {

                        let httpStatus = self.getHTTPStatusCode(httpResponse)

                        print("HTTP Status Code: \(httpStatus.rawValue) \(httpStatus)")

                        if httpStatus.rawValue != 200 {

                            let baseError: BaseError! = BaseError()

                            baseError.errorCode = String(httpStatus.rawValue)
                            baseError.alertMessage = String(describing: httpStatus)
                            baseError.serverMessage = String(describing: httpStatus)

                            completionHandler(Result.Error(error: baseError))
                        }
                        else {

                            DispatchQueue.main.async {
                                do {
                                    let dicResponse: NSDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] as NSDictionary

                                    //print("Response : \((dicResponse) .JSONString())")

                                    completionHandler(Result.Success(response: (dicResponse) .JSONString(), error: nil))

                                } catch {
                                    completionHandler(Result.Error(error: self.handleFailure(error: error)))
                                }
                            }
                        }
                    }


                }
                task.resume()


                requestURL = nil

            }
            else {
                completionHandler(Result.Internet(isOn: false))
            }
        }
    }

    open func postRequest(URL url: String, Parameter param: NSDictionary, completionHandler: @escaping (_ result: Result) -> ()) {
        AppUtility.isNetworkAvailableWithBlock { (isAvailable) in
            if isAvailable == true {
                completionHandler(Result.Internet(isOn: true))

                var requestURL: String! = _baseURL! + url
                _ = [
                    "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
                    "Accept": "application/json"
                ]

                print("---------------------")
                print("Request :- \(param .JSONString())")
                print("Request URL :- \(requestURL!)")
                print("---------------------")

                var request = URLRequest(url: URL(string: requestURL)!)
                request.httpMethod = "post"
                let strings: String = param.JSONString() as String
                request.httpBody = strings.data(using: .utf8)

                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else { // check for fundamental networking error
                        print("error=\(String(describing: error))")

                        completionHandler(Result.Error(error: self.handleFailure(error: error!)))
                        return
                    }

                    if let httpResponse = response as? HTTPURLResponse {

                        let httpStatus = self.getHTTPStatusCode(httpResponse)
                        print("HTTP Status Code: \(httpStatus.rawValue) \(httpStatus)")

                        if httpStatus.rawValue != 200 {

                            let baseError: BaseError! = BaseError()

                            baseError.errorCode = String(httpStatus.rawValue)
                            baseError.alertMessage = String(describing: httpStatus)
                            baseError.serverMessage = String(describing: httpStatus)

                            completionHandler(Result.Error(error: baseError))
                        }
                        else {

                            DispatchQueue.main.async {
                                do {
                                    let dicResponse: NSDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] as NSDictionary

                                    //print("Response : \((dicResponse) .JSONString())")

                                    completionHandler(Result.Success(response: (dicResponse) .JSONString(), error: nil))


                                } catch {
                                    completionHandler(Result.Error(error: self.handleFailure(error: error)))
                                }
                            }

                        }
                    }
                }
                task.resume()


                requestURL = nil

            }
            else {
                completionHandler(Result.Internet(isOn: false))
            }
        }
    }

    open func uploadImage (url: String, Parameter param: NSDictionary, Images arrImage: NSArray, completionHandler: @escaping (_ result: Result) -> ()) -> Void
    {

        AppUtility.isNetworkAvailableWithBlock { (isAvailable) in

            if isAvailable == true {
                completionHandler(Result.Internet(isOn: true))
                var requestURL: String! = url
                _ = [
                    "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
                    "Accept": "application/json"
                ]

                print("---------------------")
                print("Request :- \(param .JSONString())")
                print("Request URL :- \(requestURL!)")
                print("---------------------")

                var request: URLRequest
                do {
                    request = try self.createRequest(param, requestURL: _baseURL + url, Image: arrImage)

                } catch {
                    print(error)
                    return
                }

                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else { // check for fundamental networking error
                        print("error=\(String(describing: error))")

                        completionHandler(Result.Error(error: self.handleFailure(error: error!)))
                        return
                    }

                    if let httpResponse = response as? HTTPURLResponse {

                        let httpStatus = self.getHTTPStatusCode(httpResponse)
                        print("HTTP Status Code: \(httpStatus.rawValue) \(httpStatus)")

                        if httpStatus.rawValue != 200 {

                            let baseError: BaseError! = BaseError()
                            baseError.errorCode = String(httpStatus.rawValue)
                            baseError.alertMessage = String(describing: httpStatus)
                            baseError.serverMessage = String(describing: httpStatus)

                            completionHandler(Result.Error(error: baseError))
                        }
                        else {
                            DispatchQueue.main.async {
                                do {
                                    let dicResponse: NSDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] as NSDictionary

                                    //print("Response : \((dicResponse) .JSONString())")

                                    completionHandler(Result.Success(response: (dicResponse) .JSONString(), error: nil))


                                } catch {
                                    completionHandler(Result.Error(error: self.handleFailure(error: error)))
                                }
                            }

                        }
                    }
                }
                task.resume()


                requestURL = nil

            }
            else {
                completionHandler(Result.Internet(isOn: false))
            }
        }
    }

    /// Create request
    ///
    /// - parameter userid:   The userid to be passed to web service
    /// - parameter password: The password to be passed to web service
    /// - parameter email:    The email address to be passed to web service
    ///
    /// - returns:            The NSURLRequest that was created

    private func createRequest(_ parameter: NSDictionary, requestURL: String, Image: NSArray) throws -> URLRequest {
        let parameters = parameter // build your dictionary however appropriate

        let boundary = generateBoundaryString()

        let url = URL(string: requestURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpBody = try createBody(with: parameters as? [String: String], filePathKey: "file", paths: [Image], boundary: boundary)

        return request
    }

    /// Create body of the multipart/form-data request
    ///
    /// - parameter parameters:   The optional dictionary containing keys and values to be passed to web service
    /// - parameter filePathKey:  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
    /// - parameter paths:        The optional array of file paths of the files to be uploaded
    /// - parameter boundary:     The multipart/form-data boundary
    ///
    /// - returns:                The NSData of the body of the request

    private func createBody(with parameters: [String: String]?, filePathKey: String, paths: [NSArray], boundary: String) throws -> Data {
        var body = Data()

        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }

        for imageInfo in paths
        {
            let dicInfo: NSDictionary! = imageInfo[0] as? NSDictionary

            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(dicInfo["name"] as! String)\"; filename=\"\(dicInfo["fileName"] as! String)\"\r\n")
            body.append("Content-Type: \(dicInfo["type"] as! String)\r\n\r\n")
            body.append(dicInfo["data"] as! Data)
            body.append("\r\n")

        }

        body.append("--\(boundary)--\r\n")
        return body
    }

    /// Create boundary string for multipart/form-data request
    ///
    /// - returns:            The boundary string that consists of "Boundary-" followed by a UUID string.

    private func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

    /// Determine mime type on the basis of extension of a file.
    ///
    /// This requires MobileCoreServices framework.
    ///
    /// - parameter path:         The path of the file for which we are going to determine the mime type.
    ///
    /// - returns:                Returns the mime type if successful. Returns application/octet-stream if unable to determine mime type.

    private func mimeType(for path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension

        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }


    private func handleResponse(response: AnyObject) -> (BaseError?, AnyObject?) {

        var baseError: BaseError! = BaseError.getError(responseObject: response)

        if baseError.errorCode == "1" || baseError.errorCode == "200" { // 1 is success code, here we need to set success code as per project and api backend. its may 1 or 200, depend on API

            var modelResponse: AnyObject! = response

            defer {
                modelResponse = nil
                baseError = nil
            }
            return (baseError, modelResponse)
        }
        else {
            defer {
                baseError = nil
            }
            return (baseError, nil)
        }
    }

    private func handleFailure(error: Error) -> BaseError {

        print("Error : \(error.localizedDescription)")

        var baseError: BaseError! = BaseError()

        switch error._code {
        case NSURLErrorTimedOut:
            baseError.errorCode = String(error._code)
            baseError.alertMessage = "Server is not responding please try again after some time."
            baseError.serverMessage = "Server is not responding please try again after some time."
            break
        case NSURLErrorNetworkConnectionLost:
            baseError.errorCode = String(error._code)
            baseError.alertMessage = "Network connection lost try again."
            baseError.serverMessage = "Network connection lost try again."
            break
        default:
            baseError.errorCode = String(-1)
            baseError.alertMessage = "Something wants wrong please try again leter."
            baseError.serverMessage = "Something wants wrong please try again leter."
            break
        }

        defer {
            baseError = nil
        }
        return baseError
    }

    /**
     Get the HTTP status code of the request reponse.
     
     - Parameter httpURLResponse: the reponse that will contain the response code.
     - Returns: HTTPStatusCode status code of HTTP response.
     */
    func getHTTPStatusCode(_ httpURLResponse: HTTPURLResponse) -> HTTPStatusCode {
        var httpStatusCode: HTTPStatusCode!

        for status in HTTPStatusCode.getAll {
            if httpURLResponse.statusCode == status.rawValue {
                httpStatusCode = status
            }
        }

        return httpStatusCode
    }

    // Use with Almofire parameters
    // let parameterString : String = self.getURLString(fromDictionary: param)
    // requset.httpBody = parameterString .data(using: String.Encoding.utf8)
    // requset.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    private func getURLString(fromDictionary dictionary: NSDictionary) -> String {
        var urlStringWithDetailsArray = [Any]()

        for (key, value) in dictionary {

            if value is NSNumber {
                urlStringWithDetailsArray.append("\(key)=\(String(value as! Int).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)")
            }
            else if value is NSArray {
                urlStringWithDetailsArray.append("\(key)=\((value as! NSArray).JSONString())")
            }
            else {
                urlStringWithDetailsArray.append("\(key)=\((value as! String).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)")
            }
        }

        return (urlStringWithDetailsArray as NSArray).componentsJoined(by: "&")
    }

}


/**
 Enum for HTTP response codes.
 */
public enum HTTPStatusCode: Int {

    //1xx Informationals
    case `continue` = 100
    case switchingProtocols = 101

    //2xx Successfuls
    case ok = 200
    case created = 201
    case accepted = 202
    case nonAuthoritativeInformation = 203
    case noContent = 204
    case resetContent = 205
    case partialContent = 206

    //3xx Redirections
    case multipleChoices = 300
    case movedPermanently = 301
    case found = 302
    case seeOther = 303
    case notModified = 304
    case useProxy = 305
    case unused = 306
    case temporaryRedirect = 307

    //4xx Client Errors
    case badRequest = 400
    case unauthorized = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case proxyAuthenticationRequired = 407
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case lengthRequired = 411
    case preconditionFailed = 412
    case requestEntityTooLarge = 413
    case requestURITooLong = 414
    case unsupportedMediaType = 415
    case requestedRangeNotSatisfiable = 416
    case expectationFailed = 417

    //5xx Server Errors
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case httpVersionNotSupported = 505

    static let getAll = [
        `continue`,
        switchingProtocols,
        ok,
        created,
        accepted,
        nonAuthoritativeInformation,
        noContent,
        resetContent,
        partialContent,
        multipleChoices,
        movedPermanently,
        found,
        seeOther,
        notModified,
        useProxy,
        unused,
        temporaryRedirect,
        badRequest,
        unauthorized,
        paymentRequired,
        forbidden,
        notFound,
        methodNotAllowed,
        notAcceptable,
        proxyAuthenticationRequired,
        requestTimeout,
        conflict,
        gone,
        lengthRequired,
        preconditionFailed,
        requestEntityTooLarge,
        requestURITooLong,
        unsupportedMediaType,
        requestedRangeNotSatisfiable,
        expectationFailed,
        internalServerError,
        notImplemented,
        badGateway,
        serviceUnavailable,
        gatewayTimeout,
        httpVersionNotSupported
    ]

}
