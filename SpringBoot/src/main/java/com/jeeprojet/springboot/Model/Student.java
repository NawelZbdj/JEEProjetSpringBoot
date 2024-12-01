package com.jeeprojet.springboot.Model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "student")
public class Student implements IUser {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "last_name", length = 100)
    private String lastName;

    @Column(name = "first_name", length = 100)
    private String firstName;

    @Column(name = "birth_date")
    private Date birthDate;

    @Column(name = "email", length = 100)
    private String email;

    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "account_id")
    private Account account;

    // Constructeur par défaut
    public Student() {
    }

    // Getters et Setters
    @Override
    public int getId() {
        return id;
    }

    @Override
    public String getLastName() {
        return lastName;
    }

    @Override
    public String getFirstName() {
        return firstName;
    }

    @Override
    public Date getBirthDate() {
        return birthDate;
    }

    @Override
    public String getEmail() {
        return email;
    }

    public Account getAccount() {
        return account;
    }

    @Override
    public void setId(int id) {
        this.id = id;
    }

    @Override
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    @Override
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    @Override
    public void setBirthDate(Date birthDate) {
        this.birthDate = birthDate;
    }

    @Override
    public void setEmail(String email) {
        this.email = email;
    }

    public void setAccount(Account account) {
        this.account = account;
    }
}
