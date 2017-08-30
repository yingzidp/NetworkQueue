//
//  ModelDelegate.swift
//  NetworkRequestQueue
//
//  Created by apple on 16/10/19.
//  Copyright © 2016年 LJ. All rights reserved.
//

import Foundation

protocol ModelDelegate:NSObjectProtocol {
    
    func didSucceedOn(_ endpoint: String?, responseObject: AnyObject?, requestObject: NSDictionary?)
    
    func didFailOn(_ endpoint: String?, requestObject:NSDictionary?)
}
