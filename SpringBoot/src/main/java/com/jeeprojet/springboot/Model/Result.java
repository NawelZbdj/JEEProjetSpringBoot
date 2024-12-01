package com.jeeprojet.springboot.Model;

import jakarta.persistence.*;

@Entity
@Table(name = "result")
public class Result {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "grade", nullable = false)
    private double grade;

    @Column(name = "coefficient", nullable = false)
    private double coefficient;

    @ManyToOne
    @JoinColumn(name = "registration_id", nullable = false)
    private Registration registration;

    // Constructeur par défaut
    public Result() {
    }

    // Getters et Setters
    public int getId() {
        return id;
    }

    public double getGrade() {
        return grade;
    }

    public double getCoefficient() {
        return coefficient;
    }

    public Registration getRegistration() {
        return registration;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setGrade(double grade) {
        this.grade = grade;
    }

    public void setCoefficient(double coefficient) {
        this.coefficient = coefficient;
    }

    public void setRegistration(Registration registration) {
        this.registration = registration;
    }
}
