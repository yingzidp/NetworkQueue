//
//  UserModel.swift
//  NetworkQueue
//
//  Created by apple on 17/3/9.
//  Copyright © 2017年 LJ. All rights reserved.
//


import UIKit

let ENDPOINT_LOGIN = "login" // 登陆接口


class UserModel: BaseModel, ModelDelegate {
    
    var token: String?;
    
    static let shareUserModel = UserModel();

    public func SignIn(account: String?, password: String?) {
        let dictionary = ["telephone":account, "password": password];
        
        let requestDictionary = RemoteDataResolver.shareResolver.plainRequestFor(endpoint: ENDPOINT_LOGIN, delegate: self, dictionary: dictionary as NSDictionary);
        RemoteDataResolver.shareResolver.sendManagedRequest(requestDictionary);
    }
    
    
    func didFailOn(_ endpoint: String?, requestObject: NSDictionary?) {
        self.postErrorNotificationOn(endpoint: endpoint as NSString?, requestObject: requestObject);
    }
    
    func didSucceedOn(_ endpoint: String?, responseObject: AnyObject?, requestObject: NSDictionary?) {
        let rect:Int = responseObject?.value(forKey: "ret") as! Int;
        print(rect);
        if(rect == 0) {
            let optionalDictionary: NSMutableDictionary = NSMutableDictionary.init();
            self.postSuccessNotificationOn(endpoint: endpoint, requestObject: requestObject, data: optionalDictionary);
        } else {
            self.postErrorNotificationOn(endpoint: endpoint as NSString?, requestObject: requestObject, responseObject: responseObject as! NSDictionary?);
        }
    }
    
}
