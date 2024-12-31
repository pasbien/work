from flask import Flask, render_template, request, redirect, url_for
import mysql.connector
from mysql.connector import pooling

app = Flask(__name__)

# Database connection configuration
dbconfig = {
    "host": "127.0.0.1",
    "user": "root",
    "password": "hjvfynbrf324",  # Replace with your MySQL password
    "database": "realestate"  # Replace with your database name
}

connection_pool = pooling.MySQLConnectionPool(
    pool_name="mypool",
    pool_size=5,
    **dbconfig
)

@app.route("/", methods=["GET"])
def home():
    """Home page: list of properties."""
    with connection_pool.get_connection() as mydb:
        with mydb.cursor(dictionary=True) as cursor:
            cursor.execute("""
                SELECT p.PropertyID, p.Title, p.Description, p.Price, p.Location, p.Type, u.FirstName, u.LastName
                FROM properties p
                INNER JOIN users u ON p.SellerID = u.UserID
            """)
            properties = cursor.fetchall()

    return render_template("index.html", properties=properties)


@app.route("/inquiries", methods=["GET"])
def inquiries():
    """View inquiries for properties."""
    with connection_pool.get_connection() as mydb:
        with mydb.cursor(dictionary=True) as cursor:
            cursor.execute("""
                SELECT i.InquiryID, p.Title AS PropertyTitle, CONCAT(b.FirstName, ' ', b.LastName) AS BuyerName,
                       i.InquiryDate, i.Message
                FROM inquiries i
                INNER JOIN properties p ON i.PropertyID = p.PropertyID
                INNER JOIN users b ON i.BuyerID = b.UserID
            """)
            inquiries = cursor.fetchall()

    return render_template("inquiries.html", inquiries=inquiries)


@app.route("/properties/add", methods=["GET", "POST"])
def add_property():
    """Add a new property."""
    if request.method == "POST":
        title = request.form["title"]
        description = request.form["description"]
        price = request.form["price"]
        location = request.form["location"]
        property_type = request.form["type"]
        seller_id = request.form["seller_id"]

        with connection_pool.get_connection() as mydb:
            with mydb.cursor() as cursor:
                cursor.execute("""
                    INSERT INTO properties (Title, Description, Price, Location, Type, SellerID, ListingDate)
                    VALUES (%s, %s, %s, %s, %s, %s, CURDATE())
                """, (title, description, price, location, property_type, seller_id))
                mydb.commit()

        return redirect(url_for("home"))

    return render_template("add_property.html")

if __name__ == "__main__":
    app.run(debug=True)
