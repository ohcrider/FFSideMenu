//
//  FFSideMenuController.swift
//  Pods
//
//  Created by fewspider on 15/10/1.
//
//

import UIKit

// MARK: - SegueIdentifier
let FFLeftSegueIdentifier = "ff_left"
let FFRightSegueIdentifier = "ff_right"

// MARK: - Screen Size
let screenWidth = UIScreen.mainScreen().bounds.size.width
let screenHeight = UIScreen.mainScreen().bounds.size.height

// MARK: - Custom UIStoryboardSegue
public class FFSideMenuSetMenuSegue: UIStoryboardSegue {

    override public func perform() {
        switch self.identifier {
            case FFLeftSegueIdentifier?, FFRightSegueIdentifier?:
                let firstVC = self.sourceViewController as! FFSideMenuController
                let secondVC = self.destinationViewController

                var secondVCFrame: CGRect
                var secondVCOriginX: CGFloat

                if (self.identifier == FFLeftSegueIdentifier) {
                    secondVCFrame = CGRectMake(CGFloat(0), CGFloat(0), firstVC.rightMenuWidh, screenHeight)
                    secondVCOriginX = -firstVC.leftMenuWidh
                } else {
                    secondVCFrame = CGRectMake(screenWidth - firstVC.rightMenuWidh, CGFloat(0), firstVC.rightMenuWidh, screenHeight)
                    secondVCOriginX = screenWidth
                }

                firstVC.addChildViewController(secondVC)
                secondVC.view.frame = secondVCFrame
                firstVC.view.addSubview(secondVC.view)
                secondVC.didMoveToParentViewController(firstVC)

                if (self.identifier == FFLeftSegueIdentifier) {
                    firstVC.leftMenuView = secondVC.view
                } else {
                    firstVC.rightMenuView = secondVC.view
                }

                UIView.animateWithDuration(0, animations: { () -> Void in
                    secondVC.view.frame.origin.x = secondVCOriginX
                    }) { (Finished) -> Void in
                        secondVC.view.layoutIfNeeded()
                        secondVC.view.updateConstraintsIfNeeded()
                }

            default:
                break
        }
    }
}

