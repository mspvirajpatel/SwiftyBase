//
//  CustomPresentationAnimationController.swift
//  Pods
//
//  Created by MacMini-2 on 13/09/17.
//
//

import Foundation
import UIKit

class CustomPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    let isPresenting: Bool
    let duration: TimeInterval = 0.5

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            animatePresentationWithTransitionContext(transitionContext: transitionContext)
        } else {
            animateDismissWithTransitionContext(transitionContext: transitionContext)
        }
    }

    private func animatePresentationWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let presentedController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
                return
        }

        let containerView = transitionContext.containerView

        presentedControllerView.frame = transitionContext.finalFrame(for: presentedController)
        presentedControllerView.center.y += containerView.bounds.size.height
        containerView.addSubview(presentedControllerView)

        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
            presentedControllerView.center.y -= containerView.bounds.size.height
        }) { (completed) in
            transitionContext.completeTransition(completed)
        }
    }

    private func animateDismissWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }

        let containerView = transitionContext.containerView

        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
            presentedControllerView.center.y += containerView.bounds.size.height
        }) { (completed) in
            transitionContext.completeTransition(completed)
        }
    }
}

