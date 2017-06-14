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
  user_id INTEGER NOT NULL,

  FOREIGN KEY(user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;
CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;
CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  question_title TEXT NOT NULL,
  parent_reply_id INTEGER,

  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(question_title) REFERENCES questions(title),
  FOREIGN KEY(parent_reply_id) REFERENCES replies(id)
);

DROP TABLE IF EXISTS question_likes;
CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  likes INTEGER NOT NULL,

  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);


INSERT INTO
  users (fname, lname)
VALUES
  ('Jon', 'Chaney'),
  ('Deirdre', 'Hyde');

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('Assessment', 'What day will it be on?', (SELECT id FROM users WHERE fname = 'Jon')),
  ('Lunch', 'What''s for lunch?', (SELECT id FROM users WHERE fname = 'Deirdre')),
  ('Weather', 'How hot is it today?', (SELECT id FROM users WHERE fname = 'Jon'));

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Jon'), (SELECT id FROM questions WHERE title = 'Lunch')),
  ((SELECT id FROM users WHERE fname = 'Deirdre'), (SELECT id FROM questions WHERE title = 'Assessment')),
  ((SELECT id FROM users WHERE fname = 'Deirdre'), (SELECT id FROM questions WHERE title = 'Lunch'));

INSERT INTO
  replies (body, user_id, question_id, question_title, parent_reply_id)
VALUES
  ('It will be on Monday!', (SELECT id FROM users WHERE fname = 'Jon'), (SELECT id FROM questions WHERE title = 'Assessment'),
    (SELECT title FROM questions WHERE title = 'Assessment'), NULL);

INSERT INTO
  replies (body, user_id, question_id, question_title, parent_reply_id)
VALUES
  ('I thought it will be on Tuesday...?', (SELECT id FROM users WHERE fname = 'Deirdre'),
    (SELECT id FROM questions WHERE title = 'Assessment'), (SELECT title FROM questions WHERE title = 'Assessment'),
    (SELECT id FROM replies WHERE parent_reply_id IS NULL));

INSERT INTO
  replies (body, user_id, question_id, question_title, parent_reply_id)
VALUES
  ('thank you', (SELECT id FROM users WHERE fname = 'Deirdre'),
    (SELECT id FROM questions WHERE title = 'Assessment'), (SELECT title FROM questions WHERE title = 'Assessment'),
    (SELECT id FROM replies WHERE parent_reply_id = 1));

INSERT INTO
  question_likes (user_id, question_id, likes)
VALUES
  ((SELECT id FROM users WHERE fname = 'Jon'), (SELECT id FROM questions WHERE title = 'Assessment'), 5),
  ((SELECT id FROM users WHERE fname = 'Deirdre'), (SELECT id FROM questions WHERE title = 'Assessment'), 2);
