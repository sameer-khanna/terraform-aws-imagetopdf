package com.demo.image2pdf.service;

import com.demo.image2pdf.entity.User;

public interface UserService {

	User findUserById(Integer userId);
	
	User save(User user);

	void deleteById(Integer userId);
}
