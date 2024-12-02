package com.jeeprojet.springboot.Controller;


import com.jeeprojet.springboot.Model.*;
import com.jeeprojet.springboot.Repository.AccountRepository;
import com.jeeprojet.springboot.Repository.CourseRepository;
import com.jeeprojet.springboot.Repository.StudentRepository;
import com.jeeprojet.springboot.Utils.AccountUtils.PasswordGenerator;
import com.jeeprojet.springboot.Utils.AccountUtils.UsernameGenerator;
import com.jeeprojet.springboot.Utils.EmailUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/student")
public class StudentController {

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private CourseRepository courseRepository;


    @GetMapping("/list")
    public String listStudents(Model model) {
        List<Student> students = studentRepository.findAll();
        model.addAttribute("students", students);
        return "admin/StudentsManagement";
    }

    @GetMapping("/add")
    public String showAddForm() {
        return "admin/AddStudent";
    }

    @PostMapping("/add")
    public String addStudent(@RequestParam String firstName,
                             @RequestParam String lastName,
                             @RequestParam String email,
                             @RequestParam String birthDate,
                             RedirectAttributes redirectAttributes) {
            String username = UsernameGenerator.generateUsername(firstName, lastName);
            String password = PasswordGenerator.generateRandomPassword();

            Account account = new Account();
            account.setUsername(username);
            account.setPassword(password);
            account.setRole("student");

            accountRepository.save(account);

            Student student = new Student();
            student.setFirstName(firstName);
            student.setLastName(lastName);
            student.setEmail(email);
            student.setAccount(account);

            try {
                Date parsedBirthDate = new SimpleDateFormat("yyyy-MM-dd").parse(birthDate);
                student.setBirthDate(parsedBirthDate);

            } catch (ParseException e) {
                return "redirect:/student/list";
            }

            studentRepository.save(student);

            String subject = "sColartiY: Account Created!";
            String body = String.format(
                    "Welcome %s,\n\nYour account has been created.\n\nUsername: %s\nPassword: %s\n\nBest Regards,\nAdmin Staff",
                    firstName, username, password);
            try {
                EmailUtil.sendEmail(student.getEmail(), subject, body);
            } catch (Exception e) {
                e.printStackTrace();
            }


        return "redirect:/student/list";
    }

    @GetMapping("/update/{studentId}")
    public String showUpdateForm(@PathVariable int studentId, Model model) {
        Student student = studentRepository.findById(studentId).orElseThrow();
        model.addAttribute("student", student);
        return "admin/UpdateStudent";
    }

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
        return "redirect:/student/list";
    }

    @GetMapping("/delete/{studentId}")
    public String deleteStudent(@PathVariable int studentId, RedirectAttributes redirectAttributes) {
        studentRepository.deleteById(studentId);
        return "redirect:/student/list";
    }

    @GetMapping("/search")
    public String searchStudents(@RequestParam String keyword, Model model) {
        List<Student> students = studentRepository.searchByKeyword(keyword);
        model.addAttribute("students", students);
        return "admin/StudentsManagement";
    }

    @PostMapping("/listByCourses")
    public String listStudentsByCourse(@RequestParam int courseId,
                                       @RequestParam int professorId,
                                       Model model) {
        List<Student> students = studentRepository.findByCourseIdAndProfessorId(courseId, professorId);
        Course course = courseRepository.findById(courseId).orElseThrow();

        model.addAttribute("students", students);
        model.addAttribute("course", course);
        return "professor/ProfessorCourseStudents";
    }

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        dateFormat.setLenient(false);
        binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
    }
}