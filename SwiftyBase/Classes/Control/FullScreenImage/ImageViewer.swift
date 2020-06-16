//
//  ImageViewer.swift
//  Pods
//
//  Created by MacMini-2 on 31/08/17.
//
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

open class ImageViewer: UIViewController {

    // MARK: - Properties
    fileprivate let kMinMaskViewAlpha: CGFloat = 0.3
    fileprivate let kMaxImageScale: CGFloat = 2.5
    fileprivate let kMinImageScale: CGFloat = 1.0

    fileprivate let senderView: UIImageView
    fileprivate var originalFrameRelativeToScreen: CGRect!
    fileprivate var rootViewController: UIViewController!
    fileprivate let imageView = UIImageView()
    fileprivate var panGesture: UIPanGestureRecognizer!
    fileprivate var panOrigin: CGPoint!

    fileprivate var isAnimating = false
    fileprivate var isLoaded = false

    fileprivate var closeButton = UIButton()
    fileprivate let windowBounds = UIScreen.main.bounds
    fileprivate let scrollView = UIScrollView()
    fileprivate let maskView = UIView()

    // MARK: - Lifecycle methods
    init(senderView: UIImageView, backgroundColor: UIColor) {
        self.senderView = senderView

        rootViewController = UIApplication.shared.keyWindow!.rootViewController!
        maskView.backgroundColor = backgroundColor

        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureMaskView()
        configureScrollView()
        configureCloseButton()
        configureImageView()
        configureConstraints()
    }

    // MARK: - View configuration
    fileprivate func configureScrollView() {
        scrollView.frame = windowBounds
        scrollView.delegate = self
        scrollView.minimumZoomScale = kMinImageScale
        scrollView.maximumZoomScale = kMaxImageScale
        scrollView.zoomScale = 1

        view.addSubview(scrollView)
    }

    fileprivate func configureMaskView() {
        maskView.frame = windowBounds
        maskView.alpha = 0.0

        view.insertSubview(maskView, at: 0)
    }

