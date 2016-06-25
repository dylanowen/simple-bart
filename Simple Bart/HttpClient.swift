//
//  HttpClient.swift
//  Simple Bart
//
//  Created by Dylan Owen on 6/21/16.
//  Copyright © 2016 Dylan Owen. All rights reserved.
//

import Foundation

import Alamofire
import AEXML

public enum BackendError: ErrorType {
    case Network(error: NSError)
    case DataSerialization(reason: String)
    case ObjectSerialization(reason: String)
    case XMLSerialization(error: NSError)
    case ApiError(text: String, details: String)
}

extension Request {
    public static func XMLResponseSerializer() -> ResponseSerializer<AEXMLDocument, BackendError> {
        return ResponseSerializer { request, response, data, error in
            guard error == nil else { return .Failure(.Network(error: error!)) }
            
            guard let validData = data else {
                return .Failure(.DataSerialization(reason: "Data could not be serialized. Input data was nil."))
            }
            
            do {
                let XML = try AEXMLDocument(xmlData: validData)
                return .Success(XML)
            } catch {
                return .Failure(.XMLSerialization(error: error as NSError))
            }
        }
    }
    
    public func responseXMLDocument(completionHandler: Response<AEXMLDocument, BackendError> -> Void) -> Self {
        return response(responseSerializer: Request.XMLResponseSerializer(), completionHandler: completionHandler)
    }
}

public protocol ResponseXMLSerializable {
    init?(response: NSHTTPURLResponse, representation: AEXMLDocument)
}

extension Request {
    public func responseObject<T: ResponseXMLSerializable>(completionHandler: Response<T, BackendError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<T, BackendError> { request, response, data, error in
            guard error == nil else { return .Failure(.Network(error: error!)) }
            
            let xmlResponseSerializer = Request.XMLResponseSerializer()
            let result = xmlResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                //test for a bart api error
                let errorElement = value.root["message"]["error"]
                if (errorElement.error == nil) {
                    return .Failure(.ApiError(text: errorElement["text"].stringValue, details: errorElement["details"].stringValue))
                }
                
                if let response = response, responseObject = T(response: response, representation: value)
                {
                    return .Success(responseObject)
                } else {
                    return .Failure(.ObjectSerialization(reason: "XML could not be serialized into response object: \(value)"))
                }
            case .Failure(let error):
                return .Failure(error)
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
