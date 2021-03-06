//
//  ScreenRecorder.swift
//  Bugreporter
//
//  Created by Leo Thomas on 12/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import AVFoundation

extension Date {
    
    func toString() -> String {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        formatter.timeStyle = .long
        return formatter.string(from: self).replacingOccurrences(of: "/", with: ".")
    }
    
}

enum ScreenshotError: Error {
    case missingImageOutput
}


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

protocol ScreenRecorderDelegate: class {
    
    /// gets called when the recording was interrupted because of a lost connection
    func recordinginterrupted()
    
    /// gets called when previewLayer size did Change
    func sizeDidChanged(newSize: CGSize)
    
}

protocol RecordableDevice {
    
    var input: AVCaptureInput? { get }
    
    var name: String { get }
    
    var supported: Bool { get }
    
}

struct RecordableMac: RecordableDevice {
    
    var input: AVCaptureInput? {
        return AVCaptureScreenInput(displayID: CGMainDisplayID())
    }
    
    var name: String {
        return "Mac"
    }
    
    var supported: Bool {
        return true
    }
}

class ScreenRecorder: NSObject {
    
    weak var delegate: ScreenRecorderDelegate?
    
    var isRecording = false
    
    var device: RecordableDevice
    
    var deviceSize: CGSize {
        didSet {
            if deviceSize != CGSize.zero {
                delegate?.sizeDidChanged(newSize: deviceSize)
            }
        }
    }
    
    var settings: ScreenRecorderSettings
    
    private var session: AVCaptureSession
    private var imageOutput: AVCaptureStillImageOutput?
    var frameBuffer = FrameBuffer(length: 1000)
    
    private var sessionID: UUID
    
    
    var sessionLayer: AVCaptureVideoPreviewLayer?  {
        
        get {
            if !session.isRunning {
                configureSession()
            }
            guard !session.inputs.isEmpty else { return nil }
            return AVCaptureVideoPreviewLayer(session: session)
        }
        
    }
    
    init(device: RecordableDevice, delegate: ScreenRecorderDelegate?, settings: ScreenRecorderSettings) {
        self.device = device
        self.delegate = delegate
        self.settings = settings
        session = AVCaptureSession()
        sessionID = UUID()
        deviceSize = CGSize(width: 320, height: 640)
        super.init()
        configureInputFormatChangeNotifications()
    }
    
    /// starts a recording
    func start() {
        if !session.isRunning {
            configureSession()
        }
        isRecording = true
        
        ScreenRecorderManager.shared.add(recorder: self)
        
        frameBuffer.waitingForFrames = !session.inputs.isEmpty
    }
    
    /// stops and saves recording
    ///
    /// - parameter interrupted: pass true if the recording was stopped by a lost connection
    func stop(interrupted: Bool = false) {
        // TODO reset buffer after finishing recording
        isRecording = false
        ScreenRecorderManager.shared.remove(recorder: self)
        
        if interrupted {
            delegate?.recordinginterrupted()
        }
        
        if delegate == nil {
            finnishSession()
        }
        
        frameBuffer.write()
    }
    
    func finnishSession() {
        session.stopRunning()
    }
    
    func screenshot(with result: ((_ data: Data?, _ error: Error?) -> ())? = nil) {
        if !session.isRunning {
            configureSession()
        }
        
        guard let connection = imageOutput?.connection(withMediaType: AVMediaTypeVideo) else {
            result?(nil, ScreenshotError.missingImageOutput)
            return
        }
        
        imageOutput?.captureStillImageAsynchronously(from: connection, completionHandler: { (buffer, error) in
            if let buffer = buffer,
                let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer) {
                result?(data, error)
            } else {
                print("taking screenshot failed with error: \(error)")
                result?(nil, error)
            }
            return
        })
        result?(nil, nil)
    }
    
    private func configureSession() {
        
        imageOutput = AVCaptureStillImageOutput()
        imageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        session.addOutput(imageOutput)
        
        guard let input = device.input else { return }
        if session.canAddInput(input) {
            session.addInput(input)
        } else {
            print("cannot add input")
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
    
    private func configureInputFormatChangeNotifications() {
        
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
        
        guard frameBuffer.waitingForFrames else { return }
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let pixelLockFlag = CVPixelBufferLockFlags(rawValue: CVOptionFlags(0))
        
        CVPixelBufferLockBaseAddress(imageBuffer, pixelLockFlag)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        let baseAdress = CVPixelBufferGetBaseAddress(imageBuffer)
        
        let data = NSData(bytes: baseAdress, length: bytesPerRow * height)
        CVPixelBufferUnlockBaseAddress(imageBuffer, pixelLockFlag)
        
        let presentationTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        
        
        frameBuffer.append(element: Frame(data: data as Data, timeStamp: presentationTime))
        
    }
    
}
