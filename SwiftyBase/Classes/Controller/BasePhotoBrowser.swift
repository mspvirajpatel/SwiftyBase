//
//  BasePhotoBrowser.swift
//  Pods
//
//  Created by MacMini-2 on 18/09/17.
//
//

import UIKit

// MARK:- PhotoBrowserDelegate

public protocol PhotoBrowserDelegate: NSObjectProtocol {

    func sourceImageViewForCurrentIndex(_ index: Int) -> UIImageView?

    func photoBrowserDidDisplayPage(_ currentPage: Int, totalPages: Int)
    ///  (photoBrowser is preparing well and will begin display the first page )
    func photoBrowerWillDisplay(_ beginPage: Int)
    ///  (photoBrowser will be dismissed)
    func photoBrowserWillEndDisplay(_ endPage: Int)
    ///  photoBrowser is now dismissed
    func photoBrowserDidEndDisplay(_ endPage: Int)

    func extraBtnOnClick(_ extraBtn: UIButton)
}

// just to reach the effect provided by the objective-c's 'optional',but you can also use "@objc"
// MARK:-  extension PhotoBrowserDelegate

extension PhotoBrowserDelegate {

    public func sourceImageViewForCurrentIndex(_ index: Int) -> UIImageView? {
        return nil
    }

    public func photoBrowserDidDisplayPage(_ currentPage: Int, totalPages: Int) { }

    public func photoBrowerWillDisplay(_ beginPage: Int) { }

    public func photoBrowserWillEndDisplay(_ endPage: Int) { }
    public func photoBrowserDidEndDisplay(_ endPage: Int) { }

    public func extraBtnOnClick(_ extraBtn: UIButton) { }

}

open class PhotoModel {

    open var description: String?

    open var imageUrlString: String?

    open var localImage: UIImage?

    open var sourceImageView: UIImageView?

    public init(localImage: UIImage?, sourceImageView: UIImageView?) {
        self.localImage = localImage
        self.sourceImageView = sourceImageView
    }

    public init(imageUrlString: String?, sourceImageView: UIImageView?) {
        self.imageUrlString = imageUrlString
        self.sourceImageView = sourceImageView
    }
}


open class PhotoBrowser: UIViewController {

    // MARK:- public property

    open var extraBtnOnClickAction: ((_ extraBtn: UIButton) -> Void)?
    /// delegate
    open weak var delegate: PhotoBrowserDelegate?


    static let contentMargin: CGFloat = 20.0
    static let cellID = "cellID"

    // MARK:- private property

    fileprivate var toolBarStyle: ToolBarStyle!

    fileprivate var isOritenting = false
    fileprivate var photoModels: [PhotoModel] = []


    fileprivate weak var parentVc: UIViewController!

    fileprivate var currentIndex: Int = -1 {
        didSet {
            if oldValue == currentIndex { return }

            setupToolBarIndexText(currentIndex)

            delegate?.photoBrowserDidDisplayPage(currentIndex, totalPages: photoModels.count)

        }
    }

    fileprivate lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal

        flowLayout.itemSize = CGSize(width: self.view.bounds.size.width + PhotoBrowser.contentMargin, height: self.view.bounds.size.height)
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.sectionInset = UIEdgeInsets.zero
        return flowLayout
    }()

    fileprivate lazy var collectionView: UICollectionView = { [unowned self] in

        let collectionView = UICollectionView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width + PhotoBrowser.contentMargin, height: self.view.bounds.size.height), collectionViewLayout: self.flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(PhotoViewCell.self, forCellWithReuseIdentifier: PhotoBrowser.cellID)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    fileprivate lazy var toolBar: PhotoToolBar = {

        let toolBar = PhotoToolBar(frame: CGRect(x: 0.0, y: self.view.bounds.size.height - 44.0, width: self.view.bounds.size.width, height: 44.0), toolBarStyle: ToolBarStyle())
        toolBar.backgroundColor = UIColor.clear
        return toolBar
    }()

    // MARK:- life cycle
    public init(photoModels: [PhotoModel], extraBtnOnClickAction: ((_ extraBtn: UIButton) -> Void)? = nil) {
        self.photoModels = photoModels
        self.extraBtnOnClickAction = extraBtnOnClickAction
        super.init(nibName: nil, bundle: nil)
        self.view.addSubview(collectionView)
        self.view.addSubview(toolBar)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("\(self.debugDescription) --- 销毁")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        automaticallyAdjustsScrollViewInsets = false

    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFrame()
        setupToolBarAction()
        animateZoomIn()
        currentIndex(currentIndex, animated: false)

    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if isOritenting {
            currentIndex(currentIndex, animated: false)
            isOritenting = false
        }
    }


    // MARK:- orientation
    // 开始旋转
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        isOritenting = true
        // to solve the error or complaint that 'the behavior of the UICollectionViewFlowLayout is not defined because:
        // the item height must be less that the height of the UICollectionView minus the section insets top and bottom values '
        // http://stackoverflow.com/questions/14469251/uicollectionviewflowlayout-size-warning-when-rotating-device-to-landscape

        // Call -invalidateLayout to indicate that the collection view needs to requery the layout information.
        collectionView.collectionViewLayout.invalidateLayout()


    }

    open override var shouldAutorotate: Bool {
        return true
    }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }

}


