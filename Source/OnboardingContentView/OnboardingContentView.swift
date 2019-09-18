//
//  OnboardingContentView.swift
//  AnimatedPageView
//
//  Created by Alex K. on 21/04/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

protocol OnboardingContentViewDelegate: class {

    func onboardingItemAtIndex(_ index: Int) -> OnboardingContentViewItem
    func animateIn(item: OnboardingContentViewItem, duration: Double)
    func animateOut(item: OnboardingContentViewItem, duration: Double)
}

class OnboardingContentView: UIView {

    fileprivate struct Constants {
        static let showDuration: Double = 0.8
        static let hideDuration: Double = 0.2
    }

    fileprivate var currentItem: OnboardingContentViewItem?
    weak var delegate: OnboardingContentViewDelegate?

    init(itemsCount _: Int, delegate: OnboardingContentViewDelegate) {
        self.delegate = delegate
        super.init(frame: CGRect.zero)
        
        commonInit()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: public

extension OnboardingContentView {

    func currentItem(_ index: Int, animated _: Bool) {

        let showItem = createItem(index)
        showItemView(showItem, duration: Constants.showDuration)

        hideItemView(currentItem, duration: Constants.hideDuration)

        currentItem = showItem
    }
}

// MARK: life cicle

extension OnboardingContentView {

    class func contentViewOnView(_ view: UIView, delegate: OnboardingContentViewDelegate, itemsCount: Int, bottomConstant: CGFloat) -> OnboardingContentView {
        let contentView = Init(OnboardingContentView(itemsCount: itemsCount, delegate: delegate)) {
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.addSubview(contentView)

        // add constraints
        for attribute in [NSLayoutConstraint.Attribute.left, NSLayoutConstraint.Attribute.right, NSLayoutConstraint.Attribute.top] {
            (view, contentView) >>>- { $0.attribute = attribute; return }
        }
        (view, contentView) >>>- {
            $0.attribute = .bottom
            $0.constant = bottomConstant
            return
        }
        return contentView
    }
}

// MARK: create

extension OnboardingContentView {

    fileprivate func commonInit() {

        currentItem = createItem(0)
    }

    fileprivate func createItem(_ index: Int) -> OnboardingContentViewItem {
        return delegate!.onboardingItemAtIndex(index)
    }
}

// MARK: animations

extension OnboardingContentView {

    fileprivate func hideItemView(_ item: OnboardingContentViewItem?, duration: Double) {
        guard let item = item else {
            return
        }

        delegate!.animateOut(item: item, duration: duration)
    }

    fileprivate func showItemView(_ item: OnboardingContentViewItem, duration: Double) {
        delegate!.animateIn(item: item, duration: duration)
    }
}
