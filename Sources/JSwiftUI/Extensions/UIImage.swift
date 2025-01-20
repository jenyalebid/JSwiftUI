//
//  UIImage.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 1/15/25.
//

import UIKit
import Accelerate

public extension UIImage {
    
    func averageColor() -> UIColor? {
        // Downscale to 1×1
        let size = CGSize(width: 1, height: 1)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        draw(in: CGRect(origin: .zero, size: size))
        
        guard let context = UIGraphicsGetCurrentContext(),
              let data = context.data else {
            return nil
        }
        
        // Each pixel is in RGBA format
        let rgba = data.bindMemory(to: UInt8.self, capacity: 4)
        let r = CGFloat(rgba[0]) / 255
        let g = CGFloat(rgba[1]) / 255
        let b = CGFloat(rgba[2]) / 255
        let a = CGFloat(rgba[3]) / 255
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

import UIKit
import Accelerate

public extension UIImage {
    func dominantColors(count: Int) -> [UIColor] {
        DominantColorCalculator().dominantColors(image: self, count: count)
    }
}

class DominantColorCalculator {
    
    /// A structure that represents a centroid.
    struct Centroid {
        /// The red channel value.
        var red: Float
        
        /// The green channel value.
        var green: Float
        
        /// The blue channel value.
        var blue: Float
        
        /// The number of pixels assigned to this cluster center.
        var pixelCount: Int = 0
    }
    
    let dimension = 256
    let channelCount = 3
    
    var redStorage: UnsafeMutableBufferPointer<Float>
    var redBuffer: vImage.PixelBuffer<vImage.PlanarF>
    
    var greenStorage: UnsafeMutableBufferPointer<Float>
    var greenBuffer: vImage.PixelBuffer<vImage.PlanarF>
    
    var blueStorage: UnsafeMutableBufferPointer<Float>
    var blueBuffer: vImage.PixelBuffer<vImage.PlanarF>
    
    var centroids = [Centroid]()
    
    init() {
        redStorage = UnsafeMutableBufferPointer<Float>.allocate(capacity: dimension * dimension)
        redBuffer = vImage.PixelBuffer<vImage.PlanarF>(
            data: redStorage.baseAddress!,
            width: dimension,
            height: dimension,
            byteCountPerRow: dimension * MemoryLayout<Float>.stride)
        
        greenStorage = UnsafeMutableBufferPointer<Float>.allocate(capacity: dimension * dimension)
        greenBuffer = vImage.PixelBuffer<vImage.PlanarF>(
            data: greenStorage.baseAddress!,
            width: dimension,
            height: dimension,
            byteCountPerRow: dimension * MemoryLayout<Float>.stride)
        
        blueStorage = UnsafeMutableBufferPointer<Float>.allocate(capacity: dimension * dimension)
        blueBuffer = vImage.PixelBuffer<vImage.PlanarF>(
            data: blueStorage.baseAddress!,
            width: dimension,
            height: dimension,
            byteCountPerRow: dimension * MemoryLayout<Float>.stride)
    }
    
    deinit {
        redStorage.deallocate()
        greenStorage.deallocate()
        blueStorage.deallocate()
    }
    
    func dominantColors(image: UIImage, count: Int) -> [UIColor] {
        var rgbImageFormat = vImage_CGImageFormat(
            bitsPerComponent: 32,
            bitsPerPixel: 32 * 3,
            colorSpace: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(
                rawValue: kCGBitmapByteOrder32Host.rawValue |
                CGBitmapInfo.floatComponents.rawValue |
                CGImageAlphaInfo.none.rawValue))!
        
        guard let cgImage = image.cgImage else { return [] }
        
        let rgbSources: [vImage.PixelBuffer<vImage.PlanarF>] = try! vImage.PixelBuffer<vImage.InterleavedFx3>(
            cgImage: cgImage,
            cgImageFormat: &rgbImageFormat).planarBuffers()
        
        rgbSources[0].scale(destination: redBuffer)
        rgbSources[1].scale(destination: greenBuffer)
        rgbSources[2].scale(destination: blueBuffer)
        
        initializeCentroids(count: count)
        updateCentroids()
        
        return centroids.map {
            UIColor(red: CGFloat($0.red),
                    green: CGFloat($0.green),
                    blue: CGFloat($0.blue),
                    alpha: 1.0)
        }
    }
    
    func initializeCentroids(count: Int) {
        centroids.removeAll()
        
        let randomIndex = Int.random(in: 0 ..< dimension * dimension)
        centroids.append(Centroid(red: redStorage[randomIndex],
                                  green: greenStorage[randomIndex],
                                  blue: blueStorage[randomIndex]))
        
        let distances = UnsafeMutableBufferPointer<Float>.allocate(capacity: dimension * dimension)
        defer { distances.deallocate() }
        
        for i in 1 ..< count {
            distanceSquared(x0: greenStorage.baseAddress!, x1: centroids[i - 1].green,
                            y0: blueStorage.baseAddress!, y1: centroids[i - 1].blue,
                            z0: redStorage.baseAddress!, z1: centroids[i - 1].red,
                            n: greenStorage.count,
                            result: distances.baseAddress!)
            
            let randomIndex = weightedRandomIndex(distances)
            
            centroids.append(Centroid(red: redStorage[randomIndex],
                                      green: greenStorage[randomIndex],
                                      blue: blueStorage[randomIndex]))
        }
    }
    
    func updateCentroids() {
        var distances = UnsafeMutableBufferPointer<Float>.allocate(capacity: dimension * dimension * centroids.count)
        defer { distances.deallocate() }
        
        populateDistances(distances: &distances)
        let centroidIndices = makeCentroidIndices(distances: distances)
        
        for centroid in centroids.enumerated() {
            let indices = centroidIndices.enumerated().filter { $0.element == centroid.offset }.map { UInt($0.offset + 1) }
            
            centroids[centroid.offset].pixelCount = indices.count
            
            if !indices.isEmpty {
                let gatheredRed = vDSP.gather(redStorage, indices: indices)
                let gatheredGreen = vDSP.gather(greenStorage, indices: indices)
                let gatheredBlue = vDSP.gather(blueStorage, indices: indices)
                
                centroids[centroid.offset].red = vDSP.mean(gatheredRed)
                centroids[centroid.offset].green = vDSP.mean(gatheredGreen)
                centroids[centroid.offset].blue = vDSP.mean(gatheredBlue)
            }
        }
    }
    
    func populateDistances(distances: inout UnsafeMutableBufferPointer<Float>) {
        for centroid in centroids.enumerated() {
            distanceSquared(x0: greenStorage.baseAddress!, x1: centroid.element.green,
                            y0: blueStorage.baseAddress!, y1: centroid.element.blue,
                            z0: redStorage.baseAddress!, z1: centroid.element.red,
                            n: greenStorage.count,
                            result: distances.baseAddress!.advanced(by: dimension * dimension * centroid.offset))
        }
    }
    
    func makeCentroidIndices(distances: UnsafeMutableBufferPointer<Float>) -> [Int32] {
        let distancesDescriptor = BNNSNDArrayDescriptor(
            data: distances,
            shape: .matrixRowMajor(dimension * dimension, centroids.count))!
        
        let centroidIndicesDescriptor = BNNSNDArrayDescriptor.allocateUninitialized(
            scalarType: Int32.self,
            shape: .matrixRowMajor(dimension * dimension, 1))
        defer { centroidIndicesDescriptor.deallocate() }
        
        let reductionLayer = BNNS.ReductionLayer(function: .argMin,
                                                 input: distancesDescriptor,
                                                 output: centroidIndicesDescriptor,
                                                 weights: nil)
        
        try! reductionLayer?.apply(batchSize: 1,
                                   input: distancesDescriptor,
                                   output: centroidIndicesDescriptor)
        
        return centroidIndicesDescriptor.makeArray(of: Int32.self)!
    }
    
    func distanceSquared(x0: UnsafePointer<Float>, x1: Float,
                         y0: UnsafePointer<Float>, y1: Float,
                         z0: UnsafePointer<Float>, z1: Float,
                         n: Int,
                         result: UnsafeMutablePointer<Float>) {
        var x = subtract(a: x0, b: x1, n: n)
        vDSP.square(x, result: &x)
        
        var y = subtract(a: y0, b: y1, n: n)
        vDSP.square(y, result: &y)
        
        var z = subtract(a: z0, b: z1, n: n)
        vDSP.square(z, result: &z)
        
        vDSP_vadd(x, 1, y, 1, result, 1, vDSP_Length(n))
        vDSP_vadd(result, 1, z, 1, result, 1, vDSP_Length(n))
    }
    
    func subtract(a: UnsafePointer<Float>, b: Float, n: Int) -> [Float] {
        return [Float](unsafeUninitializedCapacity: n) { buffer, count in
            vDSP_vsub(a, 1, [b], 0, buffer.baseAddress!, 1, vDSP_Length(n))
            count = n
        }
    }
    
    func weightedRandomIndex(_ weights: UnsafeMutableBufferPointer<Float>) -> Int {
        var outputDescriptor = BNNSNDArrayDescriptor.allocateUninitialized(
            scalarType: Float.self,
            shape: .vector(1))
        defer { outputDescriptor.deallocate() }
        
        var probabilities = BNNSNDArrayDescriptor(
            data: weights,
            shape: .vector(weights.count))!
        
        let randomGenerator = BNNSCreateRandomGenerator(BNNSRandomGeneratorMethodAES_CTR, nil)
        defer { BNNSDestroyRandomGenerator(randomGenerator) }
        
        BNNSRandomFillCategoricalFloat(randomGenerator, &outputDescriptor, &probabilities, false)
        
        return Int(outputDescriptor.makeArray(of: Float.self)!.first!)
    }
}
