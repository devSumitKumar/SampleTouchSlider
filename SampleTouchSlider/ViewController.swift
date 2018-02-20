//
//  ViewController.swift
//  SampleTouchSlider
//
//  Created by Polosoft on 08/02/18.
//  Copyright © 2018 Sumit Kumar Khamari. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIGestureRecognizerDelegate {

    // IBOutlet
    @IBOutlet weak var lblSelctedValue: UILabel!
    @IBOutlet weak var imgvwSwipe: UIImageView!
    @IBOutlet weak var imgvwBack: UIImageView!
    //Constraints
    @IBOutlet weak var trailing_constraintForBackImg: NSLayoutConstraint!
    @IBOutlet weak var leading_constraintForBackImg: NSLayoutConstraint!
    @IBOutlet weak var leading_constraintForsliderImg: NSLayoutConstraint!

    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //to design or modify design contents after designing in storyboard
        setUpViewComponents()
    }
    
    //MARK: Design After StoryBoard
    func setUpViewComponents() -> Void {
        //adding pan gesture to the small slider icon
        let panGesture: UIGestureRecognizer? = UIPanGestureRecognizer()
        panGesture?.addTarget(self, action: #selector(ViewController.handlePan(panGesture:)))
        panGesture?.delegate = (self as UIGestureRecognizerDelegate)
        imgvwSwipe.addGestureRecognizer(panGesture!)
    }
    
    //MARK: Pan Gesture Methods
    @objc func handlePan( panGesture :UIPanGestureRecognizer) -> Void {
        if  panGesture.state == UIGestureRecognizerState.began {
        }
        else if panGesture.state == UIGestureRecognizerState.changed {
            let translation :CGPoint = panGesture.translation(in: self.view)
            //Update the constraint's constant
            leading_constraintForsliderImg.constant += translation.x
            
            // Assign the frame's position only for checking it's fully on the screen
            var recognizerFrame :CGRect = (panGesture.view?.frame)!
            recognizerFrame.origin.x = leading_constraintForsliderImg.constant
            
            // Check if UIImageView is completely inside its superView
            if !view.bounds.contains(recognizerFrame){
                leading_constraintForsliderImg.constant = 0
                if leading_constraintForsliderImg.constant < view.bounds.minX{
                    leading_constraintForsliderImg.constant = 0
                }
                else if leading_constraintForsliderImg.constant + recognizerFrame.width > view.bounds.minX{
                    leading_constraintForsliderImg.constant = view.bounds.width - recognizerFrame.width
                }
            }
            view.layoutIfNeeded()
        }
        else if panGesture.state == UIGestureRecognizerState.ended {
            let imgSliderPosX :CGFloat = imgvwSwipe.frame.origin.x
            
            let sliderBarCenter :CGFloat = imgvwBack.frame.size.width/2
            
            if imgSliderPosX > sliderBarCenter{
                UIView.animate(withDuration: 1.5, animations: {
                    self.leading_constraintForsliderImg.constant = self.view.frame.size.width - self.trailing_constraintForBackImg.constant - self.imgvwSwipe.frame.size.width
                    //female selcted
                    self.lblSelctedValue.text = "Female"
                })
            }
            else {
                UIView.animate(withDuration: 1.5, animations: {
                    self.leading_constraintForsliderImg.constant = self.leading_constraintForBackImg.constant
                    //male selcted
                    self.lblSelctedValue.text = "Male"
                })
            }
        }
        panGesture.setTranslation(CGPoint(x: 0, y: 0), in: view)
    }
    
    //MARK: Memory Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
