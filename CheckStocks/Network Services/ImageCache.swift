//
//  ImageCacha.swift
//  CheckStocks
//
//  Created by Александр Кузьминов on 18.09.23.
//
import UIKit
import Foundation
import SVGKit
import SDWebImage


//final class ImageCache {
//    static let shared = ImageCache()
//    private let cacheDirectory: URL
//
//    private init() {
//        let fileManager = FileManager.default
//        guard let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { fatalError("Unable to access cache directory") }
//        self.cacheDirectory = cacheDirectory
//    }
//
//    func setImage(_ svgData: Data, forKey key: String) {
//        let fileName = (key as NSString).lastPathComponent
//        let fileURL = cacheDirectory.appendingPathComponent(fileName)
//
//        // Сохраните данные SVG в файл
//        do {
//            try svgData.write(to: fileURL)
//        } catch {
//            print("Ошибка при сохранении SVG-файла: \(error)")
//        }
//    }
//
//    func loadSVGImage(fromKey key: String) -> SVGKImage? {
//        let fileName = (key as NSString).lastPathComponent
//        let fileURL = cacheDirectory.appendingPathComponent(fileName)
//
//        // Создайте SVGKImage из исходного SVG-файла
//        if let svgImage = SVGKImage(contentsOfFile: fileURL.path) {
//            return svgImage
//        } else {
//            return nil
//        }
//    }
//
//
//
//}
//
//class CustomImageView: UIImageView {
//    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
//
//    func load(urlString: String) {
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL: \(urlString)")
//            return
//        }
//
//        image = nil
//
//        addSpinner()
//
//        self.sd_setImage(with: url) { [weak self] (image, error, cacheType, _) in
//            guard let self = self else { return }
//
//            if let error = error {
//                print("Image download error: \(error.localizedDescription)")
//                self.stopSpinner()
//                return
//            }
//
//            // Проверка, что получено изображение
//            guard let image = image else {
//                print("No image data received")
//                self.stopSpinner()
//                return
//            }
//
//            if let svgImage = SVGKImage(data: image.sd_imageData()) {
//                // Преобразуйте SVG-изображение в UIImage
//                let uiImage = svgImage.uiImage
//
//                // Отобразите полученное изображение
//                self.image = uiImage
//            } else {
//                print("Failed to parse SVG image")
//            }
//
//            self.stopSpinner()
//        }
//    }
//
//
//    func addSpinner() {
//        addSubview(spinner)
//
//        spinner.translatesAutoresizingMaskIntoConstraints = false
//        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        spinner.startAnimating()
//    }
//
//    func stopSpinner() {
//        spinner.stopAnimating()
//    }
//}

final class ImageCache {

    private init() {}

    static let shared = NSCache<NSString, UIImage>()
}

class CustomImageView: UIImageView {
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    func load(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        image = nil
        
        addSpinner()
        
        if let imageFromCache = ImageCache.shared.object(forKey: urlString as NSString) {
            image = imageFromCache
            stopSpinner()
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data {
                    if let rI = SVGKImage(data: data) {
                        ImageCache.shared.setObject(rI.uiImage, forKey: urlString as NSString)
                        self.image = rI.uiImage
                        self.stopSpinner()
                    }
                }
            }
        }
        task.resume()
    }
    
    
    func addSpinner() {
        addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinner.startAnimating()
    }
    
    func stopSpinner() {
        spinner.stopAnimating()
    }
}
