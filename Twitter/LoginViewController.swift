//
//  ViewController.swift
//  Twitter
//
//  Created by Nehal Doshi on 4/12/17.
//  Copyright (c) 2017 CodePath. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func onLogin(_ sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            } else {
                // Handle login error
            }
        }

    }
}
