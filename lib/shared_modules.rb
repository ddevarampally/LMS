module Generate_encrypt_password
	
	def generate_password

		password_array =[]
		strpassword = ""

		special_characters = [33..47,58..64,91..96,123..126]
		lowercase_letters = [48..57]
		uppercase_letters = [65..90]
		numerics = [0..9]

		random_sp_char = rand(special_characters[rand(0..special_characters.length-1)]) 
		
		chars_array = [random_sp_char,lowercase_letters[0],uppercase_letters[0],numerics[0]]

		i = 0

		while i < 4 do 
			password_array = add_chars_to_password(password_array, chars_array[i])
			i +=1	
		end		

		password_length = rand(i..16)

		while password_array.length < password_length do
			password_array = add_chars_to_password(password_array,chars_array[rand(0..chars_array.length-1)])
		end	

		if password_array.length > 0 
			for x in 0..password_array.length-1
				strpassword += password_array[x]
			end
		end

		return generate_encrypted_password(strpassword)
	end

	def add_chars_to_password(password,char_value)

		random_char = rand(char_value)

		password.push([random_char].pack('U*'))
		return password
	end

	def generate_encrypted_password(password)

		password = AESCrypt.encrypt(password, AESCRYPT_SECRET_PASSWORD)

		return password
	end	
end