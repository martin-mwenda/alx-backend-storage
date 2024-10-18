-- Task: Create a table named 'users' with specific constraints
-- The 'id' column is an integer, never null, auto-incremented, and is the primary key
-- The 'email' column is a string, never null, unique
-- The 'name' column is a string, allows null values

CREATE TABLE IF NOT EXISTS users (
    id INT NOT NULL AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255),
    PRIMARY KEY (id)
);

