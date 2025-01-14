
form Entrez la phrase que vous souhaitez synthétiser 


text ecriture_ortho

endform



#------------- EXTRACTION PHRASE PHONÉTIQUE-------------------#


dico = Read Table from tab-separated file: "dico1.txt"
ecriture_phonetique$ = ""
ecriture_ortho$ = ecriture_ortho$ + " "
printline ecriture ortho : 'ecriture_ortho$'

longueur_ecriture_ortho = length(ecriture_ortho$)

while longueur_ecriture_ortho>0

            espace=index(ecriture_ortho$, " ")

           mot$ = left$(ecriture_ortho$, espace -1)

           ecriture_ortho$ = right$(ecriture_ortho$, longueur_ecriture_ortho-espace)

            longueur_ecriture_ortho=length(ecriture_ortho$) 

            select 'dico'
#pause //'mot$'//
            extraction = Extract rows where column (text): "orthographe", "is equal to", mot$
            mot_phonetique$ = Get value: 1, "phonetique"
            ecriture_phonetique$ = ecriture_phonetique$+ mot_phonetique$


endwhile

ecriture_phonetique$ = "_" + ecriture_phonetique$ + "_"


printline ecriture phonetique : 'ecriture_phonetique$'




#-------------------------OPENNING FILES ------------------------------#

grille = Read from file: "Logatomes.TextGrid"
son = Read from file:  "Logatomes.mp3"

#--------------------------------SET UP--------------------------------------#

select 'grille'
nb_intervals = Get number of intervals: 1 

son_vide = Create Sound from formula: "syntheseLogatomes", 1, 0, 0.01, 44100, "0"

select 'son'
intersection = To PointProcess (zeroes): 1, "no", "yes"

#----------------EXTRATCION DIPHONES SON------------------------#


for b from 1 to length (ecriture_phonetique$) -1
           select 'grille'
          diphone$ = mid$(ecriture_phonetique$, b, 2)
          char1_diphone$ = left$(diphone$, 1)
          char2_diphone$ = right$(diphone$, 1)
          printline  'char1_diphone$' / 'char2_diphone$'

               for a from 1 to nb_intervals -1 
                           select 'grille'
                          st_interval = Get start time of interval: 1,  a
     			  et_interval = Get end time of interval: 1, a
  		          label_interval$ = Get label of interval: 1, a
			   label_interval_suivant$ = Get label of interval: 1, a+1
 	 		  et_interval_suivant = Get start time of interval: 1, a+1
          

                                 if label_interval$ = char1_diphone$ and label_interval_suivant$ = char2_diphone$
                                m1 = ((et_interval - st_interval)/2 + st_interval)
                                m2 = ((et_interval_suivant - et_interval_suivant)/2 + et_interval_suivant)
                                select 'intersection'
                                index1 = Get nearest index: m1
                                zero_1= Get time from index: index1
    
                                index2 = Get nearest index: m2
                                zero_2= Get time from index: index2
                                printline 'm1:3' / 'm2:3'
                                printline 'zero_1' / 'zero_2'



                                   select 'son'
                                   extrait_son = Extract part: zero_1, zero_2, "rectangular", 1, "no"
                                   select  'son_vide'
                                   plus  'extrait_son' 
                                   son_vide = Concatenate

                           endif  
            endfor
endfor 

#----------------------TRAITEMENT PHRASE-------------------------#