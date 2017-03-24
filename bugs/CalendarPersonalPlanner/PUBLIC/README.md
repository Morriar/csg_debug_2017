# Calendar Personal Planner

Language: C++

Thanks to an evolved Artificial Intelligence (that relies on programming and algorithms), this application helps you to plan your week activities in an optimal way: why bother organizing your time when a robot can do it for you and tell you what to do and when doing it.

Calendar Personal Planner takes 4 numbers between 0 and 100:

* the initial amount of money
* the initial amount of fun
* the expected amount of money
* the expected amount of fun

Just enter the numbers and follow the directives.

## Usage

    $ make compile
    $ bin/cpp <init_money> <init_fun> <goal_money> <goal_fun>

### Example

Looking to improve fun a lot and do not lose money.

    $ bin/cpp 50 20 50 80

Output:

	* initial money=50 fun=20
	* Monday 1:00 -> 9:00: tv (money=50 fun=21)
	* Monday 9:00 -> 15:00: home alcoholism (money=46 fun=35)
	* Monday 15:00 -> 1:00: night work (money=64 fun=27)
	* Tuesday 1:00 -> 9:00: night fiesta (money=40 fun=61)
	* Tuesday 9:00 -> 15:00: home alcoholism (money=36 fun=75)
	* Tuesday 15:00 -> 1:00: night work (money=54 fun=67)
	* Wednesday 1:00 -> 9:00: tv (money=54 fun=68)
	* Wednesday 9:00 -> 15:00: home alcoholism (money=50 fun=82)

## Developers

Useful commands:

	make compile
	make check
