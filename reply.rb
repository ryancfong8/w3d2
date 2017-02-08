require_relative 'connection'
require_relative 'model_base'

class Reply < ModelBase
  def self.find_by_question_id(question_id)
    replies = QuestionDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
    return nil unless replies.length > 0

    replies.map {|reply| Reply.new(reply)}
  end

  def self.find_by_parent_id(parent_id)
    replies = QuestionDBConnection.instance.execute(<<-SQL, parent_id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL
    return nil unless replies.length > 0

    replies.map {|reply| Reply.new(reply) }
  end

  def self.find_by_user_id(user_id)
    replies = QuestionDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    return nil unless replies.length > 0

    replies.map { |reply| Reply.new(reply) }
  end
  # 
  # def self.all
  #   replies = QuestionDBConnection.instance.execute(<<-SQL)
  #     SELECT
  #       *
  #     FROM
  #       replies
  #   SQL
  #   return nil unless replies.length > 0
  #
  #   replies.map { |reply| Reply.new(reply) }
  # end

  attr_accessor :id, :question_id, :parent_id, :user_id, :body

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @body = options['body']
  end

  def save
    unless @id
      QuestionDBConnection.instance.execute(<<-SQL, @question_id, @parent_id, @user_id, @body)
        INSERT INTO
          replies (question_id, parent_id, user_id, body)
        VALUES
          (?, ?, ?, ?)
      SQL
      @id = QuestionDBConnection.instance.last_insert_row_id
    else
      QuestionDBConnection.instance.execute(<<-SQL, @question_id, @parent_id, @user_id, @body, @id)
        UPDATE
          replies
        SET
          question_id = ?, parent_id = ? user_id = ? body = ?
        WHERE
          id = ?
      SQL
    end
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    Reply.find_by_id(@parent_id)
  end

  def child_replies
    Reply.find_by_parent_id(@id)
  end

end
