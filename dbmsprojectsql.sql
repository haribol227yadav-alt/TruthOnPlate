
CREATE DATABASE TruthOnPlate;
USE TruthOnPlate;


CREATE TABLE Products (
    product_id VARCHAR(5) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    brand VARCHAR(100),
    category VARCHAR(100),
    sugar_per_100g DECIMAL(6,2),
    salt_per_100g DECIMAL(6,2),
    fat_per_100g DECIMAL(6,2),
    protein_per_100g DECIMAL(6,2),
    calories DECIMAL(6,2)
);


CREATE TABLE Product_Ingredients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id VARCHAR(5),
    ingredient_name VARCHAR(255),
    FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
        ON DELETE CASCADE
);

-- FSSAI STANDARDS TABLE
CREATE TABLE FSSAI_Standards (
    category VARCHAR(100) PRIMARY KEY,
    sugar_alert VARCHAR(100),
    sodium_alert VARCHAR(100),
    banned_limit TEXT
);

-- HARMFUL INGREDIENTS MASTER

CREATE TABLE Harmful_Ingredients_Master (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(100),
    banned_ingredients TEXT,
    key_alert VARCHAR(255)
);

-- INSERT PRODUCTS (P1 – P85)

INSERT INTO Products VALUES
('P1','Coca-Cola','Coca-Cola','Cold Drinks',10.6,0.02,0,0,42.4),
('P2','Thums Up','Coca-Cola','Cold Drinks',10,0.03,0,0,40),
('P3','Sprite','Coca-Cola','Cold Drinks',9.4,0.01,0,0,37.6),
('P4','Fanta','Coca-Cola','Cold Drinks',13,0.02,0,0,52),
('P5','Pepsi','PepsiCo','Cold Drinks',10.5,0.02,0,0,42),
('P6','Limca','Coca-Cola','Cold Drinks',11.2,0.03,0,0,44.8),

('P7','Real Mixed Fruit','Dabur','Fruit Juices',12,0.05,0,0.4,49.6),
('P8','Tropicana Orange','PepsiCo','Fruit Juices',11.5,0.01,0,0.7,48.8),
('P9','Paper Boat Aamras','Paper Boat','Fruit Juices',13.8,0.02,0,0.2,56),

('P10','Red Bull','Red Bull','Energy Drinks',11,0.1,0,0,44),
('P11','Monster','Monster','Energy Drinks',12,0.19,0,0,48),
('P12','Sting','PepsiCo','Energy Drinks',11.3,0.05,0,0,45.2),

('P13','Lay''s Classic','PepsiCo','Chips/Snacks',0.5,1.2,34.7,7,342),
('P14','Lay''s Masala','PepsiCo','Chips/Snacks',2.5,1.8,33,6.8,334),
('P15','Bingo Mad Angles','ITC','Chips/Snacks',4,2,31,7.5,325),
('P16','Kurkure','PepsiCo','Chips/Snacks',1.6,2.1,35.1,5.8,345),
('P17','Aloo Bhujia','Haldiram','Chips/Snacks',1,1.5,42,9,418),

('P18','Parle-G','Parle','Biscuits',25.5,0.4,12.5,6.7,241),
('P19','Hide & Seek','Parle','Biscuits',32,0.3,20,5.5,330),
('P20','Dark Fantasy','Sunfeast','Biscuits',38,0.4,26,5,406),
('P21','Oreo','Mondelez','Biscuits',38,0.5,20,4.5,350),

('P22','Maggi','Nestle','Noodles',1.5,3.2,13.5,8,159),
('P23','Yippee','ITC','Noodles',2,3,14,8.5,168),

('P24','Bisleri','Bisleri','Water',0,0,0,0,0),

('P25','Dairy Milk','Cadbury','Chocolates',57,0.2,30,7.5,528),
('P26','KitKat','Nestle','Chocolates',45,0.1,24,6,420),
('P27','Snickers','Mars','Chocolates',44,0.6,28,8.5,462),

('P28','Kissan Ketchup','HUL','Sauces',25,1.8,0.1,1.1,108),
('P29','Maggi Sauce','Nestle','Sauces',28.2,2,0.1,1,118),

