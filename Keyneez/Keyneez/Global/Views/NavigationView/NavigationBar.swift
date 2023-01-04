//
//  Created by Jung peter on 10/14/22.
//

import UIKit

private struct Constant {
  static let navigationBarHeight: CGFloat = 56
  static let itemHeight: CGFloat = 32
  static let logoHeight: CGFloat = 30
  static let logoWidth: CGFloat = 80
  static let padding: CGFloat = 24
  static let textfieldHeight: CGFloat = 48
  static let screenWidth: CGFloat = UIScreen.main.bounds.size.width
}

final class NavigationBar: NiblessView {
  
  var items: [NavigationItemView]
  private var viewWidth: [CGFloat] = []
  
  /// MakeNavigationBar
  /// - Parameters:
  ///   - frame: frame
  ///   - items: NavigationItemView를 순서에 맞추어 넣으면 순서에 맞게 들어간다.
  init(frame: CGRect, items: [NavigationItemView]) {
    self.items = items
    super.init(frame: frame)
    configureView()
  }

  private func configureView() {
    
    var indexOfFlexibleBoxs: [Int] = []
    var indexOfTextField: [Int] = []
    var indexOfSizedBoxs: [Int] = []
    
    let navibarViews = items.enumerated().map { index, view -> UIView in
      switch view {
      case .title(let content):
        return setLabelContent(content: content, viewWidth: &viewWidth)
      case .sizedBox(let width):
        return setSmallGap(width: width, index: index, viewWidth: &viewWidth, smallGapIdx: &indexOfSizedBoxs)
      case .flexibleBox:
        indexOfFlexibleBoxs.append(index)
        return makeFlexibleBox()
      case .iconButton(let button):
        viewWidth.append(Constant.itemHeight)
        return makeIconButton(with: button)
      case .button(with: let button):
        viewWidth.append(button.frame.size.width)
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
      case .logo:
        // 여기에 로고
        viewWidth.append(Constant.logoWidth)
        return makeLogoButton(with: view.image!)
      case .textfield(let configure):
        indexOfTextField.append(index)
        return makeTextField(with: configure.placeholder, completion: configure.completion)
      }
    }
    
    let navigationStackView = addNavigationStackView(in: navibarViews)
    navigationStackView.subviews.enumerated().forEach { index, view in
      setSubviewOfStackView(index: index, view: view, flexibleviewIndex: indexOfFlexibleBoxs, viewWidth: viewWidth)
    }
    
  }
  
}

// MARK: - Private Method

extension NavigationBar {
  
  private func makeTextField(with placeholder: String, completion: ((String?) -> Void)?) -> UITextField {
    let paddingForUnderline = viewWidth.reduce(0, +) / 2 + Constant.padding
    let textField = KeyneezTextFieldFactory.formStyleTextfield(placeholder: placeholder, borderStyle: .underlineIcon(padding: paddingForUnderline), completion: completion).build()
    textField.snp.makeConstraints { make in
      make.height.equalTo(Constant.textfieldHeight)
    }
    textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }
  
  private func makeFlexibleBox() -> UIView {
    let view = UIView()
    view.backgroundColor = .clear
    view.setContentHuggingPriority(.defaultLow, for: .horizontal)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }
  
  private func makeIconButton(with button: UIButton) -> UIButton {
    button.translatesAutoresizingMaskIntoConstraints = false
    button.widthAnchor.constraint(equalToConstant: Constant.itemHeight).isActive = true
    button.heightAnchor.constraint(equalToConstant: Constant.itemHeight).isActive = true
    button.setContentHuggingPriority(.required, for: .horizontal)
    return button
  }
  
  private func makeLogoButton(with image: UIImage) -> UIButton {
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: Constant.logoWidth, height: Constant.logoHeight))
    button.setBackgroundImage(image, for: .normal)
    button.snp.makeConstraints { make in
      make.width.equalTo(Constant.logoWidth)
      make.height.equalTo(Constant.logoHeight)
    }
    button.setContentCompressionResistancePriority(.required, for: .horizontal)
    button.setContentHuggingPriority(.required, for: .horizontal)
    return button
  }
  
  private func setSubviewOfStackView(index: Int, view: UIView, flexibleviewIndex: [Int], viewWidth: [CGFloat]) {
    
    view.snp.makeConstraints { make in
      if flexibleviewIndex.contains(index) {
        let viewwidths = viewWidth.reduce(0, +)
        make.width.equalTo((Constant.screenWidth - viewwidths) / CGFloat(flexibleviewIndex.count) - Constant.padding * 2)
      }
    }
  }
  
  private func setSmallGap(width: CGFloat, index: Int, viewWidth: inout [CGFloat], smallGapIdx: inout [Int]) -> UIView {
    viewWidth.append(width)
    return UIView().then {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.widthAnchor.constraint(equalToConstant: width).isActive = true
      
      $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      smallGapIdx.append(index)
    }
  }
  
  private func setLabelContent(content: String, viewWidth: inout [CGFloat]) -> UILabel {
    let label = UILabel().then {
      $0.text = content
      $0.font = .preferredFont(forTextStyle: .title1)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    setLabelContraint(label: label)
    viewWidth.append(label.intrinsicContentSize.width)
    return label
  }
  
  private func setLabelContraint(label: UILabel) {
    label.widthAnchor.constraint(equalToConstant: label.intrinsicContentSize.width).isActive = true
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    label.setContentHuggingPriority(.required, for: .horizontal)
  }
  
  private func addNavigationStackView(in views: [UIView]) -> UIStackView {
    let navigationStackView = UIStackView(arrangedSubviews: views)
      .then {
        $0.alignment = .center
        $0.axis = .horizontal
        $0.distribution = .fill
      }
    setupStackViewLayout(with: navigationStackView)
    return navigationStackView
  }
  
  private func setupStackViewLayout(with navigationStackView: UIStackView) {
    self.addSubview(navigationStackView)
    navigationStackView.translatesAutoresizingMaskIntoConstraints = false
    [navigationStackView.topAnchor.constraint(equalTo: self.topAnchor),
     navigationStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
     navigationStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constant.padding),
     navigationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constant.padding)
    ].forEach { $0.isActive = true }
  }
  
}
