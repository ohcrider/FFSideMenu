//
//  FFSideMenuController.swift
//  Pods
//
//  Created by fewspider on 15/10/1.
//
//

import UIKit

public enum FFSideMenuType: Int {
    case Left
    case Right
    case Both
}

public class FFSideMenuController: UIViewController {

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
    }

    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animateWithDuration(0, animations: {
            self.leftMenuView?.frame.size.width = 0
            self.rightMenuView?.frame.origin.x = self.screenWidth
        })
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - FFSideMenu core method

    public func setupMenu(leftMenuViewController: UIViewController?,
                            rightMenuViewController: UIViewController?,
                            leftMenuWidh: CGFloat?,
                            rightMenuWidh: CGFloat?,
                            enableTap: Bool,
                            enablePan: Bool) {
        var menuType: FFSideMenuType?

        if (leftMenuViewController != nil && rightMenuViewController == nil) {
            menuType = .Left
        } else if (leftMenuViewController == nil && rightMenuViewController != nil) {
            menuType = .Right
        } else if (leftMenuViewController != nil && rightMenuViewController != nil) {
            menuType = .Both
        }

        if let mt = menuType {
            switch mt {
            case .Left:
                setupLeftMenu(leftMenuViewController!)
            case .Right:
                setupRightmenu(rightMenuViewController!)
            case .Both:
                setupLeftMenu(leftMenuViewController!)
                setupRightmenu(rightMenuViewController!)
            }
        }

        if let lw = leftMenuWidh {
            self.leftMenuWidh = lw
        }

        if let rw = rightMenuWidh {
            self.rightMenuWidh = rw
        }

        if (enablePan) {
            let panLeftMenu = UIPanGestureRecognizer(target: self, action: "panLeftMenu:")
            leftMenuView!.addGestureRecognizer(panLeftMenu)

            let panRightMenu = UIPanGestureRecognizer(target: self, action: "panRightMenu:")
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

    func setupLeftMenu(viewController: UIViewController?) {
        self.addChildViewController(viewController!)
        viewController!.view.frame = CGRectMake(CGFloat(0), CGFloat(0), leftMenuWidh, screenHeight)
        self.view.addSubview(viewController!.view)

        leftMenuView = viewController?.view
    }

    func setupRightmenu(viewController: UIViewController?) {
        self.addChildViewController(viewController!)
        viewController!.view.frame = CGRectMake(screenWidth - rightMenuWidh, CGFloat(0), rightMenuWidh, screenHeight)
        self.view.addSubview(viewController!.view)

        rightMenuView = viewController?.view
    }

    public func toggleLeftMenu() {
        if (leftMenuView == nil) {
            return print("leftMenuView not set")
        }

        if (isRightMenuOpen) {
            return toggleRightMenu()
        }

        isLeftMenuOpen = leftMenuView?.frame.size.width == 0 ? true : false

        if (isLeftMenuOpen) {
            UIView.animateWithDuration(leftMenuAnimationDuration, animations: {
                leftMenuView?.frame.size.width = leftMenuWidh
            })
            isLeftMenuOpen = true
        } else {
            UIView.animateWithDuration(leftMenuAnimationDuration, animations: {
                leftMenuView?.frame.size.width = 0
            })
            isLeftMenuOpen = false
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
                let width = leftMenuWidh + translation.x

                if (width > 0 && width < leftMenuWidh) {
                    panGesture.view!.frame.size.width = width
                }
            }

            if (panGesture.state == UIGestureRecognizerState.Ended) {
                let duration = leftMenuAnimationDuration / 2

                if (panGesture.view!.frame.size.width < leftMenuWidh / 2) {
                    UIView.animateWithDuration(duration, animations: { () -> Void in
                        panGesture.view!.frame.size.width = 0
                        }, completion: { (Bool) -> Void in
                            self.isLeftMenuOpen = false
                    })
                } else {
                    UIView.animateWithDuration(duration, animations: { () -> Void in
                        panGesture.view!.frame.size.width = self.leftMenuWidh
                        }, completion: { (Bool) -> Void in
                            self.isLeftMenuOpen = true
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
                let width = translation.x

                if (width > 0 && width < leftMenuWidh) {
                    leftMenuView?.frame.size.width = width
                }
            }

            if (panGesture.state == UIGestureRecognizerState.Ended) {
                let duration = leftMenuAnimationDuration / 2

                if (self.leftMenuView?.frame.size.width < leftMenuWidh / 2) {
                    UIView.animateWithDuration(duration, animations: { () -> Void in
                        self.leftMenuView?.frame.size.width = 0
                        }, completion: { (Bool) -> Void in
                            self.isLeftMenuOpen = false
                    })
                } else {
                    UIView.animateWithDuration(duration, animations: { () -> Void in
                        self.leftMenuView?.frame.size.width = self.leftMenuWidh
                        }, completion: { (Bool) -> Void in
                            self.isLeftMenuOpen = true
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
}
