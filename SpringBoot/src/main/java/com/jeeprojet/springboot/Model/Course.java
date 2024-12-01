package com.jeeprojet.springboot.Model;

import jakarta.persistence.*;

@Entity
@Table(name = "course")
public class Course {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "title")
    private String title;

    @Column(name = "description")
    private String description;

    @Column(name = "credit")
    private double credit;

    @Column(name = "speciality")
    private String speciality;

    // Constructeur par défaut
    public Course() {
    }

    // Getters et Setters
    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getDescription() {
        return description;
    }

    public double getCredit() {
        return credit;
    }

    public String getSpeciality() {
        return speciality;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setCredit(double credit) {
        this.credit = credit;
    }

    public void setSpeciality(String speciality) {
        this.speciality = speciality;
    }
}
