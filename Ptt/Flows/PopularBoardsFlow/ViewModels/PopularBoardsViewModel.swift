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
    var popularBoards = Observable<[APIModel.BoardInfoV2]>(value: [])
    var delegate: PopularBoardsViewModelDelegate?
    
    let subPath = "boards/popular"
    let token = "123"
    let querys: Dictionary<String, Any> = ["start_idx": "", "limit": 0, "asc": false]
    
    init() {
        initViewModel()
    }
    
    func initViewModel() {
        popularBoards.value.removeAll()
    }
    
    func start() {
        initViewModel()
        APIClient.shared.getBoardListV3(subPath: subPath, token: token, querys: querys) { [weak self] (result) in
            guard let weakSelf = self else { return }
            switch result {
                case .failure(error: let apiError):
                    print("ErrorMessage " + apiError.message)
                    weakSelf.delegate?.showErrorAlert(errorMessage: apiError.message)
                    return
                case .success(data: let data):
                    for item in data.list {
                        weakSelf.popularBoards.value.append(item)
                    }
                    
                    //test
                    if (weakSelf.popularBoards.value.count <= 2) {
                        weakSelf.popularBoards.value.append(contentsOf: [
                            APIModel.BoardInfoV2(brdname: "Gossiping", title: "[八卦] 請協助置底協尋", nuser: 188),
                            APIModel.BoardInfoV2(brdname: "C_Chat", title: "[希洽] 養成好習慣 看文章前先ID", nuser: 4886),
                            APIModel.BoardInfoV2(brdname: "NBA", title: "[NBA] R.I.P. Mr. David Stern", nuser: 3760),
                            APIModel.BoardInfoV2(brdname: "Lifeismoney", title: "[省錢] 省錢板", nuser: 5238),
                            APIModel.BoardInfoV2(brdname: "Stock", title: "[股版] 發文請先詳閱版規", nuser: 254),
                            APIModel.BoardInfoV2(brdname: "HatePolitics", title: "[政黑] 第三勢力先知王kusanagi02", nuser: 37890),
                            APIModel.BoardInfoV2(brdname: "Baseball", title: "[棒球] 2020東奧六搶一在台灣", nuser: 598333),
                            APIModel.BoardInfoV2(brdname: "Tech_Job", title: "[科技] 修機改善是設備終生職責", nuser: 20009),
                            APIModel.BoardInfoV2(brdname: "LoL", title: "[LoL] PCS可憐哪", nuser: 12345),
                            APIModel.BoardInfoV2(brdname: "Beauty", title: "[表特] 發文附圖", nuser: 5376),
                        ])
                    }
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
