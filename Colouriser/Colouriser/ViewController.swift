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
    
    @IBOutlet weak var imgColouriserLogo: UIImageViewX!
    @IBOutlet weak var btnGallery: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnColourPicker: UIButton!
    @IBOutlet weak var btnAskAFriend: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    
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
        UIView.animate(withDuration: 0.4, delay: 0.14, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.btnSetting.transform = .identity
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.06, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.btnGallery.transform = .identity
            self.btnColourPicker.transform = .identity
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.12, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.btnAskAFriend.transform = .identity
        })

         UIView.animate(withDuration: 0.4, delay: 0.18, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.imgColouriserLogo.transform = .identity
            self.btnFilter.transform = .identity
        })
    }
    
    // Hide Menu Function
    func hideMenu() {
        UIView.animate(withDuration: 0.7, animations: {
            self.screenCoverButton.alpha = 0
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.08, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.imgColouriserLogo.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
            self.btnFilter.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.08, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.btnAskAFriend.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.16, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.btnGallery.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
            self.btnColourPicker.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.08, options: .curveEaseOut, animations: {
            self.menuCurveImageView.transform = CGAffineTransform(translationX: -self.menuCurveImageView.frame.width, y: 0)
        })
        
        //This is for a search feature but will probly never be used - WB
        UIView.animate(withDuration: 0.4, delay: 0.08, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.btnSetting.transform = CGAffineTransform(translationX: -self.menuView.frame.width, y: 0)
        }) { success in
            self.menuView.isHidden = true
        }
    }
}



