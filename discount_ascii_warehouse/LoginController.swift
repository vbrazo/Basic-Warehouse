//
//  loginController.swift
//  discount_ascii_warehouse
//
//  Created by Vitor Oliveira on 7/9/16.
//  Copyright © 2016 Vitor Oliveira. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import CoreLocation

class loginController : UIViewController, FBSDKLoginButtonDelegate {
    
    let loginView : FBSDKLoginButton = FBSDKLoginButton()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        loginView.delegate = self
    }
    
    @IBAction func btnFacebookClick(sender: AnyObject) {
        self.loginView.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
    }
    
    // Facebook Delegate Methods
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil) {
            // Process error
        } else if result.isCancelled {
            // Handle cancellations
        } else {
            if result.grantedPermissions.contains("email") {
                
                let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me",
                                                                         parameters: [ "fields": "email, name, gender, id, age_range, interested_in, birthday, picture.width(480).height(480)"] )
                graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                    
                    if ((error) != nil) {
                        print("Process error - Facebook login")
                        print("Error: \(error)")
                    } else {
                        
                        print(result)
                        
                        if let token = FBSDKAccessToken.currentAccessToken()?.tokenString {
                            print("token = \(token)")
                        }
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("WarehouseID")
                            self.presentViewController(vc, animated: false, completion: nil)
                        }
                        
                    }
                })
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
}