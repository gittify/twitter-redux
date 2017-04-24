//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Doshi, Nehal on 4/22/17.
//  Copyright © 2017 CodePath. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProfileViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tweetsCount: UILabel!
    
   
    @IBOutlet weak var followersCount: UILabel!
    
    @IBOutlet weak var followingCount: UILabel!
  
    var statuses: [Status]?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("in profile view controller")

        tableView.dataSource = self
        tableView.delegate = self

        loadStatuses()
        
        self.tweetsCount.text = "150 "
        self.followingCount.text = "75"
        self.followersCount.text = "35"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadStatuses() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        TwitterClient.sharedInstance.userTimelineWithParams(nil, completion: { (statuses, error) -> () in
            if self.tableView.pullToRefreshView != nil {
                self.tableView.pullToRefreshView.stopAnimating()
            }
            self.statuses = statuses
            print("got data")
            self.tableView.reloadData()
            
            DispatchQueue.main.async(execute: { () -> Void in
                MBProgressHUD.hide(for: self.view, animated: true)
                return ()
            })
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("dequeuing")
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
}
