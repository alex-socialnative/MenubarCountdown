//
//  CALayerExtensions.swift
//  MenubarCountdown
//
//  Copyright © 2009,2015,2019 Kristopher Johnson. All rights reserved.

import Cocoa

// MARK: Create layer from image resource
extension CALayer {

    /**
     Load am image from a resource in the main bundle.

     - parameter name: name of image resource

     - returns: `CGImage`, or `nil` if unable to load specified image.
     */
    static func imageFromResource(name: String) -> CGImage? {
        var image: CGImage? = nil

        if let path = Bundle.main.path(forResource: name, ofType: nil) {
            let url = NSURL.fileURL(withPath: path)
            if let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) {
                image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
            }
            else {
                Log.error("CGImageSourceCreateWithURL failed")
            }
        }
        else {
            Log.error("unable to load image from file \(name)")
        }

        return image
    }

    /**
     Create a layer containing an image loaded from a resource in the main bundle.

     - parameter name: name of image resource

     - returns: new `CALayer`.
     */
    static func newLayerFromImageResource(name: String) -> CALayer {
        let newLayer = CALayer()
        newLayer.setContentsFromImageResource(name: name)
        return newLayer
    }

    /**
     Set the contents of the layer to an image loaded from a resource in the main bundle.

     - parameter name: name of image resource

     */
    func setContentsFromImageResource(name: String) {
        if let image = CALayer.imageFromResource(name: name) {
            let imageWidth = CGFloat(image.width)
            let imageHeight = CGFloat(image.height)

            self.bounds = CGRect(x: 0.0, y: 0.0, width: imageWidth, height: imageHeight)
            self.contents = image
        }
        else {
            Log.error("unable to set contents from file \(name)")
        }
    }
}

// MARK: Layer coordinate system
extension CALayer {
    /**
     Set layer's `anchorPoint`, `position`, and `contentsGravity` to
     position contents in lower-left corner.
     */
    func orientBottomLeft() {
        self.anchorPoint = CGPoint.zero
        self.position = CGPoint.zero
        self.contentsGravity = CALayerContentsGravity.bottomLeft
    }
}

// MARK: Add/remove blink animation
extension CALayer {
    /**
     Unique key used to identify animation managed by `addBlinkAnimation` and `removeBlinkAnimation`.
     */
    @nonobjc static let blinkAnimationKey
        = "MenubarCountdown_CALayerExtensions_BlinkAnimation"

    /**
     Add a repeating blinking animiation to the layer.

     Call `removeBlinkAnimation` to stop the animation.
     */
    func addBlinkAnimation() {
        if let _ = animation(forKey: CALayer.blinkAnimationKey) {
            return
        }

        let animation = CABasicAnimation(keyPath: "opacity")

        // Repeat forever, once per second
        animation.repeatCount = Float.infinity
        animation.duration = 0.5
        animation.autoreverses = true

        // Cycle between 0 and full opacity
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        add(animation, forKey: CALayer.blinkAnimationKey)
    }

    /**
     Remove animation added by `addBlinkAnimation`.
     */
    func removeBlinkAnimation() {
        removeAnimation(forKey: CALayer.blinkAnimationKey)
    }
}