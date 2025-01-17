Create Table Sailor(

	sailor_name int Identity(300,1) Primary key,
	sailor_rank nvarchar(255)

)

Create Table Boat(

	boat_name nvarchar(255) Primary key,
	boat_color nvarchar(30),
	boat_rank int constraint rank_limit Check(70<boat_rank and boat_rank < 150)

)


Create Table Reserve(

	sailor_name nvarchar(255),
	boat_name nvarchar(255),
	weekday_reserve Int constraint date_limit Check(0<weekday_reserve and weekday_reserve<8),
	Primary key(sailor_name,boat_name)
)

INSERT INTO sailor (sailor_rank)
VALUES 
('شاهکار'),
('عالی'),
('بد'),
('بدتر');


INSERT INTO boat (boat_name, boat_color, boat_rank)
VALUES 
('blah', 'blue', 86),
('ice', 'red', 110),
('adam', 'gray', 74),
('star', 'black', 143);


INSERT INTO reserve (boat_name, sailor_name, weekday_reserve)
VALUES 
('blah', 301, 2),
('ice',300, 1),
('adam',303, 5),
('star',302, 3);

select Boat.boat_name from Boat inner join Reserve On Boat.boat_name = Reserve.boat_name where Reserve.weekday_reserve = 1 

Create view v1 As 
select Boat.boat_name,Reserve.sailor_name,Boat.boat_color from Boat inner join Reserve On Boat.boat_name = Reserve.boat_name;

Select boat_rank from Boat

select Boat.boat_name from Boat inner join Reserve On Boat.boat_name = Reserve.boat_name where Reserve.weekday_reserve = 1 or Reserve.weekday_reserve = 3

select Boat.boat_color from Boat inner join Reserve On Boat.boat_name = Reserve.boat_name where Reserve.weekday_reserve = 1 or Reserve.weekday_reserve = 2 