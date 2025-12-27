// Convert TileEd CSV export to ZX Spectrum binary map format
// TileEd exports CSV with tile indices (0-based)
// Usage: ./generate_map tilemap.csv

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s tilemap.csv\n", argv[0]);
        return 1;
    }
    
    FILE *csv = fopen(argv[1], "r");
    if (!csv) {
        printf("Error: Cannot open %s\n", argv[1]);
        return 1;
    }
    
    FILE *bin = fopen("map.bin", "wb");
    if (!bin) {
        fclose(csv);
        printf("Error: Cannot create map.bin\n");
        return 1;
    }
    
    char line[1024];
    int y = 0;
    
    while (fgets(line, sizeof(line), csv) && y < 48) {
        char *token = strtok(line, ",\n");
        int x = 0;
        
        while (token && x < 96) {
            int tile = atoi(token);
            // Clamp to valid tile range (0-3)
            if (tile < 0) tile = 0;
            if (tile > 3) tile = 3;
            
            fputc((unsigned char)tile, bin);
            x++;
            token = strtok(NULL, ",\n");
        }
        
        // Pad remaining columns if CSV is shorter
        while (x < 96) {
            fputc(0, bin);
            x++;
        }
        
        y++;
    }
    
    // Pad remaining rows if CSV is shorter
    while (y < 48) {
        for (int x = 0; x < 96; x++) {
            fputc(0, bin);
        }
        y++;
    }
    
    fclose(csv);
    fclose(bin);
    
    printf("Converted %s to map.bin (96x48 tiles)\n", argv[1]);
    return 0;
}
