//
//  MemeTimeViewController.swift
//  MemeTime
//
//  Created by Maria Kennedy on 6/16/16.
//  Copyright © 2016 Happy Feat Media. All rights reserved.
//

import UIKit

class MemeTimeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    // DECLARE VARIABLES
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var topText: UITextField!
    
    
    @IBOutlet weak var bottomText: UITextField!
    
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    @IBOutlet weak var toolbarTop: UIToolbar!
    
    @IBOutlet weak var toolbarBottom: UIToolbar!
    
    
    @IBOutlet weak var memebg: UIImageView!
    
    
    
    // END DECLARE VARIABLES
    
    
    // INITIAL STARTUP VIEW CODE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //For devices without a camera (such as simulator)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        if imageView.image == nil {
        
            shareButton.enabled = false
        } else {
            shareButton.enabled = true
        }
        
        // CALLING FUNCTION SUBSCRIBE KEYBOARD
        subscribeToKeyboardNotifications()
        
        //INTIAL VIEW TEXT IN THE TEXT FIELDS
        
        initTextField(topText, initText: "top text")
        initTextField(bottomText, initText: "bottom text")
        topText.backgroundColor = UIColor.clearColor()
        bottomText.backgroundColor = UIColor.clearColor()
    }
    
// END INITIAL STARTUP CODE
    
    // IMAGE PICKING CODE
    
    func pickAnImage(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        pickAnImage(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        pickAnImage(UIImagePickerControllerSourceType.Camera)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // END IMAGE PICKING CODE
    
    
    
    // TEXT FIELD ATTRIBUTES
    
    func initTextField(textField: UITextField!, initText: String?) {
        textField.delegate = self
        
        if let text = initText {
            textField.text = text
        } else {
            print("No init string.")
        }
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
            NSStrokeWidthAttributeName : -5,

            ]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    // END TEXT FIELD ATTRIBUTES
    
    
    
    
    
    // KEYBOARD CODE
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

    
    // END KEYBOARD CODE
    
    
    
    
    // GENERATE MEME
    //Creates a UIImage that combines the Image View and the text fields
    func generateMemedImage() -> UIImage {
        
        toolbarBottom.hidden = true
        toolbarTop.hidden = true
        memebg.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        

        
        toolbarBottom.hidden = false
        toolbarTop.hidden = false
        memebg.hidden = false
        
        return memedImage
    }

    
    
    // END GENERATE MEME
    
    
    
    
    
    // SAVE MEME
    
    func save(memedImage: UIImage){
        
    }
    

    
    // END SAVE MEME
    
    
    
    
    
    // SHARE MEME
    
    @IBAction func shareButtonClicked(sender: AnyObject) {
        let memedImage = generateMemedImage()
        
        let shareViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        self.presentViewController(shareViewController, animated: true, completion: nil)
        shareViewController.completionWithItemsHandler = { (activityType: String?, completed: Bool, returnedItems: [AnyObject]?, activityError: NSError?) in
            if completed {
                shareViewController.dismissViewControllerAnimated(true, completion: nil)
                self.save(memedImage)
            }
        }
    }

    
    // END SHARE MEME
    
    
    //CANCEL BUTTON
    
    
    @IBAction func resetAll(sender: AnyObject) {
   
            imageView.image = nil
            
            //CANCEL TEXT IN THE TEXT FIELDS
            
            initTextField(topText, initText: "top text")
            initTextField(bottomText, initText: "bottom text")
        }

// END CANCEL BUTTON
    
    
    // VIEW WILL DISAPPEAR
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    
    // END VIEW WILL DISAPPEAR
    
    

}



