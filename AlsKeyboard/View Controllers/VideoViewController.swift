//
//  ViewController.swift
//  DisplayLiveSamples
//
//  Created by Luis Reisewitz on 15.05.16.
//  Copyright © 2016 ZweiGraf. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController {
    
    @IBOutlet weak var preview: UIView!
    @IBOutlet weak var writeMessageLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var session = AVCaptureSession()
    var alsEngine: ALSEngine?
    let wrapper = DlibWrapper()
    let layer = AVSampleBufferDisplayLayer()
    var currentMetadata: [AnyObject] = []
    let sampleQueue = DispatchQueue(label: "com.zweigraf.DisplayLiveSamples.sampleQueue", attributes: [])
    let faceQueue = DispatchQueue(label: "com.zweigraf.DisplayLiveSamples.faceQueue", attributes: [])
    
    var lastFrameDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alsEngine = ALSEngine(withKeyboardDelegate: ProcessViewController(view: preview, writeMessage: writeMessageLabel, message: messageLabel))
        
        setupCamera()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        preview.frame = preview.bounds
        layer.frame = preview.bounds
        preview.layer.addSublayer(layer)
        view.layoutIfNeeded()
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
    }
    
    func setupCamera(maxFpsDesired: Double = 240) {
        let frontCamera = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
        
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera!)
            session.addInput(input)
        }
        catch {
            print("Error: can't access camera")
            return
        }
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: sampleQueue)
        
        let metaOutput = AVCaptureMetadataOutput()
        metaOutput.setMetadataObjectsDelegate(self, queue: faceQueue)
        
        session.beginConfiguration()
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        if session.canAddOutput(metaOutput) {
            session.addOutput(metaOutput)
        }
        
        if UserHardware.IS_IPAD {
            session.sessionPreset = AVCaptureSessionPresetPhoto
        }
        else {
            session.sessionPreset = AVCaptureSessionPreset1280x720
        }

        session.commitConfiguration()
        
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        metaOutput.metadataObjectTypes = [AVMetadataObjectTypeFace]
        wrapper?.prepare()
        
        session.startRunning()
    }
}

extension VideoViewController: AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        connection.videoOrientation = AVCaptureVideoOrientation.portrait
        connection.isVideoMirrored = true
        
        var shouldWeProcess: Bool = false
        
        if lastFrameDate == nil {
            shouldWeProcess = true
        } else {
            let difference = diff(firstDate: lastFrameDate!, secondDate: Date())
            if difference > 80 {
                shouldWeProcess = true
            }
        }
        
        if shouldWeProcess {
            
            if !self.currentMetadata.isEmpty {
                let boundsArray = self.currentMetadata.flatMap { $0 as? AVMetadataFaceObject }.map { (faceObject) -> NSValue in
                        let convertedObject = captureOutput.transformedMetadataObject(for: faceObject, connection: connection)
                        return NSValue(cgRect: convertedObject!.bounds)
                }
                
                if let points = self.wrapper?.doWork(on: sampleBuffer, inRects: boundsArray) {
                    var mappedPoints: [CGPoint] = []
                    for i in stride(from: 0, to: points.count, by: 2) {
                        let x: Int = points.object(at: i) as! Int
                        let y: Int = points.object(at: i + 1) as! Int
                        mappedPoints.append(CGPoint(x: x, y: y))
                    }
                    
                    let sdkInput = SDKInput(faceCoordinates: mappedPoints)
                    alsEngine?.startTyping()
                    self.alsEngine!.process(sdkInput: sdkInput)
                }
            }
            self.layer.enqueue(sampleBuffer)
            lastFrameDate = Date()
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didDrop sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        currentMetadata = metadataObjects as [AnyObject]
    }
    
    func diff(firstDate:Date, secondDate:Date) -> Int {
        let difference = firstDate.millisecondsSince1970 - secondDate.millisecondsSince1970
        return abs(Int(difference))
    }
}
