package com.example.ProjectFinalYear.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.ProjectFinalYear.model.Attendance;
import com.example.ProjectFinalYear.model.Complaint;
import com.example.ProjectFinalYear.model.Event;
import com.example.ProjectFinalYear.repositories.AttendanceRepository;
import com.example.ProjectFinalYear.repositories.ComplaintRepository;
import com.example.ProjectFinalYear.repositories.EventRepository;

@Service
public class StudentService {

    @Autowired
    private AttendanceRepository attendanceRepository;

    @Autowired
    private ComplaintRepository complaintRepository;

    @Autowired
    private EventRepository eventRepository;

    public List<Attendance> getAttendanceByStudentId(String studentId) {
        return attendanceRepository.findByStudentId(studentId);
    }

    public Complaint submitComplaint(Complaint complaint) {
        complaint.setStatus("Pending");
        complaint.setSubmittedAt(LocalDateTime.now());
        return complaintRepository.save(complaint);
    }
public List<Complaint> getComplaintResponsesByStudentId(String studentId) {
    // Assuming your Complaint entity has a studentId field
    return complaintRepository.findByStudentId(studentId);
}

    public List<Event> getAllEvents() {
        return eventRepository.findAll();
    }
}

