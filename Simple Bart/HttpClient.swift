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

public enum BackendError: Error {
    case network(error: Error)
    case dataSerialization(reason: String)
    case objectSerialization(reason: String)
    case xmlSerialization(error: Error)
    case apiError(text: String, details: String)
}

extension DataRequest {
    public static func XMLResponseSerializer() -> DataResponseSerializer<AEXMLDocument> {
        return DataResponseSerializer { request, response, data, error in
            guard error == nil else { return .failure(BackendError.network(error: error!)) }
            
            guard let validData = data else {
                return .failure(BackendError.dataSerialization(reason: "Data could not be serialized. Input data was nil."))
            }
            
            do {
                let XML = try AEXMLDocument(xml: validData)
                return .success(XML)
            } catch {
                return .failure(BackendError.xmlSerialization(error: error))
            }
        }
    }

    @discardableResult
    public func responseXMLDocument(_ completionHandler: @escaping (DataResponse<AEXMLDocument>) -> Void) -> Self {
        return .response(queue: nil, responseSerializer: DataRequest.XMLResponseSerializer(), completionHandler: completionHandler)
    }
}

public protocol ResponseXMLSerializable {
    init?(response: HTTPURLResponse, representation: AEXMLDocument)
}

extension DataRequest {
    @discardableResult
    public func responseObject<T: ResponseXMLSerializable>(_ completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            guard error == nil else { return .failure(BackendError.network(error: error!)) }
            
            let xmlResponseSerializer = DataRequest.XMLResponseSerializer()
            let result = xmlResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .success(let value):
                //test for a bart api error
                let errorElement = value.root["message"]["error"]
                if (errorElement.error == nil) {
                    return .failure(BackendError.apiError(text: errorElement["text"].string, details: errorElement["details"].string))
                }
                
                if let response = response, let responseObject = T(response: response, representation: value)
                {
                    return .success(responseObject)
                } else {
                    return .failure(BackendError.objectSerialization(reason: "XML could not be serialized into response object: \(value)"))
                }
            case .failure(let error):
                return .failure(error)
            }
        }

        return .response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