    fileprivate func configureCloseButton() {
        closeButton.alpha = 0.0
        closeButton.setTitle("x", for: UIControl.State())
        closeButton.setTitleColor(UIColor.black, for: UIControl.State())
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(ImageViewer.closeButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        view.addSubview(closeButton)

        view.setNeedsUpdateConstraints()
    }

    fileprivate func configureView() {
        var originalFrame = senderView.convert(windowBounds, to: nil)
        originalFrame.origin = CGPoint(x: originalFrame.origin.x, y: originalFrame.origin.y)
        originalFrame.size = senderView.frame.size

        originalFrameRelativeToScreen = originalFrame

    }

    fileprivate func configureImageView() {
        senderView.alpha = 0.0

        imageView.frame = originalFrameRelativeToScreen
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = senderView.contentMode

        imageView.image = senderView.image

        scrollView.addSubview(imageView)

        animateEntry()
        addPanGestureToView()
        addGestures()

        centerScrollViewContents()
    }

    fileprivate func configureConstraints() {
        var constraints: [NSLayoutConstraint] = []

        let views: [String: UIView] = [
            "closeButton": closeButton
        ]

        constraints.append(NSLayoutConstraint(item: closeButton, attribute: .centerX, relatedBy: .equal, toItem: closeButton.superview, attribute: .centerX, multiplier: 1.0, constant: 0))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:[closeButton(==64)]-40-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:[closeButton(==64)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Gestures
    fileprivate func addPanGestureToView() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(ImageViewer.gestureRecognizerDidPan(_:)))
        panGesture.cancelsTouchesInView = false
        panGesture.delegate = self

        imageView.addGestureRecognizer(panGesture)
    }

    fileprivate func addGestures() {
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageViewer.didSingleTap(_:)))
        singleTapRecognizer.numberOfTapsRequired = 1
        singleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(singleTapRecognizer)

        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageViewer.didDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapRecognizer)

        singleTapRecognizer.require(toFail: doubleTapRecognizer)
    }

    fileprivate func zoomInZoomOut(_ point: CGPoint) {
        let newZoomScale = scrollView.zoomScale > (scrollView.maximumZoomScale / 2) ? scrollView.minimumZoomScale : scrollView.maximumZoomScale

        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = point.x - (w / 2.0)
        let y = point.y - (h / 2.0)

        let rectToZoomTo = CGRect(x: x, y: y, width: w, height: h)

        scrollView.zoom(to: rectToZoomTo, animated: true)
    }

    // MARK: - Animation
    fileprivate func animateEntry() {
        guard let image = imageView.image else {
            return

        }
        self.imageView.frame = self.originalFrameRelativeToScreen

        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIView.AnimationOptions(rawValue: 0), animations: {
            self.imageView.frame = self.centerFrameFromImage(image)
            self.closeButton.alpha = 1.0
            self.maskView.alpha = 1.0

            self.view.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
            self.rootViewController.view.transform = CGAffineTransform.identity.scaledBy(x: 0.97, y: 0.95)

        }) { (finished) in

        }
    }

    fileprivate func centerFrameFromImage(_ image: UIImage) -> CGRect {
        var newImageSize = imageResizeBaseOnWidth(windowBounds.size.width, oldWidth: image.size.width, oldHeight: image.size.height)
        newImageSize.height = min(windowBounds.size.height, newImageSize.height)

        return CGRect(x: 0, y: windowBounds.size.height / 2 - newImageSize.height / 2, width: newImageSize.width, height: newImageSize.height)
    }

    fileprivate func imageResizeBaseOnWidth(_ newWidth: CGFloat, oldWidth: CGFloat, oldHeight: CGFloat) -> CGSize {
        let scaleFactor = newWidth / oldWidth
        let newHeight = oldHeight * scaleFactor

        return CGSize(width: newWidth, height: newHeight)
    }

    // MARK: - Actions
    @objc func gestureRecognizerDidPan(_ recognizer: UIPanGestureRecognizer) {
        if scrollView.zoomScale != 1.0 || isAnimating {
            return
        }

        senderView.alpha = 0.0

        scrollView.bounces = false
        let windowSize = maskView.bounds.size
        let currentPoint = panGesture.translation(in: scrollView)
        let y = currentPoint.y + panOrigin.y

        imageView.frame.origin = CGPoint(x: currentPoint.x + panOrigin.x, y: y)

        let yDiff = abs((y + imageView.frame.size.height / 2) - windowSize.height / 2)
        maskView.alpha = max(1 - yDiff / (windowSize.height / 0.95), kMinMaskViewAlpha)
        closeButton.alpha = max(1 - yDiff / (windowSize.height / 0.95), kMinMaskViewAlpha) / 2

        if (panGesture.state == UIGestureRecognizer.State.ended || panGesture.state == UIGestureRecognizer.State.cancelled)
            && scrollView.zoomScale == 1.0 {
            maskView.alpha < 0.85 ? dismissViewController() : rollbackViewController()
        }
    }

    @objc func didSingleTap(_ recognizer: UITapGestureRecognizer) {
        scrollView.zoomScale == 1.0 ? dismissViewController() : scrollView.setZoomScale(1.0, animated: true)
    }

    @objc func didDoubleTap(_ recognizer: UITapGestureRecognizer) {
        let pointInView = recognizer.location(in: imageView)
        zoomInZoomOut(pointInView)
    }

    @objc func closeButtonTapped(_ sender: UIButton) {
        if scrollView.zoomScale != 1.0 {
            scrollView.setZoomScale(1.0, animated: true)
        }
        dismissViewController()
    }

    // MARK: - Misc.
    fileprivate func centerScrollViewContents() {
        let boundsSize = rootViewController.view.bounds.size
        var contentsFrame = imageView.frame

        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }

        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }

        imageView.frame = contentsFrame
    }

    fileprivate func rollbackViewController() {
        guard let image = imageView.image else {
            fatalError("no image provided")
        }

        isAnimating = true
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: UIView.AnimationOptions.beginFromCurrentState, animations: { () in
            self.imageView.frame = self.centerFrameFromImage(image)
            self.maskView.alpha = 1.0
            self.closeButton.alpha = 1.0
        }, completion: { (finished) in
            self.isAnimating = false
        })
    }

    fileprivate func dismissViewController() {
        isAnimating = true
        DispatchQueue.main.async(execute: {
            self.imageView.clipsToBounds = true

            UIView.animate(withDuration: 0.2, animations: { () in
                self.closeButton.alpha = 0.0
            })

            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: [UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.curveEaseInOut], animations: { () in
                self.imageView.frame = self.originalFrameRelativeToScreen
                self.rootViewController.view.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                self.view.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                self.maskView.alpha = 0.0
            }, completion: { (finished) in
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
                self.senderView.alpha = 1.0
                self.isAnimating = false
            })
        })
    }

    func presentFromRootViewController() {
        willMove(toParent: rootViewController)
        rootViewController.view.addSubview(view)
        rootViewController.addChild(self)
        didMove(toParent: rootViewController)
    }
}

// MARK: - GestureRecognizer delegate
extension ImageViewer: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        panOrigin = imageView.frame.origin
        gestureRecognizer.isEnabled = true
        return !isAnimating
    }
}

// MARK: - ScrollView delegate
extension ImageViewer: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        isAnimating = true
        centerScrollViewContents()
    }

    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        isAnimating = false
    }
}

public extension UIImageView {

    func setupForImageViewer(_ backgroundColor: UIColor = UIColor.white) {
        isUserInteractionEnabled = true
        let gestureRecognizer = ImageViewerTapGestureRecognizer(target: self, action: #selector(UIImageView.didTap(_:)), backgroundColor: backgroundColor)
        addGestureRecognizer(gestureRecognizer)
    }

    @objc internal func didTap(_ recognizer: ImageViewerTapGestureRecognizer) {
        let imageViewer = ImageViewer(senderView: self, backgroundColor: recognizer.backgroundColor)
        imageViewer.presentFromRootViewController()
    }
}

class ImageViewerTapGestureRecognizer: UITapGestureRecognizer {
    let backgroundColor: UIColor

    init(target: AnyObject, action: Selector, backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor

        super.init(target: target, action: action)
    }
}

