package com.example.ProjectFinalYear.repositories;

import com.example.ProjectFinalYear.model.Attendance;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

import java.util.List;

// public interface AttendanceRepository extends MongoRepository<Attendance, String> {

//     List<Attendance> findByStudentId(String studentId);

//     // ✅ Correct Query for filtering by Year, Month, and Date
//     @Query("{ 'date': ?0 }")
//     List<Attendance> findByDate(String date);
    
// }
public interface AttendanceRepository extends MongoRepository<Attendance, String> {
    
    List<Attendance> findByStudentId(String studentId);

    // @Query("{ 'date': ?0, 'section': ?1 }")
    // List<Attendance> findByDateAndSection(String date, String section);
    @Query("{ 'date': ?0, 'section': ?1 }")
List<Attendance> findByDateAndSection(String date, String section);

}

