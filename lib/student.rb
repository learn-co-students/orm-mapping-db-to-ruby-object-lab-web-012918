require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
    SQL
    dbr = DB[:conn].execute(sql)
    dbr.map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * 
      FROM students
      WHERE students.name = (?)
    SQL
    dbr = DB[:conn].execute(sql, name)[0]
    student = Student.new
    student.id, student.name, student.grade = dbr[0], dbr[1], dbr[2]
    student
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = 9
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade < 12
    SQL
    DB[:conn].execute(sql)
  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = 10
      LIMIT (?)
    SQL
    DB[:conn].execute(sql, num)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = 10
      LIMIT 1
    SQL
    dbr = DB[:conn].execute(sql)[0]
    self.new_from_db(dbr)
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = (?)
    SQL
    dbr = DB[:conn].execute(sql, grade)
    dbr.map do |row|
      self.new_from_db(row)
    end

  end


 ######## ALREADY MADE BY CLONE #######

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
