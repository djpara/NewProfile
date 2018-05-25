//
//  ViewController.swift
//  NewProfile
//
//  Created by David Para on 5/24/18.
//  Copyright © 2018 David Para. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var textViews: [UITextField]!
    @IBOutlet var pickerTextViews: [UITextField]!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    fileprivate let genderPickerData = ["", "Male", "Female", "Prefer not to share"]
    fileprivate let preferencePickerData = ["", "Relationship","Friendship", "Other"]
    
    fileprivate let genderPicker = UIPickerView()
    fileprivate let preferencePicker = UIPickerView()
    
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var preferenceTextField: UITextField!
    
    fileprivate var keyboardHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpPickers()
        addToolbars()
        addObservers()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func addToolbars() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.donePressed))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        
        var allViews = textViews!
        allViews += pickerTextViews
        
        allViews.forEach { field in
            field.inputAccessoryView = toolbar
        }
    }
    
    fileprivate func setUpPickers() {
        genderPicker.delegate = self
        genderPicker.dataSource = self
        
        genderTextField.inputView = genderPicker
        
        preferencePicker.delegate = self
        preferencePicker.dataSource = self
        
        preferenceTextField.inputView = preferencePicker
    }
    
    @objc
    fileprivate func donePressed() {
        view.endEditing(true)
    }
    
    @objc
    fileprivate func showKeyboard(_ notification: NSNotification) {
        if !keyboardHidden { return }
        
        guard let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let height = frame.cgSizeValue.height
        
        UIView.animate(withDuration: duration, animations: {
            self.scrollView.constraints.forEach { constraint in
                if constraint.firstAttribute == .bottom {
                    constraint.constant += height
                    return
                }
            }
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.keyboardHidden = false
        })
        
    }
    
    @objc
    fileprivate func hideKeyboard(_ notification: NSNotification) {
        
        if keyboardHidden { return }
        
        guard let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        UIView.animate(withDuration: duration, animations: {
            self.scrollView.constraints.forEach { constraint in
                if constraint.firstAttribute == .bottom {
                    constraint.constant = 0
                    return
                }
            }
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.keyboardHidden = true
        })
        
    }
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == genderPicker ? genderPickerData.count : preferencePickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genderPicker {
            return genderPickerData[row]
        }
        return preferencePickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genderPicker {
            genderTextField.text = genderPickerData[row]
        }
        preferenceTextField.text = preferencePickerData[row]
    }
    
}

