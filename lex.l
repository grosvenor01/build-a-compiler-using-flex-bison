%{
#include <string.h>
#include "parti_syntaxique.tab.h"
#include "ts.h"
#include "pgm.h"
extern int nb_ligne;
extern int col;
extern int niv;
extern int counter;
extern int position[];
extern YYSTYPE yylval;

int blocks(int longeur){
    if(longeur >= niv+4){
	return 0;
	} 
	return 1;

}

int strToInt (const char str[])
{
    int i, int_value, fin_result,Result = 0;
    if (str[0] == '(')
    {
	  if(str[1] == '-'){
        for (i = 2; str[i] >= '0' && str[i] <= '9'; ++i)
        {   
            int_value = str[i] - '0';
            Result = Result * 10 + int_value;
            fin_result = Result * (-1);
        }
      }
      else if(str[1] == '+'){
        for (i = 2; str[i] >= '0' && str[i] <= '9'; ++i)
        {   
            int_value = str[i] - '0';
            Result = Result * 10 + int_value;
            fin_result = Result;
        }
	  }
	  
	  return fin_result;
    }
	else return 0;
}
int else_position(){
   int i=0;   
	  for(i=0;i<counter;i++){
	 
	    if(col-4 == position[i]){
	       return 0;
	    }
		
	}
	return 1;
}
%}
bloc "    "*
commantaire "#"(.|[ ])*
chiffre [0-9]
carectere [a-zA-Z]
entier {chiffre}+|"("("+"|"-"){chiffre}+")"
boulean "True"|"False"
reel {chiffre}+"."{chiffre}+
char "'"[^']"'"
idf [a-zA-Z]({carectere}|{chiffre})*
operateur_arth "+"|"-"|"*"|"/"
operateur_log "or"|"not"|"And"
operateur_comp ">"|"<"|">="|"<="|"=="|"!="
%option noyywrap
%%
{commantaire} ;
int { rechercher (yytext,"Mot cle ","",0, 1);
     col=col+yyleng;
     printf("mot cle integer reconnu \n");
	 return mc_int;
	}
bool { rechercher (yytext,"Mot cle ","",0, 1);
      col=col+yyleng;
      printf("mot cle boolean reconnu \n");
	  return bool;
	 }
float { rechercher (yytext,"Mot cle "," ",0, 1);
       col=col+yyleng;
       printf("mot cle float reconnu \n");
	   return mc_float;
	  }
char { rechercher (yytext,"Mot cle ","",0, 1);
      col=col+yyleng;
      printf("mot cle char reconnu \n");
	  return mc_char;
	 }
while {  rechercher (yytext,"Mot cle ","",0, 1);
       col=col+yyleng;
       niv=col-yyleng;	   
       printf("mot cle while reconnu \n");
	   return mc_while;
	  }
for {  rechercher (yytext,"Mot cle "," ",0, 1);
     col=col+yyleng;
     printf("mot cle for reconnu \n");
	 niv=col-yyleng;
	 printf("%d\n",niv);
	 return mc_for;
	}
"in"  { rechercher (yytext,"Mot cle "," ",0, 1);
            col=col+yyleng;
            printf("mot cle in  reconnu \n");
			return mc_in;
		   }
"range" {   rechercher (yytext,"Mot cle "," ",0, 1);
            col=col+yyleng;
            printf("mot cle range reconnu \n");
			return mc_range;
		   }
if { rechercher (yytext,"Mot cle "," ",0, 1);
    col=col+yyleng;
    printf("mot cle if reconnu \n");
	niv=col-yyleng;
	position[counter]=niv;
	counter++;
	return mc_if;
   }
else { 
      rechercher (yytext,"Mot cle"," ",0, 1);
      niv=col;
      col=col+yyleng;
	  if(else_position()==0){
	       printf("mot cle else reconnu \n");
	       return mc_else;
	  }
	  else{
	        
	        printf("\n erreur : position else incorrect \n");
			exit(1);
		   }
	 }
{operateur_arth} { rechercher (yytext,"separateur "," ",0, 2);
                  col=col+strlen(yytext);
				  yylval.car=yytext[0];
                  printf("operateur arethmetique reconnu \n");
				  return oprt;
				 }
{operateur_log} { rechercher (yytext,"separateur "," ",0, 2);
                 col=col+strlen(yytext);
                 printf("operateur logique reconnu \n");
				 return oprtlog;
				}
{operateur_comp} { rechercher (yytext,"separateur "," ",0, 2);
                  col=col+strlen(yytext);
                  printf("operateur comparaison reconnu \n");
				  return oprtcomp;
				 }
{entier} {
        
          col= col+ strlen (yytext);
          if(atoi(yytext)<=32767 && strToInt(yytext)>(-32769) && strToInt(yytext)<32768)
		    {
			   rechercher (yytext,"Cst entiere","entier",atoi(yytext), 0);
			   yylval.entier=atoi(yytext);
			   printf("entier reconnu %s \n",yytext);
			   return cstint;
			}
		  else{
		    printf("erreur lexical a la ligne %d  la col %d entite %s un entier doit etre entre -32769 et 32768 \n",nb_ligne,col, yytext);
		    col=col+strlen(yytext);
		  
		  }
		}
{boulean} {
           col=col+strlen(yytext);
           printf("boolean reconnu \n");
		   if(strcmp(yytext , "True")==0){
		       float value = (float) (int) yytext;
			   rechercher (yytext,"CST bool","bool",1,0);
		   }
		  else {
		       float value = (float) (int) yytext;
			   rechercher (yytext,"CST bool","bool",0,0);
		   }
		   yylval.str=strdup(yytext); 
		   return cstboolean;
		  }
{reel} {
        col=col+strlen(yytext);
		rechercher (yytext,"CST reel ","float",atof(yytext),0);
        printf("reel reconnu \n");
		yylval.str=yytext;
		return cstreel;
	   }
{char} {
        col=col+strlen(yytext);
		float value = (float) (int) yytext[1];
        rechercher (yytext,"CST char","carectere",value,0);
		yylval.str=yytext;
        printf("char reconnu %s \n",yytext);
		return cstchar;
       }
"import" { rechercher (yytext,"Mot cle "," ",0, 1);
           col=col+strlen(yytext);
           printf("mot cle import  reconnu \n");
	       return mc_import;
        }	 
"=" { rechercher (yytext,"Separateur",0,0, 2);
     col=col+strlen(yytext);
     printf("affectation reconnu \n");
	 return aff;
    }
"\"" { rechercher (yytext,"Separateur",0,0, 2);
     col=col+strlen(yytext);
     printf("gm reconnu \n");
	 return gm;
}
"," { rechercher (yytext,"Separateur",0,0, 2);
     col=col+strlen(yytext);
     printf("vergule reconnu \n");
	 return vg;
    }
"(" { rechercher (yytext,"Separateur",0,0, 2);
     col=col+strlen(yytext);
     printf("parenthese entrant reconnu \n");
	 return prent;
    }
")" { rechercher (yytext,"Separateur",0,0, 2);
     col=col+strlen(yytext);
     printf("paranthese sortant reconnu \n");
	 return prsor;
    }
":" { rechercher (yytext,"Separateur",0,0, 2);
     col=col+strlen(yytext);
     printf("deux points reconnu \n");
	 return dp;
	}
"[" { rechercher (yytext,"Separateur",0,0, 2);
     col=col+strlen(yytext);
     printf("acolade entrant reconnu \n");
	 return acov;
	}
"]" { rechercher (yytext,"Separateur",0,0, 2);
     col=col+strlen(yytext);
     printf("acolade sortant reconnu \n");
	 return acofr;
	}
"." { rechercher (yytext,"Separateur",0,0, 2);
     col=col+strlen(yytext);
     printf("point  reconnu \n");
	 return pt;
}
" " col=col+yyleng;
[\n] { 
    nb_ligne++;
	col=0;
	return saut;
   }
{idf} {
       if(yytext[0]<'A' || yytext[0]>'Z')
	    {
	      printf("erreur lexical a la ligne %d  la col %d entite %s un identificateur doit commancer par une majescule \n",nb_ligne,col, yytext);
		}
       else if(strlen(yytext)<=8){
	   rechercher (yytext,"idf ","vide",88888888, 0);
       printf("idf reconnu \n");
	   yylval.str=strdup(yytext); 
	   return idf;
	   }
	   else
	   printf("erreur lexical a la ligne %d  la col %d entite %s un idf ne  doit pas contenir plus de 8 carecteres \n",nb_ligne,col);
	  }
{bloc} { col=col+yyleng;
        printf("bloc reconnue ");
		if(blocks(yyleng)==0){
		    return true_bloc;
		}}
"%%" { col=col+yyleng;
        printf(" reconnue ");
		
		    return prs;
		
	   }
. {printf("erreur lexical a la ligne %d  la col %d entite %s \n",nb_ligne,col, yytext);
   col++;
  }
%%