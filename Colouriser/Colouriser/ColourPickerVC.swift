//
//  ColourPickerVC.swift
//  Colouriser
//
//  Created by Vitaliy Krynytskyy on 27/02/2018.
//  Copyright © 2018 Mark Moeykens. All rights reserved.
//

import AVFoundation
import UIKit

class ColourPickerVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // live camera filter
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var orientation: AVCaptureVideoOrientation = .portrait
    let context = CIContext()
    
    let concurrentQueue = DispatchQueue(label: "colourPickerQueue", attributes: .concurrent)
    
    let syntehsiser = AVSpeechSynthesizer()
    var synthesiserEnabled: Bool = false;
    
    @IBOutlet weak var filteredImage: UIImageView!
    
    let recognizer = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.concurrentQueue.async {
            self.setupDevice()
            self.setupInputOutput()
        }
        
        filteredImage.isUserInteractionEnabled = true
        
        recognizer.addTarget(self, action: #selector(ColourPickerVC.screenHasbeenTapped))
        
        filteredImage.addGestureRecognizer(recognizer)
    }
    
    
    @IBAction func toggleColourToSpeech(_ sender: Any) {
        print("before ", synthesiserEnabled)
        synthesiserEnabled = !synthesiserEnabled
        print("after ", synthesiserEnabled)
    }
    
    @objc func screenHasbeenTapped() {
        print("screen tapped")
        if recognizer.state == UIGestureRecognizerState.recognized {
            //print(recognizer.location(in: filteredImage))
            
            let location = recognizer.location(in: filteredImage)
            let colour:UIColor = getPixelColorAtPoint(point: location, sourceView: filteredImage)
            //print(colour)
            
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            colour.getRed(&r, green: &g, blue: &b, alpha: &a)
            let red: Int = Int(r * 255.0)
            let green: Int = Int(g * 255.0)
            let blue: Int = Int(b * 255.0)
            var myString = "R: \(red) G: \(green) B: \(blue)"
            
//            print(myString)
            
            myString = getColourNameFromRGB(R: red, G: green, B: blue)

            //print("returned string = \(myString)")
            self.showToast(message: myString as String)
        }
    }
    
    func getPixelColorAtPoint(point: CGPoint, sourceView: UIView) -> UIColor {
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        
        sourceView.layer.render(in: context!)
        let color: UIColor = UIColor(red: CGFloat(pixel[0])/255.0,
                                     green: CGFloat(pixel[1])/255.0,
                                     blue: CGFloat(pixel[2])/255.0,
                                     alpha: CGFloat(pixel[3])/255.0)
        pixel.deallocate()
        return color
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 200, y: self.view.frame.size.height-100, width: 400, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func getColourNameFromRGB(R: Int , G: Int, B: Int) -> String{
        let scriptUrl = "http://www.thecolorapi.com/"
        let urlWithParams = scriptUrl + "id?rgb=\(R),\(G),\(B)"
        var colourName: String
        colourName = ""
        
        //print("urlString = \(urlWithParams)")
        
        guard let url = URL(string: urlWithParams) else { return "Error"}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            
            guard let data = data else { return }
            // Implement JSON Decoding and parsing
            do {
                // Decode retireved data with JSONDecoder
                let colourData = try JSONDecoder().decode(colour.self, from: data)
                
                //print(colourData)
                colourName = colourData.name.value
                //print("colour name = \(colourName)")
                DispatchQueue.main.async {
                    self.showToast(message: colourName as String)
                }
                //                self.showToast(message: colourName as String)
                //                return colourName

                if (self.synthesiserEnabled) {
                    let utterance = AVSpeechUtterance(string: colourName)
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                    utterance.rate = 0.5
                    
                    self.syntehsiser.speak(utterance)
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
        
        //        self.showToast(message: colourName as String)
        return colourName
        
    }
    
    struct colour: Codable {
        private enum CodingKeys : String, CodingKey { case name = "name" }
        var name : name
    }
    
    struct name: Codable {
        
        private enum CodingKeys: String, CodingKey {
            case value = "value"
            case closest_name_hex = "closest_named_hex"
            case exact_match_name = "exact_match_name"
            case distance = "distance"
        }
        var value: String
        var closest_name_hex: String
        var exact_match_name: Bool
        var distance: Int
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
            setupCorrectFramerate(currentCamera: currentCamera!)
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            //depending what format you choose, the speed at which the pixels get filtered increases
            captureSession.sessionPreset = AVCaptureSession.Preset.hd1280x720
            
            if captureSession.canAddInput(captureDeviceInput) {
                captureSession.addInput(captureDeviceInput)
            }
            let videoOutput = AVCaptureVideoDataOutput()
            
            videoOutput.setSampleBufferDelegate(self, queue: self.concurrentQueue)
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
                if frameRates.maxFrameRate == 240 {
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
        videoOutput.setSampleBufferDelegate(self, queue: self.concurrentQueue)
        
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let cameraImage = CIImage(cvImageBuffer: pixelBuffer!)
        
        DispatchQueue.main.async {
            // Show default camera image
            self.filteredImage.image = UIImage(ciImage: cameraImage)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) != .authorized {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {
                (authorized) in
                
                self.concurrentQueue.async {
                    if authorized {
                        self.setupInputOutput()
                    }
                }
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.concurrentQueue.async {
            self.captureSession.stopRunning()
        }
        
        print("stopping captureSession")
    }
}
