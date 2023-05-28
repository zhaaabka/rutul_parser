.DEFAULT_GOAL := rut.analyzer.hfst

#скомпилить все фонологические файлы
rut_phon.twol.hfst: rut_phon.twol
	hfst-twolc $< -o $@
case_tags.twol.hfst: case_tags.twol
	hfst-twolc $< -o $@
dade.twol.hfst: dade.twol
	hfst-twolc $< -o $@

#соединить все в один
rut_gen.lexd: patterns.lexd morph.lexd numerals.lexd nouns.lexd
	cat $^ > $@
	
#генератор
rut_gen.lexd.hfst: rut_gen.lexd
	lexd $< | hfst-txt2fst -o $@
rut_gen1.lexd.hfst: rut_gen.lexd.hfst rut_phon.twol.hfst
	hfst-compose-intersect $^ -o $@
rut_gen2.lexd.hfst: rut_gen1.lexd.hfst case_tags.twol.hfst
	hfst-compose-intersect $^ -o $@
rut.gen.hfst: rut_gen2.lexd.hfst dade.twol.hfst
	hfst-compose-intersect $^ -o $@
	
#анализатор
rut.analyzer.hfst: rut.gen.hfst
	hfst-invert $< -o $@
	
#Запуск: hfst-fst2strings rut.gen.hfst