DROP TABLE IF EXISTS my_table;

CREATE TABLE my_table (
  id INT AUTO_INCREMENT  PRIMARY KEY,
  name VARCHAR(250) NOT NULL,
  age INT NOT NULL,
);

INSERT INTO my_table (name, age) VALUES
  ('george', 35);