// MARK: - public use func
extension PhotoBrowser {
    ///
    ///  - parameter parentVc:
    ///  - parameter beginPage:

    public func show(inVc parentVc: UIViewController, beginPage: Int) {
        currentIndex = beginPage
        self.parentVc = parentVc
        parentVc.present(self, animated: false, completion: nil)
    }

    ///
    ///
    ///  - parameter currentIndex:
    ///  - parameter animated:
    public func currentIndex(_ currentIndex: Int, animated: Bool) {
        assert(currentIndex >= 0 && currentIndex < photoModels.count, "设置的下标有误")
        if currentIndex < 0 || currentIndex >= photoModels.count { return }

        self.currentIndex = currentIndex

        collectionView.setContentOffset(CGPoint(x: CGFloat(currentIndex) * collectionView.bounds.size.width, y: 0.0), animated: animated)

    }
}

// MARK: - private helper
extension PhotoBrowser {

    fileprivate func getCurrentSourceImageView(_ index: Int) -> UIImageView? {
        let currentModel = photoModels[index]
        if let sourceView = delegate?.sourceImageViewForCurrentIndex(index) {
            return sourceView
        } else {
            if let sourceView = currentModel.sourceImageView {
                return sourceView
            } else {
                return nil
            }
        }

    }

    fileprivate func setupFrame() {
        // to solve the error or complaint that 'the behavior of the UICollectionViewFlowLayout is not defined because:
        // the item height must be less that the height of the UICollectionView minus the section insets top and bottom values '
        // http://stackoverflow.com/questions/14469251/uicollectionviewflowlayout-size-warning-when-rotating-device-to-landscape

        // Call -invalidateLayout to indicate that the collection view needs to requery the layout information.
        collectionView.collectionViewLayout.invalidateLayout()

        let collectionX = NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let collectionY = NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0)
        let collectionW = NSLayoutConstraint(item: collectionView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: PhotoBrowser.contentMargin)
        let collectionH = NSLayoutConstraint(item: collectionView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1.0, constant: 0.0)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([collectionX, collectionY, collectionW, collectionH])

        let toolBarX = NSLayoutConstraint(item: toolBar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let toolBarY = NSLayoutConstraint(item: toolBar, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let toolBarW = NSLayoutConstraint(item: toolBar, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: 0.0)
        let toolBarH = NSLayoutConstraint(item: toolBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0)

        toolBar.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([toolBarX, toolBarY, toolBarW, toolBarH])


    }
}

// MARK: - toolBar
extension PhotoBrowser {

    fileprivate func setupToolBarIndexText(_ index: Int) {
        toolBar.indexText = "\(index + 1)/\(photoModels.count)"

    }

