# Distributed Database


Distributed database schema of a university, where the information of each faculty is stored on a different geographical location. The information is also distributed locally for each career of the faculty.

Each database has it's own stored procedures to insert, update, select or delete information.

It uses the extension dblink to communicate between the databases.

## Installation

You need to install PostgreSQL version 12.4. pgAdmin4 is recommended to manage the local databases.

To install it locally, execute the sql scripts in order, and change the dblink port to the local port of each database.

To install it on different computers, you have to execute the scripts in order, but in the following locations:
- Computer 1: 1, 6
- Computer 2: 2, 5
- Computer 3: 3, 4

