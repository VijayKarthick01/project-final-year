package com.example.ProjectFinalYear.repositories;

import com.example.ProjectFinalYear.model.Event;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface EventRepository extends MongoRepository<Event, String> {
}
