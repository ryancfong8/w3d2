DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('John', 'Smith'),
  ('Jane', 'Williams'),
  ('Phil', 'Rivera'),
  ('Sally', 'Martinez'),
  ('Ken', 'James'),
  ('Louise', 'Nash');

  INSERT INTO
    questions (title, body, author_id)
  VALUES
    ('How to select?', 'this is hard! help me!', 1),
    ('What is up w sub queries???', 'this is also pretty difficult!', 1),
    ('Nulls - need help', 'I do not really understand this topic at all!!!!', 2);

  INSERT INTO
    question_follows (question_id, user_id)
  VALUES
    (1, 5),
    (1, 4),
    (2, 4),
    (3, 4),
    (3, 3),
    (3, 1);

  INSERT INTO
    replies (question_id, parent_id, user_id, body)
  VALUES
    (1, NULL, 1, "Great Question!"),
    (1, 1, 2, "I do not know the answer"),
    (1, 2, 3, "Me neither"),
    (2, NULL, 2, "Just Google it!"),
    (1, 1, 5, "I know the answer but not telling!");

  INSERT INTO
    question_likes (user_id, question_id)
  VALUES
    (1, 1),
    (2, 1),
    (3, 1),
    (4, 1),
    (4, 2),
    (4, 3);
