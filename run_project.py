import mysql.connector
import getpass
import pandas as pd
import warnings
from time import sleep

def get_db_config(user, password, database:bool = False):
    if database:
        db_config = {
            'user': user,
            'password': password,
            'host': '127.0.0.1',
            'database':'banca'
        }
    
    else:
        db_config = {
            'user': user,
            'password': password,
            'host': '127.0.0.1'
        }
    
    return db_config

def run_sql_script(cursor, sql_script_file:str):
    with open(sql_script_file, 'r') as sql_file:
        sql_script = sql_file.read()
    print(f"Executing SQL {sql_script_file} script...")
    for statement in sql_script.split(';'):
        if statement.strip():
            cursor.execute(statement)


user = str(input("Inserire nome utente: "))
password = getpass.getpass(prompt="Inserire password: ")


# Database connection configuration
try:
    db_config = get_db_config(user, password, database=True)
    connection = mysql.connector.connect(**db_config)
    connection.close()
except:
    db_config = get_db_config(user, password)
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor()
    run_sql_script(cursor, 'db_bancario.sql')
    connection.commit()
    connection.close()
    cursor.close()


db_config = get_db_config(user, password, database=True)
# Connect to the database
connection = mysql.connector.connect(**db_config)
cursor = connection.cursor()
try:
    run_sql_script(cursor, 'clients_info.sql')
except Exception as e:
    print(f"Warning: {str(e)}")
    connection.rollback()

sleep(2)
connection.commit()
connection.close()
cursor.close()

db_config = get_db_config(user, password, database=True)
# Connect to the database
connection = mysql.connector.connect(**db_config)
query = "SELECT * FROM banca.denormalizzata;"

warnings.filterwarnings("ignore")
df = pd.read_sql(query, connection)
file_to_export = 'info_clienti.csv'
df.to_csv(file_to_export, index=False)

# Close the connection
connection.close()

print(f"Data has been exported to '{file_to_export}'.")
