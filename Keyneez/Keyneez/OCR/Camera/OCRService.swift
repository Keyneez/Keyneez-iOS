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
  func recognizeText(in image: VisionImage, with uiimage: UIImage, width: CGFloat, height: CGFloat, completion: @escaping ([String], UIImage) -> Void)
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
  
  func recognizeTextWithManual(in image: VisionImage, with uiimage: UIImage, width: CGFloat, height: CGFloat, completion: @escaping ([String], UIImage) -> Void) {
    var recognizedText: Text
    do {
      recognizedText = try TextRecognizer.textRecognizer(options: koreanOptions)
        .results(in: image)
      let splited = recognizedText.text.components(separatedBy: ["\n", ":", "."]).map { String($0)}
      let regexed = regexIDCard(with: splited)
      
      completion(regexed, uiimage)
    } catch let error {
      print("이미지 인식에 실패 \(error.localizedDescription).")
    }

  }
  
  func recognizeText(in image: VisionImage, with uiimage: UIImage, width: CGFloat, height: CGFloat, completion: @escaping ([String], UIImage) -> Void) {
    var recognizedText: Text
    do {
      recognizedText = try TextRecognizer.textRecognizer(options: koreanOptions)
        .results(in: image)
      if bufferHasSurplusSpace() {
        let splited = recognizedText.text.components(separatedBy: ["\n", ":", "."]).map { String($0)}
        let regexed = regexIDCard(with: splited)
        
        append(text: regexed, image: uiimage)
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
  
  private func append(text: [String], image: UIImage) {
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
  
  private func appendTextsInTextBuffer(with text: [String]) {
    self.textBuffer.append(text)
  }
  
  private func checkOCRSuccess(completion: @escaping ([String], UIImage) -> Void, failure: @escaping () -> Void) {
    
    
    var textDict: [String:Int] = [:]
    for textElement in textBuffer {
      for text in textElement {
        textDict.updateValue((textDict[text] ?? 0) + 1, forKey: text)
      }
    }
    var sortedArr = textDict.sorted(by: { $0.value > $1.value })
    // 2개 미만일 경우 Flush
    var newArr = sortedArr.map { $0.key }
    if newArr.count < 2 {
      failure()
      return
    }
    // 2개일 경우,
    if newArr.count < 3 {
      newArr.append("")
    }

    newArr = Array(newArr[0..<3])
    if checkTeenID(in: newArr) || checkSchool(in: newArr) {
      completion(newArr, imageBuffer[5])
      return
    }
  }
  
  private func checkTeenID(in arr: [String]) -> Bool {
    for str in arr {
      if str.contains("청소년증") {
        return true
      }
    }
    return false
  }
  
  private func checkSchool(in arr: [String]) -> Bool {
    for str in arr {
      if str.contains("학교") {
        return true
      }
    }
    return false
  }
    
  private func regexIDCard(with strings: [String]) -> [String] {
    let numberPattern = "[0-9]*"
    var result: [String] = []
    var strList = strings
      .filter { $0.count >= 3}
      .map { String($0).trimmingCharacters(in: .whitespaces) }
    var flag = ""
    if strList.count < 7 {
      for index in 0..<strList.count {
        if strList[index].contains("학교") || strList[index].contains("학생") {
          flag = "학생증"
          break
        }
      }
      if flag == "학생증" {
        var resultSet: Set<String> = []
        for index in 0..<strList.count {
          if strList[index].contains("학생") {
            resultSet.insert("학생증")
          } else if strList[index].contains("학교") {
            resultSet.insert(strList[index])
          } else {
            // 숫자가 들어있거나 영어가 들어있지 않다면 추가
            let pattern = "^[가-힣]*$"
            guard let range = strList[index].range(of: pattern, options: .regularExpression) else { continue }
            print(range)
            resultSet.insert(strList[index])
          }
        }
        return Array(resultSet)
      }
    }
    
    if strList.count > 5 {
      for index in 0...5 {
        if strList[index].contains("청소년") {
          result.append("청소년증")
          continue
        } else {
          if let range = strList[index].range(of: numberPattern, options: .regularExpression) {
            if !strList[index][range].isEmpty {
              guard let str = strList[index].split(separator: "-").first else { continue }
              result.append(String(str))
              continue
            }
          }
          
          if strList[index].count <= 4 {
            result.append(strList[index])
          }
        }
      }
    }
    
    return Array(Set(result))
  }
  
  func regexStudentID(with strList: [String]) {
    
  }
    
}
