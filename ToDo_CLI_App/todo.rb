require "active_record"
require "./connect_db.rb"

class Todo < ActiveRecord::Base
  def due_today?
    due_date == Date.today
  end

  def self.due_today
    where(due_date: Date.today)
  end

  def self.due_later
    where("due_date > ?", Date.today)
  end

  def self.overdue
    where("due_date < ?", Date.today)
  end
  
  def to_displayable_string
    todo_status = completed ? "[X]" : "[ ]"
    todo_date = due_today? ? nil : due_date
    "#{id}. #{todo_status} #{todo_text} #{todo_date}"
  end

  def self.show_list
    puts "My Todo-list\n\n"

    puts "Overdue\n"
    puts overdue.map { |todo| todo.to_displayable_string }
    puts "\n\n"

    puts "Due Today\n"
    puts due_today.map { |todo| todo.to_displayable_string }
    puts "\n\n"

    puts "Due Later\n"
    puts due_later.map { |todo| todo.to_displayable_string }
    puts "\n\n"
  end

  def self.add_task(todo)
    todo_text = todo[:todo_text]
    due_date = Date.today + todo[:due_in_days]
    create!(todo_text: todo_text, due_date: due_date, completed: false)
  end

  def self.mark_as_complete(todo_id)
    todo_completion_done = find(todo_id)
    todo_completion_done.completed = true
    todo_completion_done.save
    return todo_completion_done
  end
end