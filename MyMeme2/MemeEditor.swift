//
//  MemeEditor.swift
//  MemeMe1.0Attempt1
//
//  Created by Sean Goldsborough on 8/6/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import UIKit

class MemeEditor: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var sharedButton: UIBarButtonItem!
    
    var memedImage: UIImage!
    
    var sharedDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func cancelButton(_ sender: Any) {
        resetMeme()
        disableShareButton()
    }
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        memedImage = generateMemedImage()
        
        let activityVC = UIActivityViewController(activityItems: [memedImage as Any], applicationActivities: nil)
            activityVC.completionWithItemsHandler = {
            (_, true, _, _) in
            if true {
                self.save()
                self.resetMeme()
            }
        }
        
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    func configureNav(isHidden: Bool) {
        navigationController?.isNavigationBarHidden = isHidden
        navigationController?.setToolbarHidden(isHidden, animated: isHidden)
    }
    
    func resetMeme() {
        imageView.image = nil
        topTextField.text = nil
        bottomTextField.text = nil
        configureTextFields(textField: topTextField, withText: "TOP", withTag: 0, withKeyboard: .next)
        configureTextFields(textField: bottomTextField, withText: "BOTTOM", withTag: 1, withKeyboard: .go)
    }
    
    func generateMemedImage() -> UIImage {
        
        //let imageArea = CGRect(origin: .center, size: CGSize(width: 195, height: 195))
        
        
        // TODO: Hide toolbar and navbar
        configureNav(isHidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)

        //UIGraphicsBeginImageContextWithOptions(CGSize(width: 195, height: 195), true, 0.0);
        
        //view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        
        
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        configureNav(isHidden: false)
        return memedImage
    }
    
//    TODO - FUNC TO GENERATE MEME WITHIN IMAGEVIEW BOUNDS
//    func generateMemedImage() -> UIImage {
//        
//        var imageViewPic = imageView
//        // TODO: Hide toolbar and navbar
//        configureNav(isHidden: true)
//        
//        // Render view to an image
//        UIGraphicsBeginImageContext((imageViewPic?.image?.size)!)
//        view.drawHierarchy(in: (imageViewPic?.frame)!, afterScreenUpdates: true)
//        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        
//        // TODO: Show toolbar and navbar
//        configureNav(isHidden: false)
//        return memedImage
//    }
    
    func save() {
        // Create the meme
        let meme = Meme(topTextField.text!, bottomTextField.text!, imageView.image!, memedImage)
        
        sharedDelegate.arrayOfMemes.append(meme)

    }
    
    //Dictionary of TextAttributes
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSStrokeWidthAttributeName: -5.0]
    
    //MARK Text Field Delegate Objects
    let memeTextDelegate = MemeTextDelegate()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.imageView.image = image
            disableShareButton()
        } else {
            self.imageView.image = self.imageView.image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //ImagePickerController Delegates
    
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //DISABLE SHARE BUTTON UNTIL IMAGEVIEW HAS IMAGE
    func disableShareButton() {
        if imageView.image == nil {
            sharedButton.isEnabled = false
        } else {
            sharedButton.isEnabled = true
        }
    }
    
    func configureTextFields(textField: UITextField, withText: String, withTag: Int, withKeyboard: UIReturnKeyType) {
        textField.delegate = memeTextDelegate
        textField.defaultTextAttributes = memeTextAttributes
        textField.attributedPlaceholder = NSAttributedString(string: withText, attributes: memeTextAttributes)
        textField.textColor = UIColor.white
        textField.autocapitalizationType = .allCharacters
        textField.textAlignment = .center
        textField.returnKeyType = withKeyboard
        textField.tag = withTag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MEME EDITOR UI
        
        sharedButton.isEnabled = false
        self.view.backgroundColor = UIColor.darkGray
        
        imageView.layer.borderWidth = 10
        imageView.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        imageView.contentMode = .scaleAspectFit
        
        configureTextFields(textField: topTextField, withText: "TOP", withTag: 0, withKeyboard: .next)
        configureTextFields(textField: bottomTextField, withText: "BOTTOM", withTag: 1, withKeyboard: .go)
        configureNav(isHidden: false)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    //FUNCTIONS FOR NOTIFICATION/OBSERVERS
    
    func keyboardWillShow(_ notification: NSNotification) {
        if case bottomTextField.isEditing = true {
            view.frame.origin.y = 0 - getKeyboardHeight(notification as Notification)
            topTextField.frame.origin.y = 0 - getKeyboardHeight(notification as Notification)
            
        } else {
            view.frame.origin.y = 0
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y += getKeyboardHeight(notification as Notification)
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
    }
    
    //FUNCTIONS TO PICK AN IMAGE
    
    
    @IBAction func pickAnImage(_ sender: Any) {
        chooseImageSource(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        chooseImageSource(sourceType: .camera)
    }
    
    func chooseImageSource(sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        let captureValue = UIImagePickerController.availableCaptureModes(for: .rear) != nil
        
        pickerController.delegate = self
        
        if sourceType  == .photoLibrary {
            pickerController.sourceType = .photoLibrary
            present(pickerController, animated: true, completion: nil)
            
        } else if sourceType == .camera && captureValue == true {
            pickerController.sourceType = .camera
            pickerController.cameraCaptureMode = .photo
            present(pickerController, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}