    fileprivate func setupToolBarAction() {

        toolBar.saveBtnOnClick = { [unowned self] (saveBtn: UIButton) in

            let currentCell = self.collectionView.cellForItem(at: IndexPath(row: self.currentIndex, section: 0)) as! PhotoViewCell
            guard let currentImage = currentCell.imageView.image else { return }
            AppUtility.executeTaskInGlobalQueueWithCompletion {
                UIImageWriteToSavedPhotosAlbum(currentImage, self, #selector(self.image(_: didFinishSavingWithError: contextInfo:)), nil)
            }
        }
        toolBar.extraBtnOnClick = { [unowned self] (extraBtn: UIButton) in

            self.extraBtnOnClickAction?(extraBtn)
            self.delegate?.extraBtnOnClick(extraBtn)
        }


    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {

//        self
//        let hud = SimpleHUD(frame:CGRect(x: 0.0, y: (self.view.bounds.size.height - 80)*0.5, width: self.view.bounds.size.width, height: 80.0))
//
//        self.view.addSubview(hud)
//        if error == nil {
//            // successful
//            hud.showHUD("Successful", autoHide: true, afterTime: 1.0)
//
//        } else {
//            // failure
//            hud.showHUD("Failure", autoHide: true, afterTime: 1.0)
//
//        }
    }
}

// MARK: - animation
extension PhotoBrowser {

    fileprivate func animateZoomIn() {

        let currentModel = photoModels[currentIndex]
        let sourceView = getCurrentSourceImageView(currentIndex)

        if let sourceImageView = sourceView {

            let window = UIApplication.shared.keyWindow!

            let beginFrame = window.convert(sourceImageView.frame, from: sourceImageView)

            let sourceViewSnap = snapView(sourceImageView)

            sourceViewSnap.frame = beginFrame

            var endFrame: CGRect

            if let localImage = currentModel.localImage {

                let width = localImage.size.width < view.bounds.size.width ? localImage.size.width : view.bounds.size.width
                let height = localImage.size.height * (width / localImage.size.width)

                if height > view.bounds.size.height {
                    endFrame = CGRect(x: 0.0, y: 0.0, width: width, height: height)

                } else {

                    endFrame = CGRect(x: (view.bounds.size.width - width) / 2, y: (view.bounds.size.height - height) / 2, width: width, height: height)
                }


            } else {
                if let placeholderImage = sourceImageView.image {
                    // 按照图片比例设置imageView的frame
                    let width = placeholderImage.size.width < self.view.bounds.size.width ? placeholderImage.size.width : self.view.bounds.size.width
                    let height = placeholderImage.size.height * (width / placeholderImage.size.width)
                    // 长图
                    if height > view.bounds.size.height {
                        endFrame = CGRect(x: 0.0, y: 0.0, width: width, height: height)

                    } else {
                        endFrame = CGRect(x: (view.bounds.size.width - width) / 2, y: (view.bounds.size.height - height) / 2, width: width, height: height)

                    }
                } else {
                    endFrame = CGRect.zero
                }
            }

            window.addSubview(sourceViewSnap)
            view.alpha = 1.0
            collectionView.isHidden = true
            toolBar.isHidden = true

            delegate?.photoBrowerWillDisplay(currentIndex)
            UIView.animate(withDuration: 0.5, animations: {

                sourceViewSnap.frame = endFrame
            }, completion: { [unowned self] (_) in
                sourceViewSnap.removeFromSuperview()
                self.collectionView.isHidden = false
                self.toolBar.isHidden = false

            })

        } else {
            view.alpha = 0.0

            delegate?.photoBrowerWillDisplay(currentIndex)
            UIView.animate(withDuration: 0.5, animations: { [unowned self] in
                self.view.alpha = 1.0
            }, completion: { (_) in


            })
        }
    }

    fileprivate func animateZoomOut() {

        let sourceView = getCurrentSourceImageView(currentIndex)

        if let sourceImageView = sourceView {

            let currentCell = self.collectionView.cellForItem(at: IndexPath(row: self.currentIndex, section: 0)) as! PhotoViewCell
            let currentImageView: UIView

            if currentCell.imageView.bounds.size.height > view.bounds.size.height {
                currentImageView = currentCell.contentView
            } else {
                currentImageView = currentCell.imageView
            }

            let currentImageSnap = snapView(currentImageView)

            let window = UIApplication.shared.keyWindow!
            window.addSubview(currentImageSnap)

            currentImageSnap.frame = currentImageView.frame

            let endFrame = sourceImageView.convert(sourceImageView.frame, to: window)

            delegate?.photoBrowserWillEndDisplay(currentIndex)

            UIView.animate(withDuration: 0.5, animations: { [unowned self] in
                currentImageSnap.frame = endFrame
                self.view.alpha = 0.0

            }, completion: { [unowned self] (_) in

                self.delegate?.photoBrowserDidEndDisplay(self.currentIndex)
                currentImageSnap.removeFromSuperview()
                self.dismiss(animated: false, completion: nil)

            })

        } else {
            delegate?.photoBrowserWillEndDisplay(currentIndex)

            UIView.animate(withDuration: 0.5, animations: { [unowned self] in
                self.view.alpha = 0.0

            }, completion: { [unowned self] (_) in

                self.delegate?.photoBrowserDidEndDisplay(self.currentIndex)
                self.dismiss(animated: false, completion: nil)

            })
        }
    }

    fileprivate func snapView(_ view: UIView) -> UIView {

        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        if context != nil {
            view.layer.render(in: context!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            let imageView = UIImageView(image: image)
            return imageView
        }
        return UIView()


    }

    fileprivate func dismiss() {
        animateZoomOut()
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension PhotoBrowser: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public final func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public final func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModels.count
    }

    public final func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowser.cellID, for: indexPath) as! PhotoViewCell

        cell.resetUI()
        let currentModel = photoModels[indexPath.row]

        // maybe we update the sourceImageView through the delegare, so we need to reset the currentModel.sourceImageView
        currentModel.sourceImageView = getCurrentSourceImageView(indexPath.row)
        cell.photoModel = currentModel

        cell.singleTapAction = { [unowned self](ges: UITapGestureRecognizer) in
            self.dismiss()
        }

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    public final func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isOritenting { return }
        currentIndex = Int(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5)

    }

}

/// PhotoViewCell

class PhotoViewCell: UICollectionViewCell {

