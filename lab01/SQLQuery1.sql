-- определить товары, поставки которых должны осуществиться после некоторой даты;
SELECT        Product_name, Delivery_date
FROM            ЗАКАЗЫ
WHERE        (CONVERT(DATETIME, '2024-06-01 00:00:00', 102) <= Delivery_date)

-- найти товары, цена которых находится в некоторых пределах;
SELECT        Name, Price
FROM            ТОВАРЫ
WHERE        (Price >= 100 AND Price <= 250)

-- определить названия фирм, заказавших конкретный товар;
SELECT        Client
FROM            ЗАКАЗЫ
WHERE        (Product_name = N'Компьтер' or Product_name = N'Телефон')

-- найти заказы определенной фирмы по ее названию, отсортировать их по датам поставки.
SELECT        ЗАКАЗЫ.*
FROM            ЗАКАЗЫ
WHERE        (Client IN (N'EPAM','LeverX'))
ORDER BY Delivery_date

SELECT        ЗАКАЗЫ.*
FROM            ЗАКАЗЫ
WHERE        (Client IN (N'LeverX', N'ITechArt'))
ORDER BY Delivery_date DESC