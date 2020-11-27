//
//  LoginView.swift
//  LoginForm
//
//  Created by 윤병진 on 2020/11/27.
//

import UIKit

class LoginView: UIView {
    
    public let labelTitle = UILabel()
    public let labelId = UILabel()
    public let inputId = UITextField()
    public let labelPhoneNum = UILabel()
    public let inputPhoneNum = UITextField()
    public let buttonLogin = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        makeLabelTitleAttributes()
        makeLabelIdAttributes()
        makeInputIdAttributes()
        makeLabelPhoneNumberAttributes()
        makeInputPhoneNumberAttributes()
        makeButtonLoginAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        makeLabelTitleConstraints()
        makeLabelIdConstraints()
        makeInputIdConstraints()
        #if DEBUG
        makeLabelPhoneNumberConstraints()
        makeInputPhoneNumberConstraints()
        #endif
        makeButtonLoginConstraints()
    }

    private func addView() {
        addSubview(labelTitle)
        addSubview(labelId)
        addSubview(inputId)
        addSubview(labelPhoneNum)
        addSubview(inputPhoneNum)
        addSubview(buttonLogin)
    }
    
    private func makeLabelTitleAttributes() {
        labelTitle.text = "Login"
        labelTitle.font = .boldSystemFont(ofSize: 40)
        labelTitle.textColor = .rgbColor(94, 124, 226)
    }
    
    private func makeLabelIdAttributes() {
        labelId.text = "아이디"
        labelId.font = .boldSystemFont(ofSize: 15)
        labelId.textColor = .rgbColor(69, 79, 99)
    }
    
    private func makeInputIdAttributes() {
        inputId.placeholder = "(시설번호 / 면허번호)"
        inputId.setLeftPaddingPoints(15)
        inputId.font = .boldSystemFont(ofSize: 13)
        inputId.backgroundColor = .rgbColor(240, 243, 251)
        inputId.textColor = .rgbColor(107, 108, 109)
        inputId.layer.cornerRadius = 5
    }
    
    private func makeLabelPhoneNumberAttributes() {
        labelPhoneNum.text = "핸드폰번호"
        labelPhoneNum.font = .boldSystemFont(ofSize: 15)
        labelPhoneNum.textColor = .rgbColor(69, 79, 99)
    }
    
    private func makeInputPhoneNumberAttributes() {
        inputPhoneNum.placeholder = "핸드폰번호"
        inputPhoneNum.setLeftPaddingPoints(15)
        inputPhoneNum.keyboardType = .numberPad
        inputPhoneNum.font = .boldSystemFont(ofSize: 13)
        inputPhoneNum.backgroundColor = .rgbColor(240, 243, 251)
        inputPhoneNum.textColor = .rgbColor(107, 108, 109)
        inputPhoneNum.layer.cornerRadius = 5
    }
    
    private func makeButtonLoginAttributes() {
        buttonLogin.setTitle("로그인", for: .normal)
        buttonLogin.backgroundColor = .rgbColor(94, 124, 226)
        buttonLogin.setTitleColor(.white, for: .normal)
        buttonLogin.layer.cornerRadius = 3
        buttonLogin.titleLabel?.font = .boldSystemFont(ofSize: 15)
        buttonLogin.layer.shadowColor = UIColor.pmsShadowColor.cgColor
        buttonLogin.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        buttonLogin.layer.shadowOpacity = 0.48
        buttonLogin.layer.shadowRadius = 3.0
    }
    
    private func makeLabelTitleConstraints() {
        labelTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(30)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self).offset(-40)
        }
    }
    
    private func makeLabelIdConstraints() {
        labelId.snp.makeConstraints { (make) in
            make.top.equalTo(labelTitle.snp.bottom).offset(60)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self).offset(-40)
        }
    }
    
    private func makeInputIdConstraints() {
        inputId.snp.makeConstraints { (make) in
            make.top.equalTo(labelId.snp.bottom).offset(10)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self).offset(-40)
            make.height.equalTo(40)
        }
    }
    
    private func makeLabelPhoneNumberConstraints() {
        labelPhoneNum.snp.makeConstraints { (make) in
            make.top.equalTo(inputId.snp.bottom).offset(30)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self).offset(-40)
        }
    }
    
    private func makeInputPhoneNumberConstraints() {
        inputPhoneNum.snp.makeConstraints { (make) in
            make.top.equalTo(labelPhoneNum.snp.bottom).offset(10)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self).offset(-40)
            make.height.equalTo(40)
        }
    }
    
    private func makeButtonLoginConstraints() {
        buttonLogin.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-50)
            make.leading.equalTo(self).offset(40)
            make.trailing.equalTo(self).offset(-40)
            make.height.equalTo(40)
        }
    }
}
