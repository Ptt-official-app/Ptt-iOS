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
        boardNameLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        return boardNameLabel
    }()
    
    lazy var boardTitleLabel: UILabel = {
        let boardTitleLabel = UILabel()
        boardTitleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        return boardTitleLabel
    }()
    
//    lazy var favoriteButton : FavoriteButton = {
//        let button = FavoriteButton()
//        contentView.ptt_add(subviews: [button])
//        NSLayoutConstraint.activate([
//            button.topAnchor.constraint(equalTo: contentView.topAnchor),
//            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            button.widthAnchor.constraint(equalTo: button.heightAnchor)
//        ])
//        return button
//    }()
    
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
        contentView.ptt_add(subviews: [boardNameLabel, boardTitleLabel])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
    }
    
    func configure(_ viewModel: PopularBoardsViewModel, index: Int) {
//        let imageUrl = viewModel.imageUrls.value[index]
//        picImageView.image = nil
//        if imageUrl.hasSuffix("gif") {
//            if viewModel.uiImages.keys.contains(imageUrl) {
//                picImageView.image = viewModel.uiImages[imageUrl]
//                return
//            }
//            loadGif(url: imageUrl)
////            picImageView.loadGif(url: imageUrl)
//
////            guard let imageViewAccessibilityIdentifier = picImageView.accessibilityIdentifier else {return}
////            if imageViewAccessibilityIdentifier.isEmpty {
////                picImageView.accessibilityIdentifier = viewModel.title.value
////            }
////            if viewModel.title.value == picImageView.accessibilityIdentifier {
////                picImageView.loadGif(url: imageUrl)
////            }
//        }
//        else if imageUrl.hasSuffix("mp4") {
//            guard let videoUrl = URL(string: imageUrl) else {return}
//            let player = AVPlayer(url: videoUrl)
//            let playerLayer = AVPlayerLayer(player: player)
//            playerLayer.frame = picImageView.bounds
//            contentView.layer.addSublayer(playerLayer)
//            player.play()
//            loopVideo(videoPlayer: player)
//        }
//        else {
//            picImageView.sd_setImage(with: URL(string: imageUrl))
//        }
    }
    
    func setConstraints() {
//        NSLayoutConstraint(item: boardNameLabel!, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
//        NSLayoutConstraint(item: boardNameLabel!, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
//        NSLayoutConstraint(item: boardNameLabel!, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
//        NSLayoutConstraint(item: boardNameLabel!, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
//
//        NSLayoutConstraint(item: boardTitleLabel!, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
//        NSLayoutConstraint(item: boardTitleLabel!, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
//        NSLayoutConstraint(item: boardTitleLabel!, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
//        NSLayoutConstraint(item: boardTitleLabel!, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        
        
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
