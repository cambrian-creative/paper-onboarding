//
//  PaperOnboarding.swift
//  AnimatedPageView
//
//  Created by Alex K. on 20/04/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

/// An instance of PaperOnboarding which display collection of information.
open class PaperOnboarding: UIView {

    ///  The object that acts as the data source of the  PaperOnboardingDataSource.
    weak var dataSource: PaperOnboardingDataSource! {
        didSet {
            commonInit()
        }
    }

    /// The object that acts as the delegate of the PaperOnboarding. PaperOnboardingDelegate protocol
    weak var delegate: PaperOnboardingDelegate!

    /// current index item
    open fileprivate(set) var currentIndex: Int = 0
    fileprivate(set) var itemsCount: Int = 0

    fileprivate let pageViewBottomConstant: CGFloat
    fileprivate var pageViewSelectedRadius: CGFloat = 22
    fileprivate var pageViewRadius: CGFloat = 8

    fileprivate var fillAnimationView: FillAnimationView?
    fileprivate var pageView: PageView?
    public fileprivate(set) var gestureControl: GestureControl?
    fileprivate var contentView: OnboardingContentView?
    
    public init(pageViewBottomConstant: CGFloat = 32) {
        
        self.pageViewBottomConstant = pageViewBottomConstant

        super.init(frame: CGRect.zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        self.pageViewBottomConstant = 32
        self.pageViewSelectedRadius = 22
        self.pageViewRadius = 8
        
        super.init(coder: aDecoder)
    }
}

// MARK: methods

public extension PaperOnboarding {

    /**
     Scrolls through the PaperOnboarding until a index is at a particular location on the screen.

     - parameter index:    Scrolling to a curretn index item.
     - parameter animated: True if you want to animate the change in position; false if it should be immediate.
     */
    func currentIndex(_ index: Int, animated: Bool) {
        if 0 ..< itemsCount ~= index {
            delegate.onboardingWillTransitonToIndex(index)
            currentIndex = index
            CATransaction.begin()
            
            CATransaction.setCompletionBlock({ [weak self] in
                self?.delegate.onboardingDidTransitonToIndex(index)
            })

            let backgroundColor = delegate.onboardingItemBackgroundColor(atIndex: index)

            if let postion = pageView?.positionItemIndex(index, onView: self) {
                fillAnimationView?.fillAnimation(backgroundColor, centerPosition: postion, duration: 0.5)
            }
            pageView?.currentIndex(index, animated: animated)
            contentView?.currentItem(index, animated: animated)
            CATransaction.commit()
        } else if index >= itemsCount {
            delegate.onboardingWillTransitonToLeaving()
        }
    }
}

// MARK: create

extension PaperOnboarding {

    fileprivate func commonInit() {
        itemsCount = dataSource.onboardingItemsCount()
        pageViewRadius = dataSource.onboardinPageItemRadius()
        pageViewSelectedRadius = dataSource.onboardingPageItemSelectedRadius()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let backgroundColor = delegate.onboardingItemBackgroundColor(atIndex: currentIndex)

        fillAnimationView = FillAnimationView.animationViewOnView(self, color: backgroundColor)
        contentView = OnboardingContentView.contentViewOnView(self,
                                                              delegate: self,
                                                              itemsCount: itemsCount,
                                                              bottomConstant: pageViewBottomConstant * -1 - pageViewSelectedRadius)
        pageView = createPageView()
        gestureControl = GestureControl(view: self, delegate: self)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tapGesture)
    }

    @objc fileprivate func tapAction(_ sender: UITapGestureRecognizer) {
        guard
            delegate.enableTapsOnPageControl == true,
            let pageView = self.pageView,
            let pageControl = pageView.containerView
        else { return }
        let touchLocation = sender.location(in: self)
        let convertedLocation = pageControl.convert(touchLocation, from: self)
        guard let pageItem = pageView.hitTest(convertedLocation, with: nil) else { return }
        let index = pageItem.tag - 1
        guard index != currentIndex else { return }
        currentIndex(index, animated: true)
        delegate.onboardingWillTransitonToIndex(index)
    }

    fileprivate func createPageView() -> PageView {
        let pageView = PageView.pageViewOnView(
            self,
            itemsCount: itemsCount,
            bottomConstant: pageViewBottomConstant * -1,
            radius: pageViewRadius,
            selectedRadius: pageViewSelectedRadius,
            itemColor: { [weak self] in
                return self?.dataSource.onboardingPageItemColor(at: $0) ?? .white
            })

        return pageView
    }
}

// MARK: GestureControlDelegate

extension PaperOnboarding: GestureControlDelegate {

    func gestureControlDidSwipe(_ direction: UISwipeGestureRecognizer.Direction) {
        switch direction {
        case UISwipeGestureRecognizer.Direction.right:
            currentIndex(currentIndex - 1, animated: true)
        case UISwipeGestureRecognizer.Direction.left:
            currentIndex(currentIndex + 1, animated: true)
        default:
            fatalError()
        }
    }
}

// MARK: OnboardingDelegate

extension PaperOnboarding: OnboardingContentViewDelegate {
    func onboardingItemAtIndex(_ index: Int) -> OnboardingContentViewItem {
        return delegate.onboardingItem(atIndex: index)
    }
    
    func animateIn(item: OnboardingContentViewItem, duration: Double) {
        delegate.animateIn(item: item, duration: duration)
    }
    
    func animateOut(item: OnboardingContentViewItem, duration: Double) {
        delegate.animateOut(item: item, duration: duration)
    }
}
