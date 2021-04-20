pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
-- for the bullfrog's birthday
-- by jenny Schmidt (@bikibird) except as noted below
-- some tree sprites adapted from nerdyteachers.com
-- iris effect and sprite rotation adapted from code by @freds72
-- big blue marble from nasa and adapted with https://bikibird.itch.io/depict
left,right,up,down,fire1,fire2=0,1,2,3,4,5
black,brown, gray, white,orange, yellow, blue, purple, pink,dark_brown,dark_green, red, dark_orange, green, dark_blue, dark_purple =0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
wrap,bounce,remove=0,1,2
function invcircfill(r,c) 
--@freds72, https://www.lexaloffle.com/bbs/?pid=67730
    local r2=r*r
    color(c)
    for j=-1,128 do
        local y=64-j
        local x=sqrt(r2-y*y)
        rectfill(-1,j,64-x+1,j)
        rectfill(64+x-1,j,128,j)
    end
end
function spr_r(s,x,y,a,w,h)
--@freds72,https://www.lexaloffle.com/bbs/?tid=3593
	sw=(w or 1)*8
	sh=(h or 1)*8
	sx=(s%8)*8
	sy=s\16*8
	x0=flr(0.5*sw)
	y0=flr(0.5*sh)
	a=a/360
	sa=sin(a)
	ca=cos(a)
	for ix=0,sw-1 do
	 for iy=0,sh-1 do
	  dx=ix-x0
	  dy=iy-y0
	  xx=flr(dx*ca-dy*sa+x0)
	  yy=flr(dx*sa+dy*ca+y0)
	  if (xx>=0 and xx<sw and yy>=0 and yy<=sh) then
		c=sget(sx+xx,sy+yy)
		if (c>0) pset(x+ix,y+iy,c)
	  end
	 end
	end
   end

levelcolors={white,blue,white, blue, white}
s=
{
	toppings=
	{
		{{index=73, width=1, height=1},{index=73, width=1, height=1},{index=73, width=1, height=1}},
		{{index=89, width=1, height=1},{index=105, width=1, height=1},{index=121, width=1, height=1}},
		{{index=137, width=1, height=1},{index=153, width=1, height=1},{index=169, width=1, height=1}},
	},
	scoops=
	{
		{{index=80, width=2, height=2}},
		{{index=112, width=2, height=2}},
		{{index=144, width=2, height=2}},
		{{index=176, width=2, height=2}},
		{{index=178, width=2, height=2}},
		{{index=208, width=2, height=2}}
	},
	cones=
	{
		small={{index=210, width=2, height=3}},
		big={{index=90, width=6, height=7}}
	},
	clouds=
	{
		{{index=228, width=4, height=2}},
		{{index=180, width=6, height=3}}
	},
	
	baseball={{index=56, width=1, height=1}},
	professor={{index=13, width=1, height=1}},
	umbrella={{index=0, width=1, height=1}},
	volcano={{index=1, width=1, height=1}},
	tinycloud={{index=55, width=1, height=1}}
}

