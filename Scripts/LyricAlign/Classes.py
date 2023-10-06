import pandas as pd
import re
import os
import csv

class Create_Silbe:
	def __init__(self, silbe_list, stress_list):
		self.cell = self.mult_factor = self.measure = self.t_ind = 0
		self.silbe_list = silbe_list
		self.stress = stress_list
		self.tb_map = {'*tb1':1,'*tb2':2,'*tb4':4,'*tb8':8,'*tb16':16}
		


	"""
	process_the_list: This function parses the three arrays: timestamp, stress and words and 
	"""
	def process_the_list(self, timestamp, stress, words):
		while ((self.cell < len(self.silbe_list) and (self.t_ind < len(timestamp)))):
			# print(self.cell, len(self.silbe_list), self.t_ind, len(timestamp), timestamp[self.t_ind])
			if self.is_measure(self.cell):
				# print("is_measure if")
				self.measure = int(self.silbe_list[self.cell][1:])
				self.cell+=1
			elif self.is_tb(self.cell):
				# print("is_tb if")
				self.mult_factor = int(self.tb_map[self.silbe_list[self.cell]])
				self.cell+=1
			elif self.is_lyric(self.cell):
				# print("is_lyric if: ", self.cell, " is a lyric cell")
				self.enter_lyrics(timestamp, words, stress)
				# print("Back from lyric cell")
			else:
				self.cell+=1

	"""
	is_measure: Function to check if the cell is a measure cell ie. if it starts with = followed by a digit.
	"""
	def is_measure(self, index):
		# print("is measure?")
		if(self.silbe_list[index] is not None and self.silbe_list[index][0]=='=' and self.silbe_list[index][1:].isdigit()):
			return 1
		else:
			return 0

	"""
	is_tb: Function to check if the current cell follows the format *tbx where x can be cell ie. 1, 2, 4, 8, 16.
	"""
	def is_tb(self, index):
		if(self.silbe_list[index] in self.tb_map):
			return 1
		return 0

	"""
	is_lyric: Function to check if this is a lyric cell.
	"""
	def is_lyric(self, index):
		if(self.silbe_list[index]=="."):
			return 1
		return 0
	"""
	cell_allowed_time: Function to calculate the number of cells required below the *tbx cell based on the measure value.
	"""
	def cell_allowed_time(self, ct):
		arr = [0,0]
		arr[0] = (1/self.mult_factor)*(self.mult_factor-ct) + self.measure
		arr[1] = (1/self.mult_factor)*(self.mult_factor-ct+1) +  self.measure
		return arr

	"""
	enter_lyrics: Function to enter lyrics.
	"""
	def enter_lyrics(self, timestamp, words, stress):
		counter = self.mult_factor
		
		while counter and (self.t_ind < len(timestamp)):
			# print("enter_lyrics while")
			if (timestamp[self.t_ind] >= self.cell_allowed_time(counter)[0]) and (timestamp[self.t_ind] < self.cell_allowed_time(counter)[1]):
				self.silbe_list[self.cell] = words[self.t_ind]
				self.stress[self.cell] = stress[self.t_ind]
				# print("if: ",words[self.t_ind])
				self.cell+=1
				self.t_ind+=1
			elif timestamp[self.t_ind] >= self.cell_allowed_time(counter)[1]:
				# print("elif: ", timestamp[self.t_ind] ,self.cell_allowed_time(counter)[1])
				self.cell+=1
			else:
				# print("else:")
				self.cell+=1
			counter-=1

