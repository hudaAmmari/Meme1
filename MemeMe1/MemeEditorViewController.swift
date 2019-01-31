//
//  MemeEditorViewController.swift
//  MemeMe1
//
//  Created by Huda  on 20/02/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate , UITextFieldDelegate {
    
    
    @IBOutlet weak var imageViewPicker: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Disable CameraButton if camera source not available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        setTextFields(textField : topTextField)
        setTextFields(textField : bottomTextField)
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        
        //Enable and disable ShareButton
        if (imageViewPicker.image == nil)
        { shareButton.isEnabled = false
        }
        else
        { shareButton.isEnabled = true
        }
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    //Setting font style and color for textFeild
    func setTextFields(textField:UITextField) {
        
        let memeTextAttributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue): UIColor.black,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue): -3.0]
        
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
 
    
    //The return key in the keyboard:
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    func unsubscribeFromKeyboardNotifications()
    {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    //Show the keyboard
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //Hide the keyboard
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    //get height of keyboard
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    
    //Pick image from Camera
    @IBAction func pickImageFromCamera(_ sender: Any) {
        pickAnImage(UIImagePickerController.SourceType.camera)
    }
    
    //Pich image from Album
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        pickAnImage(UIImagePickerController.SourceType.photoLibrary)
    }
    
    
    //picking an image
    func pickAnImage(_ sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    //imagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info[.originalImage] as? UIImage {
            imageViewPicker.image = image
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    //Cancel Picking
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //save the MemeImage
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageViewPicker.image!, memedImage: generateMemedImage())
   
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    //generate Meme Image
    func generateMemedImage() -> UIImage {
        
        //Hide toolbar and navbar
        hideToolbars(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        hideToolbars(false)
        
        return memedImage
    }
    
    //show and hide toolbar and nevagationBar
    func hideToolbars(_ hide: Bool) {
        toolBar.isHidden = hide
        navigationBar.isHidden = hide
    }
    
    //Share Meme
    @IBAction func shareMeme(_ sender: Any) {
    let activityView = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        self.present(activityView, animated: true, completion: nil)
        
        activityView.completionWithItemsHandler = {
            activity,completed,items,error in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
                if let navigationController = self.navigationController {
                    navigationController.popToRootViewController(animated: true)
                }

            }
        }
    }
    
    //Cancel Meme
    @IBAction func cancelMeme(_ sender: Any) {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
}


