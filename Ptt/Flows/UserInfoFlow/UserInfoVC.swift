//
//  UserInfoVC.swift
//  Ptt
//
//  Created by AnsonChen on 2023/4/19.
//  Copyright © 2023 Ptt. All rights reserved.
//

import SwiftUI

protocol UserInfoView: BaseView {

}

final class UserInfoVC: UIHostingController<UserInfoUIView>, UserInfoView {

}
