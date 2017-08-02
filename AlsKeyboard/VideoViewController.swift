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
    
    private var session = AVCaptureSession()
    private var alsEngine: ALSEngine?
    let wrapper = DlibWrapper()
    let layer = AVSampleBufferDisplayLayer()
    var currentMetadata: [AnyObject] = []
    let sampleQueue = DispatchQueue(label: "com.zweigraf.DisplayLiveSamples.sampleQueue", attributes: [])
    let faceQueue = DispatchQueue(label: "com.zweigraf.DisplayLiveSamples.faceQueue", attributes: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alsEngine = ALSEngine(withKeyboardDelegate: ProcessViewController(imageView: preview))
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        
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
        
        // For iphone7
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
        connection.isVideoMirrored = false
        
        if !currentMetadata.isEmpty {
            let boundsArray = currentMetadata
                .flatMap { $0 as? AVMetadataFaceObject }
                .map { (faceObject) -> NSValue in
                    let convertedObject = captureOutput.transformedMetadataObject(for: faceObject, connection: connection)
                    return NSValue(cgRect: convertedObject!.bounds)
            }
            
            wrapper?.doWork(on: sampleBuffer, inRects: boundsArray)
        }
        
        layer.enqueue(sampleBuffer)
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didDrop sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        currentMetadata = metadataObjects as [AnyObject]
    }
}

