require_relative 'connection'
require_relative 'model_base'

class QuestionLike < ModelBase

  def self.likers_for_question_id(question_id)
    likers = QuestionDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        question_likes
      JOIN
        users
        ON users.id = question_likes.user_id
      WHERE
        question_id = ?
    SQL
    return nil unless likers.length > 0

    likers.map {|user| User.new(user)}
  end

  def self.liked_questions_for_user_id(user_id)
    questions = QuestionDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        question_likes
      JOIN
        questions
        ON question_likes.question_id = questions.id
      WHERE
        user_id = ?
    SQL
    return nil unless questions.length > 0

    questions.map { |question| Question.new(question) }
  end

  # def self.all
  #   question_likes = QuestionDBConnection.instance.execute(<<-SQL)
  #     SELECT
  #       *
  #     FROM
  #       question_likes
  #   SQL
  #   return nil unless question_likes.length > 0
  #
  #   question_likes.map { |question_like| QuestionLike.new(question_like) }
  # end

  def self.num_likes_for_question_id(question_id)
    count_arr = QuestionDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(*) as num_likes
      FROM
        question_likes
      JOIN
        users
        ON users.id = question_likes.user_id
      GROUP BY
        question_id
      HAVING
        question_id = ?
    SQL
    return nil unless count_arr.length > 0

    count_arr.first['num_likes']
  end

  def self.most_liked_questions(n)
    questions = QuestionDBConnection.instance.execute(<<-SQL, n)
      SELECT
        *
      FROM
        question_likes
      JOIN
        questions
        ON questions.id = question_likes.question_id
      GROUP BY
        question_id
      ORDER BY
        COUNT(*) DESC
      LIMIT
        ?
    SQL
    return nil unless questions.length > 0

    questions.map { |question| Question.new(question) }

  end

  attr_accessor :id, :question_id, :user_id

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

end
