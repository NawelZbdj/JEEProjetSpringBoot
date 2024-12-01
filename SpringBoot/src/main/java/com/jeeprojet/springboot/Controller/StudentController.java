package com.jeeprojet.springboot.Controller;


import com.jeeprojet.springboot.Model.*;
import com.jeeprojet.springboot.Repository.AccountRepository;
import com.jeeprojet.springboot.Repository.CourseRepository;
import com.jeeprojet.springboot.Repository.StudentRepository;
import com.jeeprojet.springboot.Utils.AccountUtils.PasswordGenerator;
import com.jeeprojet.springboot.Utils.AccountUtils.UsernameGenerator;
import com.jeeprojet.springboot.Utils.EmailUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/students")
public class StudentController {

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private EmailUtil emailUtil;

    // Afficher la liste des étudiants
    @GetMapping("/list")
    public String listStudents(Model model) {
        List<Student> students = studentRepository.findAll();
        model.addAttribute("students", students);
        return "admin/StudentsManagement"; // Renvoie vers le JSP correspondant
    }

    // Afficher le formulaire d'ajout
    @GetMapping("/add")
    public String showAddForm() {
        return "admin/AddStudent";
    }

    // Ajouter un étudiant
    @PostMapping("/add")
    public String addStudent(@RequestParam String firstName,
                             @RequestParam String lastName,
                             @RequestParam String email,
                             @RequestParam String birthDate,
                             RedirectAttributes redirectAttributes) {
        try {
            Date parsedBirthDate = new SimpleDateFormat("yyyy-MM-dd").parse(birthDate);

            // Générer un compte pour l'étudiant
            String username = UsernameGenerator.generateUsername(firstName, lastName);
            String password = PasswordGenerator.generateRandomPassword();

            Account account = new Account();
            account.setUsername(username);
            account.setPassword(password);
            account.setRole("student");

            accountRepository.save(account);

            // Associer l'étudiant au compte
            Student student = new Student();
            student.setFirstName(firstName);
            student.setLastName(lastName);
            student.setEmail(email);
            student.setBirthDate(parsedBirthDate);
            student.setAccount(account);

            studentRepository.save(student);

            // Envoyer un email avec les détails du compte
            String subject = "sColartiY: Account Created!";
            String body = String.format(
                    "Welcome %s,\n\nYour account has been created.\n\nUsername: %s\nPassword: %s\n\nBest Regards,\nAdmin Staff",
                    firstName, username, password);
            emailUtil.sendEmail(email, subject, body);

            redirectAttributes.addFlashAttribute("successMessage", "Student added successfully!");
        } catch (ParseException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid birth date format.");
        }
        return "redirect:/students/list";
    }

    // Afficher le formulaire de mise à jour
    @GetMapping("/update")
    public String showUpdateForm(@RequestParam Integer id, Model model) {
        Student student = studentRepository.findById(id).orElseThrow();
        model.addAttribute("student", student);
        return "admin/UpdateStudent"; // Supposons que vous ayez une vue JSP pour ce formulaire
    }

    // Mettre à jour un étudiant
    @PostMapping("/update")
    public String updateStudent(@RequestParam Integer id,
                                @RequestParam String firstName,
                                @RequestParam String lastName,
                                @RequestParam String email,
                                @RequestParam String birthDate,
                                RedirectAttributes redirectAttributes) {
        try {
            Date parsedBirthDate = new SimpleDateFormat("yyyy-MM-dd").parse(birthDate);

            Student student = studentRepository.findById(id).orElseThrow();
            student.setFirstName(firstName);
            student.setLastName(lastName);
            student.setEmail(email);
            student.setBirthDate(parsedBirthDate);

            studentRepository.save(student);

            redirectAttributes.addFlashAttribute("successMessage", "Student updated successfully!");
        } catch (ParseException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid birth date format.");
        }
        return "redirect:/students/list";
    }

    // Supprimer un étudiant
    @GetMapping("/delete")
    public String deleteStudent(@RequestParam Integer id, RedirectAttributes redirectAttributes) {
        studentRepository.deleteById(id);
        redirectAttributes.addFlashAttribute("successMessage", "Student deleted successfully!");
        return "redirect:/students/list";
    }

    // Rechercher des étudiants
    @GetMapping("/search")
    public String searchStudents(@RequestParam String keyword, Model model) {
        List<Student> students = studentRepository.searchByKeyword(keyword);
        model.addAttribute("students", students);
        return "admin/StudentsManagement";
    }

    // Lister les étudiants d'un cours spécifique
    @GetMapping("/listByCourse")
    public String listStudentsByCourse(@RequestParam Integer courseId,
                                       @SessionAttribute("user") Professor professor,
                                       Model model) {
        List<Student> students = studentRepository.findByCourseIdAndProfessorId(courseId, professor.getId());
        Course course = courseRepository.findById(courseId).orElseThrow();

        model.addAttribute("students", students);
        model.addAttribute("course", course);
        return "professor/ProfessorCourseStudents";
    }
}