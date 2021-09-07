//
//  ComposeArticleViewModel.swift
//  Ptt
//
//  Created by marcus fu on 2021/9/5.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation

class ComposeArticleViewModel {
    var contentPropertyOutSideArray: [[APIModel.ContentProperty]] = []
    var currentText: String = ""
    
    init() {
        initViewModel()
    }
    
    func initViewModel() {
        contentPropertyOutSideArray.removeAll()
        currentText = ""
    }
    
    func getContentPropertyOutSideArray() -> [[APIModel.ContentProperty]] {
        if (!currentText.isEmpty) {
            var contentPropertyArray: [APIModel.ContentProperty] = []
            contentPropertyArray.append(APIModel.ContentProperty(text: currentText))
            contentPropertyOutSideArray.append(contentPropertyArray)
        }
        return contentPropertyOutSideArray
    }
    
    func insertContent(_ text: String) {
        if (text == "\n") {
            var contentPropertyArray: [APIModel.ContentProperty] = []
            if (!currentText.isEmpty) {
                contentPropertyArray.append(APIModel.ContentProperty(text: currentText))
            }
            contentPropertyOutSideArray.append(contentPropertyArray)
            currentText = ""
        }
        else if (text == "") {
            if (currentText.isEmpty) {
                if (!contentPropertyOutSideArray.isEmpty) {
                    currentText = contentPropertyOutSideArray[0][0].text
                    contentPropertyOutSideArray.removeLast()
                }
            }
            else {
                currentText = String(currentText.dropLast())
            }
        }
        else {
            currentText += text
        }
    }
}
