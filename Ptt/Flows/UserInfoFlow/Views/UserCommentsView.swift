//
//  UserCommentsView.swift
//  Ptt
//
//  Created by AnsonChen on 2023/4/29.
//  Copyright © 2023 Ptt. All rights reserved.
//

import SwiftUI

struct UserCommentsView: View {
    @Binding var comments: [APIModel.ArticleComment]

    var body: some View {
        ScrollView {
            ForEach(comments, id: \.index) { comment in
                CommentCell(comment: comment)
            }
        }
    }
}

private struct CommentCell: View {
    @State var comment: APIModel.ArticleComment

    var body: some View {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd HH:mm"

        return VStack(spacing: 0) {
            Text("\(comment.bid)/\(comment.class)/\(comment.title)")
                .lineLimit(1)
                .font(.system(size: 12, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(PttColors.lightBlueGrey.swiftUIColor)
            .padding(.top, 20)
            Text(comment.plainComment)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 18))
                .foregroundColor(PttColors.paleGrey.swiftUIColor)
                .padding(.top, 17)
            HStack {
                Image(uiImage: StyleKit.imageOfUpvote())
                    .renderingMode(.template)
                    .frame(width: 15, height: 15)
                    .foregroundColor(PttColors.tuna.swiftUIColor)
                Text("\(comment.recommend)")
                    .font(.system(size: 12))
                    .foregroundColor(PttColors.paleGrey.swiftUIColor)
                Spacer()
                Text(comment.commentTime, formatter: dateFormatter)
                    .font(.system(size: 12))
                    .foregroundColor(PttColors.lightBlueGrey.swiftUIColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 14)
            .padding(.bottom, 22)
        }
        .padding(.horizontal, 24)
        .background(PttColors.shark.swiftUIColor)
    }
}

struct UserCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        UserCommentsView(comments: .constant([.init(), .init(), .init()]))
    }
}
