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

    public var backgroundViewTag = 123456789
    public var backgroundViewColor: UIColor?

    public var isLeftMenuOpen = false {
        didSet {
            if (isLeftMenuOpen != false) {
                leftMenuIsOpen()
            } else {
                leftMenuIsClose()
            }
        }
    }
    public var isRightMenuOpen = false {
        didSet {
            if (isRightMenuOpen != false) {
                rightMenuIsOpen()
            } else {
                rightMenuIsClose()
            }
        }
    }

    public var leftMenuAnimationDuration = 0.3
    public var rightMenuAnimationDuration = 0.3
    public var backgroundAnimationDuration = 0.3

    public var leftMenuWidh: CGFloat = 0.0
    public var rightMenuWidh: CGFloat = 0.0

    public var enableTap = false
    public var enablePan = false

    // MARK: - View method
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        leftMenuWidh = screenWidth / 5 * 4
        rightMenuWidh = screenWidth / 5 * 4

        enableTap = true
        enablePan = true

        backgroundViewColor = UIColor(red:0.09, green:0.09, blue:0.09, alpha:0.5)
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func setupBackgroudView(belowSubview: UIView) {

        if ((self.view!.viewWithTag(backgroundViewTag)) == nil) {
            let backgroundView = UIView()
            backgroundView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)

            backgroundView.backgroundColor = backgroundViewColor

            backgroundView.tag = backgroundViewTag
            backgroundView.alpha = 0

            self.view.insertSubview(backgroundView, belowSubview: belowSubview)

            UIView.animateWithDuration(backgroundAnimationDuration, animations: {
                backgroundView.alpha = 1
                }, completion: { (Bool) -> Void in
            })

            if (enableTap) {
                let tap = UITapGestureRecognizer(target: self, action: "tap:")
                backgroundView.addGestureRecognizer(tap)
            }
        }
    }

    public func setLeftMenuOpen(isOpen: Bool) {
        if (isOpen) {
            self.isLeftMenuOpen = true
            setupBackgroudView(self.leftMenuView!)
        } else {
            self.isLeftMenuOpen = false
            if let bgView = self.view!.viewWithTag(backgroundViewTag) {
                UIView.animateWithDuration(backgroundAnimationDuration, animations: {
                    bgView.alpha = 0
                    }, completion: { (Bool) -> Void in
                        bgView.removeFromSuperview()
                })
            }
        }
    }

    public func setRightMenuOpen(isOpen: Bool) {
        if (isOpen) {
            self.isRightMenuOpen = true
            setupBackgroudView(self.rightMenuView!)
        } else {
            self.isRightMenuOpen = false
            if let bgView = self.view!.viewWithTag(backgroundViewTag) {
                UIView.animateWithDuration(backgroundAnimationDuration, animations: {
                    bgView.alpha = 0
                    }, completion: { (Bool) -> Void in
                        bgView.removeFromSuperview()
                })
            }
        }
    }

    // MARK: - FFSideMenu core method
    
    public func setUpLeftMenu() {
        self.performSegueWithIdentifier(FFLeftSegueIdentifier, sender: self)
        if (enablePan) {
            let panLeftMenu = UIPanGestureRecognizer(target: self, action: "panLeftMenu:")
            panLeftMenu.delegate = self
            leftMenuView!.addGestureRecognizer(panLeftMenu)
            
            let panLeftScreen = UIScreenEdgePanGestureRecognizer(target: self, action: "panLeftScreen:")
            panLeftScreen.edges = .Left
            view.addGestureRecognizer(panLeftScreen)
        }
    }
    
    public func setUpRightMenu() {
        self.performSegueWithIdentifier(FFRightSegueIdentifier, sender: self)
        if (enablePan) {
            let panRightMenu = UIPanGestureRecognizer(target: self, action: "panRightMenu:")
            panRightMenu.delegate = self
            rightMenuView!.addGestureRecognizer(panRightMenu)
            let panRightScreen = UIScreenEdgePanGestureRecognizer(target: self, action: "panRightScreen:")
            panRightScreen.edges = .Right
            view.addGestureRecognizer(panRightScreen)
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
                self.leftMenuView?.frame.origin.self.x = -self.leftMenuWidh
                }, completion: { (Bool) -> Void in
                    self.setLeftMenuOpen(false)
            })

        } else {
            UIView.animateWithDuration(leftMenuAnimationDuration, animations: {
                self.leftMenuView?.frame.origin.x = 0
                }, completion: { (Bool) -> Void in
                    self.setLeftMenuOpen(true)
            })

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
                self.rightMenuView?.frame.origin.x = self.screenWidth - self.rightMenuWidh
                }, completion: { (Bool) -> Void in
                    self.setRightMenuOpen(true)
            })

        } else {
            UIView.animateWithDuration(rightMenuAnimationDuration, animations: {
                self.rightMenuView?.frame.origin.x = self.screenWidth
                }, completion: { (Bool) -> Void in
                    self.setRightMenuOpen(false)
            })

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
                            self.setLeftMenuOpen(true)
                    })
                } else {
                    UIView.animateWithDuration(duration, animations: { () -> Void in
                        panGesture.view!.frame.origin.x = -self.leftMenuWidh
                        }, completion: { (Bool) -> Void in
                            self.setLeftMenuOpen(false)
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
                            self.setRightMenuOpen(false)
                    })
                } else {
                    UIView.animateWithDuration(duration, animations: { () -> Void in
                        panGesture.view!.frame.origin.x = self.screenWidth - self.rightMenuWidh
                        }, completion: { (Bool) -> Void in
                            self.setRightMenuOpen(true)
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
                            self.setLeftMenuOpen(true)
                    })
                } else {
                    UIView.animateWithDuration(duration, animations: { () -> Void in
                        self.leftMenuView!.frame.origin.x = -self.leftMenuWidh
                        }, completion: { (Bool) -> Void in
                            self.setLeftMenuOpen(false)
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
                            self.setRightMenuOpen(false)
                    })
                } else {
                    UIView.animateWithDuration(duration, animations: { () -> Void in
                        self.rightMenuView!.frame.origin.x = self.screenWidth - self.rightMenuWidh
                        }, completion: { (Bool) -> Void in
                            self.setRightMenuOpen(true)
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
    
    // MARK: - Didset callback
    public func leftMenuIsOpen() {
    }
    
    public func leftMenuIsClose() {
    }
    
    public func rightMenuIsOpen() {
    }
    
    public func rightMenuIsClose() {
    }
}
