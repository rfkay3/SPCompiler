// No headers required

bool isReal(char value[]){
	for(int i = 0; value[i] != '\0'; i++) {
		if(value[i] == '.'){
			return true;
		}
	}
	return false;
}