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
      SELECT * FROM students;
    SQL
    DB[:conn].execute(sql).map {|row| self.new_from_db(row)}
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?;
    SQL
    new_from_db(DB[:conn].execute(sql, name)[0])
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT COUNT(students.name) FROM students WHERE grade = ?;
    SQL

    DB[:conn].execute(sql, 9)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < ?;
    SQL

    DB[:conn].execute(sql, 12)
  end

  def self.first_X_students_in_grade_10(num)

    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10;
    SQL

    DB[:conn].execute(sql).first(num)

  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ? LIMIT 1;
    SQL
    student_id = DB[:conn].execute(sql, 10)[0][0]

    sql = <<-SQL
      SELECT * FROM students WHERE id = ?;
    SQL
    self.new_from_db(DB[:conn].execute(sql, student_id)[0])
  end

  def self.count_all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT COUNT(students.name) FROM students WHERE grade = ?;
    SQL

    DB[:conn].execute(sql, grade)

  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?;
    SQL

    DB[:conn].execute(sql, grade)
  end

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
