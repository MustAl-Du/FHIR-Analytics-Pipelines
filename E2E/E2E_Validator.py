import os
import sys
import argparse
import pyodbc

parser = argparse.ArgumentParser()
parser.add_argument("--StorageConnectionString", help="Storage connection string.")
parser.add_argument("--SqlUsername", help="SQL username")
parser.add_argument("--SqlPassword", help="SQL password")
args = parser.parse_args()

sqlServerEndpoint = "quwansynapse1207-ondemand.sql.azuresynapse.net"
database = "fhirdb"
storageConnectionString = os.getenv('STORAGE_CONNECTION_STRING')
sqlUsername = os.getenv('SQL_USERNAME')
sqlPassword = os.getenv('SQL_PASSWORD')


if __name__ == "__main__":
    sys.stdout.flush()

    print('-> Executing script file is:', str(sys.argv[0]))
    print('-> The arguments are:', str(sys.argv))

    print('-> args.StorageConnectionString: ', args.StorageConnectionString)
    print('-> args.SqlUsername: ', args.SqlUsername)
    print('-> args.SqlPassword: ', args.SqlPassword)

    print('-> StorageConnectionString: ', storageConnectionString[0:3])
    print('-> SqlUsername: ', sqlUsername[0:3])
    print('-> SqlPassword: ', sqlPassword[0:3])

    connector = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+sqlServerEndpoint+';DATABASE='+database+'' + 
        ';UID='+sqlUsername+';PWD='+sqlPassword)

    cursor = connector.cursor()
    cursor.execute("SELECT TOP(10) * FROM [fhir].[Patient]")
    row = cursor.fetchone() 
    print(row)
    