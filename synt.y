%{
 int nb_ligne=1, col=1 , niv=0,counter=0,position[100];
  char sauvType[25];
  char sauvType2[25];
  int valeur;
  char sauvcst[20];
  char sauvType3[10];
  int Fin_if=0,deb_else=0,deb_for=0,fin_for=0,deb_while=0,fin_while=0;
  int qc=0;
  int val=0,val2=0;
  char tmp [20];
  char sauvidf[8];
  int  sauvidf2=0,demidf=0;
  void nondec(char entite[]){
    if(nonDeclaration(entite)!=0)
	    printf("Erreur semantique: non declaration  de %s a la ligne %d et a la colonne %d\n",entite,nb_ligne,col);}
%}
%token <str>idf <entier>cstint bool aff <str>cstboolean  <str>cstreel <str>cstchar mc_char mc_int mc_float acov acofr vg <car>oprt oprtcomp  gm mc_import  pt  prent prsor  oprtlog dp mc_if saut true_bloc mc_else  mc_for mc_range mc_in mc_while prs
%union {
int entier;
char* str;
char car;
float reel;

}
%start S 
%%
S : LISTE_BIB saut  CODE 
   { printf("\n EXIT WITH 1 \n"); YYACCEPT; }
;
LISTE_BIB : mc_import gm idf pt idf gm LISTE_BIB {strcpy(sauvType3,"vide");}
          |
;

CODE : PDEC prs saut PINST 
     | 
;
PDEC  : DEC_VAR saut  PDEC  
      | DEC_TAB  saut PDEC
	   |
;
DEC_VAR : TYPE  LISTE_IDF 
        | idf aff CST {if(doubleDeclarationaff($1,sauvType2)==-1)   {printf("Erreur semantique: Double declaration  de %s a la ligne %d et a la colonne %d\n",$1,nb_ligne,col);}
							    inserevaleur($1,sauvcst);                                    
		
		}
;
DEC_TAB : TYPE idf acov cstint acofr { if(doubleDeclaration($2)==0)   { 
insererTYPE($2,sauvType);

inserercode($2,"tab");
inserevaleur($2,itoa($4 , sauvcst ,10));
}
							    else 
								printf("Erreur semantique: Double declaration  de %s a la ligne %d et a la colonne %d\n",$2,nb_ligne,col);
								if ($4<0)
	    printf("Erreur semantique: la taille de tableau %d doit etre positive a la ligne %d a la colonne %d\n ",$5,nb_ligne, col);
      
							  }  
;
TYPE : mc_int {strcpy(sauvType,"entier");}
     | bool    {strcpy(sauvType,"bool");}
     | mc_char  {strcpy(sauvType,"char");}
     | mc_float {strcpy(sauvType,"float");}
;
CST : cstint{ valeur=$1;
              strcpy(sauvType2,"entier");  
			 itoa($1 , sauvcst ,10);
			  }
     | cstreel {strcpy(sauvType2,"float");
	           strcpy(sauvcst,$1);
			  }
     | cstboolean {strcpy(sauvType2,"bool");
	             strcpy( sauvcst,$1);
                  }
    | cstchar   {strcpy(sauvType2,"carectere");
	             strcpy( sauvcst, $1);
                 }
;
PINST : INST_AFF saut PINST 
      | IFCOND  PINST  
	  | BOUCLE PINST 
	  | 
;

LISTE_IDF :  idf vg LISTE_IDF     { 

                                if(doubleDeclaration($1)==0)   { insererTYPE($1,sauvType);}
							    else 
								printf("Erreur semantique: Double declaration  de %s a la ligne %d et a la colonne %d\n",$1,nb_ligne,col);
							  }
        
		 | idf    {
		 if(doubleDeclaration($1)==0)   { insererTYPE($1,sauvType);}
							    else 
								printf("Erreur semantique: Double declaration  de %s a la ligne %d et a la colonne %d\n",$1,nb_ligne,col);
							  }
;
INST_AFF : idf aff EXPRESSION {nondec($1);
                      compare_type( sauvType3,$1);

}

         |idf acov cstint acofr aff EXPRESSION {nondec($1);
                      compare_type( sauvType3,$1);
					  compare_taille($1,$3);

} 
;
EXPRESSION :OPR     
| OPR oprt   EXPRESSION  { char strcst[2];
                           strcst[0]=$2;
                           if(strcmp( strcst,"/")==0 && valeur==0 ) { 
						   printf("\n erreur: division par 0 de %s a la ligne %d et a la colonne %d \n");}
                         }
