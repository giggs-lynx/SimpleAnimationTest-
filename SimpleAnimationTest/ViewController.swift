//
//  ViewController.swift
//  SimpleAnimationTest
//
//  Created by giggs on 26/02/2018.
//  Copyright © 2018 giggs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var testView: UIView!

    private var ratio: Double {
        return Double(UIApplication.shared.windows[0].screen.bounds.width / 375.0)
    }
    
    private var subButtons: Array<UIView>?
    private var oldPosition: Array<CGPoint>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
            print("debug")
        #else
            print("release")
        #endif
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.black
        self.setupButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupButton() -> Void {
        
        let cof = UIApplication.shared.windows[0].screen.bounds.width / 375.0
        let r: CGFloat = 130.0 * 0.5
        let act: Selector = #selector(testAct(_:))
        
        let lgr = UILongPressGestureRecognizer(target: self, action: act)
        lgr.minimumPressDuration = 0.2
        
        testView.backgroundColor = UIColor.gray
        testView.tag = 0x3e7
        testView.layer.cornerRadius = r * cof
        testView.addGestureRecognizer(lgr)
        testView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: act))
        testView.isUserInteractionEnabled = true
        
    }
    
    @objc private func testAct(_ gesture: UIGestureRecognizer) -> Void {
        
        switch gesture {
        case let g as UILongPressGestureRecognizer:
            longPressHandler(g)
            break
        case let g as UITapGestureRecognizer:
            tapHandler(g)
            break
        default:
            break
        }
        
    }
    
    private func longPressHandler(_ gesture: UILongPressGestureRecognizer) -> Void {
        
        guard let v = gesture.view else {
            return
        }
        
        switch gesture.state {
        case UIGestureRecognizerState.began:
            longPressStart(sender: v)
        case UIGestureRecognizerState.ended:
            longPressEnd()
        default:
            break
        }
        
        
    }
    
    private func longPressStart(sender pivotView: UIView) -> Void {
        
        let subLength = 70.0 * ratio
        let subRadius = subLength / 2.0
        let littleSpacing = (sqrt(pow(subLength, 2) * 2) - subLength) / 2.0
        let spacing = 30.0 * ratio
        
        if subButtons == nil {
            subButtons = createSubButtons(pivotView: pivotView, subLength: 70.0, amount: 4)
            
            oldPosition = Array<CGPoint>()
            for e in subButtons! {
                oldPosition?.append(e.center)
            }
            
        }
        
        guard let _subButtons = subButtons, let _ = oldPosition else {
            return
        }
        
        let pivotRadius = Double(pivotView.layer.cornerRadius)
        let totalSpacing:Double = pivotRadius + spacing + littleSpacing + subRadius
        let arcs: [Double] = [0, 90, 180, 270]
        
        for i in 0..<_subButtons.count {
            
            let sub = _subButtons[i]
            let arc = arcs[i] * Double.pi / 180.0
            
            let shiftX = totalSpacing * cos(arc)
            let shiftY = totalSpacing * sin(arc)
            
            let desCenterX = Double(pivotView.center.x) + shiftX
            let desCenterY = Double(pivotView.center.y) + shiftY
            
            sub.isHidden = false
            
            UIView.animate(withDuration: 0.3, animations: {
                sub.center = CGPoint(x: desCenterX, y: desCenterY)
                sub.alpha = 1.0
            })
        }
        
    }
    
    private func longPressEnd() -> Void {
        
        guard let _subButtons = subButtons, let _oldPosition = oldPosition else {
            return
        }
        
        for i in 0..<_subButtons.count {
            
            let target = _subButtons[i]
            let point = _oldPosition[i]
            
            UIView.animate(withDuration: 0.3, animations: {
                target.center = point
                target.alpha = 1.0
            }) {
                target.isHidden = $0
            }
            
        }
        
    }
    
    private func createSubButtons(pivotView: UIView, subLength length: CGFloat, amount: Int) -> Array<UIView> {
        
        let center = pivotView.center
        let radius = length / 2.0
        let origin = CGPoint(x: center.x - radius, y: center.y - radius)
        let size = CGSize(width: length, height: length)
        let frame = CGRect(origin: origin, size: size)
        
        var arr = Array<UIView>()
        
        for _ in 0..<amount {
            let sub = UIView(frame: frame)
            sub.backgroundColor = UIColor.red
            sub.layer.cornerRadius = radius
            sub.alpha = 0.0
            sub.isHidden = true
            self.view.addSubview(sub)
            arr.append(sub)
        }
        
        return arr
    }
    
    private func tapHandler(_ gesture: UITapGestureRecognizer) -> Void {
        
    }
    
}

