//
//  imageview.swift
//  hackathon
//
//  Created by Vijay on 24/07/16.
//  Copyright © 2016 Vijay. All rights reserved.
//
import UIKit

class imageview: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var greyscaleconversiontap: UIButton!
    
    @IBAction func grescaletapped(sender: AnyObject) {
        if (editimage.image != nil)
        {
            let grayScaleImage = convertToGrayScale(editimage.image!)

            editimage.image = grayScaleImage
        
        
        
        }
    }
    @IBOutlet weak var editimage: UIImageView!
    @IBAction func didpressimage(sender: UIButton)
    {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
      imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.editimage.image = image
       
        
            
        }
    func convertToGrayScale(image: UIImage) -> UIImage {
        let imageRect:CGRect = CGRectMake(0, 0, image.size.width, image.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.None.rawValue)
        let context = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, colorSpace, bitmapInfo.rawValue)
        
        CGContextDrawImage(context, imageRect, image.CGImage)
        let imageRef = CGBitmapContextCreateImage(context)
        let newImage = UIImage(CGImage: imageRef!)
        
        return newImage
    }
    
}

