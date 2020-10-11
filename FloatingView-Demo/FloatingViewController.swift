//
//  FloatingViewController.swift
//  FloatingView-Demo
//
//  Created by Jeremy Xue on 2020/10/11.
//

import UIKit

class FloatingViewController: UIViewController {
    
    private var animator: UIViewPropertyAnimator!

    @IBOutlet weak var indicatorView: UIView! {
        didSet {
            indicatorView.layer.cornerRadius = indicatorView.bounds.height / 2
            indicatorView.layer.masksToBounds = true
        }
    }

    @IBOutlet weak var floatingView: UIView! {
        didSet {
            floatingView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            floatingView.layer.cornerRadius = 10
            floatingView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
            avatarImageView.layer.masksToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 位移懸浮視圖，將 floatingView 位移到視窗外
        floatingView.transform = CGAffineTransform(translationX: 0, y: floatingView.bounds.height)
        // 添加拖曳手勢
        let pan = UIPanGestureRecognizer(
            target: self,
            action: #selector(panOnFloatingView(_:)))
        floatingView.isUserInteractionEnabled = true
        floatingView.addGestureRecognizer(pan)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 將懸浮視窗顯示在畫面上
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.6,
            delay: 0,
            options: [.curveEaseOut]) {
            self.view.backgroundColor = UIColor(white: 0, alpha: 0.8)
            self.floatingView.transform = .identity
        }
    }

    @objc private func panOnFloatingView(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // 拖曳開始時，創建 animator
            animator = UIViewPropertyAnimator(
                duration: 0.6,
                curve: .easeOut) {
                let translationY = self.floatingView.bounds.height
                self.floatingView.transform = CGAffineTransform(translationX: 0, y: translationY)
                self.view.backgroundColor = .clear
            }
        case .changed:
            // 拖曳變化時，根據拖曳手勢的位移程度來調整整體動畫的完成百分比
            let translation = recognizer.translation(in: floatingView)
            let fractionComplete = translation.y / floatingView.bounds.height
            animator.fractionComplete = fractionComplete
        case .ended:
            // 拖曳結束時，根據其動畫完整百分比決定不同操作
            if animator.fractionComplete <= 0.5 {
                // 設定動畫器 isReversed 設為 true，用於反轉動畫
                animator.isReversed = true
            } else {
                // 添加動畫結束後的效果，關閉此控制器
                animator.addCompletion { (position) in
                    self.dismiss(animated: true, completion: nil)
                }
            }
            // 延續動畫
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            break
        }
    }
    
    
}
