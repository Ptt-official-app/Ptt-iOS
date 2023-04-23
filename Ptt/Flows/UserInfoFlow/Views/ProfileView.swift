//
//  ProfileView.swift
//  Ptt
//
//  Created by AnsonChen on 2023/4/28.
//  Copyright © 2023 Ptt. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: UserInfoViewModel

    var body: some View {
        VStack {
            ProfileStack
                .frame(maxWidth: .infinity)
        }
    }

    private var ProfileStack: some View {
        VStack(spacing: 16) {
            ForEach(viewModel.profileData, id: \.description) { rowData in
                HStack {
                    ForEach(rowData, id: \.0) { key, value in
                        ProfileBlock(key: key, value: value)
                            .frame(maxWidth: .infinity)
                        if key != rowData.last?.0 {
                            Spacer(minLength: 45)
                        }
                    }
                }
            }
        }
    }
}

private struct ProfileBlock: View {
    var key: String
    var value: String

    var body: some View {
        HStack(spacing: 0) {
            Text(key)
                .frame(alignment: .leading)
                .font(.system(size: 14))
                .foregroundColor(PttColors.blueGrey.swiftUIColor)
            Spacer()
            Text(value)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.system(size: 14))
                .foregroundColor(PttColors.paleGrey.swiftUIColor)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    @ObservedObject static var viewModel: UserInfoViewModel = {
        let model = UserInfoViewModel()
        model.profileData = [
            [
                (L10n.loginDays, "25"),
                (L10n.validPosts, "63")
            ],
            [
                (L10n.economy, "赤貧"),
                (L10n.badPosts, "53")
            ],
            [
                (L10n.lastLoginIP, "2020/05/19  18:28:36 Tus 114.137.233.185 臺灣")
            ]
        ]
        return model
    }()

    static var previews: some View {
        ProfileView(viewModel: viewModel)
            .background(PttColors.darkGrey.swiftUIColor)
            .padding(.horizontal, 25)
    }
}
