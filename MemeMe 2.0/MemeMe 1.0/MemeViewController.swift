//
//  MemeViewController.swift
//  MemeMe 1.0
//
//  Created by Hanoudi on 5/2/20.
//  Copyright © 2020 Hanoudi. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var memeSent: Meme?
    
    // MARK:- Variables

    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var navigationBar: UINavigationBar!
    

    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var albumButton: UIBarButtonItem!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var imageView: UIImageView!
  
    // MARK:- Text Font Initilization
    let memeTextAttributes = [
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth : -3
        ] as [NSAttributedString.Key : Any]
    
    // MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray
        setInitialView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    // MARK:- TextField Delegation Methods
    func stylizeTextField(textField: UITextField, text: String) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.borderStyle = .none
        textField.text = text
        textField.textAlignment = .center
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder && view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }

    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomTextField.isFirstResponder && view.frame.origin.y != 0  {
            view.frame.origin.y = 0
        }
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
        }
    }
    // MARK:- ImagePickerController Delegation Methods
    func pickAnImageFromSource(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
             imageView.contentMode = .scaleAspectFit
             imageView.image = image
             shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK:- UI Methods
    @IBAction func cameraButtonAction(_ sender: Any) {
        pickAnImageFromSource(source: .camera)
    }
    
    
    @IBAction func photoLibraryAction(_ sender: Any) {
        pickAnImageFromSource(source: .photoLibrary)
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity, success, items, error in
            self.save()
            self.dismiss(animated: true, completion: nil)
        }
        
        present(activityController, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        setInitialView()
        let sentViewController = self.storyboard!.instantiateViewController(withIdentifier: "SentMemes")
        self.navigationController!.pushViewController(sentViewController, animated: true)
    }
    
    func setInitialView() {
        imageView.image = nil
        stylizeTextField(textField: topTextField, text: "TOP")
        stylizeTextField(textField: bottomTextField, text: "BOTTOM")
        shareButton.isEnabled = false
        dismiss(animated: true, completion: nil)
    }
    
    // MARK:- Generating MEMEs Methods
    func generateMemedImage() -> UIImage {
        //Hide Toolbar And Navigation Bar
        hideBars(bool: true)
        
        // Render View To An Image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Show Toolbar and Navigation Bar
        hideBars(bool: false)
        
        return memedImage
    }
    
    func save() {
        // Update the meme
          let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imageView.image!, memeImage:generateMemedImage())
        // Add it to the memes array in the Application Delegate
          let object = UIApplication.shared.delegate
          let appDelegate = object as! AppDelegate
          appDelegate.memes.append(meme)
    }
    
    func hideBars(bool: Bool){
        navigationBar.isHidden = bool
        toolBar.isHidden = bool
    }
}

