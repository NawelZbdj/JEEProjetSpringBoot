package com.jeeprojet.springboot.Controller;


import com.jeeprojet.springboot.Model.*;
import com.jeeprojet.springboot.Repository.CourseRepository;
import com.jeeprojet.springboot.Repository.*;
import com.jeeprojet.springboot.Utils.EmailUtil;
import jakarta.servlet.ServletException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/result")
public class ResultController {

    @Autowired
    private ResultRepository resultRepository;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private RegistrationRepository registrationRepository;


    @GetMapping("/student/{studentId}")
    public String getResultsByStudentId(Model model, @PathVariable int studentId) {
        List<Result> results = resultRepository.findByStudentId(studentId);
        model.addAttribute("results", results);
        return "student/GradesDisplay";
    }

    @PostMapping("/viewGrades")
    public String viewGrades(@RequestParam int studentId, @RequestParam int courseId,Model model) {
        Student student = studentRepository.findById(studentId).orElseThrow();
        Course course = courseRepository.findById(courseId).orElseThrow();
        List<Result> resultsList = resultRepository.findByStudentIdAndCourseId(studentId, courseId);
        model.addAttribute("results", resultsList);
        model.addAttribute("student", student);
        model.addAttribute("course", course);

        return "professor/ProfessorStudentGrades";
    }
    @GetMapping("/viewGradesGet/{studentId}/{courseId}")
    public String viewGradesGet(@PathVariable int studentId, @PathVariable int courseId,Model model) {
        Student student = studentRepository.findById(studentId).orElseThrow();
        Course course = courseRepository.findById(courseId).orElseThrow();
        List<Result> resultsList = resultRepository.findByStudentIdAndCourseId(studentId, courseId);
        model.addAttribute("results", resultsList);
        model.addAttribute("student", student);
        model.addAttribute("course", course);

        return "professor/ProfessorStudentGrades";
    }

    @PostMapping("/addGrade")
    public String addGrade(@RequestParam int studentId, @RequestParam int courseId,Model model) {
        Student student = studentRepository.findById(studentId).orElseThrow();
        Course course = courseRepository.findById(courseId).orElseThrow();

        double grade = 0.0;
        double coefficient = 1.0;

        Registration registration = registrationRepository.findByStudentAndCourse(studentId, courseId);

        Result result = new Result();
        result.setGrade(grade);
        result.setCoefficient(coefficient);
        result.setRegistration(registration);

        resultRepository.save(result);

        model.addAttribute("result",result);

        return "redirect:/result/viewGradesGet/" + studentId + "/" + courseId;
    }

    @PostMapping("/saveGrades")
    public String saveGrades(@RequestParam int studentId, @RequestParam int courseId,
                                   @RequestParam List<Double> grades, @RequestParam List<Double> coefficients,
                                   @RequestParam List<Integer> resultIds, Model model) {
        if (grades.size() != coefficients.size() || grades.size() != resultIds.size()) {
            throw new IllegalArgumentException("Mismatch between number of grades, coefficients, and result IDs");
        }

        for (int i = 0; i < grades.size(); i++) {
            double grade = grades.get(i);
            double coefficient = coefficients.get(i);
            int resultId = resultIds.get(i);

            Registration registration = registrationRepository.findByStudentAndCourse(studentId, courseId);

            if (registration != null) {
                Result result = resultRepository.findById(resultId).orElseThrow();
                result.setGrade(grade);
                result.setCoefficient(coefficient);
                result.setRegistration(registration);
                resultRepository.save(result);
            }
        }

        resultRepository.findByStudentIdAndCourseId(studentId, courseId);


        if (grades != null && coefficients != null && grades.size() == coefficients.size()) {

            for (int i = 0; i < grades.size(); i++) {

                double grade = grades.get(i);
                double coefficient = coefficients.get(i);
                int resultId = resultIds.get(i);

                Registration registration = registrationRepository.findByStudentAndCourse(studentId, courseId);

                if (registration != null) {

                    Result result = new Result();
                    result.setId(resultId);
                    result.setGrade(grade);
                    result.setCoefficient(coefficient);
                    result.setRegistration(registration);


                    resultRepository.save(result);
                }

            }
        } else {

            throw new IllegalArgumentException("parameters issue");
        }

        Student student = studentRepository.findById(studentId).orElseThrow();
        Course course = courseRepository.findById(courseId).orElseThrow();
        List<Result> results = resultRepository.findByStudentIdAndCourseId(studentId, courseId);




        model.addAttribute("student", student);
        model.addAttribute("course", course);
        model.addAttribute("results", results);

        return "professor/ProfessorStudentGrades";
    }

}
