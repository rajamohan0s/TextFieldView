# TextFieldView
TextFieldView with Error and Title labels. Currently It'll be used with storyboard only.

## Demo 
### **Preview:** 
![Preview Gif](https://rajamohan0s.github.io/Previews/TextFieldView.gif)

### **Code:**
```swift
import UIKit
import TextFieldView

final class ViewController: UIViewController {

    @IBOutlet
    private weak var textField: TextFieldView!
    
    @IBOutlet
    private weak var buttonClick: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        self.textField.delegate = self
        
        self.setButton(isValid: false)
    }

    @IBAction
    private func actionClick(_ sender: UIButton) {
         
        guard let email = self.textField.text else {
            
            return
        }
        
        print("Email: \(email)")
    }
}

// MARK: TextFieldViewDelegate
extension ViewController: TextFieldViewDelegate {
    
    func textFieldView(_ textFieldView: TextFieldView, didValidated isValid: Bool) {
    
        self.setButton(isValid: isValid)
    }
    
    private func setButton(isValid: Bool) {
         
        self.buttonClick.backgroundColor = isValid ? #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1) : #colorLiteral(red: 0.855728209, green: 0.855728209, blue: 0.855728209, alpha: 1)
        self.buttonClick.isEnabled = isValid
    }
    
    func textFieldViewDidEndEditing(_ textFieldView: TextFieldView) {
        
        let vc = UIAlertController(title: "Finished", message: "is valid: \(textFieldView.isValid)", preferredStyle: .alert)
       
        vc.addAction(.init(title: "Ok", style: .cancel, handler: { _ in
            
            // TEST
//            if textFieldView.isValid {
//
//                textFieldView.textField.becomeFirstResponder()
//
//            } else {
//
//                textFieldView.textField.resignFirstResponder()
//            }
            
        }))
        
        self.present(vc, animated: true)
    }
}
```

## Contribute
I would love you for the contribution to **TextFieldView**, check the [LICENSE](LICENSE) file for more info.

## Meta

Rajamohan S – (https://rajamohan-s.github.io/)

Distributed under the GNU GENERAL PUBLIC license. See [LICENSE](LICENSE) for more information.