('P30','Oat Milk','Oatly','New Beverages',3,0.1,1.5,1,47),
('P31','Coconut Water','Raw Pressery','New Beverages',4.5,0.05,0,0,20),

('P32','Energy Bar','Whole Truth','Healthy Snacks',15,0.05,8,12,200),
('P33','Trail Mix','Happilo','Healthy Snacks',12,0.1,35,18,525),

('P34','Nachos','Cornitos','Modern Chips',1.5,2.2,30,8,261),
('P35','Popcorn','4700BC','Modern Chips',1,1.5,18,5,250),

('P36','Instant Pasta','Maggi','Instant Meals',2.5,2.8,15,9,185),

('P37','Nutella','Ferrero','Spreads',56.3,0.1,30.9,6.3,528),

('P38','Brownie','Theobroma','Bakery',35,0.4,25,5,413),

('P39','Cornflakes','Kellogg''s','Breakfast',8.5,1.2,0.8,7,69),

('P40','Moong Dal','Haldiram','Namkeen',1,1.2,20,22,272),

('P41','Roasted Chana','Generic','Traditional',1,0.5,5,20,133),

('P42','Greek Yogurt','Epigamia','Dairy',4,0.1,3,8,82),

('P43','Quinoa','True Elements','Grains',1,0,6,14,110),

('P44','Olive Oil','Figaro','Healthy Fat',0,0,91,0,819),

('P45','Almonds','California','Nuts',4,0,49,21,541),

('P46','Dark Chocolate','Amul','Treats',12,0.05,45,9,493),

('P47','Green Tea','Tetley','Beverage',0,0,0,0,0),

('P48','Chia Seeds','Nutty','Seeds',1,0.01,31,17,347),

('P49','Himalayan Popcorn','4700BC','Modern Chips',1,1.5,18,5,250),

('P50','Korean BBQ Noodles','Maggi','Instant Meals',2.5,2.8,15,9,185),
('P51','Geki Hot & Spicy','Nissin','Instant Meals',3,3.1,16,10,220),
('P52','Masala Millets','Tata Soulfull','Instant Meals',1.5,1.8,4,8,84),
('P53','Peppy Tomato Oats','Saffola','Instant Meals',4,2.1,6,9,108.5),
('P54','Schezwan Noodles','Ching''s','Instant Meals',2,3.5,14,8,168),

('P55','Crunchy Peanut Butter','Pintola','Spreads',9,0.5,45,30,582),

('P56','90% Dark Chocolate','Amul','Chocolates',7,0.01,45,9,477),

('P57','Thousand Island','Veeba','Sauces',15,1.5,35,2,375),
('P58','Chocolate Syrup','Hershey''s','Sauces',50,0.1,1,2,265),

('P59','Eggless Brownie','Theobroma','Bakery',35,0.4,25,5,413),
('P60','Marie Biscuits','McVitie''s','Biscuits',18,0.6,10,7,190),
('P61','Fruit Cake','Winkies','Bakery',35,0.4,18,4.5,320),
('P62','Peanut Chikki','Lonavala','Treats',45,0.1,24,14,452),
('P63','Digestive Biscuits','NutriChoice','Biscuits',14.5,0.8,18,8,252),

('P64','Corn Flakes','Kellogg''s','Breakfast',8.5,1.2,0.8,7,69.2),
('P65','Choco Fills','Kellogg''s','Breakfast',28,0.8,15,6,271),
('P66','Cuppa Poha','MTR','Breakfast',4.6,3.7,10.9,7.6,146.9),
('P67','Steel Cut Oats','Quaker','Breakfast',0,0,7,12,111),
('P68','Ragi Choco Bites','Tata Soulfull','Breakfast',18,0.5,4,7,136),
('P69','Instant Upma Mix','Aashirvaad','Breakfast',3,2.5,9,8.5,127),

