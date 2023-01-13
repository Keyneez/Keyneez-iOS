//
//  File.swift
//  Keyneez
//
//  Created by Jung peter on 1/12/23.
//

import UIKit

import MLKitTextRecognitionKorean
import MLKitTextRecognition
import MLKit
import MLImage
import UIKit

fileprivate let success = false

protocol TextRecognizable {
  func recognizeText(in image: VisionImage, with uiimage: UIImage, width: CGFloat, height: CGFloat, completion: @escaping (String, UIImage) -> Void)
}

final class OCRService: TextRecognizable {
  
  private var koreanOptions = KoreanTextRecognizerOptions()
  var bufferLength = 10
  var semaphore: DispatchSemaphore
  var textBuffer: [[String]] = []
  var imageBuffer: [UIImage] = []
  
  init() {
    self.semaphore = DispatchSemaphore(value: bufferLength)
  }
  
  func recognizeText(in image: VisionImage, with uiimage: UIImage, width: CGFloat, height: CGFloat, completion: @escaping (String, UIImage) -> Void) {
    var recognizedText: Text
    do {
      recognizedText = try TextRecognizer.textRecognizer(options: koreanOptions)
        .results(in: image)
      print(recognizedText.text)
      if bufferHasSurplusSpace() {
        append(text: recognizedText.text, image: uiimage)
      } else {
        checkOCRSuccess(completion: completion) { [weak self] in
          self?.flush()
        }
      }
    } catch let error {
      print("이미지 인식에 실패 \(error.localizedDescription).")
    }
  }
  
  private func bufferHasSurplusSpace() -> Bool {
    return textBuffer.count < bufferLength - 1 && imageBuffer.count < bufferLength - 1
  }
  
  private func append(text: String, image: UIImage) {
    appendTextsInTextBuffer(with: text)
    appendImageInImageBuffer(with: image)
  }
  
  func flush() {
    imageBuffer.removeAll()
    textBuffer.removeAll()
    for _ in 0..<bufferLength {
      semaphore.signal()
    }
  }
  
  private func appendImageInImageBuffer(with image: UIImage) {
    self.imageBuffer.append(image)
  }
  
  private func appendTextsInTextBuffer(with text: String) {
    self.textBuffer.append(text.split(separator: "\n").map {String($0)})
  }
  
  private func checkOCRSuccess(completion: @escaping (String, UIImage) -> Void, failure: @escaping () -> Void) {
    // 1. 성공
    if success {
      let successIndex = 4
      completion("성공", imageBuffer[successIndex])
    } else {
      failure()
    }
  }
    
  private func regexStudentIDCard(with: String) {
    
  }
  
  private func regexTeenIDCard(with: String) {
    
  }
  
}
