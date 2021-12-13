//
//  PopularArticlesViewModel.swift
//  Ptt
//
//  Created by Anson on 2021/12/5.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation

protocol PopularArticlesVMProtocol {
    var data: [APIModel.GoPttBBSBrdArticle] { get }

    func fetchData(isPullDownToRefresh: Bool)
    func shouldFetchData(isPullDownToRefresh: Bool) -> Bool
}

final class PopularArticlesViewModel: PopularArticlesVMProtocol {
    private let apiClient: APIClientProtocol
    private var pageIndex: String = ""
    private var paginationLimit: Int = 200
    private var isDescending = true
    private weak var uiDelegate: PopularArticlesView?
    private(set) var data: [APIModel.GoPttBBSBrdArticle] = []

    init(apiClient: APIClientProtocol, uiDelegate: PopularArticlesView) {
        self.apiClient = apiClient
        self.uiDelegate = uiDelegate
    }

    func fetchData(isPullDownToRefresh: Bool) {
        guard self.shouldFetchData(isPullDownToRefresh: isPullDownToRefresh) else {
            self.uiDelegate?.stopSpinning(isPullDownToRefresh: isPullDownToRefresh)
            return
        }
        self.uiDelegate?.startSpinning(isPullDownToRefresh: isPullDownToRefresh)
        if isPullDownToRefresh {
            pageIndex = ""
        }

        self.apiClient.getPopularArticles(startIdx: self.pageIndex, limit: self.paginationLimit, desc: self.isDescending) { [weak self] result in
            guard let self = self else { return }
            switch (result) {
            case .success(let response):
                let lists = response.list
                if self.pageIndex.isEmpty {
                    self.data = lists
                    self.uiDelegate?.reloadTable()
                } else {
                    let upper = self.data.count
                    self.data += lists
                    let lower = self.data.count
                    let paths = Array(upper..<lower)
                        .map { IndexPath(row: $0, section: 0)}
                    self.uiDelegate?.insert(rows: paths)
                }
                self.pageIndex = response.next_idx
            case .failure(let error):
                self.uiDelegate?.show(error: error)
            }
            self.uiDelegate?.stopSpinning(isPullDownToRefresh: isPullDownToRefresh)
        }
    }

    func shouldFetchData(isPullDownToRefresh: Bool) -> Bool {
        if self.uiDelegate?.isLoading() ?? true { return false }
        if isPullDownToRefresh { return true }
        if data.count % self.paginationLimit == 0 {
            return true
        }
        return false
    }
}