class Preprocess_Files:
	def __init__(self, hpath, spath):
		self.hum_path = hpath
		self.str_path = spath
		self.top = []
		self.df_hum = pd.DataFrame()
		self.final_list = []
		self.timestamp = []
		self.stress = []
		self.words = []
		# 
		self.remove_lines()
		self.preprocess_hum()
		self.preprocess_str()
		

	"""
	remove_lines: Function to srip the first few lines before the dataframe starts
	This removes everything up to and including the exclusive interpretations
	"""
	def remove_lines(self):
		buffer = []
		with open(self.hum_path) as f:
			# print("within remove_lines")
			drop = True
			while drop:
			  line = f.readline()
			  drop = line.startswith('!!!')
			  if drop:
			    self.top.append(line)
			content = line + f.read()
		temp = content.split('\n')
		for i in temp:
			buffer.append(i.split('\t'))
		
		self.df_hum=pd.DataFrame(buffer[1:], columns = buffer[0])
		self.df_hum = self.df_hum[['**harm', '**deg','**timestamp']]

	"""
	preprocess_hum: Function to create a new column df[**silbe] within the hum file initialized as a copy of the 2nd column: df_hum[1]. 
	All cells in this newly created column except those containing '=', '*' or '!' are considered as potential cells for entering lyrics 
	so they are marked with a '.' and the resulting list is saved within the final_list.
	"""
	def preprocess_hum(self):

		# self.df_hum['**silbe'] = self.df_hum['**deg']
		self.df_hum['**silbe'] = self.df_hum['**deg'].apply(lambda x: x if (True if x is None else x.startswith(('=','*','!'))) else ".")
		# for i in range(len(self.df_hum['**silbe'])):
		# 	if self.df_hum['**silbe'][i]:	
		# 		if (self.df_hum['**silbe'][i][1:].isnumeric() and self.df_hum['**silbe'][i][0]== "=" or self.df_hum['**silbe'][i][0]=="*" or self.df_hum['**silbe'][i][0]=="!" ) :
		# 			pass
		# 		else:
		# 			self.df_hum['**silbe'][i]="."
		self.final_list = self.df_hum['**silbe']
		
	"""
	preprocess_str: Function to preprocess the .str files. The function splits the str file into lines and parses each line in the 
	reverse order and matches the word and the count of the word in order to split the word into respective number of syllables for
	the word. Timestamp and stress also get saved in respective arrays along with the words. 
	"""
	def preprocess_str(self):
		flag = 0
		f = open(self.str_path, "r")
		line = f.read().split("\n")
		regex = r"[0-9]* ([0-9.]*) [0-9]* [0-9]* ([0-9]) ([A-Z]*\[[0-9]\])"
		for i in reversed(line):
			match = re.findall(regex, i)
			if match:
				match = match[0]
				if flag:
					flag-=1
					self.timestamp.insert(0,float(match[0])+1.0)
					self.stress.insert(0,match[1])
					continue
				else:
					syllables = int(re.findall(r"\[([0-9]*)\]",match[2])[0])
					flag = syllables-1
					chunks = list(split_into(match[2][0:-3], syllables))

					
					self.timestamp.insert(0,float(match[0])+1.0)
					self.stress.insert(0,match[1])

					if syllables > 1:
						for i in range(len(chunks)):
							if i == 0:
								chunks[i] = chunks[i] + "-"
							elif i == len(chunks)-1:
								chunks[i] = "-" + chunks[i]
							else:
								chunks[i] = "-" + chunks[i] + "-"

					for each in reversed(chunks):
						self.words.insert(0,each.lower())
		self.df_hum['**stress'] = self.df_hum['**silbe'] 

	"""
	process_melisma: After the addition of lyrics, this function is meant to parse df_hum['**silbe'] and process the melisma the first 
	few lines before the dataframe starts.
	"""
	def process_melisma(self):
	  self.df_hum['**silbe'] = self.final_list
	  self.df_hum.loc[((self.final_list == ".") & (self.df_hum['**deg'] != ".")), '**silbe'] = "_"
	  
		# for i in range(len(self.df_hum['**silbe'])):
		# 	if self.df_hum['**silbe'][i] and self.df_hum['**deg'][i]:	
		# 		if self.df_hum['**deg'][i] != '.' and self.df_hum['**silbe'][i]=='.':
		# 			self.df_hum['**silbe'][i] = '_'

	"""
	rewrite_file: Function to rewrite the initial 5 lines back to the final file and save the newly created file in a directory (with_silbe/)
	 with the format with_silbe/filename.hum.
	"""
	def rewrite_file(self, filename):
		print(self.df_hum.columns)
		lines = "".join(self.top) 
		# lines += "\t".join(self.df_hum.columns)
		
		lines += self.df_hum.to_csv(sep = '\t', index = False)
	
		f = open("with_silbe/"+filename+".hum", "w")
		f.write(lines)
		f.close()


def split_into(s, n):
    size, remainder = divmod(len(s), n)
    start = 0
    for i in range(n):
        length = size + (i < remainder)
        yield s[start:start + length]
        start += length



