﻿&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент) 
    
    ТДТовары = Элементы.Товары.ТекущиеДанные;
    ТДТовары.Сумма = ТДТовары.Количество * ТДТовары.Цена ; 
    
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)   
    
    ТДТовары = Элементы.Товары.ТекущиеДанные; 
    ТДТовары.Сумма = ТДТовары.Количество * ТДТовары.Цена ;
    
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаПриИзменении(Элемент) 
    
    ТДТовары = Элементы.Товары.ТекущиеДанные; 
    Если ТДТовары.Сумма = 0 Тогда
        ТДТовары.Цена = 0
    Иначе 
        ТДТовары.Цена = ТДТовары.Сумма / ТДТовары.Количество ;
    КонецЕсли;            
    
КонецПроцедуры

