//
//  ViewController.swift
//  FloatingView-Demo
//
//  Created by Jeremy Xue on 2020/10/11.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapShowFloatingViewButton(_ sender: UIButton) {
        let vc = storyboard!.instantiateViewController(identifier: "FloatingViewController") as! FloatingViewController
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
}

