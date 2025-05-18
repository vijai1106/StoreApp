//
//  ProductCollectionViewCell.swift
//  StoreApp
//
//  Created by Vijai S on 17/05/25.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productimgView: UIImageView!
    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var productQuantityLbl: UILabel!
    @IBOutlet weak var ProductPriceLbl: UILabel!
    
    @IBOutlet weak var OverView: UIView!
    @IBOutlet weak var CountView: UIView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var lessView: UIView!
    @IBOutlet weak var addCartView: UIView!
    
    var maxCount:Int = 9
    var minCount:Int = 0
    var currentQuantity: Int = 0
    var showAlert: ((String) -> Void)?
    var updateCartAction: ((Int) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CountView.setCornerRadius(borderColor: UIColor(named: "#F2F2F2_BorderColor") ?? .gray)
        addView.setCornerRadius(borderColor: UIColor(named: "#F2F2F2_BorderColor") ?? .gray)
        lessView.setCornerRadius(borderColor: UIColor(named: "#F2F2F2_BorderColor") ?? .gray)
        addCartView.setCornerRadius(radius: 5,borderColor: .clear)
        OverView.setCornerRadius(borderColor: UIColor(named: "#F2F2F2_BorderColor") ?? .gray)
    }
     
     @IBAction func AddCartBtn_Act(_ sender: Any) {
         if currentQuantity > 0 {
             updateCartAction?(currentQuantity)
             currentQuantity = 0
             productQuantityLbl.text = "\(currentQuantity)"
         } else {
             showAlert?("Please select at least 1 item")
         }
     }
     
     @IBAction func LessBtn_Act(_ sender: Any) {
         if currentQuantity > minCount {
             currentQuantity -= 1
             productQuantityLbl.text = "\(currentQuantity)"
         } else {
             showAlert?("Quantity can't be less than \(minCount)")
         }
     }
     
     @IBAction func AddBtn_Act(_ sender: Any) {
         if currentQuantity < maxCount {
             currentQuantity += 1
             productQuantityLbl.text = "\(currentQuantity)"
         } else {
             showAlert?("Maximum \(maxCount) items allowed")
         }
     }
     
     override func prepareForReuse() {
         super.prepareForReuse()
         currentQuantity = 0
         productQuantityLbl.text = "\(currentQuantity)"
     }
 }
