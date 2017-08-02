//
//  ViewController.swift
//  faceKeyboard
//
//  Created by Guven Bolukbasi on 14/07/2017.
//  Copyright © 2017 dorianlabs. All rights reserved.
//

import UIKit
import Vision
import AVFoundation

class VisionViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    private var session = AVCaptureSession()
    private var requests = [VNRequest]()
    private var alsEngine: ALSEngine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alsEngine = ALSEngine(withKeyboardDelegate: ProcessViewController(imageView: imageView))
        
        setupCamera()
        startFaceDetection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupCamera(maxFpsDesired: Double = 240) {
        session.sessionPreset = AVCaptureSession.Preset.photo
        let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
        
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera!)
            session.addInput(input)
        } catch {
            print("Error: can't access camera")
            return
        }
        
        do {
            var finalFormat: AVCaptureDevice.Format? = nil
            var maxFps: Double = 0
            
            for vFormat in frontCamera!.formats {
                var ranges = vFormat.videoSupportedFrameRateRanges
                let frameRates = ranges[0]
                
                if frameRates.maxFrameRate >= maxFps && frameRates.maxFrameRate <= maxFpsDesired {
                    maxFps = frameRates.maxFrameRate
                    finalFormat = vFormat
                }
            }
            if maxFps != 0 {
                let timeValue = Int64(1200.0 / maxFps)
                let timeScale: Int32 = 1200
                try frontCamera!.lockForConfiguration()
                frontCamera!.activeFormat = finalFormat!
                frontCamera!.activeVideoMinFrameDuration = CMTimeMake(timeValue, timeScale)
                frontCamera!.activeVideoMaxFrameDuration = CMTimeMake(timeValue, timeScale)
                frontCamera!.unlockForConfiguration()
            }
        }
        catch {
            print("Something was wrong")
        }
        
        let deviceOutput = AVCaptureVideoDataOutput()
        deviceOutput.alwaysDiscardsLateVideoFrames = true
        deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        let concurrentQueue = DispatchQueue(label:"com.swift3.imageQueue")
        deviceOutput.setSampleBufferDelegate(self, queue: concurrentQueue)
        
        if session.canAddOutput(deviceOutput) {
            session.addOutput(deviceOutput)
        }
        
        let imageLayer = AVCaptureVideoPreviewLayer(session: session)
        imageLayer.frame = imageView.bounds
        imageView.layer.addSublayer(imageLayer)
        imageLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill;
        
        session.startRunning()
    }
    
    override func viewDidLayoutSubviews() {
        imageView.layer.sublayers?[0].frame = imageView.bounds
    }
    
    func startFaceDetection() {
        let faceRequest = VNDetectFaceLandmarksRequest(completionHandler: self.detectFaceHandler)
        self.requests = [faceRequest]
    }
    
    func detectFaceHandler(request: VNRequest, error: Error?) {
        if error == nil {
            guard let observations = request.results else {
                print("no result")
                return
            }
            
            let result = observations.map({$0 as? VNFaceObservation})
            
            DispatchQueue.main.async() {
                for region in result {
                    guard let rg = region else {
                        continue
                    }
                    
                    self.highlightFaces(face: [rg])
                }
            }
        } else {
            print("No face")
        }
    }
    
    func highlightFaces(face: [VNFaceObservation]) {
        for faceObservation in face {
            guard let landmarks = faceObservation.landmarks else {
                continue
            }
            
            let boundingRect = faceObservation.boundingBox
            let convertedFaceRect = CGRect(x: imageView.frame.size.width * boundingRect.origin.x,
                                           y: imageView.frame.size.height * (1 - boundingRect.origin.y - boundingRect.height),
                                           width: imageView.frame.size.width * boundingRect.width,
                                           height: imageView.frame.size.height * boundingRect.height)
            
            if let allFaceLandmarks = landmarks.allPoints {
                self.captureCommand(boundingRect: convertedFaceRect, faceLandmarkRegions: allFaceLandmarks)
                self.drawOnImage(boundingRect: convertedFaceRect, faceLandmarkRegions: allFaceLandmarks)
            }
        }
    }
    
    func captureCommand(boundingRect: CGRect, faceLandmarkRegions: VNFaceLandmarkRegion2D) {
        var points: [CGPoint] = []
        for i in 0..<faceLandmarkRegions.pointCount {
            let point = faceLandmarkRegions.point(at: i)
            let p = CGPoint(x: CGFloat(point.x), y: CGFloat(point.y))
            points.append(p)
        }
        
        let mappedPoints = points.map { point in
            return CGPoint(x: boundingRect.minX + point.x * boundingRect.width,
                           y: boundingRect.minY + (1 - point.y) * boundingRect.height)
        }
        
        let sdkInput = SDKInput(faceCoordinates: mappedPoints)
        alsEngine!.process(sdkInput: sdkInput)
    }
    
    func drawOnImage(boundingRect: CGRect, faceLandmarkRegions: VNFaceLandmarkRegion2D) {
        self.imageView.layer.sublayers?.removeSubrange(1...)
        
        var points: [CGPoint] = []
        for i in 0..<faceLandmarkRegions.pointCount {
            let point = faceLandmarkRegions.point(at: i)
            let p = CGPoint(x: CGFloat(point.x), y: CGFloat(point.y))
            points.append(p)
        }
        
        let mappedPoints = points.map { point in
            return CGPoint(x: boundingRect.minX + point.x * boundingRect.width,
                           y: boundingRect.minY + (1 - point.y) * boundingRect.height)
        }
        
        for (isKey, isValue) in mappedPoints.enumerated() {
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: isValue.x, y: isValue.y), radius: CGFloat(2), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            shapeLayer.fillColor = UIColor.yellow.cgColor
            shapeLayer.strokeColor = UIColor.clear.cgColor
            shapeLayer.lineWidth = 2.0
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.center = CGPoint(x: isValue.x + 9, y: isValue.y)
            label.textColor = UIColor.red
            label.textAlignment = .center
            label.text = "\(isKey)"
            
            imageView.addSubview(label)
            imageView.layer.addSublayer(shapeLayer)
        }
    }
}

extension VisionViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        var requestOptions:[VNImageOption : Any] = [:]
        
        if let camData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
            requestOptions = [.cameraIntrinsics:camData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 5)!, options: requestOptions)
        
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
}
