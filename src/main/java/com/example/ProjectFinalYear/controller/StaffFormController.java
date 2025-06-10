package com.example.ProjectFinalYear.controller;

import com.example.ProjectFinalYear.model.StaffFormField;
import com.example.ProjectFinalYear.service.StaffFormMetadataService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/staff/forms")
@CrossOrigin(origins = "http://192.168.201.189:53696")
@RequiredArgsConstructor
public class StaffFormController {

    private final StaffFormMetadataService formMetadataService;

    @GetMapping("/attendance")
    @CrossOrigin(origins = "http://192.168.201.189:53696")
    public ResponseEntity<List<StaffFormField>> getAttendanceFormFields() {
        return ResponseEntity.ok(formMetadataService.getAttendanceFormFields());
    }

    @GetMapping("/complaint-response")
    @CrossOrigin(origins = "http://192.168.201.189:53696")
    public ResponseEntity<List<StaffFormField>> getComplaintResponseFormFields() {
        return ResponseEntity.ok(formMetadataService.getComplaintResponseFormFields());
    }

    @GetMapping("/event")
    @CrossOrigin(origins = "http://192.168.201.189:53696")
    public ResponseEntity<List<StaffFormField>> getEventFormFields() {
        return ResponseEntity.ok(formMetadataService.getEventFormFields());
    }
}
