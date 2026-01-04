// Convert TileEd CSV export to ZX Spectrum binary map format
// TileEd exports CSV with tile indices (0-based)
// Usage: ./generate_map tilemap.csv width height

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    if (argc != 4) {
        printf("Usage: %s tilemap.csv width height\n", argv[0]);
        return 1;
    }

    int map_width = atoi(argv[2]);
    int map_height = atoi(argv[3]);
    if (map_width <= 0 || map_height <= 0) {
        printf("Error: invalid width/height (must be > 0)\n");
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
    
    while (fgets(line, sizeof(line), csv) && y < map_height) {
        char *token = strtok(line, ",\n");
        int x = 0;
        
        while (token && x < map_width) {
            int tile = atoi(token);
            // Clamp to valid tile range (0-255)
            if (tile < 0) tile = 0;
            if (tile > 255) tile = 255;
            
            fputc((unsigned char)tile, bin);
            x++;
            token = strtok(NULL, ",\n");
        }
        
        // Pad remaining columns if CSV is shorter
        while (x < map_width) {
            fputc(0, bin);
            x++;
        }
        
        y++;
    }
    
    // Pad remaining rows if CSV is shorter
    while (y < map_height) {
        for (int x = 0; x < map_width; x++) {
            fputc(0, bin);
        }
        y++;
    }
    
    fclose(csv);
    fclose(bin);
    
    printf("Converted %s to map.bin (%dx%d tiles)\n", argv[1], map_width, map_height);
    return 0;
}
