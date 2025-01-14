
form  ecriture_ortho 
             comment Quelle phrase souhaitez vous synthétiser ? 

              choice ecriture_ortho : 9
                         button le vieux cerf gris s'élance dans les bois obscurs
                         button la vieille biche grise s'élance dans la forêt verte
                         button dans l'obscure forêt rôde le loup
                         button les loups gris s'élancent vers le vieux cerf
                         button vers la noire forêt s'élance une biche
                         button dans les bois verts une biche s'élance vers un cerf
                         button la biche et le vieux loup rôdent dans la forêt verte
                         button le grand loup gris s'élance dans les bois obscurs
                         button la grande louve grise chassait dans la forêt
                     

                 


endform





#------------- EXTRACTION PHRASE PHONÉTIQUE-------------------#


dico = Read Table from tab-separated file: "dico_UTF8.txt"
ecriture_phonetique$ = ""
ecriture_ortho$ = ecriture_ortho$ + " "
printline écriture orthographique : 'ecriture_ortho$'

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


fin_mot = endsWith(ecriture_phonetique$, "a")
debut_mot_suivant = startsWith( mot_phonetique$, "O")

fin_mot_d = endsWith(ecriture_phonetique$, "d")
debut_mot_suivant_l = startsWith( mot_phonetique$, "l")
debut_mot_suivant_d = startsWith( mot_phonetique$, "d")


                      if fin_mot = 1 and debut_mot_suivant = 1

                              ecriture_phonetique$ = ecriture_phonetique$+ "z" + mot_phonetique$

                      elsif fin_mot_d = 1 and debut_mot_suivant_l = 1
                   
                             ecriture_phonetique$ = ecriture_phonetique$+ "@" + mot_phonetique$
            
                       elsif fin_mot_d = 1 and debut_mot_suivant_d = 1
                   
                             ecriture_phonetique$ = ecriture_phonetique$+ "@" + mot_phonetique$

                      else

                              ecriture_phonetique$ = ecriture_phonetique$+ mot_phonetique$

           endif 
endwhile

ecriture_phonetique$ = "_" + ecriture_phonetique$ + "_"

printline écriture phonetique : 'ecriture_phonetique$'




#-------------------------OPENNING FILES ------------------------------#

grille = Read from file: "Logatomes_2.TextGrid"
son = Read from file:  "Logatomes_2.wav"

#--------------------------------SET UP--------------------------------------#

select 'grille'
nb_intervals = Get number of intervals: 1 

son_vide = Create Sound from formula: "syntheseLogatomes", 1, 0, 0.05, 44100, "0"




select 'son'
intersection = To PointProcess (zeroes): 1, "no", "yes"

#----------------EXTRACTION DIPHONES SON------------------------#


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

selectObject: "Sound chain"
manipulation = To Manipulation: 0.01, 75, 600


pitch = Extract pitch tier
duree_fin = Get end time

#### pitch ######

Remove points between: 0, duree_fin

select 'manipulation'
plus 'pitch'
Replace pitch tier

selectObject: "PitchTier chain"
Add point: 0, 200
Add point: 0.4*duree_fin, 270
Add point: 0.4*duree_fin+0.05, 200
Add point: 0.5*duree_fin, 250
Add point: duree_fin,200

select 'manipulation'
plus 'pitch'
Replace pitch tier

##### durée #####






#pour la durée on peut repartir du sound dont on a modif f0
#on peut reprendre le même manipulation
#pas besoin de supprimer les points pour la durée pcq y'en a pas 
# modify add point au tout début. Ça marche pas par valeur absolue mais par aleur relative, si on met 1.5 ça va être 1,5 fois plus lent 



