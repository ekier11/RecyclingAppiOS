//
//  ScannerViewController.swift
//  BarCodeScanner
//
//

import AVFoundation
import UIKit
import SQLite3

@objc protocol ScannerViewDelegate: class {
    @objc func didFindScannedText(text: String)
}




class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    var db: OpaquePointer?
    

    public weak var delegate: ScannerViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.green
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue, productName: stringValue)
        }
    }
    
    func found(code: String, productName: String) {
        var statement: OpaquePointer?
        print(code)
        print(productName)
        

        let dbUrl = Bundle.main.url(forResource: "products", withExtension: "db")
        let dbPath = dbUrl?.path
        
        if sqlite3_open(dbPath, &db) != SQLITE_OK{
            print("Error opening Database")
            sqlite3_close(db)
        }
        
        
        let requestProduct = "select ProductName from products WHERE UPC_ID = \"\(code)\""
        print(requestProduct)
        if sqlite3_prepare_v2(db, requestProduct, -1, &statement, nil) != SQLITE_OK {
            
            print("Error retrieving data")
            return
        }
        while sqlite3_step(statement) == SQLITE_ROW {
            let productName = String(cString: sqlite3_column_text(statement, 0))
            let isRecyclable = Int(sqlite3_column_int(statement, 0))
            print(isRecyclable)
            print(productName)
            //delegate?.didFindScannedText(text: productName)
            let finalView = self.storyboard?.instantiateViewController(identifier: "FinalViewController") as! FinalViewController
            finalView.productName = productName
            let navController = UINavigationController(rootViewController: finalView)
            present(navController, animated: true, completion: nil)
            self.navigationController?.pushViewController(finalView, animated: true)
            //self.performSegue(withIdentifier: "FinalViewSegue", sender: self)
            
            
        }
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
