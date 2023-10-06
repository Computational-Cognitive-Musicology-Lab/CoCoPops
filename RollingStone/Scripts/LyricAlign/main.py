from Classes import Create_Silbe, Preprocess_Files
import os

def main():
    for str_file in os.listdir("../../OriginalData"):
        if str_file.endswith('.str'):
            hum_file = os.path.splitext(str_file)[0] + '.hum'
            pf = Preprocess_Files("../../Humdrum/"+hum_file, "../../OriginalData/"+str_file)
            print("before remove_lines") 
            # pf.remove_lines()
            print("before preprocess hum") 
            # pf.preprocess_hum()
            print("before preprocess str")
            # pf.preprocess_str()
            print("before Create_Silbe ")
            cs = Create_Silbe(pf.final_list, pf.df_hum['**stress'])
            print("before process_the_list ")
            cs.process_the_list(pf.timestamp, pf.stress, pf.words)
            print("before process_melisma ")
            pf.process_melisma()
            print("before rewrite_file ")
            pf.rewrite_file(hum_file.strip(".hum"))
            print("File written to", hum_file)

if __name__ == "__main__":
    main()
