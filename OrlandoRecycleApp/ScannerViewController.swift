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
    var sharedProductBit:Int = -1
    var recycleMessage: String = ""
    var productName: String = ""
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
            found(code: stringValue)
        }
    }
    
    func found(code: String) {
        var statement: OpaquePointer?
        print(code)
        print(productName)
        

        let dbUrl = Bundle.main.url(forResource: "products", withExtension: "db")
        let dbPath = dbUrl?.path
        
        if sqlite3_open(dbPath, &db) != SQLITE_OK{
            print("Error opening Database")
            sqlite3_close(db)
        }
        
        let requestRecyclable = "select * from products WHERE UPC_ID = \"\(code)\""
        
            if sqlite3_prepare_v2(self.db, requestRecyclable, -1, &statement, nil) != SQLITE_OK {
            print("Error retrieving data")
            return
            }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            productName = String(cString: sqlite3_column_text(statement, 1))
            print(productName)
            sharedProductBit = Int(sqlite3_column_int(statement, 2))
            print(sharedProductBit)
            recycleMessage = String(cString: sqlite3_column_text(statement, 3))
           
        }
        let finalView = self.storyboard?.instantiateViewController(identifier: "FinalViewController") as! FinalViewController
        let navController = UINavigationController(rootViewController: finalView)
        if (sharedProductBit == 0){
            finalView.recycle = sharedProductBit
            present(navController, animated: true, completion: nil)
            self.navigationController?.pushViewController(finalView, animated: true)
        } else if (sharedProductBit == 1) {
            finalView.recycle = sharedProductBit
            finalView.text = productName
            finalView.zeroWasteMessage = recycleMessage
            present(navController, animated: true, completion: nil)
            self.navigationController?.pushViewController(finalView, animated: true)
        } else if (sharedProductBit == -1){
            finalView.recycle = sharedProductBit
            present(navController, animated: true, completion: nil)
            self.navigationController?.pushViewController(finalView, animated: true)
        }
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

