//
//  TestViewController.swift
//  YTracker
//
//  Created by Ivan Trofimov on 27.05.17.
//  Copyright © 2017 Ivan Trofimov. All rights reserved.
//

import UIKit
import Material
class TestViewController: UIViewController {
    fileprivate var undoButton: FlatButton!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        
        prepareUndoButton()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        prepareSnackbar()
        animateSnackbar()
        scheduleAnimation()
    }
    fileprivate func prepareUndoButton() {
        undoButton = FlatButton(title: "Undo", titleColor: Color.yellow.base)
        undoButton.pulseAnimation = .backing
        undoButton.titleLabel?.font = snackbarController?.snackbar.textLabel.font
    }
    
    fileprivate func prepareSnackbar() {
        guard let snackbar = snackbarController?.snackbar else {
            return
        }
        
        snackbar.text = "Reminder saved."
        snackbar.rightViews = [undoButton]
    }
    
    fileprivate func scheduleAnimation() {
        Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(animateSnackbar), userInfo: nil, repeats: true)
    }
    @objc
    fileprivate func animateSnackbar() {
        guard let sc = snackbarController else {
            return
        }
        
        _ = sc.animate(snackbar: .visible, delay: 1)
        _ = sc.animate(snackbar: .hidden, delay: 4)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
