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

class ScreenRecorder: NSObject {
    
    var device: AVCaptureDevice
    var frameNumber: Int64 = 0

    var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor?
    lazy var assetWriterInput: AVAssetWriterInput = {
        let outputSettings: [String: AnyObject] = [AVVideoCodecKey: AVVideoCodecH264,
                                                   AVVideoWidthKey: 320,
                                                   AVVideoHeightKey: 640]
        
        return  AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: outputSettings)
    }()
    
    lazy var assetWriter: AVAssetWriter? = { [unowned self] in
        do {
            let assetWriter = try AVAssetWriter(url: self.getSaveURL()!, fileType: AVFileTypeMPEG4)
            assetWriter.add(self.assetWriterInput)
            return assetWriter
        } catch {
            print(error)
            return nil
        }
    }()
    
    var session: AVCaptureSession?
    
    var sessionLayer: AVCaptureVideoPreviewLayer?  {
        
        get {
            guard let session = session else { return nil }
            return AVCaptureVideoPreviewLayer(session: session)
        }
        
    }
    
    init(device: AVCaptureDevice) {
        self.device = device
    }
    
    func start() {
        
        frameNumber = 0
        session = AVCaptureSession()
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "ScreencastBufferQueue"))
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session!.canAddInput(input) {
                session?.addInput(input)
            } else {
                print("cannot add input")
            }
            
            if session!.canAddOutput(output) {
                session?.addOutput(output)
            } else {
                print("cannot add output")
            }
            
        } catch {
            print(error)
        }
        

        pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterInput, sourcePixelBufferAttributes: nil)
        session?.startRunning()
        assetWriter?.startWriting()
        assetWriter?.startSession(atSourceTime: kCMTimeZero)

        
    }
    
    func stop() {
        session?.stopRunning()
        assetWriter?.finishWriting(completionHandler: {
            print("finished")
        })
    }
    
    func getSaveURL() -> URL? {
        let urls = FileManager.default.urlsForDirectory(.documentDirectory, inDomains: .userDomainMask)
        let documentURL = urls[urls.count - 1]
        do {
            return try documentURL.appendingPathComponent("test.mp4")
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
            pixelBufferAdaptor?.append(imageBuffer, withPresentationTime: CMTimeMake(frameNumber, 25))
            
        }
        
        frameNumber += 1
        
    }
    
}
