CREATE TABLE my_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INTEGER
);

INSERT INTO my_table (name, age) VALUES
  ('cip', 35),
  ('alex', 25),
  ('cuza', 39);