| prent EXPRESSION prsor 
| EXPRESSION oprtcomp EXPRESSION
;
OPR:	idf {nondec($1);
         compare_type( sauvType3,$1);
          if(not_initialise($1)==-1){printf("erreur semantique: variable %s non intialiser \n",$1);}		 }
        | CST {compare_type( sauvType3,sauvcst);}
;
CONDITION : OPLOG1  EXPRESSION oprtcomp  EXPRESSION OPLOG
                     |cstboolean 
;					 

OPLOG: oprtlog CONDITION  
             |  
;
OPLOG1: oprtlog 
      | 
;

IFCOND:A   ELSE {   if( val2==1  ){
                       val2=0;
					   sprintf(tmp,"%d",qc); 
                        ajour_quad(deb_else,1,tmp); 
                      quadr("vide", "","temp_else", "vide");
                      sprintf(tmp,"%d",qc); 
                      ajour_quad(Fin_if,1,tmp);					  }
                    else{  sprintf(tmp,"%d",qc); 
                      ajour_quad(Fin_if,1,tmp);}
				       printf("pgm juste");
}
;
A:B   true_bloc INTS1   BLOCKS{ 
                                    quadr("vide", "","temp_if", "vide");  
				                    Fin_if=qc; 
                                    									
                                    quadr("BR", "","vide", "vide");   
				                    
								  
				   }
 ;
B:mc_if  prent CONDITION  prsor dp saut  {  deb_else=qc; 
 
                                       quadr("BZ", "","temp_cond", "vide"); 
                                                                   		
	}
;




BLOCKS : true_bloc INTS1  BLOCKS 
        | 
;
ELSE: mc_else  dp saut true_bloc INTS1 BLOCKSELSE { val2=1;}
|
;
BLOCKSELSE:true_bloc INTS1  BLOCKS 
        | 
;

BOUCLE : BOUCLEFOR 
| BOUCLEWHILE
;

BOUCLEFOR : BF true_bloc INTS1  BLOCKS{         quadr("vide", "","temp_CODE", "vide");
                                               sprintf(tmp,"%d",deb_for);
                                               quadr("BR",tmp ,"vide", "vide");       
                                               sprintf(tmp,"%d",qc);
											   ajour_quad(sauvidf2,1,tmp);
											  if(val==1){
											  val=0;
											  ajour_quad(fin_for,1,tmp);
											  fin_for++;
											   ajour_quad(fin_for,1,tmp);}
											   

} 
;
INTS1: INST_AFF saut
       | BOUCLE
	   |IFCOND
;



BF: AF idf mc_in VERSION dp  saut{  
                                  nondec($2);
                                  strcpy(sauvidf,$2);								 
		                          sprintf(tmp,"%d",sauvidf2);
		                          ajour_quad(sauvidf2,2,sauvidf);
								  sprintf(tmp,"%d",demidf);
								  ajour_quad(demidf,2,sauvidf);
								  demidf++;
								  ajour_quad(demidf,2,sauvidf);
		
		}
AF:mc_for {deb_for=qc ;
              }
;
VERSION :mc_range prent cstint vg cstint prsor {  val=1;
                                                 fin_for=qc;
                                                 demidf=qc;
                                                 sprintf(tmp,"%d",$3);
                                                 quadr("Bl", "","",tmp );
												 sprintf(tmp,"%d",$5);
                                                 quadr("Bg", "","",tmp );

}
| idf {  sauvidf2=qc;
        nondec($1);
		quadr("Bl", "", "",$1);
		
		}
; 

BOUCLEWHILE :AW saut  true_bloc INTS1  BLOCKS{quadr("vide","","temp code", "vide");
                                            sprintf(tmp,"%d",deb_while);
                                            quadr("BR",tmp ,"vide", "vide");
											sprintf(tmp,"%d",qc);
                                            ajour_quad(fin_while,1,tmp);}
;

AW:BW  CONDITION prsor dp { fin_while=qc;
                         quadr("BNZ","","cond.temp", "");

}
;
BW: mc_while  prent {deb_while=qc;}
;

%%
main ()
{
 initialisation();
   yyparse();
 afficher_qdr();

 }
 yywrap ()
 {}
 int yyerror ( char*  msg )  
 {
    printf ("Erreur Syntaxique la ligne %d  \n ",nb_ligne);
 }
