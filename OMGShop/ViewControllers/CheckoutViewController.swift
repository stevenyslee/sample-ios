//
//  CheckoutViewController.swift
//  OMGShop
//
//  Created by Mederic Petit on 24/10/2560 BE.
//  Copyright © 2560 Mederic Petit. All rights reserved.
//

import UIKit

class CheckoutViewController: BaseViewController {

    var viewModel: CheckoutViewModel!

    @IBOutlet weak var yourProductLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var subTotalPriceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var redeemButton: UIButton!
    @IBOutlet weak var payButton: UIButton!

    override func configureView() {
        super.configureView()
        self.title = self.viewModel.viewTitle
        self.yourProductLabel.text = self.viewModel.yourProductLabel
        self.nameLabel.text = self.viewModel.productName
        self.imageView.downloaded(from: self.viewModel.productImageURL)
        self.productPriceLabel.text = self.viewModel.productPrice
        self.summaryLabel.text = self.viewModel.summaryLabel
        self.subTotalLabel.text = self.viewModel.subTotalLabel
        self.subTotalPriceLabel.text = self.viewModel.subTotalPrice
        self.discountLabel.text = self.viewModel.discountLabel
        self.discountPriceLabel.text = self.viewModel.discountPrice
        self.totalLabel.text = self.viewModel.totalLabel
        self.totalPriceLabel.text = self.viewModel.totalPrice
        self.redeemButton.setTitle(self.viewModel.redeemButtonTitle, for: .normal)
        self.payButton.setTitle(self.viewModel.payButtonTitle, for: .normal)

        self.showLoading()
        self.viewModel.loadBalances()
    }

    override func configureViewModel() {
        super.configureViewModel()
        self.viewModel.onSuccessGetBalances = { self.hideLoading() }
        self.viewModel.onFailGetBalances = { (error) in
            self.hideLoading()
            self.showError(withMessage: error.localizedDescription)
        }
        self.viewModel.onDiscountPriceChange = { self.discountPriceLabel.text = $0 }
        self.viewModel.onTotalPriceChange = { self.totalPriceLabel.text = $0 }
        self.viewModel.onSuccessPay = { (message) in
            self.showMessage(message)
            self.hideLoading()
            self.navigationController?.popViewController(animated: true)
        }
        self.viewModel.onFailPay = { (error) in
            self.showError(withMessage: error.message)
            self.hideLoading()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.redeemButton.layer.borderColor = Color.omiseGOBlue.cgColor()
        self.redeemButton.layer.borderWidth = 1
    }

}

extension CheckoutViewController {

    @IBAction func didTapRedeemButton(_ sender: UIButton) {
        RedeemPopupViewController.present(fromViewController: self, checkout: self.viewModel.checkout, delegate: self)
    }

    @IBAction func didTapPayButton(_ sender: UIButton) {
        self.showLoading()
        self.viewModel.pay()
    }

}

extension CheckoutViewController: RedeemPopupViewControllerDelegate {

    func didFinishToRedeem() {
        self.viewModel.updatePrices()
    }

}