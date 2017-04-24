//
//  StatusViewController.swift
//  Twitter
//
//  Created by Nehal Doshi on 4/12/17.
//  Copyright (c) 2017 CodePath. All rights reserved.
//

import UIKit
import AFNetworking

class StatusViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var statusTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var retweetNumberLabel: UILabel!
    @IBOutlet weak var favoriteNumberLabel: UILabel!

    var status: Status?

    override func viewDidLoad() {
        print("inside sstatuts VC")
        super.viewDidLoad()

        self.navigationItem.title = "Tweet"

        self.profileImage.setImageWith((self.status?.user.profileImageUrl)!)
        self.profileImage.layer.cornerRadius = 9.0
        self.profileImage.layer.masksToBounds = true
        self.nameLabel.text = self.status?.user.name
        self.screennameLabel.text = "@\(self.status!.user.screenname)"
        self.statusTextLabel.text = self.status?.text

        var formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy 'at' h:mm aaa"
        self.dateLabel.text = formatter.string(from: self.status!.createdAt as Date)

        self.retweetNumberLabel.text = "\(self.status!.numberOfRetweets)"
        self.favoriteNumberLabel.text = "\(self.status!.numberOfFavorites)"
    }

}
