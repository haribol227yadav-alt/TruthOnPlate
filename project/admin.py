from flask import Flask, render_template, request, jsonify
import mysql.connector

app = Flask(__name__)

db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'futuristic', 
    'database': 'truthonplate'
}

def get_db_connection():
    return mysql.connector.connect(**db_config)

@app.route('/')
def admin_panel():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        # 1. Products (Sorted Naturally P1, P2... P10)
        cursor.execute("SELECT * FROM Products ORDER BY LENGTH(product_id), product_id")
        products = cursor.fetchall()
        
        # 2. Ingredients (Sorted Naturally)
        cursor.execute("""
            SELECT pi.product_id, p.product_name, pi.ingredient_name 
            FROM Product_Ingredients pi
            JOIN Products p ON pi.product_id = p.product_id
            ORDER BY LENGTH(pi.product_id), pi.product_id
        """)
        ingredients = cursor.fetchall()

        # 3. FSSAI Standards
        cursor.execute("SELECT * FROM FSSAI_Standards")
        fssai = cursor.fetchall()

        # 4. Harmful Ingredients Master
        cursor.execute("SELECT * FROM Harmful_Ingredients_Master")
        harmful = cursor.fetchall()

        # 5. Users
        cursor.execute("""
            SELECT u.user_id, u.full_name, u.email, ua.allergy_name, u.created_at
            FROM Users u 
            LEFT JOIN User_Allergies ua ON u.user_id = ua.user_id 
            ORDER BY u.created_at DESC
        """)
        users = cursor.fetchall()

        return render_template('admin.html', products=products, ingredients=ingredients, 
                               fssai=fssai, harmful=harmful, users=users)
    finally:
        cursor.close()
        conn.close()

# --- ADD PRODUCT (WITH ALL 8 FIELDS) ---
@app.route('/add_product', methods=['POST'])
def add_product():
    data = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("""
            INSERT INTO Products (product_id, product_name, brand, category, sugar_per_100g, salt_per_100g, fat_per_100g, protein_per_100g) 
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            data.get('product_id'), data.get('product_name'), data.get('brand'), data.get('category'),
            data.get('sugar') or 0, data.get('salt') or 0, data.get('fat') or 0, data.get('protein') or 0
        ))

        if data.get('ingredients'):
            ingredients_list = [i.strip() for i in data['ingredients'].split(',')]
            for ing in ingredients_list:
                if ing:
                    cursor.execute("INSERT INTO Product_Ingredients (product_id, ingredient_name) VALUES (%s, %s)", 
                                   (data.get('product_id'), ing))
        conn.commit()
        return jsonify({"status": "success", "message": "Product and Nutrition Data Saved!"})
    except Exception as e:
        conn.rollback()
        return jsonify({"status": "error", "message": str(e)}), 400
    finally:
        cursor.close()
        conn.close()

# --- UPDATES ---
@app.route('/update_product', methods=['POST'])
def update_product():
    data = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("UPDATE Products SET product_name=%s WHERE product_id=%s", (data['name'], data['id']))
        conn.commit()
        return jsonify({"status": "success", "message": "Product Name Updated!"})
    finally:
        cursor.close()
        conn.close()

@app.route('/update_ingredient', methods=['POST'])
def update_ingredient():
    data = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("UPDATE Product_Ingredients SET ingredient_name=%s WHERE product_id=%s AND ingredient_name=%s", 
                       (data['new_name'], data['pid'], data['old_name']))
        conn.commit()
        return jsonify({"status": "success", "message": "Ingredient Renamed!"})
    finally:
        cursor.close()
        conn.close()

@app.route('/update_fssai', methods=['POST'])
def update_fssai():
    data = request.json
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("UPDATE FSSAI_Standards SET sugar_alert=%s, sodium_alert=%s WHERE category=%s", 
                       (data['sugar'], data['sodium'], data['cat']))
        conn.commit()
        return jsonify({"status": "success", "message": "FSSAI Guidelines Updated!"})
    finally:
        cursor.close()
        conn.close()

# --- DELETES ---
@app.route('/delete_product/<pid>', methods=['DELETE'])
def delete_product(pid):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM Product_Ingredients WHERE product_id=%s", (pid,))
        cursor.execute("DELETE FROM Products WHERE product_id=%s", (pid,))
        conn.commit()
        return jsonify({"status": "success", "message": "Product Deleted!"})
    finally:
        cursor.close()
        conn.close()

@app.route('/delete_user/<uid>', methods=['DELETE'])
def delete_user(uid):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM User_Allergies WHERE user_id=%s", (uid,))
        cursor.execute("DELETE FROM Users WHERE user_id=%s", (uid,))
        conn.commit()
        return jsonify({"status": "success", "message": "User Removed!"})
    finally:
        cursor.close()
        conn.close()

if __name__ == '__main__':
    app.run(debug=True)