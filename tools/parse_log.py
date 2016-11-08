# from hns code
ppe_size = 576

 

def parse_log_file(file_name):
    reg_info = []
    
    for line in open(file_name):
        if line.find("]") != -1:
            line = line[line.find("]") + 1:]
        reg_info += line.split()[1:]
    print reg_info

parse_log_file('test.log')