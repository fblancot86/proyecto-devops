# Flask & MySQL

This practice is intended to deploy a microservice that is able to read and write in a database. To implement this we built a dockerized flask application running in one container which points out toward the database running in its corresponding container.

# Defining the app file
First of all, the app.py file is defined to configure flask app and the database settings for establishing the communication between them.
Also, there has been defined environment variables(hardcoded) for sensitive information such as, MYSQL_USER, MYSQL_PASSWORD, MYSQL_HOST and MYSQL_DB to make it configurable from only one file.

```bash
from flask import Flask
from flask_mysqldb import MySQL
import os

app = Flask(__name__)

app.config['MYSQL_USER'] = os.environ['MYSQL_USER']
app.config['MYSQL_PASSWORD'] = os.environ['MYSQL_PASSWORD']
app.config['MYSQL_HOST'] = os.environ['MYSQL_HOST']
app.config['MYSQL_DB'] = os.environ['MYSQL_DB']
mysql = MySQL(app)


@app.route('/create-table')
def createtable():
    cursor = mysql.connection.cursor()
    cursor.execute(''' CREATE TABLE IF NOT EXISTS students(id INT(5) PRIMARY KEY NOT NULL AUTO_INCREMENT,
                                             name VARCHAR(50) NOT NULL,
                                             email VARCHAR(100) NOT NULL,
                                             phone INT NOT NULL,
                                             address VARCHAR(250) NOT NULL)''')
    cursor.close()
    return 'Tabla Creada'


@app.route('/add-students')
def addstudents():
    cursor = mysql.connection.cursor()
    cursor.execute(''' INSERT IGNORE INTO students (id,name,email,phone,address) VALUES('1','Pedro Romero','pedro_romero@gmail.com',657798564,'Sant Joan Despi');
                       INSERT IGNORE INTO students (id,name,email,phone,address) VALUES('2','Nazaret Olivieri','nazaret_olivieri@gmail.com',610432987,'Cornella de Llobregat'); commit; ''')
    cursor.close()
    return 'Estudiantes añadidos del primer año'


@app.route('/')
def students():
    s = "<table style='border:1px solid red'>"

    cursor = mysql.connection.cursor()
    cursor.execute(''' SELECT * FROM students; ''')
    for row in cursor.fetchall():
        s = s + "<tr>"
        for x in row:
            s = s + "<td>" + str(x) + "</td>"
        s = s + "</tr>"

    cursor.close()
    return "<html><body>" + s + "</body></html>"

@app.route('/ping')
def ping():
    return 'pong'
```
# Requirements
In the requirements.txt file were included the necessary libraries and dependencies for app.py file
```bash
Flask==2.1.2
Flask-MySQLdb==1.0.1
```
# Building docker image
For building the app image, there was created a Dockerfile to add the required dependencies, software or libraries. 

There was also introduced the variable <b>FLASK_ENV=development</b>, which reloads the application when it detects any change.

We proceed to build the image and upload it to Docker hub repository

```bash
docker build -t flask-app .

docker image ls
REPOSITORY                    TAG          IMAGE ID       CREATED          SIZE
ramirezy/flask-app          latest       74a15c780d02   36 minutes ago     250MB
```
# Docker compose

Now the final part is create the docker compose file, where are specified the services for flask and MySQL app, the container's image, the environments, ports, and volumenes to make it persistents for both database and flask app.

```bash
version: '3.9'

services:
  app:
    build: .
    container_name: flask_app
    restart: unless-stopped
    environment:
     MYSQL_HOST: ${MYSQL_HOST}
     MYSQL_USER: ${MYSQL_USER}
     MYSQL_PASSWORD: ${MYSQL_PASSWORD}
     MYSQL_DB: ${MYSQL_DB}
    ports:
     - 5000:5000
    depends_on:
      - db
    volumes:
      - ./app.py:/app/app.py
  db:
    container_name: db
    image: mysql:5.7
    command: --default-authentication-plugin=mysql_native_password
    restart: always
    environment:
     MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
     MYSQL_DATABASE: ${MYSQL_DATABASE}
     MYSQL_USER: ${MYSQL_USER}
     MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    ports:
     - 3306:3306
    expose:
     - 3306
    volumes:
     - my-db:/var/lib/mysql

volumes:
 my-db:
 ```
Afterward the docker environment is created we proceed to run the application as follows.
```bash
docker-compose up
```
# Testing the webapp
Now we can test the webapp by typing the following endpoints in the browser:


- `http://172.18.0.3:5000/create-table`
 
  You will see the following output on your Unix terminal/browser:

  ![create-table](https://user-images.githubusercontent.com/39458920/156878380-cd7e6253-e47e-4aab-9ec5-eb188baa699a.JPG)

To see the output of added students, type the command:  
 
 - `http://172.18.0.3:5000/add-students`
 
   You will see the following output on your Unix terminal/browser:

   ![add-students](https://user-images.githubusercontent.com/39458920/156878176-3f0cb950-f870-4c59-ba98-1577547bed4b.JPG)
 
 To see the output of table students, type the command: 
  
 - `http://172.18.0.3:5000/`
 
   You will see the following output on your Unix terminal/browser:
  ![output_db](https://user-images.githubusercontent.com/39458920/157477439-3835c41a-8769-4a76-9d30-eead3e4323c6.JPG)
  
