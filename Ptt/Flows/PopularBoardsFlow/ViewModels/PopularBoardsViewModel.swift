//
//  PopularBoardsViewModel.swift
//  Ptt
//
//  Created by marcus fu on 2021/1/10.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation

protocol PopularBoardsViewModelDelegate {
    func reloadData()
}

class PopularBoardsViewModel {
    var popularBoards = Observable<[PopularBoard]>(value: [])
    
    var delegate: PopularBoardsViewModelDelegate!
    
    //        didSet {
    //            boardNameLabel.text = boardName
    //        }
    //    }
    //    var boardTitle : String? {
    //        didSet {
    //            boardTitleLabel.text = boardTitle
    //        }
    //    }
}

class Observable<T> {
    var value: T {
        didSet {
            DispatchQueue.main.async {
                self.valueChanged?(self.value)
            }
        }
    }
    
    private var valueChanged: ((T) -> Void)?
    
    init(value: T) {
        self.value = value
    }
    
    /// Add closure as an observer and trigger the closure imeediately if fireNow = true
    func addObserver(fireNow: Bool = true, _ onChange: ((T) -> Void)?) {
        valueChanged = onChange
        if fireNow {
            onChange?(value)
        }
    }
    
    func removeObserver() {
        valueChanged = nil
    }
    
}
