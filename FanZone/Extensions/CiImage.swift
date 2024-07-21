//
//  CiImage.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 01/07/2024.
//

import Foundation
import UIKit

extension CIImage {
    func resize(targetSize: CGSize) -> CIImage? {
        let scaleX = targetSize.width / self.extent.size.width
        let scaleY = targetSize.height / self.extent.size.height
        return self.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
    }
    
    func pixelBuffer() -> CVPixelBuffer? {
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.extent.width), Int(self.extent.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess else { return nil }
        
        let ciContext = CIContext()
        ciContext.render(self, to: pixelBuffer!)
        return pixelBuffer
    }
}
