//
//  MainTabBarController.swift
//  FirstCitizen
//
//  Created by Lee on 20/08/2019.
//  Copyright © 2019 Kira. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
  
  static let vTabBarButton = TabBarButtonView()
  
  private let vcPoint = PointViewController()
  private let vcMap = MapViewController()
  private let vcList = ListViewController()
  private let settingVC = SettingViewController()
  lazy private var vcSetting = UINavigationController(rootViewController: settingVC)
  
  private var isPosition = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    configure()
    autoLayout()
  }
  
  private func configure() {
    self.tabBar.isHidden = true
    
    MainTabBarController.vTabBarButton.pointButton.addTarget(self, action: #selector(pointDidTap(_:)), for: .touchUpInside)
    MainTabBarController.vTabBarButton.mapListButton.addTarget(self, action: #selector(mapListDidTap(_:)), for: .touchUpInside)
    MainTabBarController.vTabBarButton.settingButton.addTarget(self, action: #selector(settingDidTap(_:)), for: .touchUpInside)
    view.addSubview(MainTabBarController.vTabBarButton)
    
    viewControllers = [vcMap, vcList, vcPoint, vcSetting]
    
  }
  
  private func alertAction(tilte: String?, message: String?) {
    let alert = UIAlertController(title: tilte, message: message, preferredStyle: .actionSheet)
    let login = UIAlertAction(title: "로그인", style: .default) { (action) in
      let loginVC = UINavigationController(rootViewController: LoginVC())
      
      self.present(loginVC, animated: true)
    }
    let cancel = UIAlertAction(title: "취소", style: .cancel) { (action) in
      
    }
    alert.addAction(login)
    alert.addAction(cancel)
    present(alert, animated: true)
  }
  
  @objc private func pointDidTap(_ sender: UIButton) {
    guard let _ = UserDefaults.standard.object(forKey: "Token") as? String else {
      alertAction(tilte: "알림", message: "로그인이 필요한 서비스입니다")
      return
    }
    
    self.selectedViewController = vcPoint
  }
  
  @objc private func mapListDidTap(_ sender: UIButton) {
    isPosition.toggle()
    
    switch isPosition {
    case true:
      MainTabBarController.vTabBarButton.mapListButton.setImage(UIImage(named: "TabBarList"), for: .normal)
      self.selectedViewController = vcMap
      
    case false:
      MainTabBarController.vTabBarButton.mapListButton.setImage(UIImage(named: "TabBarMap"), for: .normal)
      self.selectedViewController = vcList
    }
  }
  
  @objc private func settingDidTap(_ sender: UIButton) {
    NetworkService.getUserInfo { [weak self] result in
      switch result {
      case .success(let data):
        self?.settingVC.userInfo = data
        self?.selectedViewController = self?.vcSetting
      case .failure(let err):
        print(err.localizedDescription)
      }
    }
  }
  
  private struct Standard {
    static let space: CGFloat = 8
    static let margin: CGFloat = 10
  }
  
  private func autoLayout() {
    let guide = view.safeAreaLayoutGuide
    
    MainTabBarController.vTabBarButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(guide.snp.bottom).offset(-Standard.margin.dynamic(1))
    }
  }
}
