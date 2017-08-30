//
//  ViewController.swift
//  NetworkQueue
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 LJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func signInClick(_ sender: AnyObject) {
//        let signInVC = SignInTableViewController();
//        let naivVC = UINavigationController.init(rootViewController: signInVC);
//        self.present(naivVC, animated: true, completion: nil)
        UserModel.shareUserModel.SignIn(account: "17773326368", password: "123456");
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        NotificationCenter.default.addObserver(self, selector: #selector(logIn), name: NSNotification.Name(rawValue: ENDPOINT_LOGIN), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        
        NotificationCenter.default.removeObserver(NSNotification.Name(rawValue: ENDPOINT_LOGIN));
    }
    
    
    func logIn(notification:NSNotification) {
        let userInfo = notification.userInfo;
        let userInfoDict:NSDictionary = userInfo?[ENDPOINT_LOGIN] as! NSDictionary;
        if((userInfoDict[ NOTIFICATION_SUCCESS_KEY_FOR_REQUEST_BODY]) != nil) {
            print("3333333");
        } else {
            print("432432424");
            if((userInfoDict[ NOTIFICATION_RESPONSE_ERROR_CODE_KEY]) != nil) {
                print((userInfoDict[NOTIFICATION_RESPONSE_ERROR_CODE_KEY])!);
            } else {
                
            }
        }
    }
}

