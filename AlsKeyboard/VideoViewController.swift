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
    
    var session = AVCaptureSession()
    var alsEngine: ALSEngine?
    let wrapper = DlibWrapper()
    let layer = AVSampleBufferDisplayLayer()
    var currentMetadata: [AnyObject] = []
    let sampleQueue = DispatchQueue(label: "com.zweigraf.DisplayLiveSamples.sampleQueue", attributes: [])
    let faceQueue = DispatchQueue(label: "com.zweigraf.DisplayLiveSamples.faceQueue", attributes: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alsEngine = ALSEngine(withKeyboardDelegate: ProcessViewController(imageView: self.preview))
        
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
        } catch {
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
        
        // For iphone7 comment out for ipad
        session.sessionPreset = AVCaptureSessionPreset1280x720
        
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
        
        if !self.currentMetadata.isEmpty {
            let boundsArray = self.currentMetadata
                .flatMap { $0 as? AVMetadataFaceObject }
                .map { (faceObject) -> NSValue in
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
                self.alsEngine!.process(sdkInput: sdkInput)
            }
        }
        self.layer.enqueue(sampleBuffer)
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didDrop sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        currentMetadata = metadataObjects as [AnyObject]
    }
}
