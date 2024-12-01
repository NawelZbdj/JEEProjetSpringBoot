package com.jeeprojet.springboot.Repository;
import java.util.Date;

public interface IUser {

    // Getters
    int getId();
    String getLastName();
    String getFirstName();
    Date getBirthDate();
    String getEmail();

    // Setters
    void setId(int id);
    void setLastName(String lastName);
    void setFirstName(String firstName);
    void setBirthDate(Date birthDate);
    void setEmail(String email);
}


