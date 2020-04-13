	-- by isl02
	--v 1.4.8.8
	local c = require('component')
	local term = require('term')
	local fs = require('filesystem')
	local shell = require("shell")
	local comp = require('computer')
	local r = require("robot")
	local sides = require("sides")
	local tab = require("table")
	local math = require("math")
	local maxEnergy = comp.maxEnergy()
	local waypoints = {}
	local chargeStation
	local invSlots = r.inventorySize()
	local wateringCan
	local lite 
	local arg = {...}

		term.clear()
		print("AgriCraftBot by isl02")
		print("Для проекта MCSkill.ru Сервер DraconicTech")
		os.sleep(2)
			

		if (not c.isAvailable("navigation")) or arg[1] == "-lite" then 	 
		print('Улучшение "Навигация" не найдено. Переход в лайт режим') lite = true os.sleep(2)
else		
		print('Улучшение "Навигация" найдено!')
		lite = false
			function delSettings()
			term.clear()
			print("Удаление настроек...")
			if (fs.exists(shell.getWorkingDirectory() .. "/settings.cfg")) then os.remove(shell.getWorkingDirectory() .. "/settings.cfg") end
			os.sleep(2)
			print("Настройки были успешно удалены!")
			os.exit()
		end
		nav = c.proxy(c.list("navigation")())
			f0 = { --f0[1] - центр f0[2-6] - коорды для остановок; для остальных такая же система
			{-2,-1,-2},	
			{-4,-1,-1},
			{0,-1,-2},
			{-4,-1,-3},
			{0,-1,-4},
			{-4,-1,-4}}
			
			f1 = {
			{2,-1,-2},
			{4,-1,-1},
			{0,-1,-2},
			{4,-1,-3},
			{0,-1,-4},
			{4,-1,-4}}
			
			f2 = {
			{2,-1,2},
			{4,-1,1},
			{0,-1,2},
			{4,-1,3},
			{0,-1,4},
			{4,-1,4}}
			
			f3 = {
			{-2,-1,2},
			{-4,-1,1},
			{0,-1,2},
			{-4,-1,3},
			{0,-1,4},
			{-4,-1,4}}

if not (fs.exists(shell.getWorkingDirectory() .. "/settings.cfg") ) then
print("Приветствую тебя! Сейчас будет первая настройка, давай разберемся с некоторыми параметрами.")
print("Выбери путевую точку. Если не видишь её, поставь название или поставь робота поближе.")
local point = nav.findWaypoints(12)
	for i = 1, #point do
		pointName = point[i].label
		table.insert(waypoints, point[i].label)
		print(i .. ") " .. pointName) 
	end
chargeStation = waypoints[io.read()*1]
file = io.open('settings.cfg', 'a')
file:write(chargeStation)
file:flush()
print("Робот смотрит в правильную сторону? (правый верхний угол фермы?) Y/N")
local answer = io.read()
if answer == 'Y' or answer == 'y' then side = nav.getFacing()
elseif answer == 'N' or answer == 'n' then print('Напиши в какую сторону нужно ехать роботу (правый верхний угол фермы) Как на F3 координата f. Допустимые значения: [0-3]')
local tmpResult = io.read()*1
	if tmpResult == 0 then side = 3
	elseif tmpResult == 1 then side = 4
	elseif tmpResult == 2 then side = 2
	elseif tmpResult == 3 then side = 5
	else print("Введено некорректное значение. Запустите программу заново.") os.sleep(1) file:close() delSettings() end
else print("Введено некорректное значение. Запустите программу заново.") os.sleep(1) file:close() delSettings() end
file:write("\n"..side)
file:flush()
print("Будем пользоваться лейкой (укреплённой)? Y/N")
local answer = io.read()
if answer == 'Y' or answer == 'y' then
	wateringCan = 'true'
elseif answer == 'N' or answer == 'n' then
	wateringCan = 'false'
else print("Введено некорректное значение. Запустите программу заново.") os.sleep(1) file:close() delSettings() end
file:write("\n"..wateringCan)
file:flush() --сохранить файл (аварийно), можно и не использовать
file:close() --сохранить и выгрузить файл			
else
file = io.open("settings.cfg","r")
chargeStation = file:read()
side = file:read()*1
wateringCan = file:read()
file:close()
if chargeStation == nil then print("Настройки были неправильно сохранены или нарушены: название путевой точки. Сброс настроек... " .. chargeStation) os.sleep(2) delSettings() end
if side ~= 2 and side ~= 3 and side ~= 4 and side ~= 5 then print("Настройки были неправильно сохранены или нарушены: сторона света. Сброс настроек... " .. side) os.sleep(2) delSettings() end
if wateringCan ~= 'true' and wateringCan ~= 'false'  then print("Настройки были неправильно сохранены или нарушены: наличие лейки. Сброс настроек... " .. wateringCan) os.sleep(2) delSettings() end
end
		if side == 2 then mainCoords = f2
		elseif side == 3 then mainCoords = f0
		elseif side == 4 then mainCoords = f1
		elseif side == 5 then mainCoords = f3 end

end

if not lite then 
function getRightSide(rs)
			if nav.getFacing() ~= rs then 
			curSide = nav.getFacing()
				while (curSide ~= rs) do
				r.turnRight()
				curSide = nav.getFacing()
				end
			end
		end
			
			
function getCurPos(s)
point = nav.findWaypoints(12)
for p = 1, #point do
	if point[p].label == chargeStation then
		position = point[p].position
		break
	end
