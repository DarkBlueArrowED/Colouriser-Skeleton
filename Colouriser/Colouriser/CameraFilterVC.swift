//
//  CameraFilterVC.swift
//  Colouriser
//
//  Created by Vitaliy Krynytskyy on 20/02/2018.
//  Copyright © 2018 Vitaliy Krynytskyy. All rights reserved.
//

import AVFoundation
import UIKit
import MessageUI

class CameraFilterVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, MFMessageComposeViewControllerDelegate {
    
    // live camera filter
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var orientation: AVCaptureVideoOrientation = .portrait
    let context = CIContext()

    @IBOutlet weak var filteredImage: UIImageView!
    
    
    override func viewDidLoad() {
        setupDevice()
        setupInputOutput()
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            }
            else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        
        currentCamera = backCamera
    }
    
    func setupInputOutput() {
        do {
            //setupCorrectFramerate(currentCamera: currentCamera!)
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            //depending what format you choose, the speed at which the pixels get filtered increases
            captureSession.sessionPreset = AVCaptureSession.Preset.low

            if captureSession.canAddInput(captureDeviceInput) {
                captureSession.addInput(captureDeviceInput)
            }
            let videoOutput = AVCaptureVideoDataOutput()
            
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate", attributes: []))
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            captureSession.startRunning()
        } catch {
            print(error)
        }
    }
    
    func setupCorrectFramerate(currentCamera: AVCaptureDevice) {
        for vFormat in currentCamera.formats {
            //see available types
            //print("\(vFormat) \n")
            
            var ranges = vFormat.videoSupportedFrameRateRanges as [AVFrameRateRange]
            let frameRates = ranges[0]
            
            do {
                //set to 240fps - available types are: 30, 60, 120 and 240 and custom
                // lower framerates cause major stuttering
                if frameRates.maxFrameRate == 60 {
                    try currentCamera.lockForConfiguration()
                    currentCamera.activeFormat = vFormat as AVCaptureDevice.Format
                    //for custom framerate set min max activeVideoFrameDuration to whatever you like, e.g. 1 and 180
                    currentCamera.activeVideoMinFrameDuration = frameRates.minFrameDuration
                    currentCamera.activeVideoMaxFrameDuration = frameRates.maxFrameDuration
                }
            }
            catch {
                print("Could not set active format")
                print(error)
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        connection.videoOrientation = orientation
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let cameraImage = CIImage(cvImageBuffer: pixelBuffer!)
        
        
        DispatchQueue.main.async {
            
            self.filteredImage.image = self.doShitWithGGBAImage(givenImage: cameraImage)
            
            // Show default camera image
            //self.filteredImage.image = UIImage(ciImage: cameraImage)
        }
    }
    
    func doShitWithGGBAImage(givenImage: CIImage) -> UIImage {
        
        let captureImage = convert(cmage: givenImage)
        
        let rgbaImage = RGBAImage(image: captureImage)
        
        let returnedImage = ImageProcess.setRGB(rgbaImage!, colourBlindness: "protanopia").toUIImage()
        
        return returnedImage!
    }
    
    func convert(cmage:CIImage) -> UIImage {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) != .authorized {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {
                (authorized) in
                DispatchQueue.main.async {
                    if authorized {
                        self.setupInputOutput()
                    }
                }
            })
        }
    }
    
    @IBAction func toggleFlashlight(_ sender: UISwitch) {
        
        switch sender.isOn {
            
        case true:
            print("turn on flashlight")
            
            do {
                try currentCamera?.lockForConfiguration()
                currentCamera?.torchMode = .on
                currentCamera?.unlockForConfiguration()
            }
            catch {
                print("Cannot enable flashlight")
            }
            
            break
            
        default:
            print("turn off flashlight")
            do {
                try currentCamera?.lockForConfiguration()
                currentCamera?.torchMode = .off
                currentCamera?.unlockForConfiguration()
            }
            catch {
                print("Cannot enable flashlight")
            }
            
            break
        }
    }
    
    func sendSmsToFriend() {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if MFMessageComposeViewController.canSendText() && MFMessageComposeViewController.canSendAttachments() {
            
            let smsController = MFMessageComposeViewController()
            
            smsController.body = "Can you please tell me what colour this is?"
            let screenshotImageData: Data = UIImagePNGRepresentation(screenshotImage!)!
            smsController.addAttachmentData(screenshotImageData, typeIdentifier: "data", filename: "screenshotImage.png")
            smsController.messageComposeDelegate = self
            self.present(smsController, animated: true, completion: nil)
            
        } else {
            print("User cannot send texts or attachments")
        }
    }
    
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        switch item.tag {
            
        case 0:
            break
            
        case 1:
            print("show options")
            // show options
            sendSmsToFriend()
            break
            
        default:
            break
        }
    }
   
    
}
