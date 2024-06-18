import mysql.connector
import getpass
import pandas as pd

user = str(input("Inserire nome utente: "))
password = getpass.getpass(prompt="Inserire password: ")

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

file_to_export = 'info_clienti.csv'

# Export DataFrame to CSV
df.to_csv(file_to_export, index=False)

# Close the connection
connection.close()

print(f"Data has been exported to '{file_to_export}'.")
