//
//  ViewController.swift
//  hackkathon
//
//  Created by Vijay on 07/24/15.
//  Copyright (c) 2016 Vijay. All rights reserved.
//
import UIKit
import AVFoundation

//-------------------------------------------------------------------------------------------------------

func loadShutterSoundPlayer() -> AVAudioPlayer?
{
  let theMainBundle = NSBundle.mainBundle()
  let filename = "Shutter sound"
  let fileType = "mp3"
  let soundfilePath: String? = theMainBundle.pathForResource(filename,
    ofType: fileType,
    inDirectory: nil)
  if soundfilePath == nil
  {
    return nil
  }
  //println("soundfilePath = \(soundfilePath)")
  let fileURL = NSURL.fileURLWithPath(soundfilePath!)
  var error: NSError?
  let result: AVAudioPlayer?
  do {
    result = try AVAudioPlayer(contentsOfURL: fileURL)
  } catch var error1 as NSError {
    error = error1
    result = nil
  }
  if let requiredErr = error
  {
    print("AVAudioPlayer.init failed with error \(requiredErr.debugDescription)")
  }

  result?.prepareToPlay()
  return result
}




class ViewController:
  UIViewController,
  CroppableImageViewDelegateProtocol,
  UIImagePickerControllerDelegate,
  UINavigationControllerDelegate,
  UIPopoverControllerDelegate
{
    
    
    
    @IBOutlet weak var leftmenubtn: UIButton!
    var image :NSString?
    
    @IBOutlet weak var scroll: UIScrollView!
  @IBOutlet weak var whiteView: UIView!
  @IBOutlet weak var cropButton: UIButton!
  @IBOutlet weak var cropView: CroppableImageView!
  
  var shutterSoundPlayer = loadShutterSoundPlayer()
  
    @IBOutlet weak var greenuservalue: UITextField!
    @IBOutlet weak var blueuservalue: UITextField!
    @IBOutlet weak var reduservalue: UITextField!
  
    
override func viewDidLoad()
    
{
    
    super.viewDidLoad()
    if self.revealViewController() != nil  {
        
      
        leftmenubtn.addTarget(self.revealViewController(), action: "rightRevealToggle:", forControlEvents: UIControlEvents.TouchUpInside);
        //revealViewController().rearViewRevealWidth = 120
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    // Do any additional setup after loading the view, typically from a nib.
  }

    @IBAction func rotatebtntapped(sender: UIButton)
    {
        let rotated  = Int(rotateangle.text!)
        print(rotated!)
        let valueinradian:CGFloat = CGFloat(rotated!)*CGFloat(3.14)/180
        print(valueinradian)
        
       cropView.transform = CGAffineTransformMakeRotation(valueinradian)
        
//        let image:UIImage = cropView.imageToCrop!
//        cropView.imageToCrop = image
    }
    @IBOutlet weak var rotateangle: UITextField!
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  enum ImageSource: Int
  {
    case Camera = 1
    case PhotoLibrary
  }
  
  func pickImageFromSource(
    theImageSource: ImageSource,
    fromButton: UIButton)
  {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    switch theImageSource
    {
    case .Camera:
      print("User chose take new pic button")
      imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
      imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.Front;
    case .PhotoLibrary:
      print("User chose select pic button")
      imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
    }
    if UIDevice.currentDevice().userInterfaceIdiom == .Pad
    {
      if theImageSource == ImageSource.Camera
      {
      self.presentViewController(
        imagePicker,
        animated: true)
        {
          //println("In image picker completion block")
        }
      }
      else
      {
        self.presentViewController(
          imagePicker,
          animated: true)
          {
            //println("In image picker completion block")
        }
//
      }
    }
    else
    {
      self.presentViewController(
        imagePicker,
        animated: true)
        {
          print("In image picker completion block")
      }
      
    }
  }
    
    

  
  //-------------------------------------------------------------------------------------------------------
  // MARK: - IBAction methods -
  //-------------------------------------------------------------------------------------------------------

  @IBAction func handleSelectImgButton(sender: UIButton)
  {
    /*See if the current device has a camera. (I don't think any device that runs iOS 8 lacks a camera,
    But the simulator doesn't offer a camera, so this prevents the
    "Take a new picture" button from crashing the simulator.
    */
    let deviceHasCamera: Bool = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    print("In \(__FUNCTION__)")
    
    //Create an alert controller that asks the user what type of image to choose.
    let anActionSheet = UIAlertController(title: "Pick Image Source",
      message: nil,
      preferredStyle: UIAlertControllerStyle.ActionSheet)
    
    
    //Offer the option to re the starting sample image
    let sampleAction = UIAlertAction(
      title:"Load Sample Image",
      style: UIAlertActionStyle.Default,
      handler:
      {
        
        (alert: UIAlertAction)  in
        self.cropView.imageToCrop = UIImage(named: "back1.jpg")
        self.cropView.imageforset = UIImage(named: "back1.jpg")

//        let image:UIImage = UIImage(named: "back1.jpg")!
//
//        let originalImageView:UIImageView = UIImageView(frame: CGRectMake(20, 20, image.size.width, image.size.height))
//        originalImageView.image = image
//        self.cropView.addSubview(originalImageView)
//        self.cropView.imageToCrop = originalImageView.image
//       // self.cropView.imageToCrop = UIImage(named: "back1.jpg")
//        self.image = "imagetocrop"
        
      }
    )
    
    var takePicAction: UIAlertAction? = nil
    if deviceHasCamera
    {
      takePicAction = UIAlertAction(
        title: "Take a New Picture",
        style: UIAlertActionStyle.Default,
        handler:
        {
          (alert: UIAlertAction)  in
          self.pickImageFromSource(
            ImageSource.Camera,
            fromButton: sender)
            self.image = "imagetocrop"

        }
      )
    }
    
    let selectPicAction = UIAlertAction(
      title:"Select Picture from library",
      style: UIAlertActionStyle.Default,
      handler:
      {
        (alert: UIAlertAction)  in
        self.pickImageFromSource(
          ImageSource.PhotoLibrary,
          fromButton: sender)

      }
    )
    
    let cancelAction = UIAlertAction(
      title:"Cancel",
      style: UIAlertActionStyle.Cancel,
      handler:
      {
        (alert: UIAlertAction)  in
        print("User chose cancel button")
      }
    )
    anActionSheet.addAction(sampleAction)
    
    if let requiredtakePicAction = takePicAction
    {
      anActionSheet.addAction(requiredtakePicAction)
    }
    anActionSheet.addAction(selectPicAction)
    anActionSheet.addAction(cancelAction)
    
    let popover = anActionSheet.popoverPresentationController
    popover?.sourceView = sender
    popover?.sourceRect = sender.bounds;
    
    self.presentViewController(anActionSheet, animated: true)
      {
        //println("In action sheet completion block")
    }
  }
    
    
    
    
    
    
    @IBAction func apply(sender: UIButton)
    {
 
        if (reduservalue.text == ""||greenuservalue.text == ""||blueuservalue.text == "")
        {let alertController = UIAlertController(title: "ALERT", message:
            "please fill all field", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else
        {
            let redint = Int(reduservalue.text!)
            let greenint = Int(greenuservalue.text!)
            let blueint = Int(blueuservalue.text!)
            if (redint > 255||greenint > 255||blueint > 255)
            {
                let alertController = UIAlertController(title: "ALERT", message:
                    "please fill all field", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)

                
            }
            else
            {
                

                let redint = Int(reduservalue.text!)
                
                let greenint = Int(greenuservalue.text!)
                let blueint = Int(blueuservalue.text!)
                
                
                NSUserDefaults.standardUserDefaults().setObject(redint!, forKey: "redstring")
                NSUserDefaults.standardUserDefaults().setObject(greenint!, forKey: "greenstring")
                 NSUserDefaults.standardUserDefaults().setObject(blueint!, forKey: "bluestring")
                let image:UIImage = cropView.imageToCrop!
                // print(cropView.imageToCrop)
                cropView.imageToCrop = image.getUserScale()
             
                
            }
            
        }
    }
    @IBAction func greyscalebtntapped(sender: UIButton)
    {
    
            let image:UIImage = cropView.imageforset!
           // print(cropView.imageToCrop)
        cropView.imageToCrop = cropView.imageforset
            cropView.imageToCrop = image.getGrayScale()
        
    }
    
    @IBAction func redscalebtntapped(sender: UIButton) {
        let image:UIImage = cropView.imageforset!
        // print(cropView.imageToCrop)
        cropView.imageToCrop = cropView.imageforset

        cropView.imageToCrop = image.getRedScale()
        
    }
    @IBAction func greenscalebtntapped(sender: UIButton)
    {
        let image:UIImage = cropView.imageforset!
        // print(cropView.imageToCrop)
        cropView.imageToCrop = cropView.imageforset

        cropView.imageToCrop = image.getGreenScale()
    }
  
    @IBAction func bluescalebtntapped(sender: UIButton)
    {
        let image:UIImage = cropView.imageforset!
        // print(cropView.imageToCrop)
        cropView.imageToCrop = cropView.imageforset

        cropView.imageToCrop = image.getBlueScale()
        
    }
  @IBAction func handleCropButton(sender: UIButton)
  {
    if let croppedImage = cropView.croppedImage()
    {
      self.whiteView.hidden = false
      delay(0)
        {
          self.shutterSoundPlayer?.play()
          UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil);
            self.cropView.imageforset = self.cropView.croppedImage()
            
            self.cropView.imageToCrop = self.cropView.croppedImage()
          
          delay(0.2)
            {
              self.whiteView.hidden = true
              self.shutterSoundPlayer?.prepareToPlay()
          }
      }
      
 
    }
  }

  //-------------------------------------------------------------------------------------------------------
  // MARK: - CroppableImageViewDelegateProtocol methods -
  //-------------------------------------------------------------------------------------------------------

  func haveValidCropRect(haveValidCropRect:Bool)
  {
    //println("In haveValidCropRect. Value = \(haveValidCropRect)")
    cropButton.enabled = haveValidCropRect
  }
  //-------------------------------------------------------------------------------------------------------
  // MARK: - UIImagePickerControllerDelegate methods -
  //-------------------------------------------------------------------------------------------------------
  
  func imagePickerController(
    picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [String : AnyObject])
  {
    print("In \(__FUNCTION__)")
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
    {
      picker.dismissViewControllerAnimated(true, completion: nil)
      cropView.imageToCrop = image
        self.cropView.imageforset = image
        
    }
    //cropView.setNeedsLayout()
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController)
  {
    print("In \(__FUNCTION__)")
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
}

