require_relative 'question'
require_relative 'user'
require_relative 'reply'
require_relative 'question_follow'
require_relative 'question_like'

# Question.find_by_author_id(1).each do |question|
#   puts question.title
# end

# Reply.find_by_user_id(2).each do |reply|
#   puts reply.id
# end

# Reply.find_by_question_id(1).each do |reply|
#   puts reply.id
# end

# puts User.find_by_name('John', 'Smith').id

#User.find_by_id(1).authored_questions.each { |q| puts q.id }


# User.find_by_id(1).authored_replies.each { |q| puts q.id }

# puts Question.find_by_id(1).author.id

# Question.find_by_id(1).replies.each { |reply| puts reply.body }

# puts Reply.find_by_id(1).author.fname

# puts Reply.find_by_id(1).question.body

# puts Reply.find_by_id(2).parent_reply.body

# Reply.find_by_id(1).child_replies.each do |reply|
#   puts reply.id
# end

#MEDIUM

# QuestionFollow.followers_for_question_id(1).each do |user|
#   puts user.fname
# end

# QuestionFollow.followed_questions_for_user_id(4).each do |question|
#   puts question.title
# end

# User.find_by_id(4).followed_questions.each do |question|
#   puts question.title
# end


# Question.find_by_id(3).followers.each do |user|
#   puts user.fname
# end


#HARD!!!!!

# QuestionFollow.most_followed_questions(2).each { |question| puts question.title }

# Question.most_followed(2).each { |question| puts question.title }

# QuestionLike.likers_for_question_id(1).each do |user|
#   puts user.fname
# end

# puts QuestionLike.num_likes_for_question_id(1)

# QuestionLike.liked_questions_for_user_id(4).each { |q| puts q.title}

# Question.find_by_id(1).likers.each { |user| puts user.fname }
#
# puts Question.find_by_id(1).num_likes

# User.find_by_id(4).liked_questions.each { |q| puts q.id }

# QuestionLike.most_liked_questions(3).each { |q| puts q.id }

# Question.most_liked(3).each { |q| puts q.id }

# puts User.find_by_id(1).average_karma

#UPDATE/SAVE

user = User.new({'fname' => 'Sam', 'lname' => 'Smith'})
user.save
puts User.find_by_name('Sam','Smith').fname
# user.save
# puts User.find_by_name('Sam','Smith').fname

# question = Question.new({'title' => 'Help?', 'body' => 'I do not know what I am doing', 'author_id' => 5})
# question.save
# puts Question.find_by_title('Help?').body

# reply = Reply.new({'question_id' => 2, 'parent_id' => 1,'user_id' => 5,'body' => "this thread is dumb"})
# reply.save
# puts Reply.find_by_parent_id(1).each { |rep| puts rep.body }

#BONUS TIME

# puts Reply.find_by_id(1).id

# User.all.each { |user| puts user.fname}
