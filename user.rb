require_relative "questions_database"
require_relative "question"
require_relative "question_follows"

class User

  attr_reader :id
  attr_accessor :fname, :lname

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    data.map { |datum| User.new(datum) }
  end

  def self.find_by_name(fname, lname)
    data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND
        lname = ?
    SQL
    data.map { |datum| User.new(datum) }
  end

  def authored_questions
    Question.find_by_user_id(@id)
  end

  def authored_replies
    Replies.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollows.followed_questions_for_user_id(@id)
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end
end
