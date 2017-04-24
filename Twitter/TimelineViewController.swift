//
//  TimelineViewController.swift
//  Twitter
//
//  Created by Nehal Doshi on 4/12/17.
//  Copyright (c) 2017 CodePath. All rights reserved.
//

import UIKit
import MBProgressHUD
import SVPullToRefresh

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var statuses: [Status]?

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: TwitterEvents.StatusPosted), object: nil, queue: nil) { (notification: Notification!) -> Void in
            let status = notification.object as! Status
            self.statuses?.insert(status, at: 0)
            self.tableView.reloadData()
        }

        loadStatuses()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.tableView.addPullToRefresh {
            TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (statuses, error) -> () in
                self.loadStatuses()
            })
        }
    }

    func loadStatuses() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (statuses, error) -> () in
            if self.tableView.pullToRefreshView != nil {
                self.tableView.pullToRefreshView.stopAnimating()
            }
            self.statuses = statuses
            self.tableView.reloadData()

            DispatchQueue.main.async(execute: { () -> Void in
                MBProgressHUD.hide(for: self.view, animated: true)
                return ()
            })
        })
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "statusCell") as! StatusTableViewCell
        cell.status = self.statuses?[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "StatusView") as! StatusViewController
        controller.status = self.statuses![indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statuses?.count ?? 0
    }

    @IBAction func onLogout(_ sender: AnyObject) {
        User.currentUser?.logout()
    }

}
