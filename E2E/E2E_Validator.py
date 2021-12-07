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

if __name__ == "__main__":
    sys.stdout.flush()

    print('-> Executing script file is:', str(sys.argv[0]))
    print('-> The arguments are:', str(sys.argv))

    print('-> StorageConnectionString: ', args.StorageConnectionString)
    print('-> SqlUsername: ', args.SqlUsername)
    print('-> SqlPassword: ', args.SqlPassword)

    connector = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+sqlServerEndpoint+';DATABASE='+database+'' + 
        ';UID='+args.SqlUsername+';PWD='+args.SqlPassword)

    cursor = connector.cursor()
    cursor.execute("SELECT TOP(10) * FROM [fhir].[Patient]")
    row = cursor.fetchone() 
    print(row)
    