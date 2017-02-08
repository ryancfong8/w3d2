require_relative 'connection'
require 'byebug'
require 'active_support/inflector'

class ModelBase

  def self.find_by_id(id)
    str = (self.to_s.pluralize).downcase
    debugger
    item_arr = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{str}
      WHERE
        id = ?
    SQL
    return nil unless item_arr.length > 0

    self.new(item_arr.first)
  end

  def self.all

    items = QuestionDBConnection.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.to_s.pluralize}
    SQL
    return nil unless items.length > 0

    items.map { |item| self.new(item) }
  end

  def save
    vars = self.instance_variables.reverse
    vars.pop
    real_vars = vars.map { |var| self.instance_variable_get(var) }
    question_marks = (["?"] * (real_vars.count+1)).join(", ")
    debugger

    unless @id
      QuestionDBConnection.instance.execute(<<-SQL, *vars)
        INSERT INTO
          #{self.to_s.pluralize} (#{vars.join(", ")})
        VALUES
          (#{question_marks})
      SQL
      @id = QuestionDBConnection.instance.last_insert_row_id
    else
      QuestionDBConnection.instance.execute(<<-SQL, @fname, @lname, @id)
        UPDATE
          users
        SET
          fname = ?, lname = ?
        WHERE
          id = ?
      SQL
    end
  end



end