('P70','Navratan Mix','Bikaji','Namkeen',2,1.8,35,12,377),
('P71','Banana Chips','Balaji','Namkeen',1,1,32,3,290),
('P72','Roasted Peanuts','Paper Boat','Namkeen',2,0.8,48,25,548),
('P73','Chakli','Chitale Bandhu','Namkeen',1,1.5,25,8,326),

('P74','Plain Roasted Makhana','Farmley','Superfood',0.5,0.1,0.2,3,38.9),

('P75','Oats Porridge','Generic','Healthy Snacks',1,0.1,4,10,110),

('P76','Greek Yogurt Plain','Epigamia','Dairy',4,0.1,3,8,82),

('P77','Organic Quinoa','True Elements','Grains',1,0,6,14,110),

('P78','Extra Virgin Olive Oil','Borges','Healthy Fat',0,0,91,0,819),

('P79','Raw Almonds','California Almonds','Nuts',4,0,49,21,541),

('P80','85% Dark Chocolate','Amul','Treats',12,0.05,45,9,493),

('P81','Green Tea Leaf','Lipton','Beverage',0,0,0,0,0),

('P82','Chia Seeds Premium','Nutty Gritties','Seeds',1,0.01,31,17,347),

('P83','Multigrain Bread','Britannia','Bakery',6,0.4,4,8,266),

('P84','Low Fat Milk','Amul','Dairy',5,0.1,2,3,42),

('P85','Brown Rice','India Gate','Grains',0.5,0,2.7,7.5,111);

-- INSERT PRODUCT INGREDIENTS

INSERT INTO Product_Ingredients (product_id, ingredient_name) VALUES
('P1','Carbonated Water'),('P1','Sugar'),('P1','Acidity Regulator'),
('P2','Carbonated Water'),('P2','Sugar'),
('P3','Carbonated Water'),('P3','Sugar'),
('P4','Carbonated Water'),('P4','Sugar'),
('P5','Carbonated Water'),('P5','Sugar'),
('P6','Carbonated Water'),('P6','Sugar'),
('P7','Fruit Pulp'),('P7','Water'),
('P8','Orange Juice'),('P8','Water'),
('P9','Mango Pulp'),
('P10','Caffeine'),('P10','Sugar'),
('P11','Caffeine'),('P12','Caffeine'),
('P13','Potatoes'),('P13','Salt'),
('P14','Potatoes'),('P15','Corn'),
('P16','Corn Meal'),('P17','Gram Flour'),
('P18','Wheat Flour'),('P18','Sugar'),
('P19','Wheat Flour'),
('P20','Cocoa'),
('P21','Cream'),
('P22','Wheat Flour'),('P22','Masala'),
('P23','Wheat Flour'),
('P24','Water'),
('P25','Sugar'),('P26','Cocoa'),
('P27','Peanuts'),
('P28','Tomato'),('P29','Spices'),
('P30','Oats'),('P31','Coconut Water'),
('P32','Nuts'),('P33','Dry Fruits'),
('P34','Corn'),('P35','Maize'),
('P36','Pasta'),('P37','Hazelnuts'),
('P38','Flour'),('P39','Corn'),
('P40','Lentils'),('P41','Chana'),
('P42','Milk'),('P43','Seeds'),
('P44','Olive Oil'),('P45','Almonds'),
('P46','Cocoa'),('P47','Tea Leaves'),
('P48','Chia Seeds'),('P49','Corn'),
('P50','Noodles'),('P51','Spices'),
('P52','Millets'),('P53','Oats'),
('P54','Masala'),
('P55','Peanuts'),('P56','Cocoa'),
('P57','Oil'),('P58','Sugar'),
('P59','Flour'),('P60','Wheat'),
('P61','Dry Fruits'),('P62','Peanuts'),
('P63','Fiber'),('P64','Corn'),
('P65','Chocolate'),('P66','Rice'),
('P67','Oats'),('P68','Ragi'),
('P69','Semolina'),
('P70','Spices'),
('P71','Banana'),
('P72','Peanuts'),
('P73','Rice Flour'),
('P74','Makhana'),
('P75','Oats'),
('P76','Milk'),
('P77','Quinoa'),
('P78','Olive Oil'),
('P79','Almonds'),
('P80','Cocoa'),
('P81','Tea'),
('P82','Chia Seeds'),
('P83','Wheat'),
('P84','Milk'),
('P85','Rice');

