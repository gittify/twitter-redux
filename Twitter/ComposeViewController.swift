//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Nehal Doshi on 4/12/17.
//  Copyright (c) 2017 CodePath. All rights reserved.
//

import UIKit
import AFNetworking

class ComposeViewController: UIViewController, UITextViewDelegate {

    let MAX_CHARACTERS_ALLOWED = 140

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var remainingCharactersLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileImage.setImageWith((User.currentUser?.profileImageUrl)!)
        self.profileImage.layer.cornerRadius = 9.0
        self.profileImage.layer.masksToBounds = true
        self.nameLabel.text = User.currentUser?.name
        self.screennameLabel.text = "@\(User.currentUser!.screenname)"

        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidShow, object: nil, queue: nil) { (notification: Notification!) -> Void in
            let userInfo = notification.userInfo!
            let keyboardFrameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            self.view.frame = CGRect(x: 0, y: 0, width: keyboardFrameEnd.size.width, height: keyboardFrameEnd.origin.y)
        }

        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardDidHide, object: nil, queue: nil) { (notification: Notification!) -> Void in
            let userInfo = notification.userInfo!
            let keyboardFrameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            self.view.frame = CGRect(x: 0, y: 0, width: keyboardFrameEnd.size.width, height: keyboardFrameEnd.origin.y)
        }

        self.remainingCharactersLabel.text = "\(MAX_CHARACTERS_ALLOWED)"

        self.textView.becomeFirstResponder()
    }

    override func viewDidLayoutSubviews() {
        self.adjustScrollViewContentSize()
    }

    func textViewDidChange(_ textView: UITextView) {
        let status = textView.text
        let charactersRemaining = MAX_CHARACTERS_ALLOWED - (status?.characters.count)!
        self.remainingCharactersLabel.text = "\(charactersRemaining)"
        self.remainingCharactersLabel.textColor = charactersRemaining >= 0 ? .lightGray : .red
        self.adjustScrollViewContentSize()
    }

    func adjustScrollViewContentSize() {
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: self.textView.frame.origin.y + self.textView.frame.size.height)
    }

    @IBAction func onTweetTap(_ sender: AnyObject) {
        let status = self.textView.text
        if ((status?.characters.count) == 0) {
            return
        }

        let params: NSDictionary = [
            "status": status
        ]

        TwitterClient.sharedInstance.postStatusUpdateWithParams(params, completion: { (status, error) -> () in
            if error != nil {
                NSLog("error posting status: \(error)")
                return
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: TwitterEvents.StatusPosted), object: status)
            self.dismiss(animated: true, completion: nil)
        })
    }

    @IBAction func onCancelTap(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onScrollViewTap(_ sender: AnyObject) {
        self.textView.becomeFirstResponder()
    }

}
