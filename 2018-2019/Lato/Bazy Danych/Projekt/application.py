import psycopg2
import json
import sys
from datetime import datetime

connection = None
cursor = None

status_ok = { "status": "OK" }
status_error = { "status": "ERROR" }

def quote(string):
    return "\'"+string+"\'"

def print_status():
    is_ok = cursor.fetchone()[0]
    if is_ok:
        print(status_ok)
    else:
        print(status_error)

def send_query(func,query,data,date):
    if func == "leader":
        cursor.execute(query.format(quote(date),quote(data["password"]),data["member"]))
    elif func == "support" or func == "protest":
        if len(data) == 5:
            cursor.execute(query.format(quote(date), data["member"], quote(data["password"]), data["action"], data["project"]))
        else:
            cursor.execute(query.format(quote(date), data["member"], quote(data["password"]), data["action"], str(data["project"]) + "," + str(data["authority"])))
    elif func == "upvote" or func == "downvote":
        cursor.execute(query.format(quote(date), data["member"], quote(data["password"]), data["action"]))
    elif func == "projects":
        cursor.execute("SELECT leader_check({},{},{})".format(quote(date),data["member"],quote(data["password"])))
        is_ok = cursor.fetchone()[0]
        if is_ok:
            if len(data) == 4:
                cursor.execute(query.format(quote(date), data["member"] , quote(data["password"]) + ", " + str(data["authority"])))
            else:
                cursor.execute(query.format(quote(date), data["member"], quote(data["password"])))
        else:
            print('{"status": "ERROR"}')
            return
    elif func == "votes":
        cursor.execute("SELECT leader_check({},{},{})".format(quote(date),data["member"],quote(data["password"])))
        is_ok = cursor.fetchone()[0]
        print(is_ok)
        if is_ok:
            if len(data) == 4:
                if "action" in data:
                    cursor.execute(query.format(quote(date), data["member"] , quote(data["password"]) + ", " + str(data["action"])))
                else:
                    cursor.execute(query.format(quote(date), data["member"] , quote(data["password"]) + ", " + str(data["project"])))
            else:
                cursor.execute(query.format(quote(date), data["member"], quote(data["password"])))
        else:
            print('{"status": "ERROR"}')
            return
    elif func == "trolls":
        cursor.execute(query.format(quote(date)))
    if func == "leader" or func == "support" or func == "protest" or func == "upvote" or func == "downvote":
        print(query)
        print_status()
    elif func == "trolls":
        print(query)
        query_data =[list(r) for r in cursor.fetchall()]
        query_data.sort(key=lambda x: (x[1], -x[0]), reverse=True)
        result = {"status": "OK", "data": query_data}
        print(result)
    elif func == "votes":
        print(query)
        query_data =[list(r) for r in cursor.fetchall()]
        query_data.sort(key=lambda x: x[0])
        result = {"status": "OK", "data": query_data}
        print(result)
    else:
        print(query)
        query_data =[list(r) for r in cursor.fetchall()]
        result = {"status": "OK", "data": query_data}
        print(result)
    

functions = {
    "leader" : "SELECT leader({},{},{});",
    "support" : "SELECT support({},{},{},{},{});", # last space for two
    "protest" : "SELECT protest({},{},{},{},{});", # last space for two
    "upvote" : "SELECT upvote({},{},{},{});",
    "downvote" : "SELECT downvote({},{},{},{});",
    "projects" : "SELECT * FROM projects({},{},{});", # the last space is for two arguments (authority is optional)
    "trolls" : "SELECT * FROM trolls({});",
    "votes" : "SELECT * FROM votes({},{},{});"
}
open_json = input()
open_query = json.loads(open_json)
open_query = next(iter(open_query.values()))
# next(iter(open_query)) - klucz w słowniku - nazwa funkcji
# next(iter(open_query.values()))  - wartość klucza - dane do funkcji
try:
    
    connection = psycopg2.connect(
        user=open_query["login"], password=open_query["password"], host="localhost", port=5432, database=open_query["database"])
    connection.autocommit = True
    cursor = connection.cursor()

    if len(sys.argv) == 2 and sys.argv[1] == "--init":
        cursor.execute("DROP TABLE IF EXISTS member CASCADE")
        cursor.execute("DROP TABLE IF EXISTS authority CASCADE")
        cursor.execute("DROP TABLE IF EXISTS project CASCADE")
        cursor.execute("DROP TABLE IF EXISTS action CASCADE")
        cursor.execute("DROP TABLE IF EXISTS vote CASCADE")

        cursor.execute("DROP TYPE IF EXISTS troll CASCADE;")
        cursor.execute("DROP TYPE IF EXISTS mem_vote CASCADE;")
        cursor.execute("DROP TYPE IF EXISTS projects_of_authorities CASCADE;")
        cursor.execute("DROP TYPE IF EXISTS actions_of_projects CASCADE;")
        cursor.execute("DROP USER IF EXISTS app;")
        cursor.execute(open("baza.sql", "r").read())
        cursor.execute("CREATE USER app ENCRYPTED PASSWORD 'qwerty';")
        cursor.execute("GRANT SELECT,INSERT,UPDATE ON member TO app;")
        cursor.execute("GRANT SELECT,INSERT,UPDATE ON action TO app;")
        cursor.execute("GRANT SELECT,INSERT,UPDATE ON vote TO app;")
        cursor.execute("GRANT SELECT,INSERT,UPDATE ON project TO app;")
        cursor.execute("GRANT SELECT,INSERT,UPDATE ON authority TO app;")
        cursor.execute("GRANT CONNECT ON DATABASE student TO app;")
    for line in sys.stdin:
        line.rstrip('\n')
        query_json = json.loads(line)
        func = next(iter(query_json))
        data = next(iter(query_json.values()))
        query = functions[func]
        date = datetime.fromtimestamp(data["timestamp"]).strftime("%Y-%m-%d %H:%M:%S")
        send_query(func,query,data,date)
            
except (Exception, psycopg2.Error) as error :
    print("Error while connecting to PostgreSQL",error)
finally:
    if(connection):
        #connection.commit()
        cursor.close()
        connection.close()