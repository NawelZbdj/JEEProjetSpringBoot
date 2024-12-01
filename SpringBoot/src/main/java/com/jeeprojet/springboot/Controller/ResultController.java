package com.jeeprojet.springboot.Controller;


import com.jeeprojet.springboot.Model.*;
import com.jeeprojet.springboot.Repository.CourseRepository;
import com.jeeprojet.springboot.Repository.*;
import com.jeeprojet.springboot.Utils.EmailUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/api/results")
public class ResultController {

    @Autowired
    private ResultRepository resultRepository;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private RegistrationRepository registrationRepository;

    @Autowired
    private EmailUtil emailUtil;

    // Récupérer les résultats d'un étudiant par son ID
    @GetMapping("/student/{studentId}")
    public List<Result> getResultsByStudentId(@PathVariable Long studentId) {
        return resultRepository.findByStudentId(studentId);
    }

    // Afficher les notes d'un étudiant pour un cours donné
    @GetMapping("/viewGrades")
    public List<Result> viewGrades(@RequestParam Integer studentId, @RequestParam Integer courseId) {
        Student student = studentRepository.findById(studentId).orElseThrow();
        Course course = courseRepository.findById(courseId).orElseThrow();

        // Vous pouvez inclure des informations supplémentaires dans la réponse
        return resultRepository.findByStudentAndCourse(student, course);
    }

    // Ajouter une nouvelle note
    @PostMapping("/addGrade")
    public Result addGrade(@RequestParam Integer studentId, @RequestParam Integer courseId) {
        Student student = studentRepository.findById(studentId).orElseThrow();
        Course course = courseRepository.findById(courseId).orElseThrow();

        // Valeurs par défaut
        double grade = 0.0;
        double coefficient = 1.0;

        Registration registration = registrationRepository.findByStudentAndCourse(studentId, courseId);

        Result result = new Result();
        result.setGrade(grade);
        result.setCoefficient(coefficient);
        result.setRegistration(registration);

        resultRepository.save(result);

        // Envoi de l'email
        String subject = "New Grade in " + course.getTitle();
        String body = String.format("Hello %s,\n\nA new grade has been registered in %s.\nGrade: %.2f\nCoefficient: %.2f\n\nBest Regards,\nAdmin",
                student.getFirstName(), course.getTitle(), result.getGrade(), result.getCoefficient());
        emailUtil.sendEmail(student.getEmail(), subject, body);

        return result;
    }

    // Sauvegarder ou mettre à jour les notes
    @PostMapping("/saveGrades")
    public List<Result> saveGrades(@RequestParam Integer studentId, @RequestParam Integer courseId,
                                   @RequestParam List<Double> grades, @RequestParam List<Double> coefficients,
                                   @RequestParam List<Integer> resultIds) {
        if (grades.size() != coefficients.size() || grades.size() != resultIds.size()) {
            throw new IllegalArgumentException("Mismatch between number of grades, coefficients, and result IDs");
        }

        for (int i = 0; i < grades.size(); i++) {
            double grade = grades.get(i);
            double coefficient = coefficients.get(i);
            Integer resultId = resultIds.get(i);

            Registration registration = registrationRepository.findByStudentAndCourse(studentId, courseId);

            if (registration != null) {
                Result result = resultRepository.findById(resultId).orElseThrow();
                result.setGrade(grade);
                result.setCoefficient(coefficient);
                result.setRegistration(registration);
                resultRepository.save(result);
            }
        }

        // Retourne les résultats actualisés
        return resultRepository.findByStudentIdAndCourseId(studentId, courseId);
    }
}
