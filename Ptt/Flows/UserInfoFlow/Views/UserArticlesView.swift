//
//  UserArticlesView.swift
//  Ptt
//
//  Created by AnsonChen on 2023/4/29.
//  Copyright © 2023 Ptt. All rights reserved.
//

import SwiftUI

struct UserArticlesView: View {
    @Binding var articles: [APIModel.ArticleSummary]

    var body: some View {
        ScrollView {
            ForEach(articles, id: \.url) { article in
                ArticleCell(article: article)
            }
        }
    }
}

private struct ArticleCell: View {
    @State var article: APIModel.ArticleSummary

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(article.bid)/\(article.class)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(PttColors.lightBlueGrey.swiftUIColor)
                Spacer()
                Image(systemName: "clock")
                    .resizable()
                    .rotation3DEffect(.degrees(0), axis: (x: 1, y: 0, z: 0))
                    .frame(width: 11, height: 11)
                    .foregroundColor(PttColors.blueGrey.swiftUIColor)
                Text(article.modified.toBoardDateString())
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(PttColors.blueGrey.swiftUIColor)
            }
            .padding(.top, 20)
            Text(article.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 18))
                .foregroundColor(PttColors.paleGrey.swiftUIColor)
                .padding(.top, 17)
            HStack {
                Image(uiImage: StyleKit.imageOfUpvote())
                    .renderingMode(.template)
                    .frame(width: 15, height: 15)
                    .foregroundColor(PttColors.tuna.swiftUIColor)
                Text("\(article.recommend)")
                    .font(.system(size: 12))
                    .foregroundColor(PttColors.paleGrey.swiftUIColor)
                Image(uiImage: StyleKit.imageOfComment())
                    .renderingMode(.template)
                    .frame(width: 17, height: 11.4)
                    .foregroundColor(PttColors.tuna.swiftUIColor)
                Text("\(article.comments)")
                    .font(.system(size: 12))
                    .foregroundColor(PttColors.paleGrey.swiftUIColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 14)
            .padding(.bottom, 22)
        }
        .padding(.horizontal, 24)
        .background(PttColors.shark.swiftUIColor)
    }
}

struct UserArticlesView_Previews: PreviewProvider {
    static var previews: some View {
        UserArticlesView(articles: .constant([.init(), .init(), .init()]))
    }
}