function render(entity)
	
	if entity.animate then
		step=frame\5 % (#entity.sprite-1) +1
	else
		step=#entity.sprite
	end	
	if (not (entity.angle==nil)) then
		sprite=entity.sprite[step]
		spr_r(sprite.index,entity.x,entity.y,entity.angle,sprite.width,sprite.height)
	else
		sprite=entity.sprite[step]
		spr(sprite.index,entity.x,entity.y,sprite.width,sprite.height,entity.mirror,entity.flip)
	end	
	
end
 
function hit()
	local i=1
	local s,badorder,fixing
	while (i<=#e.scoops) do
		fixing=e.scoops[i]
		if (fixing.y+8> e.player[#e.player].y and fixing.y+8< e.player[#e.player].y+6) then
			if fixing.x> e.player[#e.player].x-3 then
				if fixing.x< e.player[#e.player].x+3 then
					deli(e.scoops,i)
					fixing.x=e.player[#e.player].x
					fixing.y=e.player[#e.player].y-6
					fixing.dx=e.player[#e.player].dx
					fixing.dy=e.player[#e.player].dy 
					fixing.dt=e.player[#e.player].dt
					fixing.maxdx=e.player[#e.player].maxdx
					fixing.maxdy=e.player[#e.player].maxdy
					fixing.acc=e.player[#e.player].acc
					add(e.player,fixing)
					sfx(2)
					if #e.order.scoops >0 and fixing.sprite[1].index == e.order.scoops[1].sprite[1].index then --scoop matches order
						deli(e.order.scoops,1)
						if #e.order.scoops==0 and #e.order.toppings== 0 then
							sfx(1)
							newcone=true
							statistics[level]+=1
						end

						return	
					else
						badorder={}
						for i=1,#e.player do
							fixing={}
							for key,value in pairs(e.player[i]) do
								fixing[key]=value
							end
							fixing.x=fixing.x-rnd(20)+10
							fixing.dx=rnd{1,-1}
							fixing.dy=1
							fixing.dt=1
							fixing.acc=0
							fixing.flip=true
							--if i==1 then
							--	fixing.y=105-rnd(5)+3	
							--else	
							--	fixing.y=120-rnd(5)+3	
							--end	
							add(badorder,fixing)
						end
						badorder[1].angle=10

						add(e.badorders,badorder)
						while #e.player>1 do
							deli(e.player)
						end
						e.order={scoops={},toppings={}}
						sfx(3)
						return
					end	
				end
			end
		end	
		i+=1
	end
	
	i=1
	while (i<=#e.toppings) do
		fixing=e.toppings[i]

		if (fixing.y+8> e.player[#e.player].y and fixing.y+8< e.player[#e.player].y+6) then
			
			if fixing.x> e.player[#e.player].x+4 then
				if fixing.x< e.player[#e.player].x+12 then
					
					deli(e.toppings,i)
					fixing.dx=e.player[#e.player].dx
					fixing.dy=e.player[#e.player].dy 
					fixing.dt=e.player[#e.player].dt
					fixing.maxdx=e.player[#e.player].maxdx
					fixing.maxdy=e.player[#e.player].maxdy
					fixing.acc=e.player[#e.player].acc
					fixing.animate=false
					if (fixing.sprite[1].index==73)then  --cherry
						fixing.x=e.player[#e.player].x+4
						fixing.y=e.player[#e.player].y-6
					else
						fixing.x=e.player[#e.player].x+4
						fixing.y=e.player[#e.player].y-3
					end
					add(e.player,fixing)
					sfx(2)
					if #e.order.toppings >0 and fixing.sprite[1].index == e.order.toppings[1].sprite[1].index and #e.order.scoops==0 then --topping matches order
						deli(e.order.toppings,1)
						if #e.order.toppings==0 and #e.order.toppings== 0 then
							sfx(1)
							statistics[level]+=1
							newcone=true
						end

						return	
					else
						badorder={}
						for i=1,#e.player-1 do
							fixing={}
							for key,value in pairs(e.player[i]) do
								fixing[key]=value
							end
							fixing.x=fixing.x-rnd(20)+10
							fixing.dx=rnd{1,-1}
							fixing.dy=1
							fixing.dt=1
							fixing.acc=0
							fixing.flip=true
							--if i==1 then
							--	fixing.y=105-rnd(5)+3	
							--else	
							--	fixing.y=120-rnd(5)+3	
							--end	
							add(badorder,fixing)
						end
						badorder[1].angle=10
						add(e.badorders,badorder)
						while #e.player>1 do
							deli(e.player)
						end
						e.order={scoops={},toppings={}}
						return
					end	
				end
			end
		end	
		i+=1
	end
end
function move(entities,options)
	local i=1
	while (i<=#entities) do
		local entity=entities[i]
		if frame%entity.dt == 0 then
			entity.x+=entity.dx
			entity.y+=entity.dy
			if (options.mode==wrap)then
				if (not (options.x ==  nil)) then
					if (entity.x>options.x[2]) entity.x=options.x[1]
					if (entity.x<options.x[1]) entity.x=options.x[2]
				end
			elseif (options.mode==bounce) then
				if (entity.x>options.x[2]) then
					entity.x=options.x[2]
					entity.dx=-entity.dx
					entity.mirror=not entity.mirror
				elseif (entity.x<options.x[1]) then
					entity.x=options.x[1]
					entity.dx=-entity.dx
					entity.mirror=not entity.mirror
				end	
				
			elseif (options.mode==remove) then
				if ( entity.x>options.x[2] and entity.dx>0)or (entity.x<options.x[1] and entity.dx < 0) then
					deli(entities,i)
					i-=1						
				elseif (entity.y>options.y[2] and entity.dy>0)or (entity.y<options.y[1] and entity.dy < 0) then
					deli(entities,i)
					i-=1	
				end	
			end
		end	
		i+=1
	end
	while (i<=#entities) do
		local entity=entities[i]
		if frame%entity.dt == 0 then
			entity.x+=entity.dx
			entity.y+=entity.dy
			if (options.mode==wrap)then
				if (not (options.x ==  nil)) then
					if (entity.x>options.x[2]) entity.x=options.x[1]
					if (entity.x<options.x[1]) entity.x=options.x[2]
				end
			elseif (options.mode==bounce) then
				if (entity.x>options.x[2]) then
					entity.x=options.x[2]
					entity.dx=-entity.dx
					entity.mirror=not entity.mirror
				elseif (entity.x<options.x[1]) then
					entity.x=options.x[1]
					entity.dx=-entity.dx
					entity.mirror=not entity.mirror
				end	
				
			elseif (options.mode==remove) then
				if ( entity.x>options.x[2] and entity.dx>0)or (entity.x<options.x[1] and entity.dx < 0) then
					deli(entities,i)
					i-=1						
				elseif (entity.y>options.y[2] and entity.dy>0)or (entity.y<options.y[1] and entity.dy < 0) then
					deli(entities,i)
					i-=1	
				end	
			end
		end	
		i+=1
	end
end
function nextframe()
	frame+=1
	if (frame >32700) frame=frame%32700
end
function _init()
	pal({[0]=0, 4, 6, 7, 9,135, 12, 13, 14,132,3, 8, 137, 139, 140, 141}, 1)
	frame=0
	gravity=0.05
    friction=0.75
	e=
	{
		gray_cloudcover=
		{
			{sprite=s.clouds[2],x=-12,y=4,dx=0,dy=0},
		},
		purple_cloudcover=
		{
			{sprite=s.clouds[1],x=91,y=8}
		},
		white_cloudcover=
		{
			{sprite=s.clouds[1],x=6,y=17},
			
		},
		gray_clouds=
		{
			{sprite=s.clouds[1],x=-10,y=44,dx=1,dt=2, dy=0,mirror=false},
		},
		bigcone={sprite=s.cones.big,x=41,y=63}
	}
	newcone=false
	_draw=gs.draw.title
	_update=gs.update.title
end
e={clouds={},scoops={},cone={}}
gs={draw={},update={}}

gs.draw={
	title=function() 
		cls(blue)
		pal(white,gray)
		pal(gray, purple)
		foreach(e.gray_cloudcover,render)
		foreach(e.gray_clouds,render)
		pal(white,purple)
		pal(gray,dark_puple)
		foreach(e.purple_cloudcover,render)
		pal(white,white)
		pal(gray,gray)
		foreach(e.white_cloudcover,render)
		color(white)
		print("\^pice",53,10)
		print("\^pcream",45,22)
		print("\^pclouds",41,34)
		print("\151 to play",44,48)
		render(e.bigcone)
		render({sprite=s.clouds[2],x=52,y=87})
	end,
	newspaper1=function () 
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
		print(" if the math was right. the")
		print(" only concern was hail as big")
		print(" as baseballs bonking people")
		print(" hard. what a headache! \151")
		palt(black,false)
		palt(white,true)
		render({sprite=s.volcano,x=117,y=44})
		render({sprite=s.umbrella,x=117,y=64})
		render({sprite=s.tinycloud,x=117,y=82})
		render({sprite=s.baseball,x=118,y=101})
	end,
	newspaper2=function () 
		cls(white)
		rectfill(0,86,128,128,blue)
		color(black)
		print("")
		print(" everyone despaired, but then")
		print(" professor von stroopwafel ")
		print(" discovered a way to make the ")
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
		color(white)
		print("")
		print("          \151 to start")
		print("        \142 review order")
		print("           \139 \145 move")
		
		palt(black,true)
		palt(white,true)
		render({sprite=s.professor,x=116,y=11})
		render({sprite=s.toppings[1],x=115,y=49})
		render({sprite=s.scoops[2],x=112,y=68})
		palt(white,false)

	end,
	park=function () --park
		
		cls(blue)
		rectfill(0,69,127,127,dark_green)
		map(0,0)

		pal(gray,dark_purple)
		pal(white,purple)
		foreach(e.cloud_cover,render)

		pal(white,white)
		pal(gray,gray)
		foreach(e.player,render)
		foreach(e.scoops,render)
		foreach(e.toppings,render)
		foreach(e.clouds,render)
		for bad in all(e.badorders) do
			foreach(bad,render)	
		end
		
		print("\#6"..timer,115,2,white)
		if delay >0 then
			if level < 4 then
				print("\#6level "..level,50,42,levelcolors[delay])
			else
				print("\#6time's up",44,42,levelcolors[delay])
			end		
		else
			if showorder then
				rectfill(48,27,77,63,blue)
				rect(47,26,78,64,white)
				print("O",72,28)
				print("R",72,33)
				print("D",72,38)
				print("E",72,43)
				print("R",72,48)
				print("\142",70,58)
				line(48,65,79,65,dark_purple)
				line(79,28,79,65,dark_purple)
				foreach(e.order.scoops,render)
				foreach(e.order.toppings,render)
			end
		end	
	end,
	statistics= function()
		if fadein >= 0 then
			invcircfill(fadein,blue)
		else	
			pal(white,gray)
			pal(gray, purple)
			foreach(e.gray_cloudcover,render)
			foreach(e.gray_clouds,render)
			pal(white,purple)
			pal(gray,dark_puple)
			foreach(e.purple_cloudcover,render)
			pal(white,white)
			pal(gray,gray)
			foreach(e.white_cloudcover,render)
			color(white)
			print(" total : "..(statistics[1]+statistics[2]+statistics[3]),43,30)
			print("level 1: "..statistics[1],43,38)
			print("level 2: "..statistics[2],43,46)
			print("level 3: "..statistics[3],43,54)
			render(e.bigcone)
			render({sprite=s.clouds[2],x=52,y=87})
			if (fadeout <101) invcircfill(fadeout,blue)
		end
	end,
	epilogue=function () --big blue marble
		if fadein > 0 then
			invcircfill(fadein,blue)
		else
			cls(black)
			for star in all(stars) do
				pset(star.x,star.y,star.c)
			end
			spr(66,36,2,7,7)
			spr(90,42,71,6,7)
			if fadeout < 101 then
				invcircfill(fadeout,blue)
			else
				if msgx > -1065 then	
					print(msg.."game over \151",msgx,62,blue)

				else
					print(msg,msgx,62,purple)
					print("game over \151", 40, 62,blue)
				end		
			end	
		end

	end
}
gs.update=
{
	title=function()  -- title screen
		move(e.gray_clouds,{mode=bounce, x={-50,135}})
		if ((e.gray_clouds[1].x<-50 and e.gray_clouds[1].dx<0) or (e.gray_clouds[1].x>135 and e.gray_clouds[1].dx>0) ) then
			e.gray_clouds[1].dx=-e.gray_clouds[1].dx
			e.gray_clouds[1].mirror = not e.gray_clouds[1].mirror
		end
		if btnp()>0 then
			_draw=gs.draw.newspaper1
			_update=gs.update.newspaper1
			
		end	
		nextframe()
	end,
	newspaper1=function() -- newspaper page 1
		if btnp()>0 then
			_draw=gs.draw.newspaper2
			_update=gs.update.newspaper2
		end
	end,

	
	newspaper2=function()  -- newspaper page 2
		if btnp()>0 then
			level=1
			timer=60
			delay=5
			statistics={0,0,0}
			showorder=true
			_draw=gs.draw.park
			_update=gs.update.park
			e=
			{
				cloud_cover=
				{
					{sprite=rnd(s.clouds),x=rnd(10)-16,y=rnd(10),mirror=rnd{true,false}},
					{sprite=rnd(s.clouds),x=16+rnd(10),y=rnd(10),mirror=rnd{true,false}},
					{sprite=rnd(s.clouds),x=48+rnd(10),y=rnd(10),mirror=rnd{true,false}},
					{sprite=rnd(s.clouds),x=80+rnd(10),y=rnd(10),mirror=rnd{true,false}},
					{sprite=rnd(s.clouds),x=112+rnd(10),y=rnd(10),mirror=rnd{true,false}}
				},
				scoops={},
				toppings={},
				order={scoops={},toppings={}},
				player=
				{
					{sprite=s.cones.small,x=58,y=92,dx=0,dy=0,dt=1,maxdx=5,maxdy=0,acc=1}
				},
				badorders={},
				clouds=
				{
					{sprite=rnd(s.clouds),x=rnd(32)+32,y=flr(rnd(10))-5,mirror=rnd{true,false},dx=rnd({1,2,3,-1,-2,-3}), dy=0,dt=4, maxdx=0, maxdy=0, acc=0},
					{sprite=rnd(s.clouds),x=rnd(32)+32,y=flr(rnd(10))-5,mirror=rnd{true,false},dx=rnd({1,2,3,-1,-2,-3}),dy=0,dt=4, maxdx=0, maxdy=0, acc=0}
				}
			}
			
			music(0)
			
		end
	end,
	park=function() -- park
		local cloud,scoop,mirror
		if timer==0 then 
			delay=5
			level=level+1
			if level== 2 then
				deli(e.cloud_cover,flr(rnd(#e.cloud_cover)+1))
				deli(e.cloud_cover,flr(rnd(#e.cloud_cover)+1))
			elseif level ==3 then
				e.cloud_cover={}
			end
			e.order={scoops={},toppings={}}
			e.badorders={}
			newcone=false
			timer=60
		end	
		if delay == 0 then
			if level==4 then
				e=
				{
					gray_cloudcover=
					{
						{sprite=s.clouds[2],x=-12,y=4,dx=0,dy=0},
					},
					purple_cloudcover=
					{
						{sprite=s.clouds[1],x=91,y=8}
					},
					white_cloudcover=
					{
						{sprite=s.clouds[1],x=6,y=17},
						
					},
					gray_clouds=
					{
						{sprite=s.clouds[1],x=-10,y=44,dx=1,dt=2, dy=0,mirror=false},
					},
					bigcone={sprite=s.cones.big,x=41,y=63}
				}
				fadeout=0
				fadein=100
				timer=3
				_draw=gs.draw.statistics
				_update=gs.update.statistics
				return
			end
			if (btnp(fire1)) then 
				showorder=not(showorder) 
				if newcone then
					while #e.player>1 do
						deli(e.player)
					end
					newcone=false
				end
			end
			if #e.order.scoops== 0 and #e.order.toppings==0 then
				showorder=true
				newcone=true
				e.scoops={}
				e.toppings={}
				if level==1 then
					for i=0,1 do
						add(e.order.scoops,{sprite=rnd(s.scoops),x=55,y=40-i*11,mirror=rnd({true,false}),dx=0,dy=0,dt=1, maxdx=0, maxdy=4, acc=0})
						
					end

				elseif level ==2 then
					for i=0,2 do
						add(e.order.scoops,{sprite=rnd(s.scoops),x=55,y=51-i*11,mirror=rnd({true,false}),dx=0,dy=0,dt=1, maxdx=0, maxdy=4, acc=0})
					end
				else  -- level 3
					for i=0,2 do
						mirror=rnd({true,false})
						add(e.order.scoops,{sprite=rnd(s.scoops),x=55,y=51-i*11,mirror=rnd({true,false}),dx=0,dy=0,dt=1, maxdx=0, maxdy=2, acc=0})
					end
					add(e.order.toppings,{sprite=rnd(s.toppings),x=50,y=29,mirror=false,dx=0,dy=1,dt=1, maxdx=0, maxdy=2, acc=0})
					
				end	
			end
			if not showorder then
				hit(e.player, e.scoops)	
				for p in all(e.player) do
					if (btn(left)) p.dx-=p.acc 
					if (btn(right)) p.dx+=p.acc 
					p.dx*=friction
					p.dx=mid(-p.maxdx,p.dx,p.maxdx)
				end	
				for s in all(e.scoops) do
					s.dy+=gravity
					s.dx=mid(-s.maxdx,s.dx,s.maxdx)
					s.dy=mid(-s.maxdy,s.dy,s.maxdy)
				end	
				for t in all(e.toppings) do
					t.dy+=gravity
					t.dx=mid(-t.maxdx,t.dx,t.maxdx)
					t.dy=mid(-t.maxdy,t.dy,t.maxdy)
				end	
				
				while (#e.clouds<4) do
					cloud={sprite=rnd(s.clouds),y=flr(rnd(15))-5,mirror=rnd{true,false},dx=rnd({1,2,3,-1,-2,-3}),dy=0,dt=4, maxdx=0, maxdy=0, acc=0}
					if (cloud.dx<0) then
						cloud.x = 128+flr(rnd(30))
					else
						cloud.x= -50-flr(rnd(30))
					end	
					add(e.clouds,cloud)
				end
				if (frame%12==0)then
					cloud=e.clouds[(frame\10)%#e.clouds+1]
					if rnd()<(#e.order.scoops+1)/(#e.order.scoops+#e.order.toppings+1) then
						--if #e.order.scoops>0 then
							scoop={x=min(max(cloud.x+flr(rnd(20))+5,5),110),y=cloud.y+10,mirror=rnd({true,false}),dy=1,dt=1, maxdx=3, maxdy=3, acc=0}
							scoop.dx= sgn(cloud.dx)
							scoop.dt=1
							if (rnd()<.6 or #e.order.scoops==0)  then
								scoop.sprite=rnd(s.scoops)
							elseif (#e.order.scoops>0) then
								scoop.sprite=e.order.scoops[1].sprite
							end

							if ((cloud.x >50 and cloud.dx> 0) or (cloud.x <64 and cloud.dx<0) ) scoop.dx=-scoop.dx

							add(e.scoops, scoop)
						--end
					else
						topping={x=min(max(cloud.x+flr(rnd(20))+5,5),110),y=cloud.y+10,mirror=rnd({true,false}),dy=1,dt=1, maxdx=3, maxdy=3, acc=0}
						topping.dx= sgn(cloud.dx)
						topping.dt=1
						if (rnd()<.6)  then
							topping.sprite=rnd(s.toppings)
						else
							topping.sprite=e.order.toppings[1].sprite
						end
						topping.animate=true

						if ((cloud.x >50 and cloud.dx> 0) or (cloud.x <64 and cloud.dx<0) ) topping.dx=-topping.dx
						add(e.toppings, topping)
					end	
				end
				
				move(e.player,{mode=wrap,x={-12,128}})
				move (e.clouds,{mode=remove,x={-50,128},y={-50,128}})
				move (e.scoops,{mode=remove,y={128,128},x={-50,128}})
				move (e.toppings,{mode=remove,y={128,128},x={-50,128}})
				for badorder in all(e.badorders) do
					move (badorder,{mode=remove,y={128,128},x={-50,128}})
					badorder[1].angle+=10
				end
			end
			if (frame%30 ==0) timer-=1
		else
			if (frame%12 ==0) delay-=1
		end	
		nextframe()
	end,
	statistics=function() -- conclusion
		if fadein >=0 then 
			fadein-=1
		elseif fadeout<101 then 
			fadeout+=1
		else	
			msgx=128
			fadeout=1
			fadein=100
			msg="global climate change and rainbow sprinkles are real. ice cream clouds are not. if you love this planet and the people on it, save the earth: drive less, eat less meat, switch to renewable energy, live in cities, and \^ivote\^-i for leaders who take this issue seriously before it's "
			stars=
			{
				{x=flr(rnd(32)), y=flr(rnd(32)), c=purple},
				{x=flr(rnd(32)), y=flr(rnd(32))+32, c=purple},
				{x=flr(rnd(32)), y=flr(rnd(32))+64, c=purple},
				{x=flr(rnd(32)), y=flr(rnd(32))+96, c=purple},
				{x=flr(rnd(32))+32, y=flr(rnd(32))+96, c=purple},
				{x=flr(rnd(32))+96, y=flr(rnd(32)), c=purple},
				{x=flr(rnd(32))+96, y=flr(rnd(32))+32, c=purple},
				{x=flr(rnd(32))+96, y=flr(rnd(32))+64, c=purple},
				{x=flr(rnd(32))+64, y=flr(rnd(32))+96, c=purple},
				{x=flr(rnd(32))+96, y=flr(rnd(32))+96, c=purple},
			}
			_draw=gs.draw.epilogue
			_update=gs.update.epilogue
			return
		end
		
		nextframe()
	end,
	epilogue=function() -- epilogue
		music(-1)
		if btnp(fire2) then
			_init()
		end
		if fadein >=0 then 
			fadein-=1
		elseif fadeout<101 then 
			fadeout+=1
		else	
			msgx-=1
		end
		for star in all(stars) do
			if (star.c==dark_purple) star.c=purple
			if (rnd()>.98) star.c=dark_purple
		end
		
		
	end
}
__gfx__
73337333333433330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000333113330000000000000000
33733333333c43330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000311111130000000000000000
73366633333b033300000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000114444110000400000000000
336666633300c03300000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000149449410004540000000b0b
366666663300003300000000000000000000bbbbbbbbbbbbbbbb4b4b4b4b4b4b4b4b4b4b4bbbbbbbbbbbbbbbb0000000000000001444444100004d0000000080
33330333300f0003000000000000000bbbbbbbbbbbb4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4bbbbbbbbbbbb0000000000344bb4430000000000400bdb
3303033330000f0300000000000bbbbbbbbb4b4b4b4b4b4b4b4444444444444444444444444b4b4b4b4b4b4b4bbbbbbbbb0000003344443300000000045400d0
3330333300f000000000000bbbbbbbb4b4b4b4b4b4444444444444444444444444444444444444444444b4b4b4b4b4bbbbbbbb003334433300000000004d00d0
00000000000000000000bbbbbbbb4b4b4b4b44444444444444445454545454545454545454444444444444444b4b4b4b4bbbbbbbb00000000000000000000000
00000000000000000bbbbbb4b4b4b4b444444444444545454545454545454545454545454545454545444444444444b4b4b4bbbbbbbb00000000000000000000
00000000000000bbbbbb4b4b4b4444444444545454545454545555555555555555555555555454545454545454444444444b4b4b4bbbbbb00000000000000000
00000000000bbbbbb4b4b4b4444444454545454545555555555555555555555555555555555555555555454545454544444444b4b4b4bbbbbb00000000000000
00000000bbbbbb4b4b4b44444454545454545555555555555555d5d5d5d5d5d5d5d5d5d5d55555555555555554545454545444444b4b4b4bbbbbb00000000000
000000bbbbb4b4b4b44444454545454555555555555d5d5d5d5d5d5d5d5d5d5d5d5d5d5d5d5d5d5d5d55555555555545454545444444b4b4b4bbbbb000000000
000bbbbb4b4b4b4444445454545555555555d5d5d5d5d5d5d5ddddddddddddddddddddddddd5d5d5d5d5d5d5d5555555555454545444444b4b4b4bbbb0000000
0bbbb4b4b4b44444454545455555555d5d5d5d5d5ddddddddddddddddddddddddddddddddddddddddddd5d5d5d5d5d55555555454545444444b4b4bbbbb00000
bb4b4b4b444444545454555555d5d5d5d5d5ddddddddddddddddedededededededededededddddddddddddddd5d5d5d5d5d555555454545444444b4b4bbbb000
b4b4b444444545454555555d5d5d5d5ddddddddddddededededededededededededededededededededddddddddddd5d5d5d5d5555554545454444b4b4b4bbb0
4b4b4444545454555555d5d5d5ddddddddddedededededededeeeeeeeeeeeeeeeeeeeeeeeeededededededededddddddddd5d5d5d5555554545454444b4b4bbb
b4444545454555555d5d5d5ddddddddddededededeeeeeeeeeefefefefefefefefefefefefeeeeeeeeeedededededddddddddd5d5d5d55555545454444b4b4b4
44445454555555d5d5d5ddddddedededededeeeeeefefefefefefefefefefefefefefefefefefefefefeeeeeededededededddddd5d5d5d55555545454444b4b
45454555555d5d5d5ddddddededededeeeeeefefefefefefefffffffffffffffffffffffffffefefefefefefeeeeeedededededddddd5d5d5d555545454444b4
54545555d5d5d5ddddddedededeeeeeefefefefefffffffffff00000000000000000000000fffffffffffefefefefeeeeeededededddddd5d5d5d5545454544b
45555d5d5d5ddddddedededeeeefefefefefffffff00000000000000000000000000000000000000000fffffffefefefefeeeededededddddd5d5d5555454544
5555d5d5ddddddedededeeeefefefeffffff00000000000000000000333333333322233300000000000000000ffffffefefefeeeededededddddd5d555545454
5d5d5ddddddedededeeeefefeffffff0000000000000000000000000322233333b222b330000000000000000000000ffffffefefeeeededededddd5d5d555545
d5d5ddddedededeeeefefefffff000000000000000000000000000002277223322bbb22300000000000000000000000000fffffefefeeeededededddd5d55554
5ddddedededeeeefefeffff0000000000000000000000000000000007777772322222223000000000000000000000000000000ffffefefeeeedededddd5d5d55
ddddededeeeefefeffff000000000000000000000000000000000000f777777f22bbb223000000000000000000000000000000000ffffefefeeeedededddd5d5
dededeeeefefeffff0000000000000000000000000000000000000003f777ff33b222b33000000000000000000000000000000000000ffffefefeedededddd5d
ededeefefeffff000000000000000000000000000000000000000000337ff33333222333000000000000000000000000000000000000000ffffefeeeedededdd
deeeefeffff0000000000000000000000000000000000000000000003333333333333333000000000000000000000000000000000000000000ffffefeededede
eefeffff0000000000000000000000000000000f0fff0f0f000000000000000000000000ff0000000000000000000000000000000000000000000ffefeeeeded
efefff000000000000000000000000000009effefe0efe9effe0f000000000000000000000f0000000000000000000000000000000000000000000ffffefeede
ffff00000000000000000000000000000fefffdffffffdf0f0f0f0f00000000000000000000f00000000000000000000000000000000000000000000fffefeee
f000000000000000000000000000000fe9f7d7f7f7d7fffefdfe90e0f00000000000000000bbb000000000000000000000000000000000000000000000ffffef
00000000000000000000000000000feffef77777777777fdffffe9f0e9000000000000000bbbbb00000000000000000000000000000000000000000000000fff
000000000000000000000000000feff77f7777727777777f0ef0fdff00e0f000000000000bbb8b0000000000000000000000000000000000000000000000000f
00000000000000000000000000fef777727777efd7727d7ff77e0fefe90f0f00000000000bbbbb00000000000000000000000000000000000000000000000000
00000000000000000000000007e772727d72d777772d7277efd9fe9f90e000e00000000000bbb000000000000000000000000000000000000000000000000000
0000003533000000000000007e7f772d22277777df7f77777907ffd0ef9e90f00000000000090000111111900000000000000000000000000000091111110000
0000033353300000000000077777e77e72772277277f777277e9e0ff7d0f0e0f0000000000999000111111111111900000000000000000091111111111110000
00003333535300000000007777777777f722722d297dfdfdfd9ffe9eff70f0f0e000000009999900099991111111111111111111111111111111119999900000
000035553335000000000f7e77677e7222272d927722fff0e9e0fd9ffefe00e09e00000099199990099119999999111111111111111111119999991111900000
000533333553300000000e777277772267227fff222229df0e7f9fe9d9ff0e0900f0000099991990099191911111999999999999999999991111919111900000
00033533333350000000efe77e77e722777227d722272d0ff0fedf97fe00e0fe0f0e000099911990009911191119111911191119111911191119111919000000
0035533533553300000feff7e7fe77227e727222322d9ff0fdf77fdf090f00f00000900009999900009911119191111191911111919111119191111199000000
0003333355333000000ef7efefe9727e7702272222f907d90ff7fdf0ed0e0e0fe0f0e00000999000000991111911111119111111191111111911111190000000
000005333335000000fe7ef0e9ef77727772d772fd1d729fd9d277ffffff0f0e000e000000000000000991119191111191911111919111119191111190000000
000000055500000000effefef72e77227e227f775fff9d9d277272d9df00e0e0f0f00f0000000000000099191119111911191119111911191119111900000000
00000000000000000fefe7efe777e22272223222dffd9790927f7fff90e00ff0e00e000000999000000099911111919111119191111191911111919900000000
00000000000000000e9efe97ef22f726273227d19f19d9d90d777d1dfe0efe070f00f0e009999900000099111111191111111911111119111111191900000000
00000000000000000fefefefe722267727e7f1f9d1d999fd9ffd17229ff0f0f70e00000099199990000009911111919111119191111191911111919000000000
00000000000000000efe7fef722272f7220fd1d79717d9d90d921222277e777e00fe0e0f99991990000009991119111911191119111911191119119000000000
0000000000000000efef7e7e722222277e0f17115f79199d19d1d222222027f0f000f00099911990000000999191111191911111919111119191110000000000
0000000000000000fefefe7f772762727f079d1779d1d9d9f777232227df070e0e0e00e909999900000000991911111119111111191111111911190000000000
0000008b88000000efe7ef77722722277e77121715ff1d12d1222f7d0ff72e0f00f0e09000000000000000999191111191911111919111119191190000000000
00000888b8800000feffef772727e2272722d721d71d11729722d1df222e900e0e0f00e000000000000000099119111911191119111911191119900000000000
00008888b8b80000efeef7e722677277272232232212171d9d2f9d9000e00e00f0e0e09000000000000000099111919111119191111191911111900000000000
00008bbb888b00007efe7e77e73222222272232217575d9912ddf0f0e00f0e0e0e0ff0e009999900000000009911191111111911111119111119000000000000
000b88888bb88000e7efefef7e227722272772227d17ff12d0000e0fe9e0e0f0f0f0e00f99191990000000009911919111119191111191911119000000000000
00088b888888b00077eff77effe2222262e32237997571d000e00f0fe000f0e0e0e00f0e99911990000000009919111911191119111911191119000000000000
008bb88b88bb8800e7feeef7eff722777222777fdd972d1fe00f00e00e0e0f0f7f0fe00f09999900000000000991111191911111919111119190000000000000
00088888bb88800077e7fefefee227ef7f322772729757700f0e0e07fff0efe777e90e9000999000000000000991111119111111191111111990000000000000
00000b88888b0000e27e7fefeff27e7e072f277777d17710e00ef0000ef0f0fe7f70e0f00000e000000000000991111191911111919111119190000000000000
0000000bbb000000f77272efefefefffefe77777177d9d1e0f0f2fef0fe0ef0f77e900e0d0c00000000000000099111911191119111911191900000000000000
0000000000000000ee2322efefe0e0e0f7ff7f777d999d10f077327e00f0efe070e0e00000008000000000000099919111119191111191911900000000000000
00000000000000000772277efe0fe0fe0efefd7f3fe0f9d72322722fe0ef00f7efff0f0005000000000000000009991111111911111119119000000000000000
00000000000000000e7e7273efe77ef2e2f07ffd7f9e00f77027d277fff0777f79e0e0e000000000000000000009919111119191111191919000000000000000
00000000000000000fe7e7effefe7feffefef23fe7f0e0ef0e00ff7fe0e777df7dff0f000000e000000000000009911911191119111911199000000000000000
0000000000000000007e7efeef7fef02e0f207e0f0ef0f00e0ef0e2277ff7f77ff0e00000b000000000000000000991191911111919111190000000000000000
000000000000000000ef7ef7efee7272fefe7e9e0ef7efe0f0efef27d77d272dfe99d00000000000000000000000991119111111191111190000000000000000
000000191100000000f7e7eefeffef2e72f0e9ef0f007ffe0e00e00effefefdf00d0f00000000e00000000000000099191911111919111900000000000000000
0000011191100000000e2efefeefefe772e722777e7e7770e92ef720777f7777770e0000d0c00000000000000000099911191119111911900000000000000000
000011119191000000007e7e7fefefe7ef2effef7f7727277e77f72777f777277f09000000008000000000000000099111119191111191900000000000000000
00001999111900000000e8efeefef7effe0e0e27efe2fe0efff7e77672727277dfe0000000500000000000000000099111111911111119000000000000000000
00091111199110000000072efefeef77efeff7270ef7727e77eff7e77272772d9000000000000000000000000000009911119191111199000000000000000000
0001191111119000000000e7efeffeefe0efefee7fe07e7972772e2227dfdd0fe900000000000000000000000000009911191119111919000000000000000000
0019911911991100000000f727ee7efefefe7ef77e727777efe22272777fe9e09e0000000b0e0000000000000000000991911111919190000000000000000000
00011111991110000000000e277efefee0efe977eff77272e2272727777f0f0f0000000000000000000000000000000999111111191190000000000000000000
000009111119000000000000f77efe77fefe07ee9ee72672272722627777ffe00000000000000000000000000000000099911111919900000000000000000000
0000000999000000000000000e77e77efefe727fe877277e72e2727272efdf000000000000000000000000000000000099191119111900000000000000000000
000000000000000000000000000e827e7e7fefe7e7722777777727767777f0000000000000000000000000000000000099119191111900000000000000000000
0000000000000000000000000000e7277efe7777772ee776776776777ef0000000000000c00b0000000000000000000009911911119000000000000000000000
00000000000000000000000000000fe77e77e7ee77777e7fe7777777e90000000000000000a08000000000000000000009919191119000000000000000000000
0000000000000000000000000000000fe77e7e77eeefefef7777677e000000000000000050000000000000000000000000991119190000000000000000000000
0000000000000000000000000000000000e7e77787e77e7eeefeff000000000000000000000b0e00000000000000000000991111990000000000000000000000
0000000000000000000000000000000000009efe6777e777ff00000000000000000000000e000000000000000000000000091111190000000000000000000000
000000dadd0000000000004c44000000000000000000000000000000000333333330000000000000000000000000000000091111900000000000000000000000
00000d9dadd0000000000444c4400000000000000000000000000023333333333333300000000000000000000000000000099119900000000000000000000000
0000dddda9ad000000004444c4c40000000000000000000000003333333333333333330000000000000000000000000000099191900000000000000000000000
0000d9a9ddda000000004ccc444c0000000000000000000000233333333333333333333000000000000000000000000000009919000000000000000000000000
000addddda9dd000000c44444cc44000000000000000000000333333333333333333333300000000000000000000000000009919000000000000000000000000
000dda9d9ddda00000044c444444c000000000000000000333333333333233333333333320000000000000000000000000000910000000000000000000000000
00da9ddadda9dd00004cc44c44cc4400000000000003333233333332333322333333332333333000000000000000000000000910000000000000000000000000
000ddd9daaddd00000044444cc444000000000000033333222333223333333222333223333333330000000000000000000000000000000000000000000000000
00000addddda000000000c44444c0000000000000333333332222333333333332222333333233332000000000000000000000000000000003333222223333333
0000000aaa0000000000000ccc000000000000003333333333333333333333333333233322333333000000000000000000000000000000003322222222233333
0000000000000000000000000000000000000000333333333333333233323333333332223333333320000000000000000000d0500000000032b2222222b23333
00000000000000000000000000000000000000003333323333333332222333333333333333333332200000000000000000000d0d00000000322bb222bb223333
000000000000000000000000000000000000000023333233333333223333333333333333333333320000000000000000000000d00000000022222bbb22222333
00000000000000000000000000000000000000000233332333322233333333333333333333333332000000000f000000050d00000f0000002222222222222333
0000000000000000000000000000000000000000002233333333333333322333333323333333332200000000f7f00000d0d00000f7f000002222222222222333
00000000000000000000000000000000000000000000222222233333322333333333323333333220000000000fd0000000000000df00000022222bbb22222333
000000331300000000111111111110000000000000000002222222222333333333333322333322000000000000000000b0b0000000000b0b322bb222bb227333
000003313330000000099999999900000000000000000000000000002233333333333200022220000000000000000000080000000000008032b2222222b20333
0000311333110000000191919191000000000000000000000000000002222222333220000000000000000000050d0000bdb0000000000bdb372222222220f333
0000333331330000000111111111000000000000000000000000000000022222222000000000000000000000d0d00000dd000b0bb0b000dd33f02222200f3333
00013331133310000001191919110000000000000000000000000000000000000000000000000000000000000d0000000dd0008008000dd03333f0000f333333
00031133333130000000111111100000000000000000000000000000000000000000000000000000000000000000d0500d000bdbbdb000d03333333333333333
001333113313330000001919191000000000000000000000000000000000000000000000000000000000000000000d0d000000d00d0000003333333333333333
000113331133100000001111111000000000000000000000000000000000000000000000000000000000000000000000000000d00d0000003333333333333333
00000333333100000000019191000000000000000003333333000000000000000000000000000000dd00000000000000000000000004000000000000000000dd
00000003330000000000011111000000000000000333333333330000000000000000000000000000dad000000000000000000000004540000000000000000dad
00000000000000000000011911000000000000003333333333333333000000000000000000000000daad000000000000000000000004d000000000000000daad
00000000000000000000001110000000000000033333333333333333300000000000000f00000000aaad00dd00000000000000000400000000000000dd00daaa
0000000000000000000000191000000000033333333333333323333223330000000000f7f0000000dadd0ddad000000000000000454000400000000dadd0ddad
00000000000000000000001110000000003333332333333333322223333330000000000fd0000000addadaadda0a000000000000d40004540000a0addaadadda
00000000000000000000000100000000033333333223333333333333333330000000000000000000aadaddddadada000d00000000000004d000ddaaaddddadaa
00000000000000000000000100000000033333333332233323333333333330000000000000f00000addaadaddaadaa0ada00000000000000000adaaddadaadda
000000400000000000000000000000003333333333333222332333333333000000000f000f7f00001da0aadaaadadaadada000000000000000ddadaaadaa0ad1
04000454000000000000000000000000333333333333333333323333333000000000f7f000fd00001da009a09aadddaaddd000000000000000aadaa90a900ad1
4540004d000000000000000000000000333333333333323333332222220000000000df000000000011a00909aaddaadddaaa0000000000000addadda90900a11
04d000000000000000000000000000000333333333322333333333200000000000000000000000001a00009900aaa0aaaaa000000000000000aaaaa0990000a1
00000000000000000000000000000000002333333222333333333200000000000000000000000000100000990001000010000000000545000000100099000001
00000000000000000000000000000000000233322333333333332000000000000000000000000000100000990001000000000000000050000000000099000001
000000000000000000000000000000000000222022222332222200000000000000000000000000001000009900000000000000000000d0000000000000000001
000000000000000000000000000000000000000000022222220000000000000000000000000000001000000000000000000000000000d0000000000000000000
__label__
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccc66666666ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccd66666666666666ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccc666666666666666666cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccd66666666666666666666ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccc6666666666666666666666ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccdddddddccccccccccccccccccc
ccc666666666666d666666666666dcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccdddddddddddccccccccccccccccc
666d6666666d6666dd66666666d666666cccccccccccccccccccc7c7c7ccccc7c7ccc7c7c7cccccccccccccccccccccccccddddddddddddddddccccccccccccc
666ddd666dd6666666ddd666dd666666666cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccddddddddddddddddddcccccccccccc
66666dddd66666666666dddd666666d6666dccccccccccccccccccc7ccccc7ccccccc7ccccccccccccccccccccccccddddddddddddddd0dddd00dddccccccccc
666666666666666666666666d666dd666666cccccccccccccccccccccccccccccccccccccccccccccccccccccccccdddddd0dddddddddd0000ddddddcccccccc
66666666666d666d666666666ddd66666666ccccccccccccccccccc7ccccc7ccccccc7c7ccccccccccccccccccccdddddddd00ddddddddddddddddddcccccccc
6d666666666dddd66666666666666666666dccccccccccccccccccccccccccccccccccccccccccccccccccccccccdddddddddd00ddd0ddddddddddddcccccccc
6d66666666dd66666666666666666666666dccccccccccccccccccc7ccccc7ccccccc7cccccccccccccccccccccddddddddddddd000dd0dddddddddccccccccc
66d6666ddd6666666777777766666666666dcccccccccccccccccccccccccccccccccccccccccccccccccccccccddddddddddddddddddd0dddddddcccccccccc
6666666666666667777777777766666666ddccccccccccccccccc7c7c7ccccc7c7ccc7c7c7cccccccccccccccccddddddddddddd0dddddd000000ccccccccccc
ddddddd666666d7777777777777777666ddcccccccccccccccccccccccccccccccccccccccccccccccccccccccccdddddddddd00ddddddddd0cccccccccccccc
cccdddddddddd7777777777777777776ddccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0dddddd000ddddddddd0ccccccccccccccc
ccccccccc7777777777777776777766777cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0ddd00ddddddddddd0cccccccccccccccc
cccccccc777777677777777776666777777cccccccccccc7c7ccc7c7c7ccc7c7c7ccc7c7c7ccc7c7c7ccccccccccccc000c00000dd00000ccccccccccccccccc
ccccccc7777777766777777777777777777ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000ccccccccccccccccccc
ccccccc7777777777667776777777777777cccccccccc7ccccccc7ccc7ccc7ccccccc7ccc7ccc7c7c7cccccccccccccccccccccccccccccccccccccccccccccc
cccccc7777777777777666776777777777cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccc777777777777777777767777777cccccccccccc7ccccccc7c7ccccc7c7ccccc7c7c7ccc7ccc7cccccccccccccccccccccccccccccccccccccccccccccc
cccccc77777777777776777777666666cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccc7777777777667777777776cccccccccccccccc7ccccccc7ccc7ccc7ccccccc7ccc7ccc7ccc7cccccccccccccccccccccccccccccccccccccccccccccc
cccccccc67777776667777777776cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccc677766777777777776cccccccccccccccccccc7c7ccc7ccc7ccc7c7c7ccc7ccc7ccc7ccc7cccccccccccccccccccccccccccccccccccccccccccccc
cccccccccc666c666667766666cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccc6666666cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccc7c7ccc7ccccccccc7c7ccc7ccc7ccc7c7ccccccc7c7cccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccc7ccccccc7ccccccc7ccc7ccc7ccc7ccc7ccc7ccc7cccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccc7ccccccc7ccccccc7ccc7ccc7ccc7ccc7ccc7ccc7c7c7cccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccc7ccccccc7ccccccc7ccc7ccc7ccc7ccc7ccc7ccccccc7cccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccc7c7ccc7c7c7ccc7c7ccccccc7c7ccc7c7c7ccc7c7cccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccc77777cccccc777cc77ccccc777c7ccc777c7c7ccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccc77c7c77cccccc7cc7c7ccccc7c7c7ccc7c7c7c7ccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccc777c777cccccc7cc7c7ccccc777c7ccc777c777ccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccc77c7c77cccccc7cc7c7ccccc7ccc7ccc7c7ccc7ccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccc77777ccccccc7cc77cccccc7ccc777c7c7c777ccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccc444444kcccccccccccccccccccccccccccccck444444ccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccc444444444444kcccccccccccccccccck444444444444ccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccckkkk444444444444444444444444444444444kkkkkcccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccckk44kkkkkkk44444444444444444444kkkkkk4444kcccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccckk4k4k44444kkkkkkkkkkkkkkkkkkkk4444k4k444kcccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccckk444k444k444k444k444k444k444k444k444k4kccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccckk4444k4k44444k4k44444k4k44444k4k44444kkccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccckk4444k4444444k4444444k4444444k444444kcccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccckk444k4k44444k4k44444k4k44444k4k44444kcccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccckk4k444k444k444k444k444k444k444k444kccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccckkk44444k4k44444k4k44444k4k44444k4kkccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccckk4444444k4444444k4444444k4444444k4kccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccckk44444k4k44444k4k44444k4k44444k4kcccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccckkk444k444k444k444k444k444k444k44kcccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccckkk4k44444k4k44444k4k44444k4k444ccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccckk4k4444444k4444444k4444444k444kccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccckkk4k44444k4k44444k4k44444k4k44kccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccckk44k444k444k444k444k444k444kkcccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccckk444k4k44444k4k44444k4k44444kcccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccckk444k4444444k4444444k44444kccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccckk44k4k44444k4k44444k4k4444kccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccckk4k444k444k444k444k444k444kccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccckk44444k4k44444k4k44444k4kcccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccckk444444k4444444k4444444kkcccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccckk44444k4k44444k4k44444k4kccc77777777ccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccckk444k444k444k444k444k4677777777777777ccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccckkk4k44444k4k44444k4k777777777777777777cccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccckkk4444444k4444444677777777777777777777ccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccckk4k44444k4k44444k7777777777777777777777cccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccckk44k444k444k4477777777777767777777777776ccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccckk44k4k4447777677777776777766777777776777777ccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccckk444k4447777766677766777777766677766777777777ccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccckk4k4k4777777776666777777777776666777777677776cccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccckkk4447777777777777777777777777777677766777777cccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccckk44447777777777777776777677777777766677777777cccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccckk44447777767777777776666777777777777777777776cccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccckk4446777767777777766777777777777777777777776cccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccckk444k677776777766677777777777777777777777776cccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccckk4k4466777777777777777667777777677777777766cccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccckkk4444466666667777776677777777776777777766ccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccckkk44444k46666666666777777777777766777766cccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccckk4k444k444kccccccc66777777777776ccc6666ccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccckk44k4k4444kcccccccc666666677766ccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccckk44k4444kccccccccccc66666666ccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccckk4k4k444kcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccckk444k4kccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccckk4444kkccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccck44444kccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccck4444kcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccckk44kkcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccckk4k4kcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccckk4kccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccckk4kccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccck4cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccck4cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
__map__
000002030405060707090a0b0c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
101112131415161717191a1b1c1d1e1f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
202122232425262727292a2b2c2d2e2f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30313233340000000000003b3c3d3e3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40000000000000000000000000004e4f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eaebec0000000000000000000000eeef00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fafbfc0000000000000000000000feff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000cd00e8e900fd00cb0f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccf80eddddf8cdedf8f9f000db0e0edc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
410200003c5703c5703c5703c5603c5603c5603c5503c5503c5403c5403c5403c5303c5303c5703c5703c5703c5603c5603c5603c5503c5503c5403c5403c5403c5303c5303c5303c5203c5203c5203c5103c515
6d0220003c5703c5703c5703c5603c5603c5603c5503c5503c5403c5403c5403c5303c5303c5703c5703c5703c5603c5603c5603c5503c5503c5403c5403c5403c5303c5303c5303c5203c5203c5203c5103c515
930108003c6313c6313c6313c6213c6213c6213c6113c6113c6003c6003c6003c6000c600266002560022600206001d6001a6001a6001a6001c6001d6001e6001f600226002a6001d6001c6001a6001960018600
010800003275432750007000070032754327503275032750007000070000700007000070000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
450f06001407014072140721407214032140150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d11e001f005021f5351f5351f5351f5321f5351c5321c535185021f5351e5351c5351a5351f5351a5321a535005021a5351a5351a5351a5351e53515532155351a5021a5351a5351a5351f53517532175351a535
__music__
02 20614040
04 42404040



