//
//  PopularBoardsTableViewCell.swift
//  Ptt
//
//  Created by marcus fu on 2021/1/9.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

class PopularBoardsTableViewCell: BoardsTableViewCell {

    lazy var nuserLabel: UILabel = {
        let nuserLabel = UILabel()
        nuserLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        if #available(iOS 11.0, *) {
            nuserLabel.textColor = UIColor(named: "textColor-240-240-247")!
        } else {
            nuserLabel.textColor = UIColor(red:240/255, green:240/255, blue:247/255, alpha:1.0)
        }
        return nuserLabel
    }()

    lazy var nuserUIImageView: UIImageView = {
        let nuserUIImageView = UIImageView()
        nuserUIImageView.contentMode = .scaleAspectFit
        nuserUIImageView.image = StyleKit.imageOfPopularNUser()
        return nuserUIImageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ viewModel: PopularBoardsViewModel, index: Int) {
        boardName = viewModel.popularBoards.value[index].brdname
        boardTitle = viewModel.popularBoards.value[index].title
        nuserLabel.text = "\(viewModel.popularBoards.value[index].nuser)"

        if (viewModel.popularBoards.value[index].nuser < 2000) {
            nuserUIImageView.setImageColor(color: UIColor.white)
        }
        else if (viewModel.popularBoards.value[index].nuser < 5000) {
            nuserUIImageView.setImageColor(color: UIColor.red)
        }
        else if (viewModel.popularBoards.value[index].nuser < 10000) {
            nuserUIImageView.setImageColor(color: UIColor.blue)
        }
        else if (viewModel.popularBoards.value[index].nuser >= 10000) {
            nuserUIImageView.setImageColor(color: UIColor.cyan)
        }
    }

    func setConstraints() {
        contentView.ptt_add(subviews: [nuserLabel, nuserUIImageView])

        NSLayoutConstraint(item: nuserLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -20).isActive = true
        NSLayoutConstraint(item: nuserLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 10).isActive = true
        NSLayoutConstraint(item: nuserLabel, attribute: .leading, relatedBy: .equal, toItem: nuserUIImageView, attribute: .trailing, multiplier: 1.0, constant: 4).isActive = true

        NSLayoutConstraint(item: nuserUIImageView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 11).isActive = true
    }
}
