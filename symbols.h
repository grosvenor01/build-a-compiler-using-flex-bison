/****************CREATION DE LA TABLE DES SYMBOLES ******************/
/***Step 1: Definition des structures de données ***/
#include <stdio.h>
#include <stdlib.h>

typedef struct
{
   int state;
   char name[20];
   char code[20];
   char type[20];
   float val;
 } element;
typedef struct
{ 
   int state; 
   char name[20];
   char type[20];
} elt;
typedef struct
{  
   char name[20];
   char taille[20];
} tabelm;
tabelm tabobj[100];
element tab[1000];
elt tabs[40],tabm[40];
extern char sav[20];

/***Step 2: initialisation de l'état des cases des tables des symbloles***/
/*0: la case est libre    1: la case est occupée*/

void initialisation()
{
  int i;
  for (i=0;i<1000;i++)
  tab[i].state=0;
  
  

  for (i=0;i<40;i++)
    {tabs[i].state=0;
    tabm[i].state=0;}

} 
/***Step 3: insertion des entititées lexicales dans les tables des symboles ***/

void inserer (char entite[], char code[],char type[],float val,int i, int y)
{
  switch (y)
 { 
   case 0:/*insertion dans la table des IDF et CONST*/
       tab[i].state=1;
       strcpy(tab[i].name,entite);
       strcpy(tab[i].code,code);
	   strcpy(tab[i].type,type);
	   tab[i].val=val;
	   break;

   case 1:/*insertion dans la table des mots clés*/
       tabm[i].state=1;
       strcpy(tabm[i].name,entite);
       strcpy(tabm[i].type,code);
       break; 
    
   case 2:/*insertion dans la table des séparateurs*/
      tabs[i].state=1;
      strcpy(tabs[i].name,entite);
      strcpy(tabs[i].type,code);
      break;
 }

}

/***Step 4: La fonction Rechercher permet de verifier  si l'entité existe dèja dans la table des symboles */
void rechercher (char entite[], char code[],char type[],float val,int y)	
{

int j,i;

switch(y) 
  {
   case 0:/*verifier si la case dans la tables des IDF et CONST est libre*/
        for (i=0; ((i<1000)&&(tab[i].state==1))&&(strcmp(entite,tab[i].name)!=0);i++);
        if(i<1000 && strcmp(entite,tab[i].name)!=0 )
          inserer(entite,code,type,val,i,0);
        else
          printf("entité existe déjà\n");
        break;

   case 1:/*verifier si la case dans la tables des mots clés est libre*/
       
       for (i=0;((i<1000)&&(tabm[i].state==1))&&(strcmp(entite,tabm[i].name)!=0);i++); 
        if(i<40)
          inserer(entite,code,type,val,i,1);
        else
          printf("entité existe déjà\n");
        break; 
    
   case 2:/*verifier si la case dans la tables des séparateurs est libre*/
         for (i=0;((i<40)&&(tabs[i].state==1))&&(strcmp(entite,tabs[i].name)!=0);i++); 
        if(i<40)
         inserer(entite,code,type,val,i,2);
        else
   	       printf("entite existe deja\n");
        break;
  }

}
	  int Recherche_position(char entite[])
		{
		int i=0;
		
		while(i<1000 && tab[i].state==1)
		{
		
		if (strcmp(entite,tab[i].name)==0){
		return i;}	
		i++;
		}
      
		return -1;
		
		}

	 void insererTYPE(char entite[], char type[])
	{
       int pos;
	   pos=Recherche_position(entite);
	   if(pos!=-1)  { strcpy(tab[pos].type,type);
                      				  }
	}
    void inserercode(char entite[], char code[])
	{
       int pos;
	   pos=Recherche_position(entite);
	   if(pos!=-1)  { strcpy(tab[pos].code,code);
                      				  }
	}
    
	
	int doubleDeclaration(char entite[])
	{
	int pos2;
	pos2=  Recherche_position(entite);
	if(strcmp(tab[pos2].type ,"vide")==0 ){
			return 0;}
	   else return -1;
	
	
	}
	int doubleDeclarationaff(char entite[],char type[] , char cst)
	{
	int pos2;
	pos2=  Recherche_position(entite);
	if(strcmp(tab[pos2].type ,"vide")==0 ){
		strcpy(tab[pos2].type,type);
	  
			return 0;}
		  else return -1;
	   
	}
	
		
		int nonDeclaration(char entite[])
	{
	int pos2;
	pos2=  Recherche_position(entite);
	if(strcmp(tab[pos2].type ,"vide")==0 ){
			
			return -1;}
	   else return 0;
	
	
	}
	/***Step 5 L'affichage du contenue de la table des symboles ***/

