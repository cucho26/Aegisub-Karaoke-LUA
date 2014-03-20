-- Karaskel necesario para interacruar con aegisub
include("karaskel.lua")
-- Zheolib.lua libreria auxiliar, necesaria para trabajar con los sistema de tag, que usaremos en esta guía
include("zheolib.lua")

-- El nombre que aparecera en automation de aegisub
script_name = "OP Opening 629"
-- Descripcion que aparecera en automation de aegisub
script_description = "One Piece Opening Cap 629"
-- 
script_author = "Cucho"
script_version = "0.1"

-- Esta funcion es la encargada de realizar los cambios en los subtitulos timeados en aegisub
function fx_zheolib(subs)
	aegisub.progress.task("ESPERA MIESTRAS SE HACE EL FX... (Sale a dar una vuelta D:)")
	local meta, styles = karaskel.collect_head(subs)
	aegisub.progress.task("Aplicando tu FX D:")
	local i, ai, maxi, maxai = 1, 1, #subs, #subs
	while i <= maxi do
		aegisub.progress.task(string.format("Esto llevo trabajado (%d/%d)...", ai, maxai))
		aegisub.progress.set((ai-1)/maxai*100)
		local l = subs[i]
		if l.class == "dialogue" and
				not l.comment and
				-- l.style: el o los estilos que recibiran los efectos
				(l.style == "Romaji" or l.style == "Romaji-Coro") then
				karaskel.preproc_line(subs, meta, styles, l)
			do_fx(subs, meta, l)
			maxi = maxi - 1
			subs.delete(i)
		else
			i = i + 1
		end
		ai = ai + 1
	end
	aegisub.progress.task("Por fin termine D:!")
	aegisub.progress.set(100)
	aegisub.set_undo_point("fx_zheo")
end

-- 
function do_fx(subs, meta, line)
	for i = 1, line.kara.n do
		local syl = line.kara[i]
		local x=syl.center + line.left
		-- + 35: es la separacion de las lineas de karaoke con respecto al borde superior del video
		local y=line.margin_v + 35
		if i==1 then
	tempo=0
end

-- funcion encargada de tomar la silaba libre de tag de aegisub
function sil()
silaba = ""..syl.text_stripped..""
		return silaba
end

-- Condicion para limpiar espacios en blanco y asi estos no reciban efectos
if sil() == " " or sil() == "" then
l.text = ""
else

-- Variable alternativa para generar tiempos progresivos
tempo=tempo+(1000/line.kara.n)

-------------------------------------------------------------------------------
--Bloque de Entrada de la linea a la pantalla--
l = table.copy(line)
-- Combinacion de tag de aegisub para generar los efectos, utilizando la forma Zheolib.lua.
l.text = "{"..an(5)..fad(420,0)..color(1,'ffffff')..move(x-100,y,x,y,0,350)..fscxy(60)..frx(180)..t(tt(0,700,0.8)..frx(0)..fscxy(100)).."}"..sil()
-- l.start_time: nuevo tiempo de inicio de los tiempo de la linea. -- line.start_time: tiempo original de inicio de los tiempos de la linea.
l.start_time = line.start_time - 1500 + tempo
-- l.end_time: nuevo tiempo de final de los tiempos de la linea.
l.end_time = line.start_time - 800 + tempo
-- Nivel de capa de la linea.
l.layer = 1
subs.append(l)

--[[Bloque intermedio entre la entrada de la linea en pantalla y la espera de efecto a cada silaba. -- Este bloque aveces se puede omitir si el bloque
de entrada se extendiende hasta el efecto de silaba.]]
l = table.copy(line)
l.text = "{"..an(5)..pos(x,y)..bord(3)..blur(4)..color(3,'000000').."}"..sil()
l.start_time = line.start_time - 800 + tempo
l.end_time = line.start_time + syl.start_time
l.layer = 1
subs.append(l)

--Bloque encargado de dar efecto a cada silaba 
for i=0,14 do
l = table.copy(line)
l.text = "{"..pos(x,y)..an(5)..color(3,"0000FF")..bord(1+ i*1)..img(1,'C:/fire_texture.png',0,0)..alfa(3,"F5")..t(blur(1+i*1)).."}"..sil()
l.start_time=line.start_time + syl.start_time
l.end_time=line.start_time + syl.start_time + syl.duration
l.layer=1 
subs.append(l) 
end

--[[Bloque intermedio entre el efecto de silaba y la salida de la linea en pantalla. -- Este bloque aveces se puede omitir si el bloque
de salida comienza cuando termina el efecto de cada silaba.]]
l = table.copy(line)
l.text = "{"..an(5)..pos(x,y)..bord(3)..blur(4)..color(3,'000000').."}"..sil()
l.start_time = line.start_time + syl.start_time + syl.duration
l.end_time = line.end_time + 500
l.layer = 1
subs.append(l)

--[[Bloque de salida de la linea de la pantalla.]]
l = table.copy(line)
l.text = "{"..an(5)..pos(x,y)..bord(3)..blur(4)..color(3,'000000').."}"..sil()
l.start_time = line.end_time + 500
l.end_time = line.end_time
l.layer = 1
subs.append(l)