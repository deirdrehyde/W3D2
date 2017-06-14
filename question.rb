require_relative "questions_database"
require_relative "user"
require_relative "replies"

class Question

  attr_reader :id, :user_id
  attr_accessor :title, :body

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    data.map { |datum| Question.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def self.find_by_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?
    SQL
    data.map { |datum| Question.new(datum) }
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

  def replies
    Replies.find_by_question_id(@id)
  end

  def followers
    QuestionFollows.followers_for_question_id(@id)
  end

  def self.most_followed(n)
    QuestionFollows.most_followed_questions(n)
  end

end
