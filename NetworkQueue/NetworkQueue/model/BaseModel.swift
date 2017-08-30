//
//  BaseModel.swift
//  NetworkRequestQueue
//
//  Created by apple on 16/10/19.
//  Copyright © 2016年 LJ. All rights reserved.
//

import UIKit


class BaseModel: NSObject{
    
    var notificationCenter: NotificationCenter!
    
    override init() {
        super.init();
    
        self.notificationCenter = NotificationCenter.default
    }
    
    public func postSuccessNotificationOn(endpoint: String?, requestObject: NSDictionary?, data: NSDictionary?) {
        
        let notificationInfo: NSMutableDictionary = NSMutableDictionary.init();
        notificationInfo.setObject(endpoint as Any, forKey: NOTIFICATION_SUCCESS_KEY_FOR_REQUEST_BODY as NSCopying)
        notificationInfo.setObject(requestObject as Any, forKey: NOTIFICATION_REQUEST_BODY_KEY as NSCopying)
        for (key, value) in data! {
            notificationInfo.setObject(value, forKey: key as! NSCopying);
        }
        let successNotification: Notification = Notification.init(name: Notification.Name(rawValue: endpoint!), object: self, userInfo: notificationInfo as? [AnyHashable : Any])
        self.notificationCenter.post(successNotification)
    }
    
    public func postErrorNotificationOn(endpoint: NSString?, requestObject: NSDictionary?, responseObject: NSDictionary?) {
        let notificationInfo: NSMutableDictionary = NSMutableDictionary.init();
        notificationInfo.setValue(requestObject, forKey:NOTIFICATION_FAILURE_KEY_FOR_REQUEST_BODY)
        notificationInfo.setValue(responseObject?.object(forKey: "msg"), forKey: NOTIFICATION_RESPONSE_ERROR_CODE_KEY)
        let failureNotification: NSNotification = NSNotification.init(name: Notification.Name(rawValue: endpoint! as String), object: self, userInfo: notificationInfo as? [AnyHashable : Any])
        self.notificationCenter.post(failureNotification as Notification);
    }
    
    public func postErrorNotificationOn(endpoint: NSString?, requestObject: NSDictionary?) {
        let notificationInfo: NSMutableDictionary = NSMutableDictionary.init()
        notificationInfo.setValue(requestObject, forKey:NOTIFICATION_FAILURE_KEY_FOR_REQUEST_BODY)
        let failureNotification: NSNotification = NSNotification.init(name: Notification.Name(rawValue: endpoint! as String), object: self, userInfo: notificationInfo as? [AnyHashable : Any])
        self.notificationCenter.post(failureNotification as Notification);
    }
}
