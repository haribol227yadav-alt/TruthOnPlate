from flask import Flask, render_template, request, jsonify
import mysql.connector

app = Flask(__name__)

# Database Configuration
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'futuristic',
    'database': 'TruthOnPlate'
}

def get_db_connection():
    return mysql.connector.connect(**db_config)

# --- USER REGISTRATION LOGIC ---
@app.route('/register', methods=['POST'])
def register_user():
    data = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        user_query = "INSERT INTO Users (full_name, email) VALUES (%s, %s)"
        cursor.execute(user_query, (data['name'], data['email']))
        user_id = cursor.lastrowid
        
        if data.get('allergy') and data['allergy'] != "None":
            allergy_query = "INSERT INTO User_Allergies (user_id, allergy_name) VALUES (%s, %s)"
            cursor.execute(allergy_query, (user_id, data['allergy']))
        
        conn.commit()
        return jsonify({"status": "success", "message": "Details & Allergy Saved to DB!"})
    except mysql.connector.Error as err:
        conn.rollback()
        return jsonify({"status": "error", "message": str(err)}), 400
    finally:
        cursor.close()
        conn.close()

# --- MAIN DASHBOARD ROUTE ---
@app.route('/')
def index():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    # Dashboard Main Stats
    cursor.execute("SELECT COUNT(*) as total FROM Products")
    total_stats = cursor.fetchone()

    # Category Breakdown
    cursor.execute("SELECT category, COUNT(*) as count FROM Products GROUP BY category")
    categories = cursor.fetchall()
    
    # Product List for dropdowns
    # FIX: category ko SELECT mein add kiya hai filter ke liye
    cursor.execute("SELECT product_id, product_name, category FROM Products ORDER BY product_name")
    product_list = cursor.fetchall()

    # Ingredient List for allergy selection
    cursor.execute("SELECT DISTINCT ingredient_name FROM Product_Ingredients ORDER BY ingredient_name")
    ingredients_list = cursor.fetchall()

    cursor.close()
    conn.close()
    
    return render_template('foodtruth1.html', 
                           stats=total_stats, 
                           categories=categories, 
                           product_list=product_list, 
                           ingredients_list=ingredients_list)

# --- BATTLE LOGIC (UPDATED FOR NEW HTML METRICS) ---
@app.route('/battle', methods=['POST'])
def battle():
    p1_id = request.json.get('p1_id')
    p2_id = request.json.get('p2_id')
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute("SELECT * FROM Products WHERE product_id IN (%s, %s)", (p1_id, p2_id))
    results = cursor.fetchall()
    
    for row in results:
        # Added 'calories', 'fat_per_100g', 'salt_per_100g' for the new Battle Table & Chart
        for key in ['sugar_per_100g', 'salt_per_100g', 'fat_per_100g', 'protein_per_100g', 'calories']:
            if key in row:
                row[key] = float(row[key]) if row[key] is not None else 0.0

    cursor.close()
    conn.close()
    return jsonify(results)

