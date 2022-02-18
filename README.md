# Prototype of a Distributed Database of an Academic Management System


Distributed database schema to manage academic information of a university, where the information of each faculty is stored in a different geographical location. Information is also distributed locally for each career of the faculty.

This project was implemented with PostgreSQL and each database has its own stored procedures to insert, update, select or delete information using the PL/pgSQL language. It uses the dblink extension to communicate between databases.

## Installation

You need to install PostgreSQL version 12.4. PgAdmin4 is recommended for managing local databases.

To install it locally, run the sql scripts in order and change the dblink port to the local port of each database.

To install it on different computers, you need to run the scripts in order, but in the following locations:
- Computer 1: 1, 6
- Computer 2: 2, 5
- Computer 3: 3, 4

The ngrok software was used to expose the local database server, so replace the ip address of the dblink field for the one provided by ngrok.
