//
//  HamburgerViewController.swift
//  Twitter
//
//  Created by Doshi, Nehal on 4/22/17.
//  Copyright © 2017 CodePath. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuView: UIView!
    var originalLeftMargin: CGFloat!
    var centerNavigationController: UINavigationController!
    
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentVC){
            view.layoutIfNeeded()
            if oldContentVC != nil {
                oldContentVC.willMove(toParentViewController: nil)
                oldContentVC.view.removeFromSuperview()
                oldContentVC.didMove(toParentViewController: nil)
            }
          
            /*
            centerNavigationController = UINavigationController(rootViewController: contentViewController)
         //   view.addSubview(centerNavigationController.view)
            addChildViewController(centerNavigationController)
            
            centerNavigationController.didMove(toParentViewController: self)
           */
            
            contentViewController.willMove(toParentViewController: self)
            
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
            
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
            )
        }
    }

    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in:view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == UIGestureRecognizerState.began{
            originalLeftMargin = leftMarginConstraint.constant
        }
        else if sender.state == UIGestureRecognizerState.changed{
            leftMarginConstraint.constant = originalLeftMargin + translation.x
        }
        else if sender.state == UIGestureRecognizerState.ended{
            
            UIView.animate(withDuration: 0.3, animations:
                
                {
                    if velocity.x > 0 {
                        self.leftMarginConstraint.constant = self.view.frame.size.width - 50
                    }
                    else{
                        self.leftMarginConstraint.constant = 0
                    }
                    self.view.layoutIfNeeded()
            }
            )
        }
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

}
