/*
 * Copyright Dome Systems.
 *
 * Dome Private License (D-PL) [a369] PubPL 36 (1 Xenon 539)
 *
 * * URL: http://csgames.org/2016/dome_license.md
 * * Type: Software
 * * Media: Software
 * * Origin: Hexko Dept.
 * * Author: Kevin Hexko
 */

#include <dirent.h>
#include <sys/stat.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>
#include <sys/stat.h>
#include <errno.h>
#include <fcntl.h>
#include <fstream>
#include <iostream>
#include <sstream>
#include <vector>

using namespace std;

void accumuler(char * fichierActuel, int * taille, int * nombre)
{
        struct stat lesStats;
        struct dirent *dirIterator;
        char nomDuFichier[260];
        DIR * dossier;

        if ((dossier = opendir(fichierActuel)))
        {
                while((dirIterator = readdir(dossier)) != NULL)
                {
                        strcpy (nomDuFichier, dirIterator->d_name);

                        if (strcmp(nomDuFichier, ".") == 0 || strcmp(nomDuFichier, "..") == 0)
                                continue;

                        strcpy(nomDuFichier, fichierActuel);
                        strcat(nomDuFichier, "/");
                        strcat(nomDuFichier, dirIterator->d_name);
                        stat(nomDuFichier, &lesStats);

                        if (S_ISDIR(lesStats.st_mode))
                        {
                                accumuler(nomDuFichier, taille, nombre);
                        }
                        else
                        {
                                *taille = *taille + lesStats.st_size;
                                *nombre = *nombre + 1;
                        }
                }
        }
        closedir(dossier);
}

void lancerLeCalcule(char *path)
{
        int nbrFichier = 0;
        int tailleTotal = 0;
        DIR * dossier;
        if ((dossier = opendir(path)))
        {
                closedir(dossier);
                accumuler(path, &tailleTotal, &nbrFichier);
                printf("The directory contains %d files (%d bytes).\n", nbrFichier, tailleTotal);
        }
        else
        {
                printf("Directory not found\n");

        }
}

int main(int argc, char * argv[])
{
        lancerLeCalcule(argv[1]);
        return 0;
}
