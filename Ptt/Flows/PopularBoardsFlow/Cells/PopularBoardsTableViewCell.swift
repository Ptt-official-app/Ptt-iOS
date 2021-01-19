//
//  PopularBoardsTableViewCell.swift
//  Ptt
//
//  Created by marcus fu on 2021/1/9.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

class PopularBoardsTableViewCell: UITableViewCell {
    lazy var boardNameLabel: UILabel = {
        let boardNameLabel = UILabel()
        boardNameLabel.font = UIFont.systemFont(ofSize: 19)
        return boardNameLabel
    }()
    
    lazy var boardTitleLabel: UILabel = {
        let boardTitleLabel = UILabel()
        boardTitleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        return boardTitleLabel
    }()
    
    lazy var nuserLabel: UILabel = {
        let nuserLabel = UILabel()
        nuserLabel.font = UIFont.systemFont(ofSize: 12)
        return nuserLabel
    }()
    
    lazy var nuserUIImageView: UIImageView = {
        let nuserUIImageView = UIImageView()
        nuserUIImageView.contentMode = .scaleAspectFit
        nuserUIImageView.image = StyleKit.imageOfPopularNUser()
        return nuserUIImageView
    }()
    
//    var delegate: DetailTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = GlobalAppearance.backgroundColor
//        selectionStyle = .none
        if #available(iOS 11.0, *) {
            boardNameLabel.textColor = UIColor(named: "textColor-240-240-247")
            boardTitleLabel.textColor = UIColor(named: "textColorGray")
        } else {
            boardNameLabel.textColor = UIColor(red: 240/255, green: 240/255, blue: 247/255, alpha: 1.0)
            boardTitleLabel.textColor = .systemGray
        }
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configure(_ viewModel: PopularBoardsViewModel, index: Int) {
        boardNameLabel.text = viewModel.popularBoards.value[index].brdname
        boardTitleLabel.text = viewModel.popularBoards.value[index].title
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
        contentView.ptt_add(subviews: [boardNameLabel, boardTitleLabel, nuserLabel, nuserUIImageView])
        
        NSLayoutConstraint(item: nuserLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: nuserLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 10).isActive = true
        NSLayoutConstraint(item: nuserLabel, attribute: .leading, relatedBy: .equal, toItem: nuserUIImageView, attribute: .trailing, multiplier: 1.0, constant: 4).isActive = true
        
        NSLayoutConstraint(item: nuserUIImageView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 11).isActive = true
        
        let viewsDict = ["boardNameLabel": boardNameLabel, "boardTitleLabel": boardTitleLabel]
        let metrics = ["hp": 20, "vp": 10, "vps": 4]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(hp)-[boardNameLabel]-|",
                                                      options: [], metrics: metrics, views: viewsDict)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(hp)-[boardTitleLabel]-|",
                                                      options: [], metrics: metrics, views: viewsDict)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(vp)-[boardNameLabel]-(vps)-[boardTitleLabel]-(vp)-|",
                                                      options: [], metrics: metrics, views: viewsDict)
        NSLayoutConstraint.activate(constraints)
    }
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
