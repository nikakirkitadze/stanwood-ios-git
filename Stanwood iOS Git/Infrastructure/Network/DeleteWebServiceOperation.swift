//
//  DeleteWebServiceOperation.swift
//  NetworkingLayer
//
//  Created by Nika Kirkitadze on 9/27/19.
//  Copyright © 2019 Nika Kirkitadze. All rights reserved.
//

import Foundation

class DeleteWebServiceOperation<T: Codable>: GetWebServiceOperation<T> {
    override var method: WebServiceOperation<T>.HttpMethod {
        return .DELETE
    }
}
