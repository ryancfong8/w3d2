require_relative 'connection'
require_relative 'model_base'

class QuestionFollow < ModelBase

  def self.find_by_question_id(question_id)
    question_follow = QuestionDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        question_id = ?
    SQL
    return nil unless question_follow.length > 0

    QuestionFollow.new(question_follow.first)
  end

  def self.find_by_user_id(user_id)
    question_follow = QuestionDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        user_id = ?
    SQL
    return nil unless question_follow.length > 0

    QuestionFollow.new(question_follow.first)
  end
  # 
  # def self.all
  #   question_follows = QuestionDBConnection.instance.execute(<<-SQL)
  #     SELECT
  #       *
  #     FROM
  #       question_follows
  #   SQL
  #   return nil unless question_follows.length > 0
  #
  #   question_follows.map { |question_follow| QuestionFollow.new(question_follow) }
  # end

  def self.followers_for_question_id(question_id)
    users = QuestionDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, users.fname, users.lname
      FROM
        users
      JOIN
        question_follows
        ON question_follows.user_id = users.id
      WHERE
        question_follows.question_id = ?
    SQL
    return nil unless users.length > 0

    users.map {|user| User.new(user)}
  end

  def self.followed_questions_for_user_id(user_id)
    questions = QuestionDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      JOIN
        question_follows
        ON question_follows.question_id = questions.id
      WHERE
        question_follows.user_id = ?
    SQL
    return nil unless questions.length > 0

    questions.map {|question| Question.new(question)}
  end

  def self.most_followed_questions(n)
    questions = QuestionDBConnection.instance.execute(<<-SQL, n)
      SELECT
        *
      FROM
        questions
      JOIN
        question_follows
        ON question_follows.question_id = questions.id
      GROUP BY
        question_id
      ORDER BY
        COUNT(user_id) DESC
      LIMIT
        ?
    SQL
    return nil unless questions.length > 0

    questions.map {|question| Question.new(question)}
  end

  attr_accessor :id, :question_id, :user_id

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
end
