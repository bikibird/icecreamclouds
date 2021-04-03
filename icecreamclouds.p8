pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
black,dark_blue,dark_purple,dark_green,brown,dark_gray,light_gray,white,red,orange,yellow,green,blue,indigo,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
left,right,up,down,fire1,fire2=0,1,2,3,4,5

function draw_intro1()
	cls(white)
	color(black)
	print("")
	print(" dateline: the future...")
	print("")
	print(" we only had one planet and ")
	print(" things were getting worse. it ")
	print(" was time for drastic action. ")
	print(" the scientists and engineers ")
	print(" brainstormed. the first idea ")
	print(" was to harness volcanoes to ")
	print(" pump sulfur dioxide into the ")
	print(" upper atmosphere, but no one ")
	print(" wanted acid rain-- too sour.")
	print("")
	print(" the next idea was ultra ")
	print(" reflective clouds spun from ")
	print(" sugar and soy. it might work ")
	print(" if the math was right. the ")
	print(" only drawback was baseball ")
	print(" sized hail that would bonk ")
	print(" people hard. what a headache!")
end

function draw_intro2()
	cls(white)
	color(black)
	print("")
	print(" everyone was downhearted, but ")
	print(" then professor von stroopwafel ")
	print(" thought of a way to make the ")
	print(" hail softer, sweeter, and ")
	print(" overall ice creamier.")
	print("")
	print(" it worked! in year three, they ")
	print(" even figured out how to add ")
	print(" toppings. now, every summer ")
	print(" the people of earth gather in ")
	print(" parks and on lawns to catch ")
	print(" ice cream from the sky.	")
	print("")
	print("")
	print("")
	print("           x to start")
end	

function draw_park()
	cls(blue)
	
	circfill(63,128,128,red)
	circfill(63,136,128,yellow)
	circfill(63,144,128,green)
	circfill(63,152,128,blue)

	
	rectfill(0,88,127,127,dark_green)
	
end	

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
410200003d0653d0553d0453d0353d0253d0253d0153d015000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005
4104000c3d5703d5603d5503d5403d5303d5203d5103d5103d5103d5103d5103d5103d5103d5103d5103d5103d5103d5103d5103d5103d5103d5103d5103d5103d5103d5103d5103d5103d5103d5103d5103d510
000402003d0303d030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 01404040
04 02404040
