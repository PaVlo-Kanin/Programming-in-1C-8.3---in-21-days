﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
    //{{__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
    // Данный фрагмент построен конструктором.
    // При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
    Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеТоваров") Тогда
        // Заполнение шапки
        Ответственный = ДанныеЗаполнения.Ответственный;
        Покупатель = ДанныеЗаполнения.Поставщик;
        Склад = ДанныеЗаполнения.Склад;
        Для Каждого ТекСтрокаТовары Из ДанныеЗаполнения.Товары Цикл
            НоваяСтрока = Товары.Добавить();
            НоваяСтрока.Количество = ТекСтрокаТовары.Количество;
            НоваяСтрока.Номенклатура = ТекСтрокаТовары.Номенклатура;
            НоваяСтрока.Сумма = ТекСтрокаТовары.Сумма;
            НоваяСтрока.Цена = ТекСтрокаТовары.Цена;
        КонецЦикла;
    КонецЕсли;
    //}}__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
   
    // регистр ОстаткиТоваров Расход
    Движения.ОстаткиТоваров.Записывать = Истина;
    Для Каждого ТекСтрокаТовары Из Товары Цикл
        Движение = Движения.ОстаткиТоваров.Добавить();
        Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
        Движение.Период = Дата;
        Движение.Номенклатура = ТекСтрокаТовары.Номенклатура;
        Движение.Количество = ТекСтрокаТовары.Количество;
        Движение.Выручка = ТекСтрокаТовары.Сумма
    КонецЦикла;   
    
   Движения.Записать(); 
    
    Если Режим = РежимПроведенияДокумента.Оперативный Тогда
        
        Запрос = Новый Запрос;
        Запрос.Текст = 
        "ВЫБРАТЬ
        |   ОстаткиТоваровОстатки.Номенклатура КАК Номенклатура,
        |   ОстаткиТоваровОстатки.КоличествоОстаток КАК Количество
        |ИЗ
        |   РегистрНакопления.ОстаткиТоваров.Остатки(
        |           ,
        |           Номенклатура В
        |               (ВЫБРАТЬ
        |                   РеализацияТоваровТовары.Номенклатура КАК Номенклатура
        |               ИЗ
        |                   Документ.РеализацияТоваров.Товары КАК РеализацияТоваровТовары
        |               ГДЕ
        |                   РеализацияТоваровТовары.Ссылка = &Ссылка)) КАК ОстаткиТоваровОстатки
        |ГДЕ
        |   ОстаткиТоваровОстатки.КоличествоОстаток < 0";
        
        Запрос.УстановитьПараметр("Ссылка", Ссылка);
        
        РезультатЗапроса = Запрос.Выполнить();
        
        Если НЕ РезультатЗапроса.Пустой() Тогда 
            
            Отказ = Истина;
            
            ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
            
            Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
               Сообщить("На складе не хватает товара " + ВыборкаДетальныеЗаписи.Номенклатура + 
               " в количестве " +ВыборкаДетальныеЗаписи.Количество*(-1));
            КонецЦикла;
            
        КонецЕсли; 
        
    КонецЕсли; 
    
    Если  Отказ Тогда
        Возврат
    КонецЕсли;
        
        Движения.ОстаткиТоваров.Записывать = Истина;
        
        Запрос = Новый Запрос;
        Запрос.Текст = 
        "ВЫБРАТЬ
        |   ОстаткиТоваровОстатки.Номенклатура КАК Номенклатура,
        |   ОстаткиТоваровОстатки.КоличествоОстаток КАК Количество,
        |   ОстаткиТоваровОстатки.СуммаОстаток КАК Сумма
        |ИЗ
        |   РегистрНакопления.ОстаткиТоваров.Остатки(
        |           &МоментВремени,
        |           Номенклатура В
        |               (ВЫБРАТЬ
        |                   РеализацияТоваровТовары.Номенклатура КАК Номенклатура
        |               ИЗ
        |                   Документ.РеализацияТоваров.Товары КАК РеализацияТоваровТовары
        |               ГДЕ
        |                   РеализацияТоваровТовары.Ссылка = &Ссылка)) КАК ОстаткиТоваровОстатки";
        
        Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
        Запрос.УстановитьПараметр("Ссылка", Ссылка);  
        
        РезультатЗапроса = Запрос.Выполнить();        
        ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
        
        Движения.Продажи.Записывать = Истина ;         
        НакопленнаяСебестоимость = 0; 
         
        Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
            
            Если ВыборкаДетальныеЗаписи.Количество = 0 Тогда
                СебестоимостьЕдиницы = 0  ;
            Иначе
                СебестоимостьЕдиницы = ВыборкаДетальныеЗаписи.Сумма / ВыборкаДетальныеЗаписи.Количество;
            КонецЕсли; 
            
            Для каждого Движение  Из Движения.ОстаткиТоваров Цикл
                
                Если Движение.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура Тогда
                    Себестоимость = Движение.Количество * СебестоимостьЕдиницы;  
                    Движение.Сумма = Движение.Количество * СебестоимостьЕдиницы;  
                     
                    
                    ДвижениеПродажи = Движения.Продажи.Добавить();
                    ДвижениеПродажи.Период = Дата;
                    ДвижениеПродажи.Контрагент = Покупатель;
                    ДвижениеПродажи.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
                    ДвижениеПродажи.Сумма = Движение.Выручка;
                    ДвижениеПродажи.Количество = Движение.Количество;
                    ДвижениеПродажи.Себестоимость = Движение.Сумма;
                    
                   НакопленнаяСебестоимость = НакопленнаяСебестоимость + Себестоимость; 
                КонецЕсли; 

            КонецЦикла;
            
        КонецЦикла;
        
        
    Движения.РегистрБухУчет.Записывать = Истина;
    Проводка = Движения.РегистрБухУчет.Добавить();
    Проводка.Период = Дата;
    Проводка.СчетДт = ПланыСчетов.БухУчет.РасчетыСПокупатели;
    Проводка.СчетКт = ПланыСчетов.БухУчет.Выручка;
    Проводка.Сумма = СуммаДокумента;
    
   
    Движения.РегистрБухУчет.Записывать = Истина;
    Проводка = Движения.РегистрБухУчет.Добавить();
    Проводка.Период = Дата;
    Проводка.СчетДт = ПланыСчетов.БухУчет.Себестоимость;
    Проводка.СчетКт = ПланыСчетов.БухУчет.Товары;
    Проводка.Сумма = НакопленнаяСебестоимость;



   КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
   
    Если НЕ Покупатель.ЭтоПокупатель  Тогда
        Отказ = Истина  ;
        Сообщить("Выбирите покупателя");   
        
    КонецЕсли ; 
    
    
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
     
    
    СуммаДокумента = Товары.Итог("Сумма");

КонецПроцедуры
