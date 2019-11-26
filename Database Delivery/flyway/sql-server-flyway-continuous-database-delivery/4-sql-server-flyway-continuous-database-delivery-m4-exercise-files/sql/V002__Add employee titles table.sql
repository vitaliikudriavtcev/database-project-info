CREATE TABLE titles (
  id INT NOT NULL IDENTITY(1,1),
  title VARCHAR(100) NOT NULL,
  PRIMARY KEY (id)
)

INSERT INTO titles (title) VALUES ('Underling');
INSERT INTO titles (title) VALUES ('Evil Overlord');
INSERT INTO titles (title) VALUES ('Benevolent Dictator');
