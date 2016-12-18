//
//  FrameBuffer.swift
//  Bugreporter
//
//  Created by Leo Thomas on 31/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import AVFoundation

struct Frame {
    var data: Data
    var timeStamp: CMTime
}

class FrameBuffer: RingBuffer<Frame> {
    
    var waitingForFrames = false
    
    lazy var assetWriterInput: AVAssetWriterInput = {
        let outputSettings: [String: Any] = [AVVideoCodecKey: AVVideoCodecH264,
                                                   AVVideoWidthKey: 720,
                                                   AVVideoHeightKey: 320]
        
        let input = AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: outputSettings)
        input.expectsMediaDataInRealTime = false
        return input
    }()
    
    lazy var assetWriter: AVAssetWriter? = { [unowned self] in
        do {
            let url = AttachmentManager.getURL(for: .video, name: "\(Date().toString())")
            let assetWriter = try AVAssetWriter(url: url, fileType: AVFileTypeMPEG4)
            assetWriter.add(self.assetWriterInput)
            return assetWriter
        } catch {
            print(error)
            return nil
        }
        }()
    
    override func append(element: Frame) {
        if waitingForFrames {
            super.append(element: element)
        }
    }
    
    private func getPixelBuffer(at index : Int) -> (pixelBuffer: CVPixelBuffer, presentationTime: CMTime)? {
        guard index >= 0, index < elements.count else { return nil }
        guard let frame = elements[index] else { return nil}
        let mutableData = NSMutableData(data: frame.data)
        let refCon = NSMutableData()
        let allocator: Unmanaged<CFAllocator>! = CFAllocatorGetDefault()
        
        var imageBuffer: CVPixelBuffer?
        
        let status = CVPixelBufferCreateWithBytes(allocator.takeRetainedValue(), 750, 1334, 846624121, mutableData.mutableBytes, 1504, nil, refCon.mutableBytes, nil, &imageBuffer)
        
        if status == kCVReturnSuccess, let pixelBuffer = imageBuffer {
            return (pixelBuffer, frame.timeStamp)
        } else {
            print("Creating PixelBuffer for data failed with error: \(status)")
            return nil
        }
    }
    
    var writingIndex = 0
    var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor?
    func write() {
        guard !elements.isEmpty else { return }
        waitingForFrames = false
        pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterInput, sourcePixelBufferAttributes: nil)
        
        assetWriter?.startWriting()
        assetWriter?.startSession(atSourceTime: kCMTimeZero)
        
        assetWriterInput.requestMediaDataWhenReady(on: DispatchQueue(label: "saveVideoQueue"), using: {
            [weak self] in
            guard let strongSelf = self else { return }
            while strongSelf.assetWriterInput.isReadyForMoreMediaData {
                if let frame = strongSelf.getPixelBuffer(at: strongSelf.writingIndex) {
                    strongSelf.pixelBufferAdaptor?.append(frame.pixelBuffer, withPresentationTime: frame.presentationTime)
                    strongSelf.writingIndex += 1
                } else {
                    strongSelf.assetWriterInput.markAsFinished()
                    strongSelf.assetWriter?.finishWriting {
                        print("finished writing")
                    }
                    break
                }
            }
            })
    }
    
}
