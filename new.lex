%{
 #include<string.h>
 int line_number=0;
 int line_position=0;
 void print_message(char*,char*,int,int);
 void print_error(char*,int,int);
%}
comments \/\/.*
letter [A-Za-z]
delim [ \t]
delims {delim}+
digit [0-9]
number 0|([1-9]{digit}*)
ws {delim}+
id {letter}({letter}|{digit})*
keyword if|then|else|while

%%

\n {line_position=0;line_number++;}
{delims} {line_position+=yyleng;}
{comments} {/* No actions on comments */}
{keyword} {print_message(yytext,yytext,line_number,line_position);line_position+=yyleng;}
"{" {print_message("{","{",line_number,line_position);line_position+=yyleng;}
"}" {print_message("}","}",line_number,line_position);line_position+=yyleng;}
"(" {print_message("(","(",line_number,line_position);line_position+=yyleng;}
")" {print_message(")",")",line_number,line_position);line_position+=yyleng;}
";" {print_message(";",";",line_number,line_position);line_position+=yyleng;}
"," {print_message(",",",",line_number,line_position);line_position+=yyleng;}
{id} {print_message("ID",yytext,line_number,line_position);line_position+=yyleng;}
{number} {int num_len = yyleng;if(num_len>0 && num_len<=10 && (num_len<10 || strcmp(yytext,"2147483648")<0)){print_message("NUM",yytext,line_number,line_position);line_position+=yyleng;}else{print_error("Number format error",line_number,line_position);exit(1);}}
"+" {print_message("+","+",line_number,line_position);line_position+=yyleng;}
"-" {print_message("-","-",line_number,line_position);line_position+=yyleng;}
"*" {print_message("*","*",line_number,line_position);line_position+=yyleng;}
"/" {print_message("/","/",line_number,line_position);line_position+=yyleng;}
"=" {print_message("=","=",line_number,line_position);line_position+=yyleng;}
"==" {print_message("==","==",line_number,line_position);line_position+=yyleng;}
"<" {print_message("<","<",line_number,line_position);line_position+=yyleng;}
">" {print_message(">",">",line_number,line_position);line_position+=yyleng;}
"<=" {print_message("<=","<=",line_number,line_position);line_position+=yyleng;}
">=" {print_message(">=",">=",line_number,line_position);line_position+=yyleng;}
"!=" {print_message("!=","!=",line_number,line_position);line_position+=yyleng;}
. {char* a=(char*)malloc(sizeof(char)*(20+yyleng));strcpy(a,"Exception character \"");print_error(strcat(strcat(a,yytext),"\""),line_number,line_position);free(a);exit(1);}

%%

int main(){
	yylex();
	return 0;
}

void print_message(char* token_type,char* attribute_value,int line_number,int line_position){
	printf("%s\t\t%s\t\t%d\t\t%d\n",token_type,attribute_value,line_number,line_position);
}

void print_error(char* message,int line_number,int line_position){
	fprintf(stderr,"ERROR: %s. In line %d, position %d.\n",message,line_number,line_position);
}

int yywrap(){
	return 1;
}