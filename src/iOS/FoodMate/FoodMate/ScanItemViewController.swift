//
//  ScanItemViewController.swift
//  FoodMate
//
//  Created by Jordan Horwich on 9/13/14.
//  Copyright (c) 2014 FoodMate. All rights reserved.
//

import UIKit
import AVFoundation

class ScanItemViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var _session:AVCaptureSession!
    var _device:AVCaptureDevice!
    var _input:AVCaptureDeviceInput!
    var _output:AVCaptureMetadataOutput!
    var _prevLayer:AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var scanView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _session = AVCaptureSession()
        _device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error: NSError? = nil
        
        _input = AVCaptureDeviceInput.deviceInputWithDevice(_device, error: &error) as AVCaptureDeviceInput
        if ((_input) != nil) {
            _session.addInput(_input)
        } else {
            print("Error: \(error)")
        }
        
        _output = AVCaptureMetadataOutput()
        _output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        _session.addOutput(_output)
        
        _output.metadataObjectTypes = _output.availableMetadataObjectTypes
        
        _prevLayer = AVCaptureVideoPreviewLayer.layerWithSession(_session) as AVCaptureVideoPreviewLayer
        _prevLayer.frame = scanView.bounds
        _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        scanView.layer.addSublayer(_prevLayer)
    }
    
    override func viewDidAppear(animated: Bool) {
        _session.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        var highlightViewRect:CGRect = CGRectZero
        var barCodeObject:AVMetadataMachineReadableCodeObject
        var detectionString = ""
        var barCodeTypes = [AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
        AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
        AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode]
        
        for metadata in metadataObjects {
            for type in barCodeTypes {
                if metadata.type == type {
                    barCodeObject = _prevLayer.transformedMetadataObjectForMetadataObject(metadata as AVMetadataObject) as AVMetadataMachineReadableCodeObject
                    highlightViewRect = barCodeObject.bounds
                    detectionString = metadata.stringValue
                    break
                }
            }
            
            if detectionString != "" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil);
                let vc = storyboard.instantiateViewControllerWithIdentifier("manualItem") as ManualItemViewController
                vc.initwithBarcode(detectionString)
                self.presentViewController(vc, animated: true, completion: nil)
                _session.stopRunning()
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    /////////////////////
    // Button Bar Actions
    /////////////////////
    
    @IBAction func doneButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
