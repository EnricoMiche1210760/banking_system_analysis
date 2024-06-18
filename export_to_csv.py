import mysql.connector
import pandas as pd

user = str(input("Inserire nome utente: "))
password = str(input("Inserire password: "))

# Database connection configuration
db_config = {
    'user': user,
    'password': password,
    'host': '127.0.0.1',
    'database': 'banca'
}

# Connect to the database
connection = mysql.connector.connect(**db_config)
query = "SELECT * FROM banca.denormalizzata"

# Fetch data into a pandas DataFrame
df = pd.read_sql(query, connection)

# Export DataFrame to CSV
df.to_csv('output.csv', index=False)

# Close the connection
connection.close()

print("Data has been exported to 'output.csv'.")
