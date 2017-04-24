//
//  StatusTableViewCell.swift
//  Twitter
//
//  Created by Nehal Doshi on 4/12/17.
//  Copyright (c) 2017 CodePath. All rights reserved.
//

import UIKit
import NSDateMinimalTimeAgo.NSDate_MinimalTimeAgo
import AFNetworking

class StatusTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var statusTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    var status: Status? {
        willSet(newValue) {
            self.profileImage.setImageWith((newValue?.user.profileImageUrl)!)
            self.nameLabel.text = newValue?.user.name
            self.screennameLabel.text = "@\(newValue!.user.screenname)"
            self.statusTextLabel.text = newValue?.text
            self.timeLabel.text =  ""//  newValue?.createdAt.timeAgo()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.profileImage.layer.cornerRadius = 9.0
        self.profileImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }

}
