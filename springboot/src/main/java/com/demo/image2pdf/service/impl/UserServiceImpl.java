package com.demo.image2pdf.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.demo.image2pdf.entity.User;
import com.demo.image2pdf.repository.UserRepository;
import com.demo.image2pdf.service.UserService;

@Service
public class UserServiceImpl implements UserService {

	@Autowired
	private UserRepository repository;

	@Override
	public User findUserById(Integer userId) {
		return repository.findByUserId(userId);
	}

	@Override
	public User save(User user) {
		return repository.save(user);
	}
	
	@Override
	public void deleteById(Integer userId) {
		repository.deleteById(userId);
	}

}
