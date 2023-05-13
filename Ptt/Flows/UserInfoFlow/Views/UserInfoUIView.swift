//
//  UserInfoUIView.swift
//  Ptt
//
//  Created by AnsonChen on 2023/3/22.
//  Copyright © 2023 Ptt. All rights reserved.
//

import SwiftUI

struct UserInfoUIView: View {
    @StateObject var viewModel: UserInfoViewModel
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    let tabBarHeight: CGFloat = 48

    var body: some View {
        VStack {
            headerView
            segmentView
            switch viewModel.currentSegment {
            case 0:
                ProfileView(viewModel: viewModel)
                    .padding(.horizontal, 25)
                    .padding(.top, 34)
            case 1:
                UserArticlesView(articles: $viewModel.articles)
                    .padding(.top, 22)
            case 2:
                UserCommentsView(comments: $viewModel.comments)
                    .padding(.top, 22)
            default:
                Spacer()
            }
            Spacer()
        }
        .padding(.top, safeAreaInsets.top)
        .padding(.bottom, safeAreaInsets.bottom + tabBarHeight)
        .background(PttColors.codGray.swiftUIColor)
        .edgesIgnoringSafeArea([.top, .bottom])
        .onAppear(perform: viewModel.fetchData)
    }

    private var segmentView: some View {
        HStack {
            ForEach(Array(viewModel.segment.enumerated()), id: \.offset) { index, text in
                Button(text) {
                    viewModel.updateCurrentSegment(to: index)
                }
                .font(.system(size: 12))
                .foregroundColor(PttColors.paleGrey.swiftUIColor)
                .frame(width: 97, height: 34)
                .background(index == viewModel.currentSegment ? PttColors.blueGrey.swiftUIColor : Color.clear)
                .cornerRadius(17)

                if index < viewModel.segment.count - 1 {
                    Spacer()
                }
            }
        }
        .frame(height: 34)
        .background(PttColors.shark.swiftUIColor)
        .cornerRadius(17)
        .padding(.horizontal, 25)
    }

    private var headerView: some View {
        VStack(spacing: 0) {
            ZStack {
                Image(uiImage: viewModel.avatar)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                // Disable, can't edit right now
//                HStack {
//                    Spacer()
//                    Image(uiImage: StyleKit.imageOfCompose())
//                        .frame(width: 24, height: 24)
//                        .padding(.trailing, 30)
//                }
//                .padding(.bottom, 35)
            }
            Text(viewModel.account)
                .foregroundColor(PttColors.paleGrey.swiftUIColor)
                .font(.system(size: 16, weight: .bold))
                .padding(.top, 20)
            Text(viewModel.name)
                .foregroundColor(PttColors.paleGrey.swiftUIColor)
                .font(.system(size: 14, weight: .bold))
                .padding(.top, 5)
            // Comment, since not sure what is this
//            HStack {
//                Image(uiImage: StyleKit.imageOfUpvote())
//                    .renderingMode(.template)
//                    .foregroundColor(PttColors.slateGrey.swiftUIColor)
//                    .frame(width: 18, height: 18)
//                Text("1.8k")
//                    .font(.system(size: 18))
//                    .foregroundColor(PttColors.tangerine.swiftUIColor)
//            }
        }
    }
}

struct UserInfoUIView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoUIView(viewModel: UserInfoViewModel())
    }
}
