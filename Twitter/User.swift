//
//  User.swift
//  Twitter
//
//  Created by Nehal Doshi on 4/12/17.
//  Copyright (c) 2017 CodePath. All rights reserved.
//

import UIKit
import AFNetworking

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {

    var name: String
    var screenname: String
    var profileImageUrl: URL
    var tagline: String
    var dictionary: NSDictionary

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary

        self.name = dictionary["name"] as! String
        self.screenname = dictionary["screen_name"] as! String
        self.profileImageUrl = URL(string: (dictionary["profile_image_url"] as! String).replacingOccurrences(of: "_normal", with: "_bigger"))!
        self.tagline = dictionary["description"] as! String
    }

    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()

        NotificationCenter.default.post(name: Notification.Name(rawValue: userDidLogoutNotification), object: nil)
    }

    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = UserDefaults.standard.object(forKey: currentUserKey) as? Data
                if data != nil {
                    do{
                    var dictionary = try JSONSerialization.jsonObject(with: data!,options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary as NSDictionary)
                    }
                    catch{
                        print(error)
                    }
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user

            if _currentUser != nil {
                do{
                let data = try JSONSerialization.data(withJSONObject: user!.dictionary)
                UserDefaults.standard.set(data, forKey: currentUserKey)
                }
                catch{
                    print(error)
                }
                
            } else {
                UserDefaults.standard.set(nil, forKey: currentUserKey)
            }
            UserDefaults.standard.synchronize()
        }
    }

}
