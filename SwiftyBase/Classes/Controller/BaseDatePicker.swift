//
//  BaseDatePicker.swift
//  Pods
//
//  Created by MacMini-2 on 13/09/17.
//
//

import UIKit

public typealias returnDate = (String?) -> ()

public enum dateformat: String {
    case yyyy_m_d = "yyyy/MM/dd"
    case d_m_yyyy = "dd/MM/yyyy"
    case m_d_yy = "MM/dd/yy"
    case d_mmmm_yy = "d-MMMM-yy"
    case d_mmmm = "dd-MMMM"
    case mmmm_yy = "MMMM-yy"
    case h_mm_PM = "hh:mm aaa"
    case h_mm_ss = "HH:mm:ss"
    case yyyy_To_ss = "yyyy/MM/dd HH:mm:ss"
}


open class BaseDatePicker: UIViewController {

    public var buttonColor: UIColor = UIColor.blue
    public var pickerMode: UIDatePicker.Mode = .dateAndTime
    public var minimumDate: Date? = nil
    public var maximumDate: Date? = nil
    public var date_format: dateformat = .yyyy_To_ss
    public var titleString: String? = nil

    private var picker: UIDatePicker = UIDatePicker.init()
    private var confirmButton: UIButton = UIButton.init()
    private let cornerRadius: CGFloat = 7.5
    private let highlightedView: UIView = UIView.init()
    private let pickerHeight: CGFloat = 216
    private let pickerWidth: CGFloat = UIScreen.main.bounds.size.width - 10

    open var block: returnDate?

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if titleString != nil {
            let titleLabel: UILabel = UILabel.init(frame: CGRect(x: 5, y: 0, width: pickerWidth, height: 40))
            titleLabel.backgroundColor = UIColor.white
            titleLabel.layer.cornerRadius = cornerRadius
            titleLabel.layer.masksToBounds = true
            titleLabel.textColor = buttonColor
            titleLabel.textAlignment = .center
            titleLabel.text = titleString
            self.view.addSubview(titleLabel)
        }

        picker.frame = CGRect(x: 5, y: 45, width: pickerWidth, height: pickerHeight)
        picker.backgroundColor = UIColor.white
        picker.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
        picker.layer.cornerRadius = cornerRadius
        picker.datePickerMode = self.pickerMode

        if minimumDate != nil {
            picker.minimumDate = self.minimumDate!
        }

        if maximumDate != nil {
            picker.maximumDate = self.maximumDate!
        }

        if minimumDate != nil && maximumDate != nil {
            assert(minimumDate! < maximumDate!, "minimum date cannot bigger then maximum date")
        }

        picker.layer.masksToBounds = true
        self.view.addSubview(picker)

        highlightedView.frame = CGRect(x: -5, y: ((pickerHeight - 40) / 2) + 2, width: pickerWidth + 10, height: 35.5)
        highlightedView.backgroundColor = UIColor.clear
        highlightedView.layer.borderColor = buttonColor.cgColor
        highlightedView.layer.borderWidth = 1.0
        picker.addSubview(highlightedView)


        confirmButton.frame = CGRect(x: 5, y: CustomPresentationController.viewHeight + 5, width: pickerWidth, height: CustomPresentationController.buttonHeight)
        confirmButton.setTitle("OK", for: .normal)
        confirmButton.backgroundColor = buttonColor
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.setTitleColor(UIColor.gray, for: .highlighted)
        confirmButton.layer.cornerRadius = cornerRadius
        confirmButton.layer.masksToBounds = true
        confirmButton.addTarget(self, action: #selector(confirmButton_Click), for: .touchUpInside)
        self.view.addSubview(confirmButton)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initialize()
    }


    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initialize() {
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }

    @objc open func confirmButton_Click() {
        if block != nil {
            self.dismiss(animated: true, completion: nil)
            let df: DateFormatter = DateFormatter.init()
            df.dateFormat = date_format.rawValue
            df.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
            let returnDate: String = df.string(from: picker.date)
            block!(returnDate)
        }
    }

    open func showPicker(viewController: UIViewController) {
        viewController.present(self, animated: true) {

        }
    }
}

extension BaseDatePicker: UIViewControllerTransitioningDelegate {

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if presented == self {
            return CustomPresentationController(presentedViewController: presented, presenting: presenting)
        } else {
            return nil
        }
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented == self {
            return CustomPresentationAnimationController(isPresenting: true)
        } else {
            return nil
        }
    }


    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed == self {
            return CustomPresentationAnimationController(isPresenting: false)
        } else {
            return nil
        }
    }
}
