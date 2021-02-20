#include <pthread.h>
#include <iostream>
#include <sys/stat.h>
#include <sys/types.h>
#include <vector>
#include <filesystem>
#include <fstream>
#include <thread>

//compile command: g++ LogGoblin.cpp -o LogGoblin -std=c++17 -pthread

struct stat info;

void grepFile(std::string path) {
	std::fstream file;
	file.open(path, std::fstream::in);
	if(file.fail()) {
		std::cout << "[ERROR] Looks like we don't have permissions to read " + path + " boss :-(\n";
		return;
	}
	std::string temp;
	while(getline(file, temp)) {
		if (temp.find("comm=\"su\"") != std::string::npos){
			std::cout << "[PWN] " << path << " " << temp << "\n";
		}
	}
}

int main() {
	std::vector<std::thread*> threadmanager;
	std::cout << "Less Shitty Audit Log SU Password Leak Finder WOOOOO V 2.0\n";
	if (stat("/var/log/audit", &info) != 0) {
		std::cout << "[ERROR] cannot access /var/log/audit, Looks like we don't have permissions to get their boss :-(\n";
		return -1;
	} else if (info.st_mode & S_IFDIR) {
		std::cout << "[PASSED] access has been obtained, boss!\n";
	} else {
		std::cout << "[ERROR] No audit directory found LOL RIP\n";
		return -1;
	}
	for (const auto & log : std::filesystem::directory_iterator("/var/log/audit")) {
		std::thread *file = new std::thread(grepFile, log.path());
		threadmanager.push_back(file);
	}
	for (unsigned int i = 0; i < threadmanager.size(); ++i) {
		threadmanager[i]->join();
	}
	std::cout << "[INFO] All files have been searched. Script complete. Happy hunting :)\n";
}
