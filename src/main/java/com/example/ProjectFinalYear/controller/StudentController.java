package com.example.ProjectFinalYear.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.ProjectFinalYear.model.Attendance;
import com.example.ProjectFinalYear.model.Complaint;
import com.example.ProjectFinalYear.model.Event;
import com.example.ProjectFinalYear.service.StudentService;

@RestController
@RequestMapping("/api/student")
@PreAuthorize("hasAuthority('STUDENT')")
public class StudentController {

    @Autowired
    private StudentService studentService;

    @GetMapping("/attendance/{studentId}")
    public ResponseEntity<List<Attendance>> getAttendance(@PathVariable String studentId) {
        return ResponseEntity.ok(studentService.getAttendanceByStudentId(studentId));
    }

    @PostMapping("/complaints")
    public ResponseEntity<Complaint> submitComplaint(@RequestBody Complaint complaint) {
        return ResponseEntity.ok(studentService.submitComplaint(complaint));
    }
@GetMapping("/complaints/responses/{studentId}")
public ResponseEntity<List<Complaint>> getComplaintResponses(@PathVariable String studentId) {
    List<Complaint> complaintsWithResponses = studentService.getComplaintResponsesByStudentId(studentId);
    return ResponseEntity.ok(complaintsWithResponses);
}

    @GetMapping("/events")
    public ResponseEntity<List<Event>> getEvents() {
        return ResponseEntity.ok(studentService.getAllEvents());
    }
}

