#Daniel Kantor
#CSI 305 - Dr. Helsing
#5/14/2021
#Library system in python storing information in a MySQL database. 
#The features include - Checking out a book, Checking in a book, adding library member, adding a new book, and adding a new branch
#This is done by running queries to the database that utilize inputs from the user
#User can choose any option they want as many times as they want until they quit the program.

import mysql.connector
from datetime import date
from dateutil.relativedelta import relativedelta

mydb = mysql.connector.connect(
  host='localhost',
  user='root',
  database = 'library_system'
)
mycursor = mydb.cursor(dictionary=True)

print("Choose an Option")
print("1. Check-in a book")
print("2. Check-out a book")
print("3. Add a borrower")
print("4. Add a new book")
print("5. Add a new branch")
print("6. Exit")
menuVal = int(input())

while(menuVal != 6): #Keep running until the user chooses the exit
    
    if(menuVal == 1): #Check in book
        bookName = input("\nPlease enter the name of the book you are checking in\n").strip() #User input title
        branchName = input("Please enter the name of the branch you are checking in the book\n").strip() #User input branch name

        mycursor.execute("select title from book where title = %s",(bookName,)) #Query to check if the given book exists in the database
        result = mycursor.fetchall()
        if(mycursor.rowcount == 0): #If book not in database
            print("\nEntered Invalid Book Title - Please Reselect")
            print("1. Check-in a book")
            print("2. Check-out a book")
            print("3. Add a borrower")
            print("4. Add a new book")
            print("5. Add a new branch")
            print("6. Exit")
            menuVal = int(input())
        else:
            mycursor.execute("select branch_name from library_branch where branch_name = %s",(branchName,)) #Query to check if given branch exists in the database
            result = mycursor.fetchall()
            if(mycursor.rowcount == 0): #If branch not in database 
                print("\nEntered Invalid Branch - Please Reselect")
                print("1. Check-in a book")
                print("2. Check-out a book")
                print("3. Add a borrower")
                print("4. Add a new book")
                print("5. Add a new branch")
                print("6. Exit")
                menuVal = int(input())
            else: 
                print("\nSuccessfully Checked-in Book! - What next?")
                mycursor.execute("update book_copies natural join library_branch natural join book set no_of_copies = no_of_copies + 1 where title = %s and branch_name = %s",(bookName, branchName,)) 
                mydb.commit() #Add an additional copy of the book specified by the user to the branch specified by the user
                print("1. Check-in a book")
                print("2. Check-out a book")
                print("3. Add a borrower")
                print("4. Add a new book")
                print("5. Add a new branch")
                print("6. Exit")
                menuVal = int(input())

    elif(menuVal == 2): #Check out book
        cardNum = input("\nPlease enter you card number\n").strip()#User inputs their library card number 
        bookName = input("Please enter the name of the book you want to check out\n").strip()#User input book title
        branchName = input("Please enter the name of the branch you are checking the book out of\n").strip()#User input branch name

        mycursor.execute("select card_no from borrower where card_no = %s",(cardNum,)) #Query to check if the given card number exsits in the database
        result = mycursor.fetchall()
        if(mycursor.rowcount == 0): #If the card number not in database
            print("\nAccount Doesn't Exist - Please Reselect")
            print("1. Check-in a book")
            print("2. Check-out a book")
            print("3. Add a borrower")
            print("4. Add a new book")
            print("5. Add a new branch")
            print("6. Exit")
            menuVal = int(input())
        else: 
            mycursor.execute("select title from book where title = %s",(bookName,)) #Query to check if the given book exists in the database
            result = mycursor.fetchall()
            if(mycursor.rowcount == 0): #If book not in database
                print("\nBook not in system - Please Reselect")
                print("1. Check-in a book")
                print("2. Check-out a book")
                print("3. Add a borrower")
                print("4. Add a new book")
                print("5. Add a new branch")
                print("6. Exit")
                menuVal = int(input())
            else:
                mycursor.execute("select branch_name from library_branch where branch_name = %s",(branchName,)) #Query to check if the given branch exists in the database
                result = mycursor.fetchall()
                if(mycursor.rowcount == 0): #If branch not in database
                    print("\nBranch not in system - Please Reselect")
                    print("1. Check-in a book")
                    print("2. Check-out a book")
                    print("3. Add a borrower")
                    print("4. Add a new book")
                    print("5. Add a new branch")
                    print("6. Exit")
                    menuVal = int(input())
                else:
                    mycursor.execute("select no_of_copies from book_copies natural join book natural join library_branch where title = %s and branch_name = %s",(bookName, branchName,)) #Query to get the number of copies 
                    result = mycursor.fetchall()                                                                                                                                         #available of the given book
                    if(mycursor.rowcount == 0 or result[0]["no_of_copies"] == 0): #No books available                                                                                    #located at the given branch 
                        print("\nSorry, no copies of the book available at this branch - Please Reselect")
                        print("1. Check-in a book")
                        print("2. Check-out a book")
                        print("3. Add a borrower")
                        print("4. Add a new book")
                        print("5. Add a new branch")
                        print("6. Exit")
                        menuVal = int(input())
                    else:
                        today = date.today() 
                        date_out = today.strftime("%#m/%#d/%Y") #Date book is checked out - uses todays date
                        oneyear = date.today() + relativedelta(years = 1)
                        due_date = oneyear.strftime("%#m/%#d/%Y") #Date book is due - uses date a year from today

                        #Query to update the book_copies table to reflect that a given book has been checked out at a given branch
                        mycursor.execute("update book_copies natural join library_branch natural join book set no_of_copies = no_of_copies - 1 where title = %s and branch_name = %s",(bookName, branchName,))
                        mydb.commit()
                        #Querty to insert info about the borrowed book into the book_loans table into the database
                        mycursor.execute("insert into book_loans (book_id, branch_id, card_no, date_out, due_date) values ((select book_id from book where title = %s), (select branch_id from library_branch where branch_name = %s), %s, %s, %s)", (bookName, branchName, cardNum, date_out, due_date,))
                        mydb.commit()
                        print("\nSuccessfully Checked-out Book! - What next?")
                        print("1. Check-in a book")
                        print("2. Check-out a book")
                        print("3. Add a borrower")
                        print("4. Add a new book")
                        print("5. Add a new branch")
                        print("6. Exit")
                        menuVal = int(input())

    elif(menuVal == 3): #Add a borrower
        borrowerName = input("\nPlease enter your name\n").strip() #User input their name 
        phoneNumber = input("Please enter your phone number\n").strip() #User input their phone number

        mycursor.execute("select name,phone from borrower where name = %s and phone = %s", (borrowerName, phoneNumber,)) #Query to check if the user already exists in the database
        result = mycursor.fetchall()
        if(mycursor.rowcount != 0): #If user already exists
            print("\nYou already have an account - Please Reselect")
            print("1. Check-in a book")
            print("2. Check-out a book")
            print("3. Add a borrower")
            print("4. Add a new book")
            print("5. Add a new branch")
            print("6. Exit")
            menuVal = int(input())
        else:
            mycursor.execute("select max(card_no) as max from borrower") #Query to get the max card number in the database
            result = mycursor.fetchall()
            cardNumber = result[0]["max"] + 1 #New borrowerers card number - the max card number in the database plus one
            mycursor.execute("insert into borrower (card_no, name, phone) values (%s, %s, %s)", (cardNumber, borrowerName, phoneNumber)) #Query to insert the new borrower in to the database
            mydb.commit()
            print("\nSuccessfully entered as borrower in the system! - What next?")
            print("1. Check-in a book")
            print("2. Check-out a book")
            print("3. Add a borrower")
            print("4. Add a new book")
            print("5. Add a new branch")
            print("6. Exit")
            menuVal = int(input())

    elif(menuVal == 4): #Add a new book
        bookName = input("\nPlease enter the book name\n").strip() #User input book title
        publisher = input("Please enter the name of the publisher\n").strip() #User input publisher name
        author = input("Please enter the name of the author\n").strip() #User input author name

        mycursor.execute("select title from book where title = %s",(bookName,)) #Query to check if the book already exists in the database 
        result = mycursor.fetchall()
        if(mycursor.rowcount != 0): #If book already exists
            print("\nBook already in system - Please Reselect")
            print("1. Check-in a book")
            print("2. Check-out a book")
            print("3. Add a borrower")
            print("4. Add a new book")
            print("5. Add a new branch")
            print("6. Exit")
            menuVal = int(input())
        else:
            mycursor.execute("select name from publisher where name = %s", (publisher,)) #Query to check if the publisher already exsits in the database
            result = mycursor.fetchall()
            if(mycursor.rowcount == 0): #If publisher doesn't exist
                print("\nPublisher doesn't exist in system - please enter details")
                address = input("Enter publisher address\n").strip() #User input address of publisher 
                phoneNumber = input("Enter publisher phone number\n").strip() #User input phone number of publisher
                mycursor.execute("insert into publisher (name, address, phone) values (%s, %s, %s)", (publisher, address, phoneNumber)) #Query to insert the publisher into the database
                mydb.commit()
            mycursor.execute("select max(book_id) as max from book") #Query to get the max book id in the database
            result = mycursor.fetchall()
            bookID = result[0]["max"] + 1 #New book id - max in database plus one
            mycursor.execute("insert into book (book_id, title, publisher_name) values (%s, %s, %s)", (bookID, bookName, publisher)) #Query to insert the book into the database
            mydb.commit()
            mycursor.execute("insert into book_authors (book_id, author_name) values (%s, %s)", (bookID, author)) #Query to insert the author of the book into the database associated with the book id
            mydb.commit()
            mycursor.execute("select branch_id, branch_name from library_branch") #Query to get all the branch id's and names from the database
            result = mycursor.fetchall()
            for row in result: #For all branches
                branch_id = (row["branch_id"]) #Get branch id
                print("\nEnter how many copies of " + bookName + " will be stored at " + row["branch_name"])
                numberCopies = input() #User input number of copies of book stored at specific branch
                mycursor.execute("insert into book_copies (book_id, branch_id, no_of_copies) values (%s, %s, %s)", (bookID, branch_id, numberCopies)) #Query to insert how many copies of the new book will be available at branch
                mydb.commit()
            print("\nSucessfully added book! - What next?")
            print("1. Check-in a book")
            print("2. Check-out a book")
            print("3. Add a borrower")
            print("4. Add a new book")
            print("5. Add a new branch")
            print("6. Exit")
            menuVal = int(input())

    elif(menuVal == 5): #Add a new branch
        branchName = input("\nPlease enter name of the new branch\n").strip() #User input name of new branch
        branchAddress = input("Please enter address of the new branch\n").strip() #User input address of new branch

        mycursor.execute("select branch_name from library_branch where branch_name = %s", (branchName,)) #Query to check if given branch already exists in the database
        result = mycursor.fetchall()
        if(mycursor.rowcount != 0): #If branch already exists
            print("\nBranch already in system - Please Reselect")
            print("1. Check-in a book")
            print("2. Check-out a book")
            print("3. Add a borrower")
            print("4. Add a new book")
            print("5. Add a new branch")
            print("6. Exit")
            menuVal = int(input())
        else:
            mycursor.execute("select max(branch_id) as max from library_branch") #Query to get the max branch id in the database
            result = mycursor.fetchall()
            branchID = result[0]["max"] + 1 #New branch id - max in database plus one
            mycursor.execute("insert into library_branch (branch_id, branch_name, address) values (%s, %s, %s)", (branchID, branchName, branchAddress)) #Query to insert the new branch into the database
            mydb.commit()
            mycursor.execute("select book_id, title from book") #Query to get all the book id's and titles from the database
            result = mycursor.fetchall()
            for row in result: #For all books
                bookID = (row["book_id"]) #Get book id
                print("\nEnter how many copies of " + row["title"] + " will be stored at " + branchName)
                numberCopies = input() #User input number of copies of book stored at new branch
                mycursor.execute("insert into book_copies (book_id, branch_id, no_of_copies) values (%s, %s, %s)", (bookID, branchID, numberCopies)) #Query to insert how many copies of the new book will be available at branch
                mydb.commit()
            print("\nSuccessfully created new branch! - What next?")
            print("1. Check-in a book")
            print("2. Check-out a book")
            print("3. Add a borrower")
            print("4. Add a new book")
            print("5. Add a new branch")
            print("6. Exit")
            menuVal = int(input())

    else: #Value chosen that isn't an option
        print("\nInvalid Option - Please Choose again")
        print("1. Check-in a book")
        print("2. Check-out a book")
        print("3. Add a borrower")
        print("4. Add a new book")
        print("5. Add a new branch")
        print("6. Exit")
        menuVal = int(input())
