//
//  LoginViewController.swift
//  LoginForm
//
//  Created by 윤병진 on 2020/11/27.
//

import UIKit
import RxSwift
import RxCocoa
import LocalAuthentication

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    private let viewModel = LoginViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        loginViewConstraintsCondition()
        textBind()
        buttonBind()
        mainBind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults().bool(forKey: Constants.autoSignIn) {
            let id : String = UserDefaults().string(forKey: Constants.memId) ?? ""
            let hp : String = UserDefaults().string(forKey: Constants.memHp) ?? ""
            loginView.inputId.text = id
            viewModel.inputId.accept(id)
            loginView.inputPhoneNum.text = hp
            viewModel.inputPhoneNum.accept(hp)
            viewModel.request()
        }
        else if UserDefaults().bool(forKey: Constants.biometricsSignIn) {
            let id : String = UserDefaults().string(forKey: Constants.memId) ?? ""
            let hp : String = UserDefaults().string(forKey: Constants.memHp) ?? ""
            
            biometricsLoginProcess(id: id, hp: hp)
        }
        else {
            userDefaultIdCheck()
            idTextCountCheck()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    private func addView() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.backgroundColor = .white
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "LoginBackground")
        self.view.insertSubview(backgroundImage, at: 0)
        view.addSubview(loginView)
    }
    
    private func loginViewConstraintsCondition() {
        loginView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
        }
    }
    
    private func userDefaultIdCheck() {
        /*
        if let id = UserDefaults().string(forKey: Constants.memId) {
            loginView.inputId.text = id
            viewModel.inputId.accept(id)
        }
         */
        if let hp = UserDefaults().string(forKey: Constants.memHp) {
            loginView.inputPhoneNum.text = hp
            viewModel.inputPhoneNum.accept(hp)
        }
    }
    
    private func idTextCountCheck() {
        if viewModel.idTextCheck {
            loginView.inputPhoneNum.becomeFirstResponder()
        } else {
            loginView.inputId.becomeFirstResponder()
        }
    }
    
    private func biometricsLoginProcess(id: String, hp: String) {
        let authenticationContext = LAContext()
        authenticationContext.localizedFallbackTitle = ""
        authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics , localizedReason: "지문을 스캔해 주세요", reply: { [unowned self] (success, error) -> Void in
            if( success ) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.loginView.inputId.text = id
                    self.viewModel.inputId.accept(id)
                    self.loginView.inputPhoneNum.text = hp
                    self.viewModel.inputPhoneNum.accept(hp)
                    self.viewModel.request()
                })
            }
            else {
                let temp = error as! LAError
                switch temp.code {
                case .authenticationFailed:
                    print("지문/얼굴 인식에 실패하였습니다")
                case .userCancel:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        self.loginView.inputPhoneNum.becomeFirstResponder()
                    })
                case .touchIDNotAvailable:
                    print("Touch ID/Face ID를 사용할수 없습니다")
                case .touchIDLockout:
                    print("Touch ID/Face ID가 잠겼습니다")
                default :
                    print("지문/얼굴 인식에 실패하였습니다")
                    break
                }
            }
        })
    }
    
    private func textBind() {
        loginView.inputId.rx.text.orEmpty.debug().map{$0}.bind(to: viewModel.inputId).disposed(by: disposeBag)
        loginView.inputPhoneNum.rx.text.orEmpty.debug().map{$0}.bind(to: viewModel.inputPhoneNum).disposed(by: disposeBag)
    }
    
    private func buttonBind() {
        loginView.buttonLogin.rx.tap
            .asDriver()
            .throttle(.seconds(1))
            .debug("buttonLogin")
            .drive(onNext: buttonLoginEvent)
            .disposed(by: disposeBag)
        
    }
    
    private func buttonLoginEvent() {
        switch viewModel.loginCheck {
        case 1:
            IndicatorView.shared.show()
            viewModel.request()
            break
        case 2:
            alertHandler("아이디를 입력해주세요", actionButton: nil, handlerAction: { _ in
                self.loginView.inputId.becomeFirstResponder()
            })
            break
        case 3:
            alertHandler("핸드폰번호를 입력해주세요", actionButton: nil, handlerAction: { _ in
                self.loginView.inputPhoneNum.becomeFirstResponder()
            })
            break
        default:
            return
        }
    }
    
    private func mainBind() {
        viewModel.model.asObservable()
            .map{$0}
            .subscribe(onNext: { response in
                IndicatorView.shared.hide()
                switch response?.responseCode {
                case 1:
                    print("로그인 성공!")
                    UserDefaults().setValuesForKeys([Constants.memId : self.viewModel.inputId.value!,
                                                     Constants.memHp : self.viewModel.inputPhoneNum.value!])
                    Constants.Value.tempPassword = self.viewModel.inputPhoneNum.value!
                    Constants.Value.memName = response!.information!.memName
                    Constants.Value.memCName = response!.information!.memCName
                    Constants.Value.memLevel = response!.information!.memLevel
                    Constants.Value.memArea = response!.information!.memArea
                    self.presentMainTabBar()
                    break
                case 2:
                    print("로그인 실패!")
                    self.alertHandler("아이디를 확인해주세요", actionButton: nil, handlerAction: { _ in
                        self.loginView.inputId.becomeFirstResponder()
                    })
                    break
                case 0:
                    print("통신 이상!")
                    self.alertHandler("서버통신에 이상이있습니다\n관리자에게 문의하세요", actionButton: nil)
                    break
                default:
                    return
                }
            }).disposed(by: disposeBag)
        
        viewModel.responseError.asObservable()
            .debug("responseError")
            .subscribe(onNext: { error in
                if !error.isEmpty {
                    IndicatorView.shared.hide()
                    self.alertHandler("서버와의 통신이 원활하지 않습니다\n잠시 후에 시도해 주세요", actionButton: nil)
                }
            }).disposed(by: disposeBag)
    }
    
    private func presentMainTabBar() {
        let mainTabBarController = MainTabBarController()
        let navigationController : UINavigationController = UINavigationController(rootViewController: mainTabBarController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
}