end
if position == nil then print("Не могу найти путевую точку. Проверьте название точки.") os.exit() end
if s == 1 then return(position[1])
elseif s == 2 then return(position[2])
elseif s == 3 then return(position[3]) end
end
			
			
function autoGo(xyz) --x увеличивается на side = 1(4) || уменьшается на side = 3(5) .. z увел на side = 2(2) || умен на side = 0(3)
	xSteps = getCurPos(1)
	ySteps = getCurPos(2)
	zSteps = getCurPos(3)
	if xSteps > xyz[1] then 
		getRightSide(5)
		while (xSteps ~= xyz[1]) do
			r.forward()
			xSteps = getCurPos(1)
		end
	elseif xSteps < xyz[1] then
		getRightSide(4)
		while (xSteps ~= xyz[1]) do
			r.forward()
			xSteps = getCurPos(1)
		end
	end
	
	if ySteps < xyz[2] then 
		while (ySteps ~= xyz[2]) do
			r.down()
			ySteps = getCurPos(2)
		end
	elseif ySteps > xyz[2] then
		while (ySteps ~= xyz[2]) do
			r.up()
			ySteps = getCurPos(2)
		end
	end

	if zSteps > xyz[3] then
		getRightSide(3)
		while (zSteps ~= xyz[3]) do
			r.forward()
			zSteps = getCurPos(3)
		end
	elseif zSteps < xyz[3] then 
		getRightSide(2)
		while (zSteps ~= xyz[3]) do
			r.forward()
			zSteps = getCurPos(3)
		end
	end	
end
		
function autoGoUse(xyz) --x увеличивается на side = 1(4) || уменьшается на side = 3(5) .. z увел на side = 2(2) || умен на side = 0(3)
	xSteps = getCurPos(1)
	ySteps = getCurPos(2)
	zSteps = getCurPos(3)
	if xSteps > xyz[1] then 
		getRightSide(5)
		while (xSteps ~= xyz[1]) do
			r.useDown()
			r.suckDown()
			r.forward()
			xSteps = getCurPos(1)
		end
	elseif xSteps < xyz[1] then
		getRightSide(4)
		while (xSteps ~= xyz[1]) do
			r.useDown()
			r.suckDown()
			r.forward()
			xSteps = getCurPos(1)
		end
		r.useDown()
	end
	r.useDown()
	
	if ySteps < xyz[2] then 
		while (ySteps ~= xyz[2]) do
			r.down()
			ySteps = getCurPos(2)
		end
	elseif ySteps > xyz[2] then
		while (ySteps ~= xyz[2]) do
			r.up()
			ySteps = getCurPos(2)
		end
	end

	if zSteps > xyz[3] then
		getRightSide(3)
		while (zSteps ~= xyz[3]) do
			r.useDown()
			r.suckDown()
			r.forward()
			zSteps = getCurPos(3)
		end
	elseif zSteps < xyz[3] then 
		getRightSide(2)
		while (zSteps ~= xyz[3]) do
			r.useDown()
			r.suckDown()
			r.forward()
			zSteps = getCurPos(3)
		end
		r.useDown()
	end
	r.useDown()
end
		
		
function poliv()
	autoGo(mainCoords[1])
	r.down()
	for a = 0, 20 do
		r.useDown(sides.bottom,true,10000)
	end 
	r.up()
	autoGo({0,-1,0})
end
		
		
function startPosition()
	autoGo({0,-1,0})
	getRightSide(side)
end
			
			
function gett()
	autoGoUse({0,-1,0})
	autoGoUse(mainCoords[2])
	autoGoUse(mainCoords[3])
	autoGoUse(mainCoords[4])
	autoGoUse(mainCoords[5])
	autoGoUse(mainCoords[6])
end		
		
function checkBattery()
	local compEnergy = comp.energy()
	if maxEnergy/10 > compEnergy then startPosition() 
		while compEnergy ~= maxEnergy-500 do
			compEnergy = comp.energy()
			end
		end
	end
	
function drop()
	startPosition()
	r.turnRight()
	for k = 1, invSlots do
		r.select(k)
		r.drop()
	end
	r.turnLeft()
end
end

function main()	
	term.clear()
	if not lite then print("Загружены настройки: \nНазвание точки: " .. chargeStation) end
	print('Начало работы через 3 секунды...')
	os.sleep(3)
	while(true) do
		if not lite then 
		checkBattery()
		if wateringCan == 'true' then poliv() end
		drop()
		gett()
		else liteMode()
		end
	end
end

function liteMode()
local function dropLite()
r.turnRight()
for k = 1, invSlots do
	r.select(k)
	r.drop()
end
r.turnLeft()
end

function checkBatteryLite()
local compEnergy = comp.energy()
if maxEnergy/10 > compEnergy then 
	while compEnergy ~= maxEnergy-500 do
		compEnergy = comp.energy()
	end
end
end
		
local function returning(k)
		if math.fmod(k,2) == 1 then r.turnAround() 	isPass = r.detect()
		while not isPass do
			r.forward()
			isPass = r.detect()
		end
		r.turnRight()
		isPass = r.detect()
		while not isPass do
			r.forward()
			isPass = r.detect()
		end
		r.turnAround()
		else r.turnAround() isPass = r.detect()
		while not isPass do
			r.forward()
			isPass = r.detect()
		end
		r.turnLeft()
		end
	i = 1
	checkBatteryLite()
	dropLite()
	end
	
	i = 1
	while true do 
		isPass = r.detect()
			while not isPass do
				r.useDown()
				r.suckDown()
				r.forward()
				isPass = r.detect()
			end
			r.useDown()
			r.suckDown()
			if math.fmod(i,2) == 1 then r.turnLeft() isPass = r.detect() if isPass then returning(i) else r.forward() r.turnLeft() i = i + 1 end
			else r.turnRight() isPass = r.detect() if isPass then returning(i) else  r.forward() r.turnRight() i = i + 1 end
			end
	end
end
	



main()