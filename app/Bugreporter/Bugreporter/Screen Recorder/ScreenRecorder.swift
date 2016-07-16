//
//  ScreenRecorder.swift
//  Bugreporter
//
//  Created by Leo Thomas on 12/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa
import AVFoundation

extension AVCaptureDevice {
    
    var isiOS: Bool {
        return modelID == "iOS Device"
    }
    
    var dimension: CGSize {
        
        if let description = activeFormat.formatDescription {
            let dimension = CMVideoFormatDescriptionGetDimensions(description)
            return CGSize(width: Int(dimension.width), height: Int(dimension.height))
        }
        
        return CGSize.zero
    }
    
}

extension AVCaptureInput {
    
    var dimension: CGSize {
        if let port = ports.first as? AVCaptureInputPort {
            if let description = port.formatDescription {
                let dimension = CMVideoFormatDescriptionGetDimensions(description)
                return CGSize(width: Int(dimension.width), height: Int(dimension.height))
            }
            
        }
        
        return CGSize.zero
    }
    
}

protocol ScreenRecorderDelegate: class {
    
    /// gets called when the recording was interrupted because of a lost connection
    func recordinginterrupted()
    
    /// gets called when previewLayer size did Change
    func sizeDidChanged(newSize: CGSize)
    
}

final class ScreenRecorder: NSObject {
    
    weak var delegate: ScreenRecorderDelegate?
    
    var isRecording = false
    
    var device: AVCaptureDevice
    var deviceSize: CGSize {
        didSet {
            if deviceSize != CGSize.zero {
                delegate?.sizeDidChanged(newSize: deviceSize)
            }
        }
    }
    
    private var session: AVCaptureSession
    private var imageOutput: AVCaptureStillImageOutput?
    private var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor?
    
    private var frameNumber: Int64 = 0
    private var sessionID: UUID
    
    lazy var assetWriterInput: AVAssetWriterInput = {
        let outputSettings: [String: AnyObject] = [AVVideoCodecKey: AVVideoCodecH264,
                                                   AVVideoWidthKey: self.deviceSize.width,
                                                   AVVideoHeightKey: self.deviceSize.height]
        
        return  AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: outputSettings)
    }()
    
    lazy var assetWriter: AVAssetWriter? = { [unowned self] in
        do {
            let url = AttachmentManager.shared.getURL(for: .video, name: "test")!
            let assetWriter = try AVAssetWriter(url: url, fileType: AVFileTypeMPEG4)
            assetWriter.add(self.assetWriterInput)
            return assetWriter
        } catch {
            print(error)
            return nil
        }
    }()
    

    
    var sessionLayer: AVCaptureVideoPreviewLayer?  {
        
        get {
            if !session.isRunning {
                configureSession()
            }
            return AVCaptureVideoPreviewLayer(session: session)
        }
        
    }
    
    init(device: AVCaptureDevice, delegate: ScreenRecorderDelegate?) {
        self.device = device
        self.delegate = delegate
        session = AVCaptureSession()
        sessionID = UUID()
        deviceSize = CGSize(width: 320, height: 640)
        super.init()
        configureInputFotmatChangeNotifications()
    }
    
    /// starts a recording
    func start() {
        isRecording = true
        
        ScreenRecorderManager.shared.add(recorder: self)
        
        frameNumber = 0
        
        pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterInput, sourcePixelBufferAttributes: nil)
        
        assetWriter?.startWriting()
        assetWriter?.startSession(atSourceTime: kCMTimeZero)
    }
    
    /// stops and saves recording
    ///
    /// - parameter interrupted: pass true if the recording was stopped by a lost connection
    func stop(interrupted: Bool = false) {
        isRecording = false
        assetWriter?.finishWriting(completionHandler: {
            print("finished")
        })
        
        ScreenRecorderManager.shared.remove(recorder: self)
        
        if interrupted {
            delegate?.recordinginterrupted()
        }
        
        if delegate == nil {
            finnishSession()
        }
    }
    
    func finnishSession() {
        session.stopRunning()
    }
    
    func screenshot()  {
        
        if let connection = imageOutput?.connection(withMediaType: AVMediaTypeVideo){
            imageOutput!.captureStillImageAsynchronously(from: connection, completionHandler: { (buffer, error) in
                
                if let buffer = buffer,
                    let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer) {
                        let url = AttachmentManager.shared.getURL(for: .image, name: "test")!
                        try! data.write(to: url)
                    
                } else {
                    print("taking screenshot failed")
                }
            })
        }
    }
    
    private func configureSession() {
        
        imageOutput = AVCaptureStillImageOutput()
        imageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        session.addOutput(imageOutput)
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            } else {
                print("cannot add input")
            }
        } catch {
            print(error)
        }
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "ScreencastBufferQueue"))
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        } else {
            print("cannot add output")
        }
        
        session.startRunning()
    }
    
    private func configureInputFotmatChangeNotifications() {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: nil) { [weak self] (notification) in
            guard let port = notification.object as? AVCaptureInputPort else { return }
            
            if let description = port.formatDescription {
                let dimension = CMVideoFormatDescriptionGetDimensions(description)
                let size = CGSize(width: Int(dimension.width), height: Int(dimension.height))
                self?.deviceSize = size
            }
        }
    }
    
}

extension ScreenRecorder: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        
        if assetWriterInput.isReadyForMoreMediaData {
            
            pixelBufferAdaptor?.append(imageBuffer, withPresentationTime: CMTimeMake(frameNumber, 60))
        }
        
        frameNumber += 1
        
    }
    
}
