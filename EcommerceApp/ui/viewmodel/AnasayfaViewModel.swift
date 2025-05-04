//
//  AnasayfaViewModel.swift
//  EcommerceApp
//
//  Created by Meltem Ergul on 30.04.2025.
//

import Foundation
import RxSwift
class AnasayfaViewModel {
    var urunlerRepository = UrunlerRepository()
    var urunlerListesi = BehaviorSubject<[Urunler]>(value: [Urunler]())
    
    init(){
        urunlerListesi = urunlerRepository.urunlerListesi//Bağlantı
    }
    
    func urunleriYukle(){
        urunlerRepository.urunleriYukle()
    }
    
     func ara(aramaKelimesi:String){
         urunlerRepository.ara(aramaKelimesi: aramaKelimesi)
     }
     
}