    var singleTapAction: ((_ gesture: UITapGestureRecognizer) -> Void)?

    var photoModel: PhotoModel! = nil {
        didSet {
            setupImage()
        }
    }

    fileprivate var isLandscap: Bool {
        let screenSize = UIScreen.main.bounds.size
        return screenSize.width >= screenSize.height
    }

    fileprivate(set) lazy var imageView: UIImageView = { [unowned self] in
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = UIColor.black
        return imageView
    }()

    fileprivate(set) lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0.0, y: 0.0, width: self.contentView.bounds.size.width - PhotoBrowser.contentMargin, height: self.contentView.bounds.size.height))
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.clipsToBounds = true
        //        pagingEnabled = false
        // 预设定
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 1.0
        scrollView.backgroundColor = UIColor.black
        scrollView.delegate = self
        return scrollView
    }()

    var image: UIImage? = nil {
        didSet {
            setupImageViewFrame()
        }
    }

    //MARK:- life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    deinit {
        ImageCacheManager.shared.session.finishTasksAndInvalidate()
        print("\(self.debugDescription) ---")
    }

    //MARK:- private
    fileprivate func commonInit() {
        setupScrollView()
        addGestures()
    }

    fileprivate func addGestures() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1

        singleTap.require(toFail: doubleTap)

        addGestureRecognizer(singleTap)
        addGestureRecognizer(doubleTap)
    }

    fileprivate func setupScrollView() {
        scrollView.addSubview(imageView)
        contentView.addSubview(scrollView)
    }

    //MARK:-


    @objc func handleSingleTap(_ ges: UITapGestureRecognizer) {

        if scrollView.zoomScale != scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
        }
        singleTapAction?(ges)
    }

    @objc func handleDoubleTap(_ ges: UITapGestureRecognizer) {

        if imageView.image == nil { return }

        if scrollView.zoomScale <= scrollView.minimumZoomScale {

            let location = ges.location(in: scrollView)

            let width = scrollView.bounds.size.width / scrollView.maximumZoomScale
            let height = scrollView.bounds.size.height / scrollView.maximumZoomScale

            let rect = CGRect(x: location.x * (1 - 1 / scrollView.maximumZoomScale), y: location.y * (1 - 1 / scrollView.maximumZoomScale), width: width, height: height)
            scrollView.zoom(to: rect, animated: true)

        } else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)

        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = CGRect(x: 0.0, y: 0.0, width: self.contentView.bounds.size.width - PhotoBrowser.contentMargin, height: self.contentView.bounds.size.height)
        setupImageViewFrame()
    }

    func resetUI() {
        scrollView.zoomScale = scrollView.minimumZoomScale
        imageView.image = nil
        singleTapAction = nil
        BaseProgressHUD.shared.hide()
    }
}

// MARK: - private helper ---
extension PhotoViewCell {
    fileprivate func setupImage() {

        guard let photo = photoModel else {
            assert(false, "")
            return
        }

        if photo.localImage != nil {
            image = photo.localImage
            return
        }

        guard let urlString = photo.imageUrlString, let url = URL(string: urlString) else {
            assert(false, "")
            return
        }

        BaseProgressHUD.shared.showInView(view: self)

        if let sourceImageView = photo.sourceImageView {
            image = sourceImageView.image
        }

        image = image ?? UIImage(named: "2")
        imageView.loadImage(urlString: urlString, placeholder: image) {
            (success, error) in
            BaseProgressHUD.shared.hide()
            
            // 'success' is a 'Bool' indicating success or failure.
            // 'error' is an 'Error?' containing the error (if any) when 'success' is 'false'.
        }
    }

    fileprivate func setupImageViewFrame() {

        if let imageV = image {

            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
            imageView.image = image

            let width = imageV.size.width < scrollView.bounds.size.width ? imageV.size.width : scrollView.bounds.size.width
            let height = imageV.size.height * (width / imageV.size.width)


            if height > scrollView.bounds.size.height {
                imageView.frame = CGRect(x: (scrollView.bounds.size.width - width) / 2, y: 0.0, width: width, height: height)
                scrollView.contentSize = imageView.bounds.size
                scrollView.contentOffset = CGPoint.zero

            } else {

                imageView.frame = CGRect(x: (scrollView.bounds.size.width - width) / 2, y: (scrollView.bounds.size.height - height) / 2, width: width, height: height)

            }
            scrollView.maximumZoomScale = scrollView.bounds.size.height / height + 1.0
        }
    }
}

