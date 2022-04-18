//
//  ViewController.swift
//  DemoAlert
//
//  Created by MacOs on 16/04/2022.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var myButton: UIButton!
    let customAlert = MyAlert()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions
    @IBAction func showAlertTapped(_ sender: Any) {
        // do anything
        customAlert.showAlert(with: "Error", message: "Change password success",
                              on: self)
    }

    @objc private func dismissAlert() {
        customAlert.dismissAlert()
    }
}

class MyAlert {
    struct Constants {
        static let backgroundAlphaTo: CGFloat = 0.6
    }

    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        return backgroundView
    }()

    private let alertView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.alpha = 0
        return view
    }()

    private var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.alpha = 0
        return view
    }()

    private var messageLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.alpha = 0
        return view
    }()

    private var myTargetView: UIView?

    func showAlert(with title: String?, message: String?,
                   on viewController: UIViewController) {
        guard let targetView = viewController.view else {
            return
        }
        myTargetView = targetView

        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        targetView.addSubview(alertView)
        alertView.frame = CGRect(x: 40, y: -300,
                                 width: targetView.frame.size.width - 80, height: 300)

        titleLabel = UILabel(frame: CGRect(x: 0, y: 0,
                                               width: alertView.frame.size.width, height: 80))
        titleLabel.textColor = .black
        titleLabel.text = title
        titleLabel.textAlignment = .center
        alertView.addSubview(titleLabel)

        messageLabel = UILabel(frame: CGRect(x: 0, y: 80,
                                               width: alertView.frame.size.width, height: 170))
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        alertView.addSubview(messageLabel)

        let button = UIButton(frame: CGRect(x: 0, y: alertView.frame.size.height - 50,
                                            width: alertView.frame.size.width, height: 50))
        alertView.addSubview(button)
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.addTarget(self, action: #selector(dismissAlert),
                         for: .touchUpInside)
        alertView.addSubview(button)

        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.alpha = Constants.backgroundAlphaTo
        }, completion: { done in
            if done {
                UIView.animate(withDuration: 0.4, animations: {
                    self.alertView.alpha = 1
                })
            }
        })
        alertView.center = targetView.center
    }

    @objc fileprivate func dismissAlert() {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height
        UIView.animate(withDuration: 0.2) {
            self.backgroundView.alpha = Constants.backgroundAlphaTo
        } completion: { done in
            if done {
                UIView.animate(withDuration: 0.2, animations: {
                    self.alertView.alpha = 0
                    self.titleLabel.alpha = 0
                    self.messageLabel.alpha = 0
                    self.titleLabel.removeFromSuperview()
                    self.messageLabel.removeFromSuperview()
                    self.alertView.frame = CGRect(x: width / 2,
                                             y: height / 2,
                                             width: 0,
                                             height: 0)
                }) { done in
                    if done {
                        self.alertView.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                    }
                }
            }
        }
    }
}

