
form Entrez la phrase que vous souhaitez synthétiser 


text ecriture_ortho
endform



#------------- EXTRACTION DIPHONES PHONÉTIQUE-------------------#
dico = Read Table from tab-separated file: "dico1.txt"
ecriture_phonetique$ = ""
ecriture_ortho$ = ecriture_ortho$ + " "
printline //'ecriture_ortho$'//
longueur_ecriture_ortho = length(ecriture_ortho$)

while longueur_ecriture_ortho>0

            espace=index(ecriture_ortho$, " ")

           mot$ = left$(ecriture_ortho$, espace -1)


 printline 'mot$' /  'mot_phonetique$' / 'ecriture_phonetique$'


           ecriture_ortho$ = right$(ecriture_ortho$, longueur_ecriture_ortho-espace)

printline 'ecriture_ortho$'

            longueur_ecriture_ortho=length(ecriture_ortho$) 

            select 'dico'
pause //'mot$'//
            extraction = Extract rows where column (text): "orthographe", "is equal to", mot$
            mot_phonetique$ = Get value: 1, "phonetique"
            ecriture_phonetique$ = ecriture_phonetique$+ mot_phonetique$

 printline 'mot$' /  'mot_phonetique$' / 'ecriture_phonetique$'



endwhile

