//
//  SepetViewModel.swift
//  EcommerceApp
//
//  Created by Meltem Ergul on 4.05.2025.
//

import Foundation
import RxSwift

class SepetViewModel{
      var sepetRepository = SepetRepository()
      var sepetListesi = BehaviorSubject<[Sepet]>(value: [Sepet]())
      
      init(){
          sepetListesi = sepetRepository.sepetListesi//Bağlantı
      }
      
    
       func sepetiYukle(kullaniciAdi: String){
           sepetRepository.sepetiYukle(kullaniciAdi: kullaniciAdi)
       }
    
    
     func sil(sepetId:Int,kullaniciAdi: String){
         sepetRepository.sil(sepetId: sepetId,kullaniciAdi:kullaniciAdi)
         sepetiYukle(kullaniciAdi: kullaniciAdi)
     }
}
