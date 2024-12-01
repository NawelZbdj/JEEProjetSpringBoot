package com.jeeprojet.springboot.Controller;

import com.jeeprojet.springboot.Model.Course;
import com.jeeprojet.springboot.Model.Professor;
import com.jeeprojet.springboot.Model.Registration;
import com.jeeprojet.springboot.Model.Student;
import com.jeeprojet.springboot.Repository.CourseRepository;
import com.jeeprojet.springboot.Repository.ProfessorRepository;
import com.jeeprojet.springboot.Repository.RegistrationRepository;
import com.jeeprojet.springboot.Repository.StudentRepository;
import com.jeeprojet.springboot.Utils.EmailUtil;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/registration")
public class RegistrationController {

    @Autowired
    private RegistrationRepository registrationRepository;

    @Autowired
    private ProfessorRepository professorRepository;

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private StudentRepository studentRepository;

    @GetMapping("/list")
    public String listRegistrations(Model model, @RequestParam("destination") String destination) {
        List<Registration> registrations = registrationRepository.findAll();
        model.addAttribute("registrations", registrations);
        return destination != null ? "forward:" + destination : "admin/RegistrationManagement";
    }

    @GetMapping("/listall")
    public String listRegistrationsAndProfessors(Model model, @RequestParam("destination") String destination) {
        List<Registration> registrations = registrationRepository.findAll();
        List<Professor> professors = professorRepository.findAll();
        model.addAttribute("registrations", registrations);
        model.addAttribute("professors", professors);
        return "forward:" + destination;
    }

    @GetMapping("/listByStudent")
    public String listRegistrationsByStudent(HttpSession session, Model model, @RequestParam("destination") String destination) {
        Student student = (Student) session.getAttribute("user");
        List<Registration> registrations = registrationRepository.findByStudentId(student.getId());
        model.addAttribute("registrations", registrations);
        return "forward:" + destination;
    }

    @PostMapping("/add")
    public String addRegistration(HttpServletRequest request, HttpSession session) {
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        Student student = (Student) session.getAttribute("user");
        Course course = courseRepository.findById(courseId).orElse(null);
        student = studentRepository.findById(student.getId()).orElse(null);

        if (course != null && student != null) {
            Registration registration = new Registration();
            registration.setCourse(course);
            registration.setStudent(student);
            registration.setRegistrationDate(new Date());
            registrationRepository.save(registration);
            return "redirect:/registration/listByStudent?destination=/views/student/RegistrationManagement.jsp";
        }
        return "error";
    }

    @PostMapping("/update")
    public String updateRegistration(@RequestParam int registrationId, @RequestParam int professorId, @RequestParam String destination) {
        Registration registration = registrationRepository.findById(registrationId).orElse(null);
        Professor professor = professorRepository.findById(professorId).orElse(null);

        if (registration != null && professor != null) {
            registration.setProfessor(professor);
            registrationRepository.save(registration);

            String subject = "Registration Update: " + registration.getCourse().getTitle();
            String body = "Hello " + registration.getStudent().getFirstName() + ",\n\n" +
                    "Your registration has been updated. Your professor is now " + professor.getFirstName() + " " + professor.getLastName() + ".\n\nBest Regards, Admin";
            EmailUtil.sendEmail(registration.getStudent().getEmail(), subject, body);
        }
        return "redirect:/registration/listall?destination=" + destination;
    }

    @PostMapping("/multiupdate")
    public String updateManyRegistrations(@RequestParam("idProfessor") int professorId, @RequestParam("registrationsList") List<Integer> registrationIds) {
        Professor professor = professorRepository.findById(professorId).orElse(null);

        if (professor != null) {
            for (Integer registrationId : registrationIds) {
                Registration registration = registrationRepository.findById(registrationId).orElse(null);
                if (registration != null) {
                    registration.setProfessor(professor);
                    registrationRepository.save(registration);

                    String subject = "Registration Update: " + registration.getCourse().getTitle();
                    String body = "Hello " + registration.getStudent().getFirstName() + ",\n\n" +
                            "Your registration has been updated. Your professor is now " + professor.getFirstName() + " " + professor.getLastName() + ".\n\nBest Regards, Admin";
                    EmailUtil.sendEmail(registration.getStudent().getEmail(), subject, body);
                }
            }
        }
        return "redirect:/registration/listall?destination=/views/admin/CourseAssignment.jsp";
    }

    @GetMapping("/delete/{id}")
    public String deleteRegistration(@PathVariable int id) {
        registrationRepository.deleteById(id);
        return "redirect:/registration/listByStudent?destination=/views/student/RegistrationManagement.jsp";
    }

    @GetMapping("/listByProfessor")
    public String listRegistrationsByProfessor(HttpSession session, Model model, @RequestParam("destination") String destination) {
        Professor professor = (Professor) session.getAttribute("user");
        List<Registration> registrations = registrationRepository.findByProfessorId(professor.getId());
        model.addAttribute("registrations", registrations);
        return "forward:" + destination;
    }
}
