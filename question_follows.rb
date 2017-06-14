require_relative "questions_database"

class QuestionFollows

  attr_reader :id, :user_id, :question_id

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL
    data.map { |datum| QuestionFollows.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def self.followers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        users
      JOIN
        question_follows
      ON
        users.id = question_follows.user_id
      WHERE
        question_id = ?
    SQL
    data.map { |datum| User.new(datum) }
  end

  def self.followed_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      JOIN
        question_follows
      ON
        questions.id = question_follows.question_id
      WHERE
        question_follows.user_id = ?
    SQL
    data.map { |datum| Question.new(datum) }
  end

  def self.most_followed_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        questions.user_id,
        title,
        body,
        questions.id,
        COUNT(question_follows.question_id) AS num_follows
      FROM
        questions
      JOIN
        question_follows
      ON
        question_follows.question_id = questions.id
      GROUP BY
        question_follows.question_id
      ORDER BY
        COUNT(question_follows.question_id) DESC
      LIMIT
        '#{n}'
    SQL
    data.map { |datum| Question.new(datum) }
  end

end
