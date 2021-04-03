/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     tENTIER = 258,
     tVAR_NAME = 259,
     tMAIN = 260,
     tPARENTHESE_OUVRANTE = 261,
     tPARENTHESE_FERMANTE = 262,
     tACCOLADE_OUVRANTE = 263,
     tACCOLADE_FERMANTE = 264,
     tCONST = 265,
     tINT = 266,
     tPLUS = 267,
     tMOINS = 268,
     tFOIS = 269,
     tDIVISER = 270,
     tEGALE = 271,
     tESPACE = 272,
     tVIRGULE = 273,
     tPOINT_VIRGULE = 274,
     tPRINTF_VARIABLE = 275,
     tIF = 276,
     tELSE = 277,
     tWHILE = 278,
     tRETURN = 279,
     tCMP = 280,
     tINF = 281,
     tSUP = 282,
     tINFEQUAL = 283,
     tSUPEQUAL = 284,
     tNOTEQUAL = 285
   };
#endif
/* Tokens.  */
#define tENTIER 258
#define tVAR_NAME 259
#define tMAIN 260
#define tPARENTHESE_OUVRANTE 261
#define tPARENTHESE_FERMANTE 262
#define tACCOLADE_OUVRANTE 263
#define tACCOLADE_FERMANTE 264
#define tCONST 265
#define tINT 266
#define tPLUS 267
#define tMOINS 268
#define tFOIS 269
#define tDIVISER 270
#define tEGALE 271
#define tESPACE 272
#define tVIRGULE 273
#define tPOINT_VIRGULE 274
#define tPRINTF_VARIABLE 275
#define tIF 276
#define tELSE 277
#define tWHILE 278
#define tRETURN 279
#define tCMP 280
#define tINF 281
#define tSUP 282
#define tINFEQUAL 283
#define tSUPEQUAL 284
#define tNOTEQUAL 285




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 16 "yacc.y"
{
    char * variable;
    int nombre;
}
/* Line 1529 of yacc.c.  */
#line 114 "y.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

