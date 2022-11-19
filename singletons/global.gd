extends Node

var YELLOW = Color(0.79,0.83,0.53,1)
var RED = Color(0.62,0.30,0.26,1)
var ORANGE = Color(0.63,0.40,0.23,1)

var player
var entities
var top_3_speeds


func calculate_extra_turn_chance(target_speed):
	if target_speed in top_3_speeds:
		var chance = 10
		var total:int = 0
		for i in top_3_speeds:
			total += i
		var avg:int = round(total/top_3_speeds.size())
		print('AVERAGE TOP 3 SPEEDS = ', avg)
	else:
		return false

var goblin_names = [
	'Zenik','Gamak', 'Ghal-baba', 'Risahg','Kelekawa','Malacandra', 'Cambarich', 
	'Girahild', 'Arielmanda', 'Isabelmanda', 'Alisande', 'Aidos', 'Asmira', 
	'Alexander', 'Irisander', 'Mandaor', 'Dominus','Giraldus','Galker',
	'Zalemkis','Gakri',"Shar'kay","Gilikia",'Aklis', 'Hasper','Mayah', 'Marzig', 
	'Marpax', 'Tlik','Ziger', 'Gral', 'Gerbil', 'Nimbi', 'Sekenen','Eshgaebar', 
	'Teblor', 'Gobel', 'Diarik', 'Eshmun', 'Demar','Clarabeth', 'Malloc',
	'Aylita', 'Alfreda', 'Isabell', 'Adeliza', 'Ida', 'Idaddo', 'Idullana', 'Yseult', 
	'Iswen','Aldurhliot', 'Kalabah', 'Kariss', 'Bartimaeus', 'Charon', 'Ortri', 'Ophelia', 
	'Pisistratus', 'Mabinogi', 'Manawaka', 'Orlik', 'Ornit', 'Piffle',
	'Thuris', 'Henard', 'Ariel','Ishbel', 'Gob', 'Gub', 'Dobby', 'Bogey', 'Gozer', 'Ghoulie', 
	'Ghort', 'Shaggy', 'Snott','Spuggy', 'Oggie', 'Knackie', 'Grog', 'Gubber', 'Spudge', 'Guck', 
	'Trog', 'Burble', 'Bump', 'Gaffle', 'Muck', 'Gulliver', 'Stinker', 'Flibble',  'Tubby', 'Harry', 
	'Drac', 'Dreck', 'Droog', 'Gibson', 'Gref', 'Grumble', 'Moke', 'Boggle', 'Scrabble', 'Spodder', 
	'Wringer', 'Woggle', 'Quirkle', 'Inky', 'Jinkle', 'Stuffy', 'Bloat', 'Brutus', 'Giblets'
]

var human_names = [
	'Francis', 'Christian', 'Iris', 'Annabelle', 'Rose', 'Eliza', 'Tyson', 'Abigail', 'Percival', 
	'Josiah', 'Fred', 'Nathaniel', 'Juneau', 'Quintin', 'Homer', 'Ester', 'Princess', 'Mortimer', 
	'Kelly-Ann', 'Bernard', 'Rufus', 'Florence', 'Lionel', 'Madelyn', 'Ben', 'Trudy', 'Jane', 'Ada', 
	'Alba', 'Josephine', 'Riley', 'Sally', 'Brigitte', 'Irwin', 'Gaston', 'Cyrinda', 'Kay',
	 'Theodora', 'Dorethea', 'Bonnie', 'Olivia', 'Tom', 'Gloria', 'Cass', 'Jeff', 'Octavia', 'Rosie', 
	'Charles', 'Carl', 'Dora', 'Thomas', 'Skip', 'Leo', 'Jacob', 'Juniper', 'Frederik', 'Bud', 
	'Luke', 'Clark', 'Frederic', 'John', 'Desiree', 'Nellie', 'Persia', 'Johnathan', 'Lucas', 
	'Othello', 'George', 'Rosella', 'Spencer', 'Clara', 'Jasmine', 'Edmund', 'Benjamin', 'Duncan', 
	'Joy', 'Sapphira', 'Joyce', 'Lily', 'Gerald', 'Clinton', 'Dale', 'Eric', 'Patricia', 'Abel', 
	'Fernanda', 'Robert', 'Geraldine', 'Perdita', 'Stanley', 'Adaline', 'Tripp', 'Ricky', 'Wanda', 
	'Lucius', 'Cameron', 'Kate', 'Jack', 'Rosabelle', 'Queenie', 'Polly', 'Marcus', 'Evelyn', 
	'Esther', 'Just', 'Rhoda', 'Elinor', 'Margaret', 'Gary', 'Laura-Belle', 'Dana', 'Addie', 'Alma',
	 'Raphael', 'Sidney', 'Richard', 'Junie', 'Dwayne', 'Ferdinand', 'Justa', 'Archie', 'Julia', 
	'Kathleen', 'Lyde', 'Olaf', 'Orville', 'Otis', 'Harry', 'Orvie', 'Genevieve', 'Mark', 'Fernando', 
	'Rita', 'Leonora', 'Harold', 'Silvia', 'Olive', 'Alexander', 'William', 'Joseph', 'Frederick', 
	'Franklin', 'Paula', 'Katherine', 'Percy', 'Henry', 'Abram', 'Sebastian', 'Paul', 'Nelly', 
	'Rena', 'Teddy', 'Marian', 'Charlie', 'April', 'Grady', 'Jean', 'Daphne', 'Helen', 'Frank',
	 'Agnes', 'Nancy', 'Beulah', 'Sabina', 'Eli', 'Oscar', 'Harmonica', 'Zita', 'Bart', 'Isaac',
	 'Lawrence', 'Prince', 'Alfred', 'Peter', 'Wally', 'Emil', 'Velma', 'Ethel', 'Ned', 'Kelly', 
	'Sue', 'James', 'Fern', 'Linda', 'Andrew', 'Oliver', 'Lenny', 'Mary', 'Theodosia', 'Jerry', 
	'Gina', 'Gramma', 'Coral', 'Dorothy', 'Waldo', 'Mathew', 'Fay', 'Max', 'Arthur', 'Zoe', 'Junior',
	 'Michael', 'Douglas', 'Hap', 'June', 'Lucy', 'Parker', 'Ronnie', 'Alan', 'Ruth', 'Alice', 
	'Forest', 'Minnie', 'Donald', 'Maggie', 'Ruby', 'Maxwell', 'Vivian', 'Louis', 'Adam', 'Betty', 
	'Sibyl', 'Lem', 'Johnny', 'Hazel', 'Diane', 'Valeria', 'Wilma', 'Nora', 'Philip', 'Samuel', 
	'Chip', 'Viviana', 'Pauline', 'Wallace', 'Lorelei', 'Laura', 'Luna', 'Loretta'
]