# --- PRODUCT DECODER / INGREDIENT LAB ---
@app.route('/analyze_product/<product_id>')
def analyze_product(product_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    query = """
        SELECT p.*, GROUP_CONCAT(pi.ingredient_name SEPARATOR ', ') as all_ingredients
        FROM Products p
        LEFT JOIN Product_Ingredients pi ON p.product_id = pi.product_id
        WHERE p.product_id = %s
        GROUP BY p.product_id
    """
    cursor.execute(query, (product_id,))
    product = cursor.fetchone()
    
    if product:
        for key in ['sugar_per_100g', 'salt_per_100g', 'fat_per_100g', 'protein_per_100g', 'calories']:
            if key in product:
                product[key] = float(product[key]) if product[key] is not None else 0.0

    cursor.close()
    conn.close()
    return jsonify(product) if product else (jsonify({"error": "Not found"}), 404)

# --- SMART SWAP ---
@app.route('/get_swap/<product_id>')
def get_swap(product_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT category, sugar_per_100g FROM Products WHERE product_id = %s", (product_id,))
    current = cursor.fetchone()
    if current:
        query = "SELECT product_id, product_name, sugar_per_100g FROM Products WHERE category = %s AND product_id != %s AND sugar_per_100g < %s ORDER BY sugar_per_100g ASC LIMIT 1"
        cursor.execute(query, (current['category'], product_id, current['sugar_per_100g']))
        swap = cursor.fetchone()
        
        if swap:
            swap['sugar_per_100g'] = float(swap['sugar_per_100g'])
            
        cursor.close()
        conn.close()
        return jsonify(swap) if swap else jsonify(None)
    return jsonify(None)

# --- HEALTH REPORT ---
@app.route('/health_report/<category>')
def health_report(category):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    if category == "All":
        cursor.execute("SELECT * FROM Product_Health_Report")
    else:
        cursor.execute("SELECT * FROM Product_Health_Report WHERE category = %s", (category,))
    report_data = cursor.fetchall()
    
    for row in report_data:
        if 'sugar_per_100g' in row:
            row['sugar_per_100g'] = float(row['sugar_per_100g'])

    cursor.close()
    conn.close()
    return jsonify(report_data)

# --- BODY LAB CALCULATION ---
@app.route('/body_lab/<product_id>/<int:grams>')
def body_lab(product_id, grams):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT product_name, protein_per_100g FROM Products WHERE product_id = %s", (product_id,))
    product = cursor.fetchone()
    cursor.close()
    conn.close()

    if product:
        # Calculation logic based on protein content
        protein_factor = float(product['protein_per_100g'])
        total_protein = (protein_factor * grams) / 100.0
        
        # Biometric conversions
        skin_cells = int(total_protein * 50000) 
        muscle_fibers = int(total_protein * 15) 
        hair_growth = total_protein * 0.2 

        return jsonify({
            "product_name": product['product_name'],
            "total_protein": round(total_protein, 2),
            "skin_cells": "{:,}".format(skin_cells),
            "muscle_fibers": "{:,}".format(muscle_fibers),
            "hair_growth": round(hair_growth, 2)
        })
    return jsonify({"error": "Product not found"}), 404

# --- HEALTHIEST IN CATEGORY ---
@app.route('/healthiest_in_category/<category>')
def healthiest_in_category(category):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    query = """
        SELECT *, 
        ((protein_per_100g * 2) - (sugar_per_100g + salt_per_100g + fat_per_100g)) AS health_score
        FROM Products 
        WHERE category = %s OR %s = 'All'
        ORDER BY health_score DESC
        LIMIT 1
    """
    cursor.execute(query, (category, category))
    healthiest = cursor.fetchone()
    
    if healthiest:
        for key in ['sugar_per_100g', 'salt_per_100g', 'fat_per_100g', 'protein_per_100g', 'calories']:
            if key in healthiest:
                healthiest[key] = float(healthiest[key])

    cursor.close()
    conn.close()
    return jsonify(healthiest) if healthiest else jsonify(None)

# --- SATIETY LEADERBOARD ---
@app.route('/satiety_index')
def satiety_index():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    # Satiety logic: High volume/calories + protein bonus
    query = """
        SELECT 
            product_name, 
            category,
            calories,
            protein_per_100g,
            ROUND((100 / NULLIF(calories, 0)) * 100, 0) AS grams_for_100kcal,
            ROUND(((100 / NULLIF(calories, 0)) * 100) + ((protein_per_100g / NULLIF(calories, 0)) * 1000), 2) AS satiety_score
        FROM Products 
        WHERE calories > 0
        ORDER BY satiety_score DESC
        LIMIT 10
    """
    cursor.execute(query)
    results = cursor.fetchall()
    
    for row in results:
        row['satiety_score'] = float(row['satiety_score'])
        row['grams_for_100kcal'] = float(row['grams_for_100kcal'])

    cursor.close()
    conn.close()
    return jsonify(results)

# --- CUSTOM SATIETY CALCULATION ROUTE ---
@app.route('/calculate_satiety/<product_id>/<int:grams>')
def calculate_satiety(product_id, grams):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT product_name, calories, protein_per_100g FROM Products WHERE product_id = %s", (product_id,))
    product = cursor.fetchone()
    cursor.close()
    conn.close()

    if product and product['calories'] > 0:
        # Calculate totals for the specific user input
        total_cals = (float(product['calories']) * grams) / 100.0
        total_protein = (float(product['protein_per_100g']) * grams) / 100.0
        
        # Matching the exact leaderboard score formula
        # Score = (Volume for 100kcal) + (Protein Weighting)
        score = ((100 / float(product['calories'])) * 100) + ((float(product['protein_per_100g']) / float(product['calories'])) * 1000)
        
        return jsonify({
            "product_name": product['product_name'],
            "calories": round(total_cals, 1),
            "protein": round(total_protein, 1),
            "satiety_score": round(score, 2)
        })
    return jsonify({"error": "Data invalid or product not found"}), 404

if __name__ == '__main__':
    app.run(debug=True)