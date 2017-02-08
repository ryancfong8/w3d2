require_relative 'connection'
require_relative 'model_base'

class User < ModelBase
  def self.find_by_name(fname, lname)
    user = QuestionDBConnection.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ?
        AND lname = ?
    SQL
    return nil unless user.length > 0

    User.new(user.first)
  end

  # def self.all
  #   users = QuestionDBConnection.instance.execute(<<-SQL)
  #     SELECT
  #       *
  #     FROM
  #       users
  #   SQL
  #   return nil unless users.length > 0
  #
  #   users.map { |user| User.new(user) }
  # end

  attr_accessor :id, :fname, :lname

  def initialize(options)
    @id = options['id']
    @fname= options['fname']
    @lname = options['lname']
  end

  # def save
  #   unless @id
  #     QuestionDBConnection.instance.execute(<<-SQL, @fname, @lname)
  #       INSERT INTO
  #         users (fname, lname)
  #       VALUES
  #         (?, ?)
  #     SQL
  #     @id = QuestionDBConnection.instance.last_insert_row_id
  #   else
  #     QuestionDBConnection.instance.execute(<<-SQL, @fname, @lname, @id)
  #       UPDATE
  #         users
  #       SET
  #         fname = ?, lname = ?
  #       WHERE
  #         id = ?
  #     SQL
  #   end
  # end

  def authored_questions
    Question.find_by_author_id(self.id)
  end

  def authored_replies
    Reply.find_by_user_id(self.id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    avg_array = QuestionDBConnection.instance.execute(<<-SQL, @id)
      SELECT
        CAST(COUNT(DISTINCT(question_likes.id)) AS FLOAT) / COUNT(DISTINCT(questions.id)) AS my_avg
      FROM
        question_likes
      JOIN
        questions
        ON questions.id = question_likes.question_id
      JOIN
        users
        ON users.id = questions.author_id
      GROUP BY
        users.id
      HAVING
        users.id = ?
    SQL
    return nil unless avg_array.length > 0

    avg_array.first['my_avg']

  end

end
