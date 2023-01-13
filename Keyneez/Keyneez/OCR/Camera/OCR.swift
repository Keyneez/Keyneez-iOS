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


protocol TextRecognizable {
  func recognizeText(in image: VisionImage, width: CGFloat, height: CGFloat, completion: @escaping (String) -> Void)
}

final class OCRService: TextRecognizable {
  
  private var koreanOptions = KoreanTextRecognizerOptions()
  
//  private var IdcontentBuffer: [] = []
  
  init() { }
  
  func recognizeText(in image: VisionImage, width: CGFloat, height: CGFloat, completion: @escaping (String) -> Void) {
    var recognizedText: Text
    do {
      recognizedText = try TextRecognizer.textRecognizer(options: koreanOptions)
        .results(in: image)
      completion(recognizedText.text)
    } catch let error {
      print("이미지 인식에 실패 \(error.localizedDescription).")
    }
  }
  
  private func regexStudentIDCard(with: String) {
    
  }
  
  private func regexTeenIDCard(with: String) {
    
  }
  
}
