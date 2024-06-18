import mysql.connector
import getpass
import pandas as pd
import warnings


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
cursor = connection.cursor()

try:
    with open('clients_info.sql', 'r') as sql_file:
        sql_script = sql_file.read()
    print("Executing SQL script...")
    for statement in sql_script.split(';'):
        if statement.strip():
            cursor.execute(statement)
    connection.commit()
except Exception as e:
    print(f"Warning: {str(e)}")
    connection.rollback()

query = "SELECT * FROM banca.denormalizzata"
warnings.filterwarnings("ignore")
df = pd.read_sql(query, connection)
file_to_export = 'info_clienti.csv'
df.to_csv(file_to_export, index=False)

# Close the connection
connection.close()

print(f"Data has been exported to '{file_to_export}'.")
