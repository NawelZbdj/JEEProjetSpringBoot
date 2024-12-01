package com.jeeprojet.springboot.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home() {
        return "menu";
    }

    @GetMapping("/student/login")
    public String studentLogin() {
        return "student/logStudent";
    }

    @GetMapping("/professor/login")
    public String professorLogin() {
        return "professor/logProfessor";
    }

    @GetMapping("/admin/login")
    public String adminLogin() {
        return "admin/logAdmin";
    }
}
