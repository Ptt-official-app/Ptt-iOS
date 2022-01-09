//
//  PopularArticleCell.swift
//  Ptt
//
//  Created by Anson on 2021/12/9.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

final class PopularArticleCell: UITableViewCell {

    static var reuseID = "PopularArticleCell"
    static var nib = UINib(nibName: "PopularArticleCell", bundle: nil)
    @IBOutlet private var categoryIcon: UIImageView!
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var metadataLabel: UILabel!
    @IBOutlet private var previewImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var titleRightToPreview: NSLayoutConstraint!
    @IBOutlet private var titleRightToContentView: NSLayoutConstraint!
    @IBOutlet private var upvoteIcon: UIImageView!
    @IBOutlet private var upvoteLabel: UILabel!
    @IBOutlet private var commentIcon: UIImageView!
    @IBOutlet private var commentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.categoryLabel.font = UIFont.preferredFont(forTextStyle: .headline).bold()
        self.upvoteLabel.font = UIFont.preferredFont(forTextStyle: .headline).bold()
        self.commentLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        self.categoryIcon.image = StyleKit.imageOfPopularBoard()
        self.upvoteIcon.image = StyleKit.imageOfUpvote()
        self.commentIcon.image = StyleKit.imageOfComment()
        self.hasPreviewImage(has: false)
    }

    override func prepareForReuse() {
        self.hasPreviewImage(has: false)
    }

    func config(by info: APIModel.GoPttBBSBrdArticle) {
        self.categoryLabel.text = self.assembleCategoryText(info: info)
        self.metadataLabel.text = self.assembleMetadataText(info: info)
        self.titleLabel.text = info.title.withoutCategory
        self.setupVote(recommend: info.recommend)
        self.commentLabel.text = info.n_comments.easyRead
    }

    private func assembleCategoryText(info: APIModel.GoPttBBSBrdArticle) -> String {
        let boardName = info.url.getBorderName()
        return info.class.isEmpty ? boardName: "\(boardName)/\(info.class)"
    }

    private func assembleMetadataText(info: APIModel.GoPttBBSBrdArticle) -> String {
        "\(info.owner)∙\(info.create_time.diff())"
    }

    private func setupVote(recommend: Int) {
        self.upvoteIcon.image = recommend >= 0 ? StyleKit.imageOfUpvote(): StyleKit.imageOfDownvote()
        self.upvoteLabel.text = recommend.easyRead
    }

    private func hasPreviewImage(has: Bool) {
        if has {
            self.titleRightToPreview.isActive = true
            self.titleRightToContentView.isActive = false
        } else {
            self.previewImageView.image = nil
            self.titleRightToPreview.isActive = false
            self.titleRightToContentView.isActive = true
        }
    }
}
