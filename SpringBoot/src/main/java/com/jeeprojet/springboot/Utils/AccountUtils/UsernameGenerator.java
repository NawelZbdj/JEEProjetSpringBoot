package com.jeeprojet.springboot.Utils.AccountUtils;

import java.util.List;

public class UsernameGenerator {
    public static String generateUsername(String firstName, String lastName) {
        if (firstName == null || lastName == null || firstName.isEmpty() || lastName.isEmpty()) {
            throw new IllegalArgumentException("First name and last name must not be null or empty");
        }
        String firstPart = firstName.substring(0, Math.min(3, firstName.length())).toLowerCase();
        String lastPart = lastName.substring(0, Math.min(3, lastName.length())).toLowerCase();

        // Generate and return the username
        return firstPart + lastPart + (int) (Math.random() * 1000);

    }
}