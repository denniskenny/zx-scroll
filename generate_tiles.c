// Convert ZX-Paintbrush .zxp bitmap to ZX Spectrum 1bpp 8x8 tile bytes.
// Usage: ./generate_tiles <input.zxp> <output_header.h> <tile_width_px> <tile_height_px>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int is_bit_line(const char *s) {
    if (!s || !*s) return 0;
    for (const char *p = s; *p; ++p) {
        if (*p != '0' && *p != '1') return 0;
    }
    return 1;
}

static void die(const char *msg) {
    fprintf(stderr, "%s\n", msg);
    exit(1);
}

int main(int argc, char **argv) {
    if (argc != 5) {
        fprintf(stderr, "Usage: %s <input.zxp> <output_header.h> <tile_width_px> <tile_height_px>\n", argv[0]);
        return 1;
    }

    const char *in_path = argv[1];
    const char *out_path = argv[2];

    int tile_w = atoi(argv[3]);
    int tile_h = atoi(argv[4]);
    if (tile_w != 8 || tile_h != 8) {
        die("Error: only 8x8 tiles are supported by this generator/output format");
    }

    FILE *in = fopen(in_path, "r");
    if (!in) {
        perror("fopen input");
        return 1;
    }

    char **rows = NULL;
    size_t rows_cap = 0;
    size_t rows_len = 0;
    int width = -1;

    char line[2048];
    while (fgets(line, sizeof(line), in)) {
        size_t n = strlen(line);
        while (n && (line[n - 1] == '\n' || line[n - 1] == '\r')) {
            line[--n] = 0;
        }
        if (!is_bit_line(line)) {
            continue;
        }
        if (width < 0) {
            width = (int)strlen(line);
        }
        if ((int)strlen(line) != width) {
            die("Error: inconsistent row widths in .zxp data");
        }

        if (rows_len == rows_cap) {
            size_t new_cap = rows_cap ? rows_cap * 2 : 128;
            char **nr = (char **)realloc(rows, new_cap * sizeof(char *));
            if (!nr) die("Error: out of memory");
            rows = nr;
            rows_cap = new_cap;
        }

        char *copy = (char *)malloc((size_t)width + 1);
        if (!copy) die("Error: out of memory");
        memcpy(copy, line, (size_t)width + 1);
        rows[rows_len++] = copy;
    }

    fclose(in);

    if (width <= 0 || rows_len == 0) {
        die("Error: no bitmap data found in .zxp");
    }

    int height = (int)rows_len;

    if ((width % tile_w) != 0 || (height % tile_h) != 0) {
        die("Error: bitmap width/height must be multiples of 8");
    }

    int tiles_x = width / tile_w;
    int tiles_y = height / tile_h;
    int tile_count = tiles_x * tiles_y;

    FILE *out = fopen(out_path, "w");
    if (!out) {
        perror("fopen output");
        return 1;
    }

    fprintf(out, "#ifndef TILES_DATA_H\n");
    fprintf(out, "#define TILES_DATA_H\n\n");
    fprintf(out, "#define TILE_COUNT %d\n", tile_count);
    fprintf(out, "#define TILE_BYTES_PER_TILE 8\n\n");
    fprintf(out, "extern const unsigned char tiles[];\n\n");
    fprintf(out, "#ifdef TILES_DATA_IMPLEMENTATION\n");
    fprintf(out, "const unsigned char tiles[] = {\n");

    int byte_index = 0;
    for (int ty = 0; ty < tiles_y; ++ty) {
        for (int tx = 0; tx < tiles_x; ++tx) {
            for (int py = 0; py < tile_h; ++py) {
                unsigned char b = 0;
                const char *row = rows[ty * tile_h + py];
                for (int px = 0; px < tile_w; ++px) {
                    char c = row[tx * tile_w + px];
                    if (c == '1') {
                        b |= (unsigned char)(0x80u >> px);
                    }
                }

                if ((byte_index % 16) == 0) {
                    fprintf(out, "    ");
                }
                fprintf(out, "0x%02X", b);
                byte_index++;
                if (byte_index != tile_count * 8) {
                    fprintf(out, ", ");
                }
                if ((byte_index % 16) == 0) {
                    fprintf(out, "\n");
                }
            }
        }
    }

    if ((byte_index % 16) != 0) {
        fprintf(out, "\n");
    }

    fprintf(out, "};\n");
    fprintf(out, "#endif\n\n");
    fprintf(out, "#endif\n");

    fclose(out);

    for (size_t i = 0; i < rows_len; ++i) {
        free(rows[i]);
    }
    free(rows);

    return 0;
}
