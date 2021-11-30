//
//  AddCafeTableViewController.swift
//  MessingWithTableView
//
//  Created by Ravil on 28.11.2021.
//

import UIKit
import RealmSwift

class AddCafeTableViewController: UITableViewController {
    
    var currentCafe: Cafe?
    var imageIsChanged = false // for image placeholder
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var cafeImage: UIImageView!
    @IBOutlet weak var cafeNameTF: UITextField!
    @IBOutlet weak var cafeLocationTF: UITextField!
    @IBOutlet weak var cafeTypeTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // making Save bar button inactive till filling cafeNameTF
        saveButton.isEnabled = false
        cafeNameTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        //вызываем настройку данных на экране редактирования
        setUpEditScreen()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // по нажатию на любую область, клавиатура скрывается, кроме ячейки по индексу 0 (фото)
        if indexPath.row == 0 {
            let cameraIcon = UIImage(named: "camera")
            let galleryIcon = UIImage(named: "gallery")
            
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Камера", style: .default) { _ in
                self.chooseImagwePicker(source: .camera)
            }
            
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let gallery = UIAlertAction(title: "Галерея", style: .default) { _ in
                self.chooseImagwePicker(source: .photoLibrary)
            }
            
            gallery.setValue(galleryIcon, forKey: "image")
            gallery.setValue(CATextLayerTruncationMode.end, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(gallery)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true, completion: nil)
        } else {
            view.endEditing(true)
        }
    }
    
    func saveCafe() {
        
        let newCafe = Cafe()
        
        var image: UIImage?
        
        if imageIsChanged {
            image = cafeImage.image
        } else {
            image = UIImage(named: "imagePlaceholder")
        }
        
        let imageData = image?.pngData()
        
        newCafe.name = cafeNameTF.text!
        newCafe.location = cafeLocationTF.text
        newCafe.type = cafeTypeTF.text
        newCafe.imageData = imageData
        
        // сохранение при редактировании существующего кафе
        if currentCafe != nil {
            try! realm.write {
                currentCafe?.name = newCafe.name
                currentCafe?.location = newCafe.location
                currentCafe?.type = newCafe.type
                currentCafe?.imageData = newCafe.imageData
            }
        } else {
            StorageManager.saveObject(newCafe) // сохранение для нового кафе
        }
        
        
    }
    
    // настройка данных на экране редактирования
    private func setUpEditScreen() {
        
        if currentCafe != nil {
            
            setUpNavigationBar()
            
            imageIsChanged = true // не дает картинке измениться после редактирования
            
            guard let data = currentCafe?.imageData, let image = UIImage(data: data) else { return }
            
            cafeImage.image = image
            cafeImage.contentMode = .scaleAspectFill // возвращает изображению нормальный вид
            cafeNameTF.text = currentCafe?.name
            cafeLocationTF.text = currentCafe?.location
            cafeTypeTF.text = currentCafe?.type
        }
    }
    
    private func setUpNavigationBar() {
        
        navigationItem.leftBarButtonItem = nil
        title = currentCafe?.name
        saveButton.isEnabled = true
        
        // убираем надпись на кнопке назад при Show
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true )
    }
    
}

// MARK: - Text field delegate

extension AddCafeTableViewController: UITextFieldDelegate {
    
    // hide keyboard with Done button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @objc private func textFieldChanged() {
        if cafeNameTF.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

// MARK: - Work with image

extension AddCafeTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagwePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        cafeImage.image = info[.editedImage] as? UIImage
        cafeImage.contentMode = .scaleAspectFill
        cafeImage.clipsToBounds = true
        
        imageIsChanged = true
        
        dismiss(animated: true, completion: nil)
    }
}