-- INSERT FSSAI STANDARDS
INSERT INTO FSSAI_Standards VALUES
('Cold Drinks','>10 g/100ml','Declare Sodium','Caffeine >200 mg/L not allowed'),
('Fruit Juices','Added Sugar not recommended','No fixed limit','Artificial sweeteners banned'),
('Energy Drinks','>11 g/100ml','No fixed limit','Caffeine >300 mg/L banned'),
('Chips/Snacks','>5 g/100g','>600 mg/100g','Trans fat banned'),
('Biscuits','>10 g/100g','>400 mg/100g','Hydrogenated fat banned'),
('Noodles','>5 g/100g','>800 mg/100g','MSG must be declared'),
('Water','Not Applicable','Not Applicable','Heavy metals banned'),
('Chocolates','>25 g/100g','No limit','Artificial colors banned'),
('Sauces','>15 g/100g','>750 mg/100g','Preservatives beyond limit'),
('New Beverages','Check added sugar','Check sodium','Sweeteners restricted'),
('Healthy Snacks','>8 g/100g','No limit','Steroids banned'),
('Modern Chips','>5 g/100g','>600 mg/100g','Trans fat banned'),
('Instant Meals','>5 g/100g','>800 mg/100g','MSG declaration mandatory'),
('Spreads','>20 g/100g','>400 mg/100g','Hydrogenated fat banned'),
('Bakery','>20 g/100g','>400 mg/100g','Trans fat banned'),
('Breakfast','>10 g/100g','>500 mg/100g','Artificial sweeteners restricted'),
('Namkeen','Low sugar','>600 mg/100g','Reused oil banned'),
('Traditional','>10 g/100g','>600 mg/100g','Non-permitted colors'),
('Dairy','Added sugar declared','>300 mg/100g','Synthetic milk banned'),
('Grains','No added sugar','No sodium','Adulterants banned'),
('Healthy Fat','No sugar','No sodium','Argemone oil banned'),
('Nuts','Low sugar','Low sodium','Artificial coating banned'),
('Beverage','Sugar declaration','No sodium','Artificial color banned'),
('Seeds','Low sugar','Low sodium','Chemical coating banned'),
('Treats','High sugar','Low sodium','Artificial colors banned'),
('Superfood','Low sugar','Low sodium','No additives allowed');

-- INSERT HARMFUL INGREDIENTS

INSERT INTO Harmful_Ingredients_Master (category,banned_ingredients,key_alert) VALUES
('Cold Drinks','Aspartame, Phosphoric Acid','Obesity & tooth decay'),
('Energy Drinks','Excess Caffeine','Heart issues'),
('Chips/Snacks','Trans Fat','Cardiac risk'),
('Noodles','MSG, Excess Sodium','High BP risk'),
('Biscuits','Hydrogenated Oils','Bad cholesterol'),
('Chocolates','Excess Sugar','Diabetes risk'),
('Sauces','Preservatives','Gastric problems'),
('Breakfast','High Sugar','Misleading health claims'),
('Namkeen','Reused Oil','Digestive issues'),
('Dairy','Synthetic Milk','Severe health hazard');


-- USERS TABLE

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- USER ALLERGIES TABLE

CREATE TABLE User_Allergies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    allergy_name VARCHAR(100),
    FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE
);

CREATE VIEW Product_Health_Report AS
SELECT p.product_name,
       p.brand,
       p.category,
       p.sugar_per_100g,
       p.salt_per_100g,
       f.sugar_alert,
       f.sodium_alert
FROM Products p
JOIN FSSAI_Standards f
     ON p.category = f.category;


CREATE VIEW Harmful_Product_Analyzer AS
SELECT DISTINCT p.product_name,
       p.brand,
       p.category,
       h.banned_ingredients,
       h.key_alert
FROM Products p
JOIN Product_Ingredients pi
     ON p.product_id = pi.product_id
JOIN Harmful_Ingredients_Master h
     ON p.category = h.category;





     

     





