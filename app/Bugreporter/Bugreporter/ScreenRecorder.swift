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
    
}

final class ScreenRecorder: NSObject {
    
    weak var delegate: ScreenRecorderDelegate?
    
    var isRecording = false
    
    var device: AVCaptureDevice
    
    private var session: AVCaptureSession
    private var imageOutput: AVCaptureStillImageOutput?
    private var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor?
    
    private var frameNumber: Int64 = 0
    
    lazy var assetWriterInput: AVAssetWriterInput = {
        let outputSettings: [String: AnyObject] = [AVVideoCodecKey: AVVideoCodecH264,
                                                   AVVideoWidthKey: 320,
                                                   AVVideoHeightKey: 640]
        
        return  AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: outputSettings)
    }()
    
    lazy var assetWriter: AVAssetWriter? = { [unowned self] in
        do {
            
            let assetWriter = try AVAssetWriter(url: self.getSaveURL(typeName: "mp4")!, fileType: AVFileTypeMPEG4)
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
        super.init()
    }
    
    /// starts a recording
    func start() {
        isRecording = true
        
        ScreenRecorderManager.shared.add(recorder: self)
        
        frameNumber = 0
        
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
    }
    
    func finnishSession() {
        session.stopRunning()
    }
    
    func screenshot()  {
        
        if let connection = imageOutput?.connection(withMediaType: AVMediaTypeVideo){
            imageOutput!.captureStillImageAsynchronously(from: connection, completionHandler: { (buffer, error) in
                
                if let buffer = buffer,
                    let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer) {
                    
                        try! data.write(to: self.getSaveURL(typeName: "jpg")!)
                    
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
        
        pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterInput, sourcePixelBufferAttributes: nil)
        
        session.startRunning()
    }
    
    private func getSaveURL(typeName: String) -> URL? {
        let urls = FileManager.default.urlsForDirectory(.documentDirectory, inDomains: .userDomainMask)
        let documentURL = urls[urls.count - 1]
        do {
            return try documentURL.appendingPathComponent("test.\(typeName)")
        } catch {
            print(error)
            return nil
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
