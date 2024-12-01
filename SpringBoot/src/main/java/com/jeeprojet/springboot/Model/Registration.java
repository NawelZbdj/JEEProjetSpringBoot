package com.jeeprojet.springboot.Model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "registration")
public class Registration {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "registration_date")
    private Date registrationDate;

    @ManyToOne
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    @ManyToOne
    @JoinColumn(name = "course_id", nullable = false)
    private Course course;

    @ManyToOne
    @JoinColumn(name = "professor_id")
    private Professor professor;

    // Constructeur par défaut
    public Registration() {
    }

    // Getters et Setters
    public int getId() {
        return id;
    }

    public Date getRegistrationDate() {
        return registrationDate;
    }

    public Student getStudent() {
        return student;
    }

    public Course getCourse() {
        return course;
    }

    public Professor getProfessor() {
        return professor;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setRegistrationDate(Date registrationDate) {
        this.registrationDate = registrationDate;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    public void setCourse(Course course) {
        this.course = course;
    }

    public void setProfessor(Professor professor) {
        this.professor = professor;
    }
}
