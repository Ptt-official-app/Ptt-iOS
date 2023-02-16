//
//  PopularBoardsViewModel.swift
//  Ptt
//
//  Created by marcus fu on 2021/1/10.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation

protocol PopularBoardsViewModelDelegate {
    func showErrorAlert(errorMessage: String)
}

class PopularBoardsViewModel {
    var popularBoards = Observable<[APIModel.BoardInfo]>(value: [])
    var delegate: PopularBoardsViewModelDelegate?

    let subPath = "boards/popular"
    let token = ""

    init() {
        initViewModel()
    }

    func initViewModel() {
        popularBoards.value.removeAll()
    }

    func start() {
        APIClient.shared.getPopularBoards(subPath: subPath, token: token) { [weak self] (result) in
            guard let weakSelf = self else { return }
            switch result {
                case .failure(error: let apiError):
                    print("ErrorMessage " + apiError.message)
                    weakSelf.delegate?.showErrorAlert(errorMessage: apiError.message)
                    return
                case .success(data: let data):
                    var tempList: [APIModel.BoardInfo] = []

                    for item in data.list {
                        tempList.append(item)
                    }
                    weakSelf.initViewModel()
                    weakSelf.popularBoards.value = tempList
                    return
            }
        }
    }
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
