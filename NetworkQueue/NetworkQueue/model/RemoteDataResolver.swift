//
//  RemoteDataResolver.swift
//  NetworkRequestQueue
//
//  Created by apple on 16/10/19.
//  Copyright © 2016年 LJ. All rights reserved.
//

import UIKit

import Alamofire

class RemoteDataResolver: NSObject {
    static let shareResolver = RemoteDataResolver()
    
    var queueLock: NSLock?
    var requestQueue: NSMutableArray?
    var isProcessing: Bool = false
    
    fileprivate override init() {
        super.init()
        self.queueLock = NSLock()
        self.requestQueue = NSMutableArray()
    }
    
    public func plainRequestFor(endpoint: String?, delegate:ModelDelegate, dictionary: NSDictionary) -> NSDictionary {
        let requestDictionary:NSMutableDictionary? = NSMutableDictionary.init();
        requestDictionary?[REMOTEDATARESOLVER_ENDPOINT_KEY] = endpoint!;
        requestDictionary?[REMOTEDATARESOLVER_DELEGATE_KEY] = delegate;
        requestDictionary?[REMOTEDATARESOLVER_REQUESTBODY_KEY] = dictionary;
        requestDictionary?[REMOTEDATARESOLVER_REQUESTURL_KEY] = REMOTEDATA_BASE_URL + endpoint!;
        return requestDictionary!;
    }

    public func tokenRequestFor(endpoint: String,delegate: ModelDelegate, dictionary: NSDictionary) -> NSDictionary {
        let requestDictionary:NSMutableDictionary? = NSMutableDictionary.init();
        if (dictionary.count != 0) {
            requestDictionary?.setDictionary(dictionary as! [AnyHashable : Any]);
        }
        requestDictionary?["key"] = UserModel.shareUserModel.token;
        
        return RemoteDataResolver.shareResolver.plainRequestFor(endpoint: endpoint, delegate: delegate, dictionary: requestDictionary!);
    }
    
    func sendManagedRequest(_ dictionary: NSDictionary?){
        self.queueLock?.lock()
        if((dictionary) != nil) {
            self.requestQueue?.add(dictionary as Any)
        }
        if(self.isProcessing) {
            self.queueLock?.unlock()
            return
        }
        self.isProcessing = true;
        self.queueLock?.unlock()
        let dict: NSDictionary? = (self.requestQueue?.object(at: 0) as? NSDictionary)!
        let requestDict: NSDictionary = dict?.object(forKey: NOTIFICATION_REQUEST_BODY_KEY) as! NSDictionary
        let usrString : String = dict?.value(forKey: REMOTEDATARESOLVER_REQUESTURL_KEY) as! String;
        print(requestDict);
        print(usrString);
        Alamofire.request(usrString, method: .post, parameters: requestDict as? Parameters).responseJSON { (response) in
            switch response.result {
            case .success:
                let delegate = dict?.object(forKey: REMOTEDATARESOLVER_DELEGATE_KEY) as! ModelDelegate
                delegate.didSucceedOn(dict?.object(forKey: REMOTEDATARESOLVER_ENDPOINT_KEY) as! String?, responseObject: response.result.value as! NSDictionary?, requestObject: dict?.object(forKey: REMOTEDATARESOLVER_REQUESTBODY_KEY) as! NSDictionary?)
                self.queueLock?.lock()
                self.requestQueue?.removeObject(at: 0)
                self.isProcessing = false
                if (self.requestQueue?.count)! > 0 {
                    self.queueLock?.unlock()
                    self.sendManagedRequest(nil)
                } else {
                    self.queueLock?.unlock()
                }
                break
            case .failure:
                let delegate = dict?.object(forKey: REMOTEDATARESOLVER_DELEGATE_KEY) as! ModelDelegate
                delegate.didFailOn(dict?.object(forKey: REMOTEDATARESOLVER_ENDPOINT_KEY) as! String?, requestObject: dict?.object(forKey: REMOTEDATARESOLVER_REQUESTBODY_KEY) as! NSDictionary?)
                self.queueLock?.lock()
                self.requestQueue?.removeObject(at: 0)
                self.isProcessing = false
                if (self.requestQueue?.count)! > 0 {
                    self.queueLock?.unlock()
                    self.sendManagedRequest(nil)
                } else {
                    self.queueLock?.unlock()
                }
                break
            }
        }

    }
}
