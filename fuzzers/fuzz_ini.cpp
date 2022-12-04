#include <stdio.h>
#include "SimpleIni.h"

int main(int argc, char **argv)
{
	CSimpleIniA ini;
	ini.SetUnicode();
	SI_Error rc = ini.LoadFile(argv[1]);
	if (rc < 0) return 1;
	printf("ok");
	return 0;
}
