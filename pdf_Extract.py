import PyPDF2
import re
import csv
import os

#assign files
file_name ="White_house_staff.pdf"
output_path= 'White_House_output.csv'
#read in bytes
doc = PyPDF2.PdfReader(open(file_name,"rb"))


#number of pages
num_of_pages = len(doc.pages)
print(num_of_pages)


#we want to create a table by extracting rows and columns

#Create and RE according to the data pattern in the PDF
pattern = r'(\d{4})(.*?) ([Ma|Fe]\S*?) ([Em|D].*?) (\d.*?)([Per].*?[Annum]) (.*?)\n'
#year ->(\d{4})
#name ->(.*?)
#gender ->([Ma|Fe]\S*?)
#status ->([Em|D].*?)
#salary ->(\d.*?)
#pay_basis->([Per].*?[Annum])
#title ->(.*?)


#create outputfile if file doesnt exist and add headers
file_exists = os.path.exists(output_path)

if not file_exists:
    with open (output_path, mode='w', newline ='') as file:
        writer = csv.writer(file)
        writer.writerow(["Year", "Name", "Gender", "Employee Status", "Salary","Pay Basis", "Title"])
        
#loop through the pages
for pagenum in range(num_of_pages):
    #Extract text from the columns
    page = doc.pages[pagenum]
    text = page.extract_text()
    matches = re.findall(pattern,text,re.DOTALL)
    for match in matches:
        year,name,gender,status,salary,pay_basis,title= match
        
         # append the rows of data to the csv we created
        with open('White_house_output.csv',mode='a',newline='') as file:
            writer=csv.writer(file)
            writer.writerow([year.strip(),name.strip(),gender.strip(),status.strip(),salary.strip(),pay_basis.strip(),title.strip()])
        