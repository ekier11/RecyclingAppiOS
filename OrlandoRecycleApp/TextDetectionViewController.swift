//
//  TextDetectionViewController.swift
//  OrlandoRecycleApp
//
//  Created by Manny Batt on 3/30/21.
//

import UIKit
import AVKit
import Vision
import VideoToolbox
import SQLite3

//Global Variables
var db: OpaquePointer?
var sharedProductName: String = "Product"
var sharedProductInfo: String = "Product Info"
var sharedProductPrologue: String = "You most likely have"
var sharedProductBit: Int = -999


class TextDetectionViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    //UI Elements
    @IBOutlet weak var videoPreview: UIView!
    @IBOutlet weak var ocrData1: UILabel!
    @IBOutlet weak var ocrData2: UILabel!
    @IBOutlet weak var ocrData3: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    
    //Variables
    var objDataText:String = ""                  // Stream of Object Recognition results as text (debug)
    var ocrText:String = ""                      // Stream of OCR results as text (debug)
    var productList = [Product]()                // An array containing the entire contents of the DB
    
    var detections: Array<String> = Array()      // Overall words detected
    var hits: Array<Int> = Array()               // Number of times those words are detected
    var hitCountThreshold:Int = 10               // Minimum number of words needed to prevent OCR staleness
    var hitCount:Int = 0                         // Count of detections
    var foundWords: Array<String> = Array()      // If a words appears more than hitCountThreshold, it's added here

    var lastFoundWords: Array<String> = Array()  // Keeps a copy of the last OCR results for staleness check
    var initialTime: CFAbsoluteTime = CFAbsoluteTimeGetCurrent() // Timing variable for OCR staleness check
        
    
    //** Prepare Camera and video feed **//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Open Database
        readDB()
        
        //Launch Camera
        let captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else{return}
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else{return}
        captureSession.addInput(input)
        captureSession.startRunning()
        
        //Display camera video feed
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resize
        previewLayer.connection?.videoOrientation = .portrait
        videoPreview?.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        previewLayer.frame = videoPreview.bounds //Essential to resize video view
    }
    
    
    //** Recognize Objects AND Text in Video Feed **//
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        //Create a buffer
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else{return}
        
        /*
        //[OBJ] Process an Object Recognition request
        objectRecognition(pixelBuffer: pixelBuffer);
        */
         
        //[TXT] Create individual images from video feed, create an OCR request, and process it!
        let ciimage : CIImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(ciimage, from: ciimage.extent)!
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("DATAWORLD: " + error.localizedDescription)
                return
            }
            print("\(String(describing: self.recognizeText(from: request)))")
        }
        request.recognitionLevel = .accurate // .accurate || .fast
        do {
            try requestHandler.perform([request])
        } catch { print("DATAWORLD: Unable to perform the TXT request: \(error).") }
    }
    
    
    //[TXT] ** Perform OCR on image **//
    func recognizeText(from request: VNRequest) -> String? {
        
        //Prepare best detected words for storage in detetions array
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            return nil
        }
        let recognizedStrings: [String] = observations.compactMap { (observation)  in
            guard let topCandidate = observation.topCandidates(1).first else { return nil }
            self.ocrText = "\(topCandidate.string.trimmingCharacters(in: .whitespaces))"
            return topCandidate.string.trimmingCharacters(in: .whitespaces)
        }
        let words:String = "\(recognizedStrings.joined(separator: " "))"
        print("DATAWORLD: [TXT]  \(words)")
        let components = words.components(separatedBy: " ")
        print("DATAWORLD: componenets - \(components)")
        
        //If OCR was succesful, iterate through detections and store them in detections array
        if(components.isEmpty){}
        else{
            for word in components{ //Each word
                if(detections.contains(word)){  //If word is already seen
                    guard let hitIndexOfWord = detections.firstIndex(of: word) else { return nil }
                    if(hits[hitIndexOfWord] < 100){
                        hits[hitIndexOfWord] += 1
                    }
                }
                else{  //If word is new
                    if(word.count > 1){ //Keeps blanks out of the list
                        let isNumber = word.rangeOfCharacter(from: .decimalDigits)
                        if(isNumber == nil){ //If there are no numeric chars
                            detections.insert(word, at: hitCount)
                            print("DATAWORLD: detections-- \(detections)")
                            hits.insert(1, at: hitCount)
                            hitCount += 1
                        }
                    }
                }
            }
            print("DATAWORLD: detections-- \(detections)")
            print("DATAWORLD: hits-- \(hits)")
            print("DATAWORLD: hitCount-- \(hitCount)")
        }
        
        //Clears all detections and their hits every 7 seconds to prevent OCR staleness
        if(detections.endIndex > 7 && lastFoundWords.elementsEqual(foundWords)){ //7 is Arbitrary
            let elapsedTime = CFAbsoluteTimeGetCurrent() - initialTime
            print("DATAWORLD: [elapsedTime] - \(elapsedTime)")
            if(elapsedTime > 7) { //over 7 seconds
                detections.removeAll()
                hits.removeAll()
                foundWords.removeAll()
                hitCount = 0
                print("DATAWORLD: Arrays cleared.")
                print("DATAWORLD: Arrays cleared.")
                initialTime = CFAbsoluteTimeGetCurrent()
                DispatchQueue.main.async() {            //update uilabels
                    self.ocrData1.text = ""
                    self.ocrData2.text = ""
                    self.ocrData3.text = ""
                }
            }
        }
        else {
            initialTime = CFAbsoluteTimeGetCurrent()
            print("DATAWORLD: intialTime - \(String(describing: initialTime))")
        }
        
        //Gather the top 3 hits, place them in chosenWords array, and update scanning result labels
        var index:Int = 0
        var first:Int = 0
        var second:Int = 0
        var third:Int = 0
        
        if (detections.endIndex > 4) {
            for examinedIndex in hits{ //first hit
                if(examinedIndex > first){
                    first = index
                }
                index += 1
            }
            index = 0
            for examinedIndex in hits{ //second hit
                if(index != first){
                    if(examinedIndex > second){
                        second = index
                    }
                }
                index += 1
            }
            index = 0
            for examinedIndex in hits{ //third hit
                if(index != first || index != second){
                    if(examinedIndex > third){
                        third = index
                    }
                }
                index += 1
            }
            index = 0
            foundWords.removeAll()
            foundWords.append(detections[first])
            foundWords.append(detections[second])
            foundWords.append(detections[third])
            
            DispatchQueue.main.async() { //update UILabels
                self.ocrData1.text = self.foundWords[0]
                self.ocrData2.text = self.foundWords[1]
                self.ocrData3.text = self.foundWords[2]
            }
            
            lastFoundWords.removeAll()
            lastFoundWords.append(foundWords[0])
            lastFoundWords.append(foundWords[1])
            lastFoundWords.append(foundWords[2])
        }
        return recognizedStrings.joined(separator: " ")
    }
    
    
    //Search Button. Takes 3 displayed products, searches for matches in productList, and shows the results page
    @IBAction func searchProductButtonPressed(sender: UIButton) {
 
        var detectionStrength = [Int](repeating: 0, count: 3)
        var count = 0
        
        //Iterate through productList and mark matches of strings
        var sumOfDetections:Int = 0
        var highestDetection:Int = -1
        if(productList.count > 0){
            for product in productList{
                if((product.productName?.range(of: foundWords[0], options: .caseInsensitive)) != nil){
                    detectionStrength[count] += 1
                }
                print("DATAWORLD: [[ detectionStrength - \(detectionStrength)]]")
                count += 1
            }
            
            
            
            //Find the array position of the highest detection product
            count = 0
            while (count < detectionStrength.count){
                if(detectionStrength[count] > highestDetection){
                    highestDetection = count
                }
                print("DATAWORLD: [[ highestDetection - \(highestDetection)]]")
                count += 1
            }
            sumOfDetections = detectionStrength.reduce(0, +)
            print("DATAWORLD: [[ sumOfDetections - \(sumOfDetections)]]")
        }
        
        //Decide the answer based on detections
        if(sumOfDetections == 0){ //It aint here chief...
            sharedProductPrologue = "No matches"
            sharedProductName = "Please try again."
            sharedProductBit = -1
            sharedProductInfo = ""
        }
        else{ //Bingo
            let theChosenProduct = productList[highestDetection]
            print("DATAWORLD: [[ Product Detected - \(String(describing: theChosenProduct.productName)) ]]")
            print("DATAWORLD: [[ Product Detected - \(String(describing: theChosenProduct.recyclableBit)) ]]")
            print("DATAWORLD: [[ Product Detected - \(String(describing: theChosenProduct.recycleMessage)) ]]")
            sharedProductName = theChosenProduct.productName!
            sharedProductBit = theChosenProduct.recyclableBit
            sharedProductInfo = theChosenProduct.recycleMessage!
            print("DATAWORLD: $$$ spn=\(sharedProductName) spb=\(sharedProductBit) spi=\(sharedProductInfo)")
        }
        let finalViewController = self.storyboard?.instantiateViewController(identifier: "FinalViewController") as! FinalViewController
        let navController = UINavigationController(rootViewController: finalViewController)
        finalViewController.text = sharedProductName
        finalViewController.recycle = sharedProductBit
        finalViewController.zeroWasteMessage = sharedProductInfo
        present(navController, animated: true, completion: nil)
        self.navigationController?.pushViewController(finalViewController, animated: true)
    }
    
    
    //** Creates an array of Products from the SQLite DB **//
    func readDB(){
        
        //Prepare DB URL and open connection
        let dbUrl = Bundle.main.url(forResource: "products", withExtension: "db")
        let dbPath = dbUrl?.path
        if sqlite3_open(dbPath, &db) != SQLITE_OK{
            print("DATAWORLD: error opening database")
        }
        else { print("DATAWORLD: Successfully opened connection to DB at \(String(describing: dbUrl))") }
        
        
        //Empty the list of Products
        productList.removeAll()
        
        //Prepare the query
        let queryString = "SELECT * FROM products"
        var stmt:OpaquePointer?
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            DispatchQueue.main.async() {            //update uilabels
                self.ocrData3.text = "error preparing insert: \(errmsg)"
            }
            print("DATAWORLD: error preparing insert: \(errmsg)")
            return
        }
        else{
            print("DATAWORLD: Succesful connection to Database and tables.")
        }
        
        //Traverse through all records and add Products to productList Array
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let upc = String(cString: sqlite3_column_text(stmt, 0))
            let productName = String(cString: sqlite3_column_text(stmt, 1))
            let recyclableBit = sqlite3_column_int(stmt, 2)
            let recycleMessage = String(cString: sqlite3_column_text(stmt, 3))
            productList.append(Product(upc: String(upc), productName: String(describing: productName),                                        recyclableBit: Int(recyclableBit), recycleMessage: String(describing: recycleMessage)))
        }
    }
    
    //Open Final View Controller and send data over
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let text = sharedProductName
        let recycle = sharedProductBit
        let zeroWasteMessage = sharedProductInfo
        
        
        // Create a new variable to store the instance of the SecondViewController
        // set the variable from the SecondViewController that will receive the data
        let destinationVC = segue.destination as! FinalViewController
        destinationVC.text = text
        destinationVC.recycle = recycle
        destinationVC.zeroWasteMessage = zeroWasteMessage
    }
}


//[] The Object Class for the db import []//
class Product {
    var upc: String?
    var productName: String?
    var recyclableBit: Int
    var recycleMessage: String?
    
    init(upc: String?, productName: String?, recyclableBit: Int, recycleMessage: String?){
        self.upc = upc
        self.productName = productName
        self.recyclableBit = recyclableBit
        self.recycleMessage = recycleMessage
    }
}

    
/*
    //** Creates and Processes Object Recognitions Requests **//
    func objectRecognition(pixelBuffer:CVPixelBuffer){
        //AI model. Resnet is larger but more accurate than SqueezeNet
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else{return}
        
        //Create Object Recognition request and process for Objects
        let request_ObjectDetection = VNCoreMLRequest(model: model){ (finishedReq, err) in
            guard let results = finishedReq.results as? [VNClassificationObservation] else{return}
            guard let firstObservation = results.first else{return}
            print("DATAWORLD: [OBJ]  " + firstObservation.identifier, firstObservation.confidence)
            self.objDataText = "\(firstObservation.identifier)  \(firstObservation.confidence)"
        }
        
        //Perform Object Recognition through request using buffer (showtime baby)
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request_ObjectDetection])
    }
}
*/

