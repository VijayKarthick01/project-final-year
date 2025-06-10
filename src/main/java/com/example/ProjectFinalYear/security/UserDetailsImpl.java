package com.example.ProjectFinalYear.security;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import java.util.Collection;
import java.util.List;

public class UserDetailsImpl implements UserDetails {
    private String id;
    private String email;
    private String password;
    private Collection<? extends GrantedAuthority> authorities;
    private final boolean isActive;
  
    public UserDetailsImpl(String id, String email, String password, String role,boolean isActive) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.authorities = List.of(new SimpleGrantedAuthority(role)); // Use role as it is
        this.isActive = isActive;
    }
    
    

    public String getId() {
        return id;
    }

    public String getEmail() {
        return email;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

   
    @Override
    public boolean isEnabled() {
    return isActive;
}
}
