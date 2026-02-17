extern void shift_buffer_left_1px_rows(unsigned char *buffer, unsigned char rows);
void foo(unsigned char *p) {
  shift_buffer_left_1px_rows(p, 3);
}
