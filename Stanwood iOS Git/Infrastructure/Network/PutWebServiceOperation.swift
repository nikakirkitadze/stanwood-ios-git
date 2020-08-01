//
//  PutWebServiceOperation.swift
//  NetworkingLayer
//
//  Created by Nika Kirkitadze on 9/27/19.
//  Copyright © 2019 Nika Kirkitadze. All rights reserved.
//

import Foundation

class PutWebServiceOperation<T: Codable> : PostWebServiceOperation<T> {
    override var method: WebServiceOperation<T>.HttpMethod {
        return .PUT
    }
}
