﻿                
                
                
//ДвухзначноеЧисло = 7;
//Степень = 4;

//ВозведениеВСтепень = Pow(ДвухзначноеЧисло,Степень);   
//Если ВозведениеВСтепень > 10000 Тогда
//    Сообщить("Полученное число превышает 10000");
//Иначе
//    Сообщить(ВозведениеВСтепень);
//    
//КонецЕсли;
//ВозведениеВСтепень = ДвухзначноеЧисло;
//Для Счетчик = 1 По 3 Цикл

//ВозведениеВСтепень =  ВозведениеВСтепень * ДвухзначноеЧисло;	

//КонецЦикла; 

//Если ВозведениеВСтепень > 10000 Тогда
//    Сообщить("Полученное число превышает 10000");                                 31 622 401
//Иначе
//    Сообщить(ВозведениеВСтепень);
//    
//КонецЕсли;
// Сообщить(ВозведениеВСтепень);


//НГ = '20221231';  
//Сообщить(Формат(НГ,"ДФ=дддд"));

//ДеньСледущегоГода = НГ + 86400;  

//Для Счетчик = 1 По 10 Цикл
// Прибавляем к 01.01  1 год 1 день и 1 секунду
// чтобы не зависеть от высокосного года
// затем приводим к началу года и вычитаем 1 сек
// получаем 31.12 
// прибавляем 1 сек чтобы привести к 01.01
// 
//ДеньСледущегоГода = НачалоГода(ДеньСледущегоГода + 31622401)- 1; 
//Сообщить(Формат(ДеньСледущегоГода,"ДФ=дддд"));  
//ДеньСледущегоГода = ДеньСледущегоГода + 1;
//КонецЦикла;











