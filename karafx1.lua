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