// MARK: - FFSideMenuController Class
public class FFSideMenuController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - Variable
    public var screenWidth = UIScreen.mainScreen().bounds.width
    public var screenHeight = UIScreen.mainScreen().bounds.height

    public var leftMenuView: UIView?
    public var rightMenuView: UIView?

    public var isLeftMenuOpen = false
    public var isRightMenuOpen = false

    public var leftMenuAnimationDuration = 0.3
    public var rightMenuAnimationDuration = 0.3

    public var leftMenuWidh: CGFloat = 0.0
    public var rightMenuWidh: CGFloat = 0.0

    // MARK: - View method
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        leftMenuWidh = screenWidth / 5 * 4
        rightMenuWidh = screenWidth / 5 * 4

        self.performSegueWithIdentifier(FFLeftSegueIdentifier, sender: self)
        self.performSegueWithIdentifier(FFRightSegueIdentifier, sender: self)
        setupGestrue(true, enableTap: true)
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - FFSideMenu core method
    public func setupGestrue(enablePan: Bool, enableTap: Bool) {
        if (enablePan) {
            let panLeftMenu = UIPanGestureRecognizer(target: self, action: "panLeftMenu:")
            panLeftMenu.delegate = self
            leftMenuView!.addGestureRecognizer(panLeftMenu)

            let panRightMenu = UIPanGestureRecognizer(target: self, action: "panRightMenu:")
            panRightMenu.delegate = self
            rightMenuView!.addGestureRecognizer(panRightMenu)

            let panLeftScreen = UIScreenEdgePanGestureRecognizer(target: self, action: "panLeftScreen:")
            panLeftScreen.edges = .Left
            view.addGestureRecognizer(panLeftScreen)

            let panRightScreen = UIScreenEdgePanGestureRecognizer(target: self, action: "panRightScreen:")
            panRightScreen.edges = .Right
            view.addGestureRecognizer(panRightScreen)
        }

        if (enableTap) {
            let tap = UITapGestureRecognizer(target: self, action: "tap:")
            self.view.addGestureRecognizer(tap)
        }
    }

    public func toggleLeftMenu() {
        if (leftMenuView == nil) {
            return print("leftMenuView not set")
        }

        if (isRightMenuOpen) {
            return toggleRightMenu()
        }

        isLeftMenuOpen = leftMenuView?.frame.origin.x != -leftMenuWidh ? true : false

        if (isLeftMenuOpen) {
            UIView.animateWithDuration(leftMenuAnimationDuration, animations: {
                leftMenuView?.frame.origin.x = -leftMenuWidh
            })
            isLeftMenuOpen = false
        } else {
            UIView.animateWithDuration(leftMenuAnimationDuration, animations: {
                leftMenuView?.frame.origin.x = 0
            })
            isLeftMenuOpen = true
        }
    }

    public func toggleRightMenu() {
        if (rightMenuView == nil) {
            return print("rightMenuView not set")
        }

        if (isLeftMenuOpen) {
            return toggleLeftMenu()
        }

        isRightMenuOpen = rightMenuView?.frame.origin.x != screenWidth - rightMenuWidh ? true : false

        if (isRightMenuOpen) {
            UIView.animateWithDuration(rightMenuAnimationDuration, animations: {
                rightMenuView?.frame.origin.x = screenWidth - rightMenuWidh
            })
            isRightMenuOpen = true
        } else {
            UIView.animateWithDuration(rightMenuAnimationDuration, animations: {
                rightMenuView?.frame.origin.x = screenWidth
            })
            isRightMenuOpen = false
        }
    }

    // MARK: - Gesture method
    func tap(gesture: UIGestureRecognizer) {
        if let tapGesture = gesture as? UITapGestureRecognizer {
            let dot = tapGesture.locationOfTouch(0, inView: self.view)

            if (isLeftMenuOpen && dot.x > leftMenuWidh) {
                toggleLeftMenu()
            }

            if (isRightMenuOpen && dot.x < screenWidth - rightMenuWidh) {
                toggleRightMenu()
            }
        }
    }

    func panLeftMenu(gesture: UIGestureRecognizer) {
        if let panGesture = gesture as? UIPanGestureRecognizer {
            let translation = panGesture.translationInView(panGesture.view!)

            if (isLeftMenuOpen) {
                let originX = translation.x

                if (originX > -leftMenuWidh && originX <= 0) {
                    panGesture.view!.frame.origin.x = originX
                }
            }

            if (panGesture.state == UIGestureRecognizerState.Ended) {
                let duration = leftMenuAnimationDuration / 2

                if (panGesture.view!.frame.origin.x > -self.leftMenuWidh / 2) {
                    UIView.animateWithDuration(duration, animations: { () -> Void in
                        panGesture.view!.frame.origin.x = 0
                        }, completion: { (Bool) -> Void in
                            self.isLeftMenuOpen = true
                    })
                } else {
                    UIView.animateWithDuration(duration, animations: { () -> Void in
                        panGesture.view!.frame.origin.x = -self.leftMenuWidh
                        }, completion: { (Bool) -> Void in
                            self.isLeftMenuOpen = false
                    })
                }
            }
        }
    }

    func panRightMenu(gesture: UIGestureRecognizer) {
        if let panGesture = gesture as? UIPanGestureRecognizer {
            let translation = panGesture.translationInView(panGesture.view!)

            if (isRightMenuOpen) {
                let originX = screenWidth - rightMenuWidh + translation.x

                if (originX > screenWidth - rightMenuWidh && originX < screenWidth) {
                    panGesture.view!.frame.origin.x = originX
                }
            }

            if (panGesture.state == UIGestureRecognizerState.Ended) {
                let duration = rightMenuAnimationDuration / 2

                if (panGesture.view!.frame.origin.x > (self.screenWidth - self.rightMenuWidh) + rightMenuWidh / 2) {
                    UIView.animateWithDuration(duration, animations: { () -> Void in
                        panGesture.view!.frame.origin.x = self.screenWidth
                        }, completion: { (Bool) -> Void in
                            self.isRightMenuOpen = false
                    })
                } else {
                    UIView.animateWithDuration(duration, animations: { () -> Void in
                        panGesture.view!.frame.origin.x = self.screenWidth - self.rightMenuWidh
                        }, completion: { (Bool) -> Void in
                            self.isRightMenuOpen = true
                    })
                }
            }
        }
    }

    func panLeftScreen(gesture: UIGestureRecognizer) {
        if let panGesture = gesture as? UIScreenEdgePanGestureRecognizer {
            let translation = panGesture.translationInView(panGesture.view!)

            if (!isLeftMenuOpen && !isRightMenuOpen) {
                let originX = -leftMenuWidh + translation.x

                if (originX > -leftMenuWidh && originX < 0) {
                    self.leftMenuView!.frame.origin.x = originX
                }
            }

            if (panGesture.state == UIGestureRecognizerState.Ended) {
                let duration = leftMenuAnimationDuration / 2

                if (self.leftMenuView!.frame.origin.x >  -self.leftMenuWidh / 2) {
                    UIView.animateWithDuration(duration, animations: { () -> Void in
                        self.leftMenuView!.frame.origin.x = 0
                        }, completion: { (Bool) -> Void in
                            self.isLeftMenuOpen = true
                    })
                } else {
                    UIView.animateWithDuration(duration, animations: { () -> Void in
                        self.leftMenuView!.frame.origin.x = -self.leftMenuWidh
                        }, completion: { (Bool) -> Void in
                            self.isLeftMenuOpen = false
                    })
                }
            }
        }
    }

    func panRightScreen(gesture: UIGestureRecognizer) {
        if let panGesture = gesture as? UIScreenEdgePanGestureRecognizer {
            let translation = panGesture.translationInView(panGesture.view!)

            if (!isLeftMenuOpen && !isRightMenuOpen) {
                let originX = screenWidth + translation.x

                if (originX > screenWidth - rightMenuWidh && originX < screenWidth) {
                    self.rightMenuView!.frame.origin.x = originX
                }
            }

            if (panGesture.state == UIGestureRecognizerState.Ended) {
                let duration = rightMenuAnimationDuration / 2

                if (self.rightMenuView!.frame.origin.x > (self.screenWidth - self.rightMenuWidh) + rightMenuWidh / 2) {
                    UIView.animateWithDuration(duration, animations: { () -> Void in
                        self.rightMenuView!.frame.origin.x = self.screenWidth
                        }, completion: { (Bool) -> Void in
                            self.isRightMenuOpen = false
                    })
                } else {
                    UIView.animateWithDuration(duration, animations: { () -> Void in
                        self.rightMenuView!.frame.origin.x = self.screenWidth - self.rightMenuWidh
                        }, completion: { (Bool) -> Void in
                            self.isRightMenuOpen = true
                    })
                }
            }
        }
    }
    
    // MARK: - Gesture delegate
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        let translation = (gestureRecognizer as! UIPanGestureRecognizer).translationInView(gestureRecognizer.view!.superview)
        return abs(translation.x) > abs(translation.y)
    }
}
