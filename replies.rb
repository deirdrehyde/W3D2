require_relative "questions_database"

class Replies

  attr_reader :id, :body, :user_id, :question_id, :question_title, :parent_reply_id

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    data.map { |datum| Replies.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @body = options['body']
    @user_id = options['user_id']
    @question_id = options['question_id']
    @question_title = options['question_title']
    @parent_reply_id = options['parent_reply_id']
  end

  def self.find_by_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    data.map { |datum| Replies.new(datum) }
  end

  def self.find_by_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
    data.map { |datum| Replies.new(datum) }
  end

  def author
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    data.map { |datum| User.new(datum) }
  end

  def question
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    data.map { |datum| Question.new(datum) }
  end

  def parent_reply
    data = QuestionsDatabase.instance.execute(<<-SQL, parent_reply_id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    data.map { |datum| Replies.new(datum) }
  end

  def child_replies
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_reply_id = ?
    SQL
    data.map { |datum| Replies.new(datum) }
  end
end
