//
//  ViewController.swift
//  Colouriser
//
//  Created by Group 1 on 1/1/18.
//  Copyright © 2018 Group 1. All rights reserved.
//
import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var screenCoverButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageViewX!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var breakButton: UIButton!
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var hotButton: UIButton!
    
    @IBOutlet weak var menuCurveImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuCurveImageView.image = #imageLiteral(resourceName: "MenuCurve")
        
        hideMenu()
    }
    
/* For GUI Basic Functions and Side MENU */
    @IBAction func menuTapped(_ sender: UIButton) {
        showMenu()
    }
    
    @IBAction func screenCoverTapped(_ sender: UIButton) {
        hideMenu()
    }
    
    // Show Menu Function
    func showMenu() {
        menuView.isHidden = false
        
        UIView.animate(withDuration: 0.7, animations: {
            self.screenCoverButton.alpha = 1
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.06, options: .curveEaseOut, animations: {
            self.menuCurveImageView.transform = .identity
        })
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.searchButton.transform = .identity
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.06, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.locationButton.transform = .identity
            self.breakButton.transform = .identity
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.12, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.alertButton.transform = .identity
        })

         UIView.animate(withDuration: 0.4, delay: 0.18, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.profileImageView.transform = .identity
            self.hotButton.transform = .identity
        })
    }
    
    // Hide Menu Function
    func hideMenu() {
        UIView.animate(withDuration: 0.7, animations: {
            self.screenCoverButton.alpha = 0
        })
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.profileImageView.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
            self.hotButton.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.08, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.alertButton.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.16, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.locationButton.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
            self.breakButton.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.08, options: .curveEaseOut, animations: {
            self.menuCurveImageView.transform = CGAffineTransform(translationX: -self.menuCurveImageView.frame.width, y: 0)
        })
        
        //This is for a search feature but will probly never be used - WB
        UIView.animate(withDuration: 0.4, delay: 0.21, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.searchButton.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
        }) { success in
            self.menuView.isHidden = true
        }
    }
}