/***Step 5 L'affichage du contenue de la table des symboles ***/

void afficher()
{
	int i;

printf("/***************Table des symboles IDF*************/\n");
printf("____________________________________________________________________\n");
printf("\t| Nom_Entite |  Code_Entite | Type_Entite | Val_Entite\n");
printf("____________________________________________________________________\n");
  
for(i=0;i<1000;i++)
{	
	
    if(tab[i].state==1)
      { if(strcmp(tab[i].type , "entier")==0){
		  int valeur = (int) tab[i].val;
		  printf("\t|%10s |%15s | %12s | %d\n",tab[i].name,tab[i].code,tab[i].type,valeur);
	    }
		else if(strcmp(tab[i].type , "carectere")==0){
		char valeur = (char)( (int) tab[i].val);
		  printf("\t|%10s |%15s | %12s | %c\n",tab[i].name,tab[i].code,tab[i].type,valeur);
	    }
		else if(strcmp(tab[i].type , "float")==0){
		  printf("\t|%10s |%15s | %12s | %2f\n",tab[i].name,tab[i].code,tab[i].type,tab[i].val);
	    }
		else if(strcmp(tab[i].type , "vide")==0){
		  printf("\t|%10s |%15s | %12s | %2f\n",tab[i].name,tab[i].code,tab[i].type,tab[i].val);
	    }
		else if(strcmp(tab[i].type , "entier-tab")==0){
		  printf("\t|%10s |%15s | %12s | %2f\n",tab[i].name,tab[i].code,tab[i].type,tab[i].val);
	    }
      }
}

 
printf("\n/***************Table des symboles mots clés*************/\n");

printf("_____________________________________\n");
printf("\t| NomEntite |  CodeEntite | \n");
printf("_____________________________________\n");
  
for(i=0;i<40;i++)
    if(tabm[i].state==1)
      { 
        printf("\t|%10s |%12s | \n",tabm[i].name, tabm[i].type);
               
      }

printf("\n/***************Table des symboles séparateurs*************/\n");

printf("_____________________________________\n");
printf("\t| NomEntite |  CodeEntite | \n");
printf("_____________________________________\n");
  
for(i=0;i<40;i++)
    if(tabs[i].state==1)
      { 
        printf("\t|%10s |%12s | \n",tabs[i].name,tabs[i].type );
}}  
      
	  void inserevaleur(char entiteidf[],char entitecst[])
		{
		int posidf = Recherche_position(entiteidf);
		int poscst = Recherche_position(entitecst);
		if(strcmp(tab[posidf].type,tab[poscst].type)==0){
			tab[posidf].val=tab[poscst].val;
		}
		else printf(" \n erreur semantique :incmptabilté de type \n");
		}
	void  compare_type(char* current_type, char* operant){
		int pos = Recherche_position(operant);
		
		if(strcmp(current_type , "vide")==0){
			strcpy(current_type , tab[pos].type);
		}
		else if (strcmp(current_type , tab[pos].type)!=0){
			printf("erreur semantique : incompatibilite  de type  \n");
	}}
	void  compare_taille(char* idf, int cstint){
		int pos = Recherche_position(idf);
		
		if(tab[pos].val < cstint){
			printf("erreur semantique : valeur hors limite\n");
		}
		}
		int not_initialise(char *entite){
		int pos=Recherche_position(entite);
		if(tab[pos].val == 88888888){
			return -1;
		}
		return 0;
	}
