//
//  TwitterClient.swift
//  Twitter
//
//  Created by Nehal Doshi on 04/13/17.
//  Copyright (c) 2017 CodePath. All rights reserved.
//

import AFNetworking

import BDBOAuth1Manager
import MBProgressHUD
import UIKit

let twitterConsumerKey = "dOoxwVFdMicbtw5Jj5fMdF6cJ"//"4QHE4kyiC3c3T1U1KW4oc7PFt"
let twitterConsumerSecret = "zY8kVj7XnbBL1JiwxeFziExs2fpkDdAHaAmR0iaQUgHpaEEGZi" //"BDsANeiRZjbi5FwKgh7FwQ56dGBIPKq4AFPXRRMMS3ZWyCcZx8"
let twitterBaseURL = URL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {

    var loginCompletion: ((_ user: User?, _ error: NSError?) -> ())?

    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance!
    }

    func homeTimelineWithParams(_ params: NSDictionary?, completion: @escaping (_ statuses: [Status]?, _ error: NSError?) -> ()) {
        self.get("1.1/statuses/home_timeline.json", parameters: nil, progress:nil,success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let statuses = Status.statusesWithArray(response as! [NSDictionary])
            completion(statuses, nil)
        }, failure: { (task: URLSessionDataTask?, error: Error!) -> Void in
            print("error getting home timeline")
            completion(nil, error as NSError?)
        })
    }

    func mentionsWithParams(_ params: NSDictionary?, completion: @escaping (_ statuses: [Status]?, _ error: NSError?) -> ()) {
        self.get("1.1/statuses/home_timeline.json", parameters: nil, progress:nil,success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let statuses = Status.statusesWithArray(response as! [NSDictionary])
            completion(statuses, nil)
        }, failure: { (task: URLSessionDataTask?, error: Error!) -> Void in
            print("error getting mentions timeline")
            completion(nil, error as NSError?)
        })
    }
    
    func userTimelineWithParams(_ params: NSDictionary?, completion: @escaping (_ statuses: [Status]?, _ error: NSError?) -> ()) {
        self.get("1.1/statuses/user_timeline.json", parameters: nil, progress:nil,success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let statuses = Status.statusesWithArray(response as! [NSDictionary])
            completion(statuses, nil)
        }, failure: { (task: URLSessionDataTask?, error: Error!) -> Void in
            print("error getting mentions timeline")
            completion(nil, error as NSError?)
        })
    }
    
    
    func postStatusUpdateWithParams(_ params: NSDictionary?, completion: @escaping (_ status: Status?, _ error: NSError?) -> ()) {
        self.post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let status = Status(dictionary: response as! NSDictionary)
            completion(status, nil)
        }) { (task: URLSessionDataTask?, error: Error!) -> Void in
            print("error posting status update")
            completion(nil, error as NSError?)
        }
    }

    func loginWithCompletion(_ completion: @escaping (_ user: User?, _ error: NSError?) -> ()) {
        self.loginCompletion = completion

        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "cptwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            print("Got the request token")
            print(requestToken?.token)
            let tStr = requestToken?.token as String!
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(tStr!)")
            UIApplication.shared.openURL(authURL as! URL)
        }) {
            (error: Error?) -> Void in
            print("Failed to get request token")
            self.loginCompletion?(nil, error as NSError?)
        }
    }

    func openURL(_ url: URL) {
        self.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential?) -> Void in
            print("Got the access token!")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil,success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print("user: \(user.name)")
                self.loginCompletion?(user, nil)
            }, failure: { (task: URLSessionDataTask?, error: Error?) -> Void in
                print("error getting current user")
                self.loginCompletion?(nil, error as NSError?)
            })
        }) { (error: Error?) -> Void in
            print("Failed to receive access token")
            self.loginCompletion?(nil, error as NSError?)
        }
    }

}
