from twilio.rest import TwilioRestClient

class Person:
	def __init__(self, name, phone_number, food_list):		
		self.nm = name
		self.pn = phone_number
		self.fl = food_list

class Food:
	def __init__(self, name, price, shared_by):
		self.nm = name
		self.pr = price
		self.sh = shared_by

class Receipt:
	def __init__(self, recipient, all_lines):
		self.al = all_lines
		self.rc = recipient
	def add_line(self, name, price):
		self.al.append(name + " : " + "$" + str(price) + "\n")

malk = Food("malk", 2, 2)
bred = Food("bred", 4, 2)
groups = []
all_food_list = []
all_food_list.append(malk)
all_food_list.append(bred)
all_people = []
jazmine = Person("Jazmine", "8134282970", all_food_list)
#5108988195
all_people.append(jazmine)

all_receipts = []
for person in all_people:
	first_line = "Hello " + person.nm + ", here's your receipt from FoodMate! \n"
	lines = []
	lines.append(first_line)
	r = Receipt(person.pn, lines)
	for item in person.fl:
		r.add_line(item.nm, item.pr/item.sh)
	all_receipts.append(r)


#twilio output
account_sid = "ACbc3928fd09ab352b3118024b8d80e218"
auth_token  = "62933b7d42d429eeab56b6578dd8e665"
client = TwilioRestClient(account_sid, auth_token)
output = ""
for r in all_receipts:
	output = ""
	print "send text to : ",  r.rc
	for line in r.al:
		output+= line
	client.messages.create(
		to= "+1" + r.rc, 
		from_="+18137937914", 
		body=output,  
	)