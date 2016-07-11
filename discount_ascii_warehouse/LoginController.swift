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
    
    let global = GlobalHelper()

    let loginView : FBSDKLoginButton = FBSDKLoginButton()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        // checks whether the user has an auth_token or not
        if let _ = self.global.defaults.stringForKey("auth_token") {
            self.goToFeed()
        } else {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        }
        
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
                        
                        var params = [String: AnyObject]()
                        
                        if let name = result.valueForKey("name") {
                            self.global.defaults.setObject(name.description, forKey: "name")
                            params["user[name]"] = name.description
                        }
                        
                        if let facebook_id = result.valueForKey("id") {
                            self.global.defaults.setObject(facebook_id.description, forKey: "facebook_id")
                            params["user[url_facebook_image]"] = facebook_id.description
                        }
                        
                        if let email = result.valueForKey("email") {
                            self.global.defaults.setObject(email.description, forKey: "email")
                            params["user[email]"] = email.description
                        }
                        
                        if let token = FBSDKAccessToken.currentAccessToken()?.tokenString {
                            params["user[facebook_token]"] = token
                        }
                        
                        self.global.request(ROUTES.facebook_auth, params: params, headers: nil, type: .POST) { (response) in
                            if let user_response = response[0] {
                                self.global.defaults.setObject(user_response["auth_token"].description, forKey: "auth_token")
                                self.goToFeed()
                            }
                        }
                        
                    }
                })
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func goToFeed(){
        dispatch_async(dispatch_get_main_queue()) {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("WarehouseID")
            self.presentViewController(vc, animated: false, completion: nil)
        }
    }
    
}