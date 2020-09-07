//
//  OESViewController.swift
//  OESController
//
//  Created by Avnish Kumar on 04/09/20.
//

import UIKit


class OESViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet var colorPickwerView: UIView!
    @IBOutlet var colorViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var colorPickerButton: UIButton!
    @IBOutlet var applyButton: UIButton!
    
    var color = UIColor.blue
//    var colorPicker = UIColorPickerViewController()
    var arrayOfObjects:[UIImage?] = [UIImage(systemName: "paintbrush"), UIImage(systemName: "textformat.size"),UIImage(systemName: "trash.slash"),UIImage(systemName: "gobackward"),UIImage(systemName: "square.and.arrow.down"), UIImage(systemName: "square.and.arrow.down")]
    var arrayOfTexts:[String] = ["Brush", "Text", "Reset", "Redo", "Save", "Test"]
    var selectedColor:UIColor = .black {
        willSet {
            colorPickerButton.backgroundColor = newValue
        }
    }
    var selectedTextView:UITextView?
    var textFields = [OESTextView]() {
        didSet {
            if textFields.count == 0 {
                applyButton.isHidden = true
            }else {
                applyButton.isHidden = false
            }
        }
    }
    
    var selectedOption:Option = .brush {
        willSet {
            if newValue == .texts {
                addNewTextViewAt(point: imageView.center)
            }else if newValue == .reset {
                imageView.image = nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        // Do any additional setup after loading the view.
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.itemSize = .init(width: collectionView.frame.height - 10, height: collectionView.frame.height - 10)
        flow.minimumLineSpacing = .init(20)
        collectionView.collectionViewLayout = flow
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        colorPickerButton.clipsToBounds = false
        colorPickerButton.layer.cornerRadius = (colorPickerButton.frame.height > colorPickerButton.frame.width ? colorPickerButton.frame.height/2:colorPickerButton.frame.width/2)
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction(recognizer:)))
        gestureRecognizer.delegate = self
        self.colorViewHeightConstraint.constant = 0
        self.applyButton.isHidden = true
    }
    

    @IBAction func colorPickerButtonTapped(_ sender: UIButton) {
        hideColorPicker(false)
        DrawingConstants.shared.color = selectedColor
    }
    
    @IBAction func chooseImageButtonTapped(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.image"]
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
        }
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func applyButtonTapped(_ sender: UIButton) {
        for textContainer in textFields {
            let textView = textContainer.textView
            if textView.text.count > 0 {
                imageView.drawText(string: textView.text, atPoint: CGPoint(x: textContainer.frame.origin.x + 20.0, y: textContainer.frame.origin.y + 20.0), size: textContainer.textView.frame.size, textColor:textView.textColor ?? UIColor.black)
            }
            textContainer.removeFromSuperview()
        }
        textFields.removeAll()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[.imageURL] as? URL, let data = try? Data(contentsOf: url) {
            imageView.image = UIImage(data: data)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func panGestureRecognizerAction(recognizer:UIPanGestureRecognizer) {
    }
    
    @IBAction func colorSelectionChanged(_ sender: UIButton) {
        if sender.tag == 0 {
            DrawingConstants.shared.color = UIColor.systemRed
        }else if sender.tag == 1 {
            DrawingConstants.shared.color = UIColor.systemBlue
        }else if sender.tag == 2 {
            DrawingConstants.shared.color = UIColor.systemGreen
        }else if sender.tag == 3 {
            DrawingConstants.shared.color = UIColor.white
        }else if sender.tag == 4 {
            DrawingConstants.shared.color = UIColor.systemYellow
        }else if sender.tag == 5 {
            DrawingConstants.shared.color = UIColor.black
        }else if sender.tag == 6 {
            DrawingConstants.shared.color = UIColor.systemPurple
        }
        self.selectedColor = DrawingConstants.shared.color
        hideColorPicker(true)
    }
    
    func hideColorPicker(_ shouldHide:Bool) {
        self.colorViewHeightConstraint.constant = shouldHide ? 0:40
        UIView.animate(withDuration: 0.3) {
            self.colorPickwerView.layoutIfNeeded()
//            self.imageView.layoutIfNeeded()
        }
    }
    
    func addNewTextViewAt(point:CGPoint) {
        let textContainerView = OESTextView(frame: CGRect(origin: point, size: CGSize(width: 150, height: 50)))
        textContainerView.center = imageView.center
        imageView.addSubview(textContainerView)
        textFields.append(textContainerView)
        textContainerView.textView.boarderWidth = 2
//        textContainerView.textView.isScrollEnabled = false
        textContainerView.textView.isEditable = true
        textContainerView.textView.delegate = self
        textContainerView.textView.becomeFirstResponder()
        textContainerView.textView.font = UIFont(name: "HelveticaNeue-Thin", size: 18)
        textContainerView.textView.textColor = selectedColor
        textContainerView.callBack = {(sender:UIButton)->Void in
            textContainerView.removeFromSuperview()
            self.textFields.removeAll(where: {$0 == textContainerView})
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        true
    }
        
    func textViewDidBeginEditing(_ textView: UITextView) {
        selectedTextView = textView
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        textView.frame.size.height = 0 // you have to do that because if not it's not working with the proper content size
        if let containerView = textView.superview as? OESTextView {
            print(containerView.frame.size)
            containerView.frame.size = CGSize(width: containerView.frame.width, height: textView.contentSize.height + 20)
        }
    }
    
}

extension OESViewController:UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionCollectionViewCell", for: indexPath) as? OptionCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.imageView.image = arrayOfObjects[indexPath.row]
        cell.textLabel.text = arrayOfTexts[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row >= 0 && indexPath.row <= 2 {
            selectedOption =  Option.init(rawValue: indexPath.row) ?? Option.brush
        }
    }
}

//extension OESViewController:UIColorPickerViewControllerDelegate {
//    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
//
//    }
//
//    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
//
//    }
//}

extension OESViewController:UIGestureRecognizerDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let textView = selectedTextView {
            textView.resignFirstResponder()
        }
        if let touch = touches.first {
            DrawingConstants.shared.lastPoint = touch.location(in: imageView)
            DrawingConstants.shared.isPath = false
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        guard let touch = touches.first else {
            return
        }
        let point = touch.location(in: imageView)
        if let touch = touches.first {
            if selectedOption == .texts {
                let currentTextView = textFields.filter { (textView) -> Bool in
                    if textView.frame.contains(point) {
                        return true
                    }else {
                        return false
                    }
                }.first
                if let textView = currentTextView {
                    textView.center = point
                    imageView.layoutIfNeeded()
                }
                
            }else if selectedOption == .brush {
                let point = touch.location(in: imageView)
                DrawingConstants.shared.isPath = true
                imageView.drawLineFrom(startPoint:DrawingConstants.shared.lastPoint, toPoint: point)
            }
            DrawingConstants.shared.lastPoint = point
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard  let touch =  touches.first else {
            return
        }
        let point = touch.location(in: imageView)
        if selectedOption == .texts {
            let currentTextView = textFields.filter { (textView) -> Bool in
                if textView.point(inside: point, with: nil) {
                    return true
                }else {
                    return false
                }
            }.first
            if let textView = currentTextView {
                textView.frame.origin = point
            }
        }else {
            if DrawingConstants.shared.isPath == false {
                imageView.drawLineFrom(startPoint:             DrawingConstants.shared.lastPoint, toPoint: DrawingConstants.shared.lastPoint)
            }
        }
    }
}