// MARK: - UIScrollViewDelegate

extension PhotoViewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {

        setImageViewToTheCenter()
    }

    func setImageViewToTheCenter() {
        let offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0
        let offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0

        imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)

    }

}


struct ToolBarStyle {
    enum ToolBarPosition {
        case up
        case down
    }

    var showSaveBtn = true
    var showExtraBtn = true
    var toolbarPosition = ToolBarPosition.down

}

class PhotoToolBar: UIView {
    typealias BtnAction = (_ btn: UIButton) -> Void
    var saveBtnOnClick: BtnAction?
    var extraBtnOnClick: BtnAction?

    var indexText: String = " " {
        didSet {
            indexLabel.text = indexText
        }
    }

    var toolBarStyle: ToolBarStyle!

    /// 保存图片按钮
    fileprivate lazy var saveBtn: UIButton = {

        let saveBtn = UIButton()
        saveBtn.setTitleColor(UIColor.white, for: UIControl.State())
        saveBtn.backgroundColor = UIColor.clear
        saveBtn.setImage(UIImage(named: "feed_video_icon_download_white"), for: UIControl.State())
        saveBtn.addTarget(self, action: #selector(self.saveBtnOnClick(_:)), for: .touchUpInside)

        //        saveBtn.hidden = self.toolBarStyle.showSaveBtn
        return saveBtn
    }()

    fileprivate lazy var extraBtn: UIButton = {
        let extraBtn = UIButton()
        extraBtn.setTitleColor(UIColor.white, for: UIControl.State())
        extraBtn.backgroundColor = UIColor.clear
        extraBtn.setImage(UIImage(named: "more"), for: UIControl.State())
        extraBtn.addTarget(self, action: #selector(self.extraBtnOnClick(_:)), for: .touchUpInside)
        //        extraBtn.hidden = self.toolBarStyle.showExtraBtn

        return extraBtn
    }()

    fileprivate lazy var indexLabel: UILabel = {
        let indexLabel = UILabel()
        indexLabel.textColor = UIColor.white
        indexLabel.backgroundColor = UIColor.clear
        indexLabel.textAlignment = NSTextAlignment.center
        indexLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        return indexLabel
    }()

    init(frame: CGRect, toolBarStyle: ToolBarStyle) {
        super.init(frame: frame)
        self.toolBarStyle = toolBarStyle
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func commonInit() {
        addSubview(saveBtn)
        addSubview(indexLabel)
        addSubview(extraBtn)
    }

    @objc func saveBtnOnClick(_ btn: UIButton) {
        saveBtnOnClick?(btn)
    }
    @objc func extraBtnOnClick(_ btn: UIButton) {
        extraBtnOnClick?(btn)
    }


    override func layoutSubviews() {
        super.layoutSubviews()

        let margin: CGFloat = 30.0
        let btnW: CGFloat = 60.0

        let saveBtnX = NSLayoutConstraint(item: saveBtn, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: margin)
        let saveBtnY = NSLayoutConstraint(item: saveBtn, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let saveBtnW = NSLayoutConstraint(item: saveBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: btnW)
        let saveBtnH = NSLayoutConstraint(item: saveBtn, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0.0)

        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([saveBtnX, saveBtnY, saveBtnW, saveBtnH])

        let extraBtnX = NSLayoutConstraint(item: extraBtn, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -margin)
        let extraBtnY = NSLayoutConstraint(item: extraBtn, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let extraBtnW = NSLayoutConstraint(item: extraBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: btnW)
        let extraBtnH = NSLayoutConstraint(item: extraBtn, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0.0)

        extraBtn.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([extraBtnX, extraBtnY, extraBtnW, extraBtnH])


        let indexLabelLeft = NSLayoutConstraint(item: indexLabel, attribute: .leading, relatedBy: .equal, toItem: saveBtn, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let indexLabelY = NSLayoutConstraint(item: indexLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let indexLabelRight = NSLayoutConstraint(item: indexLabel, attribute: .trailing, relatedBy: .equal, toItem: extraBtn, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let indexLabelH = NSLayoutConstraint(item: indexLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0.0)

        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([indexLabelLeft, indexLabelY, indexLabelRight, indexLabelH])


    }

}

